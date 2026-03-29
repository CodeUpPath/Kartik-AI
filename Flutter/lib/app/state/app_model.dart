import 'dart:async';
import 'dart:convert';
import 'dart:math';

import 'package:geolocator/geolocator.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:pedometer/pedometer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../config.dart';
import '../models.dart';
import '../services/api_service.dart';
import '../services/plan_engine.dart';

const String _themeKey = '@kartik_fit_dark_mode';
const String _languageKey = '@kartik_fit_language';
const String _userKey = '@kartik_fit_user';
const String _tokenKey = '@kartik_fit_token';
const String _planKey = '@kartik_fit_plan';
const String _weekKey = '@kartik_fit_week_start';
const String _weekNumKey = '@kartik_fit_week_num';
const String _periodKey = '@kartik_fit_period';
const String _deviceKey = '@kartik_fit_device';
const String _historyKey = '@kartik_fit_workout_history';
const String _dayPrefix = '@kartik_fit_day_';
const String _notificationsPrefix = '@kartik_fit_notifs_';
const String _trackingEnabledKey = '@kartik_fit_tracking_enabled';
const int _waterGoal = 8;
const int _stepGoal = 10000;

final List<NotificationPreference> _defaultNotifications =
    <NotificationPreference>[
      const NotificationPreference(
        id: '1',
        title: 'Morning Workout',
        description: 'Start your day with energy',
        time: '7:00 AM',
        enabled: true,
        icon: 'fitness_center',
      ),
      const NotificationPreference(
        id: '2',
        title: 'Water Reminder',
        description: 'Stay hydrated throughout the day',
        time: 'Every 2 hrs',
        enabled: true,
        icon: 'water_drop',
      ),
      const NotificationPreference(
        id: '3',
        title: 'Nutrition Log',
        description: 'Log your meals to track calories',
        time: '12:00 PM',
        enabled: false,
        icon: 'restaurant',
      ),
      const NotificationPreference(
        id: '4',
        title: 'Evening Walk',
        description: '20-min walk after dinner',
        time: '8:00 PM',
        enabled: true,
        icon: 'directions_walk',
      ),
      const NotificationPreference(
        id: '5',
        title: 'Sleep Reminder',
        description: 'Wind down for quality sleep',
        time: '10:30 PM',
        enabled: false,
        icon: 'bedtime',
      ),
    ];

const Map<String, String> _goalTips = <String, String>{
  FitnessGoalValue.loseWeight:
      'Stay in a calorie deficit and prioritize cardio to accelerate fat loss today.',
  FitnessGoalValue.gainMuscle:
      'Hit your protein goal today. Muscle is built in the kitchen as much as the gym.',
  FitnessGoalValue.improveEndurance:
      'Focus on steady-state cardio and stay hydrated throughout your session.',
  FitnessGoalValue.maintain:
      'Consistency is key. A balanced day of nutrition and movement keeps you on track.',
};

class AppModel extends ChangeNotifier {
  AppModel();

  final ApiService api = ApiService();
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  SharedPreferences? _prefs;
  FlutterSecureStorage? _secureStorage;
  Timer? _syncTimer;
  StreamSubscription<StepCount>? _stepSubscription;
  StreamSubscription<PedestrianStatus>? _pedestrianStatusSubscription;
  StreamSubscription<Position>? _locationSubscription;
  final Map<String, DayData> _dayDataCache = <String, DayData>{};

  bool _trackingWriteInFlight = false;
  bool _googleInitialized = false;
  int _stepSessionOffset = 0;
  String _stepSessionDate = _todayKey();
  Position? _lastTrackedPosition;

  bool isReady = false;
  bool isDark = false;
  bool authBusy = false;
  bool coachBusy = false;
  bool trackingBusy = false;
  bool trackingEnabled = false;
  bool liveTrackingAvailable = false;
  bool gpsTrackingAvailable = false;
  String liveTrackingStatus = 'Checking live step tracking...';
  String language = 'en';
  String coachTip = '';
  String planSource = 'local';

  AppUser? user;
  String? token;
  List<WorkoutDay> weeklyPlan = <WorkoutDay>[];
  NutritionPlan nutritionPlan = const NutritionPlan(
    calories: 2000,
    proteinGoal: 150,
    carbsGoal: 220,
    fatGoal: 65,
    meals: <MealSuggestion>[],
  );
  int currentWeek = 1;
  int tdee = 2000;
  double bmi = 24.2;
  String bmiStatus = 'Normal';

  DayData todayData = DayData.empty(_todayKey());
  List<DayData> recentDays7 = <DayData>[];
  int streak = 0;

  List<NotificationPreference> notifications = _defaultNotifications;
  PeriodData periodData = const PeriodData(
    entries: <PeriodEntry>[],
    cycleLength: 28,
  );
  DeviceInfo? connectedDevice;
  List<WorkoutHistoryRecord> workoutHistory = <WorkoutHistoryRecord>[];
  List<ChatMessage> coachMessages = <ChatMessage>[
    ChatMessage(
      id: 'init',
      role: 'assistant',
      text:
          "Hey! I'm your personal AI fitness coach. Ask me anything about workouts, diet, or recovery.",
      time: 'Now',
    ),
  ];

  bool get isAuthenticated => user != null;
  bool get isProfileCompleted => user != null && isProfileComplete(user!);
  bool get supportsPeriodTracking => user?.gender == GenderValue.female;
  bool get hasRealtimeTracking => liveTrackingAvailable || gpsTrackingAvailable;
  int get waterGoal => _waterGoal;
  int get stepGoal => _stepGoal;
  WorkoutDay? get todayWorkout => getTodayWorkout(weeklyPlan);
  double get distanceKm => todayData.distanceKm > 0
      ? todayData.distanceKm
      : _calculateDistance(todayData.stepsCompleted);
  int get stepCaloriesBurned =>
      _calculateStepCalories(todayData.stepsCompleted);
  bool get isTrackingSimulated => false;

  List<StepRecord> get weeklyHistory => recentDays7
      .map(
        (DayData day) => StepRecord(
          date: day.date,
          steps: day.stepsCompleted,
          distance: day.distanceKm > 0
              ? day.distanceKm
              : _calculateDistance(day.stepsCompleted),
          calories: _calculateStepCalories(day.stepsCompleted),
        ),
      )
      .toList();

  Future<void> bootstrap() async {
    _prefs = await SharedPreferences.getInstance();
    _secureStorage = const FlutterSecureStorage();
    isDark = _prefs?.getBool(_themeKey) ?? false;
    language = _prefs?.getString(_languageKey) ?? 'en';
    trackingEnabled = _prefs?.getBool(_trackingEnabledKey) ?? false;
    token = await _readStoredToken();
    api.setToken(token);

    await _loadUser();
    await _loadPeriodData();
    await _loadConnectedDevice();
    await _loadWorkoutHistory();
    await _loadNotifications();
    await _loadTodayData();
    await _refreshDerivedDailyHistory();
    await _loadPlansForCurrentUser();

    await _initializeGoogleSignIn();
    await _hydrateRemoteState();
    await refreshCoachTip(silent: true);
    if (trackingEnabled) {
      await _startLiveStepTracking(requestPermission: false);
      await _startGpsTracking(requestPermission: false);
    } else {
      _refreshTrackingStatus(
        fallback:
            'Activity and GPS tracking are off. Enable them from Home or Settings when you are ready.',
      );
    }
    _startStepSync();

    isReady = true;
    notifyListeners();
  }

  @override
  void dispose() {
    _syncTimer?.cancel();
    _stepSubscription?.cancel();
    _pedestrianStatusSubscription?.cancel();
    _locationSubscription?.cancel();
    super.dispose();
  }

  Future<AuthActionResult> login(String email, String password) async {
    final String trimmedEmail = email.trim().toLowerCase();
    if (trimmedEmail.isEmpty || password.isEmpty) {
      return const AuthActionResult(
        success: false,
        error: 'Please fill in all fields',
      );
    }

    authBusy = true;
    notifyListeners();
    try {
      final Map<String, dynamic> response = await api.login(
        trimmedEmail,
        password,
      );
      await _completeAuthenticatedSession(
        response,
        fallbackName: 'User',
        fallbackEmail: trimmedEmail,
      );
      return const AuthActionResult(success: true);
    } on ApiException catch (error) {
      final String message = error.message.contains('timed out')
          ? 'Cannot connect to server. Please check your internet connection.'
          : 'Invalid email or password';
      return AuthActionResult(success: false, error: message);
    } finally {
      authBusy = false;
      notifyListeners();
    }
  }

  Future<AuthActionResult> signup(
    String name,
    String email,
    String password,
  ) async {
    final String trimmedEmail = email.trim().toLowerCase();
    final String trimmedName = name.trim();
    if (trimmedName.isEmpty || trimmedEmail.isEmpty || password.isEmpty) {
      return const AuthActionResult(
        success: false,
        error: 'Please fill in all fields',
      );
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(trimmedEmail)) {
      return const AuthActionResult(
        success: false,
        error: 'Please enter a valid email address',
      );
    }
    if (password.length < 6) {
      return const AuthActionResult(
        success: false,
        error: 'Password must be at least 6 characters',
      );
    }

    authBusy = true;
    notifyListeners();
    try {
      final Map<String, dynamic> response = await api.signup(
        trimmedName,
        trimmedEmail,
        password,
      );
      await _completeAuthenticatedSession(
        response,
        fallbackName: trimmedName,
        fallbackEmail: trimmedEmail,
        hydrateRemote: false,
      );
      coachTip = _goalTips[FitnessGoalValue.maintain] ?? '';
      return const AuthActionResult(success: true, isNewUser: true);
    } on ApiException catch (error) {
      final String message =
          error.message.contains('already') || error.message.contains('409')
          ? 'An account with this email already exists'
          : error.message.contains('timed out')
          ? 'Cannot connect to server. Please check your internet connection.'
          : 'Signup failed. Please try again.';
      return AuthActionResult(success: false, error: message);
    } finally {
      authBusy = false;
      notifyListeners();
    }
  }

  Future<AuthActionResult> signInWithGoogle() async {
    authBusy = true;
    notifyListeners();
    try {
      await _initializeGoogleSignIn();
      if (!_googleInitialized) {
        return const AuthActionResult(
          success: false,
          error: 'Google Sign-In is not configured for this build yet.',
        );
      }
      GoogleSignInAccount? account;
      if (_googleSignIn.supportsAuthenticate()) {
        account = await _googleSignIn.authenticate();
      } else {
        account = await _googleSignIn.attemptLightweightAuthentication(
          reportAllExceptions: true,
        );
      }

      if (account == null) {
        return const AuthActionResult(
          success: false,
          error: 'Google Sign-In was cancelled.',
        );
      }

      final String? idToken = account.authentication.idToken;
      if (idToken == null || idToken.isEmpty) {
        return const AuthActionResult(
          success: false,
          error: 'Google Sign-In is not configured correctly for this build.',
        );
      }

      final Map<String, dynamic> response = await api.googleAuth(
        idToken,
        account.displayName?.trim().isNotEmpty == true
            ? account.displayName!.trim()
            : account.email.split('@').first,
        account.email,
      );
      await _completeAuthenticatedSession(
        response,
        fallbackName: account.displayName ?? account.email.split('@').first,
        fallbackEmail: account.email,
      );
      final bool isNewUser = response['isNewUser'] == true;
      return AuthActionResult(success: true, isNewUser: isNewUser);
    } on ApiException catch (error) {
      return AuthActionResult(
        success: false,
        error: _googleSignInMessage(error),
      );
    } catch (error) {
      return AuthActionResult(
        success: false,
        error: _googleSignInMessage(error),
      );
    } finally {
      authBusy = false;
      notifyListeners();
    }
  }

  Future<AuthActionResult> resetPassword(String email) async {
    final String trimmedEmail = email.trim().toLowerCase();
    if (trimmedEmail.isEmpty) {
      return const AuthActionResult(
        success: false,
        error: 'Please enter your email address',
      );
    }
    if (!RegExp(r'\S+@\S+\.\S+').hasMatch(trimmedEmail)) {
      return const AuthActionResult(
        success: false,
        error: 'Please enter a valid email address',
      );
    }
    try {
      await api.resetPassword(trimmedEmail);
      return const AuthActionResult(success: true);
    } on ApiException catch (error) {
      final String message =
          error.message.contains('No account') || error.message.contains('404')
          ? 'No account found with this email'
          : error.message.contains('timed out')
          ? 'Cannot connect to server. Please try again.'
          : 'Failed to process request. Please try again.';
      return AuthActionResult(success: false, error: message);
    }
  }

  Future<void> logout() async {
    user = null;
    token = null;
    coachTip = '';
    api.setToken(null);
    await _prefs?.remove(_userKey);
    await _clearStoredToken();
    try {
      await _googleSignIn.signOut();
    } catch (_) {}
    final PlanSnapshot defaults = defaultPlanSnapshot();
    _applyPlan(defaults, 1, source: 'local');
    notifyListeners();
  }

  Future<void> toggleTheme() async {
    isDark = !isDark;
    await _prefs?.setBool(_themeKey, isDark);
    notifyListeners();
  }

  Future<void> setLanguage(String nextLanguage) async {
    language = nextLanguage;
    await _prefs?.setString(_languageKey, nextLanguage);
    notifyListeners();
  }

  Future<void> updateProfile(Map<String, dynamic> patch) async {
    if (user == null) return;
    user = _patchUser(user!, patch);
    await _saveUser();
    await _loadPlansForCurrentUser();
    notifyListeners();
    try {
      final Map<String, dynamic> response = await api
          .updateProfile(<String, dynamic>{
            'name': user?.name,
            'age': user?.age == null ? null : int.tryParse(user!.age!),
            'heightCm': user?.height == null
                ? null
                : double.tryParse(user!.height!),
            'weightKg': user?.weight == null
                ? null
                : double.tryParse(user!.weight!),
            'fitnessLevel': user?.fitnessLevel,
            'goal': user?.goal,
            'gender': user?.gender,
            'dietType': user?.dietType,
            'activityLevel': user?.activityLevel,
            'workoutDaysPerWeek': user?.workoutDaysPerWeek,
            'workoutTime': user?.workoutTime,
          });
      user = _mergeProfile(user!, response);
      await _saveUser();
      await _loadPlansForCurrentUser();
      notifyListeners();
    } catch (_) {}
  }

  Future<void> regeneratePlans() async {
    if (user == null) return;
    currentWeek += 1;
    await _prefs?.setInt(_weekNumStorageKey(user!.id), currentWeek);
    await _generateAndSavePlan(user!, currentWeek);
    notifyListeners();
  }

  Future<void> resetWeek() async {
    if (user == null) return;
    currentWeek = 1;
    await _prefs?.setString(
      _weekStorageKey(user!.id),
      DateTime.now().toIso8601String(),
    );
    await _prefs?.setInt(_weekNumStorageKey(user!.id), 1);
    await _generateAndSavePlan(user!, 1);
    notifyListeners();
  }

  Future<void> _loadPlansForCurrentUser() async {
    if (user == null) {
      _applyPlan(defaultPlanSnapshot(), 1, source: 'local');
      return;
    }
    final String weekStartKey = _weekStorageKey(user!.id);
    final String weekNumKey = _weekNumStorageKey(user!.id);
    final String weekStartIso =
        _prefs?.getString(weekStartKey) ?? DateTime.now().toIso8601String();
    await _prefs?.setString(weekStartKey, weekStartIso);
    final int storedWeek = _prefs?.getInt(weekNumKey) ?? 1;
    final int calendarWeek = computeCalendarWeek(weekStartIso);
    currentWeek = calendarWeek > storedWeek ? calendarWeek : storedWeek;
    await _prefs?.setInt(weekNumKey, currentWeek);

    final String signature = _planSignature(user!, currentWeek);
    final String? raw = _prefs?.getString(_planStorageKey(user!.id));
    if (raw != null && raw.isNotEmpty) {
      final Map<String, dynamic> decoded =
          jsonDecode(raw) as Map<String, dynamic>;
      if (decoded['signature'] == signature) {
        final Map<String, dynamic> bmiData = calculateBmi(user!);
        _applyPlan(
          PlanSnapshot(
            weekly: (decoded['weekly'] as List<dynamic>)
                .map(
                  (dynamic item) =>
                      WorkoutDay.fromJson(item as Map<String, dynamic>),
                )
                .toList(),
            nutrition: NutritionPlan.fromJson(
              decoded['nutrition'] as Map<String, dynamic>,
            ),
            tdee: calculateTdee(user!),
            bmi: bmiData['bmi'] as double,
            bmiStatus: bmiData['status'] as String,
          ),
          currentWeek,
          source: decoded['source']?.toString() ?? 'local',
        );
        return;
      }
    }
    await _generateAndSavePlan(user!, currentWeek);
  }

  Future<void> _generateAndSavePlan(AppUser targetUser, int week) async {
    final ({PlanSnapshot snapshot, String source}) resolved =
        await _resolvePlanSnapshot(targetUser, week);
    _applyPlan(resolved.snapshot, week, source: resolved.source);
    await _prefs?.setString(
      _planStorageKey(targetUser.id),
      jsonEncode(<String, dynamic>{
        'signature': _planSignature(targetUser, week),
        'source': resolved.source,
        'weekly': resolved.snapshot.weekly
            .map((WorkoutDay day) => day.toJson())
            .toList(),
        'nutrition': resolved.snapshot.nutrition.toJson(),
      }),
    );
  }

  void _applyPlan(PlanSnapshot snapshot, int week, {String source = 'local'}) {
    weeklyPlan = snapshot.weekly;
    nutritionPlan = snapshot.nutrition;
    tdee = snapshot.tdee;
    bmi = snapshot.bmi;
    bmiStatus = snapshot.bmiStatus;
    currentWeek = week;
    planSource = source;
  }

  Future<({PlanSnapshot snapshot, String source})> _resolvePlanSnapshot(
    AppUser targetUser,
    int week,
  ) async {
    final PlanSnapshot fallback = buildPlanSnapshot(targetUser, week);
    if (token?.isNotEmpty != true) {
      return (snapshot: fallback, source: 'local');
    }

    try {
      final Map<String, dynamic> response = await api.generatePlan(
        week: week,
        profile: _planPayloadForUser(targetUser),
      );
      final PlanSnapshot? remote = _planSnapshotFromResponse(
        response,
        targetUser,
        fallback,
      );
      if (remote != null) {
        final String source = response['source']?.toString().trim() ?? 'ai';
        return (snapshot: remote, source: source.isEmpty ? 'ai' : source);
      }
    } catch (error) {
      debugPrint('Remote plan generation failed: $error');
    }

    return (snapshot: fallback, source: 'local');
  }

  Map<String, dynamic> _planPayloadForUser(AppUser targetUser) {
    return <String, dynamic>{
      'age': int.tryParse(targetUser.age ?? '') ?? 25,
      'heightCm': _safeProfileDouble(targetUser.height, 170),
      'weightKg': _safeProfileDouble(targetUser.weight, 70),
      'goal': targetUser.goal ?? FitnessGoalValue.maintain,
      'fitnessLevel': targetUser.fitnessLevel ?? FitnessLevelValue.beginner,
      'activityLevel': targetUser.activityLevel ?? ActivityLevelValue.moderate,
      'gender': targetUser.gender ?? GenderValue.male,
      'dietType': targetUser.dietType ?? DietTypeValue.nonVeg,
      'workoutDaysPerWeek': targetUser.workoutDaysPerWeek ?? 3,
      'workoutTime': targetUser.workoutTime ?? 'morning',
    };
  }

  PlanSnapshot? _planSnapshotFromResponse(
    Map<String, dynamic> response,
    AppUser targetUser,
    PlanSnapshot fallback,
  ) {
    final dynamic weeklyRaw = response['weekly'];
    final dynamic nutritionRaw = response['nutrition'];
    if (weeklyRaw is! List<dynamic> || nutritionRaw is! Map<String, dynamic>) {
      return null;
    }

    try {
      final List<WorkoutDay> weekly = weeklyRaw
          .whereType<Map<dynamic, dynamic>>()
          .map(
            (Map<dynamic, dynamic> item) => WorkoutDay.fromJson(
              item.map(
                (dynamic key, dynamic value) =>
                    MapEntry<String, dynamic>(key.toString(), value),
              ),
            ),
          )
          .toList();
      if (weekly.length != 7) {
        return null;
      }

      final NutritionPlan nutrition = NutritionPlan.fromJson(nutritionRaw);
      if (nutrition.meals.length < 4 || nutrition.calories <= 0) {
        return null;
      }

      final Map<String, dynamic> bmiData = calculateBmi(targetUser);
      final int resolvedTdee = _asInt(response['tdee']);
      final double resolvedBmi =
          (response['bmi'] as num?)?.toDouble() ??
          (bmiData['bmi'] as double? ?? fallback.bmi);
      final String resolvedBmiStatus =
          response['bmiStatus']?.toString() ??
          bmiData['status']?.toString() ??
          fallback.bmiStatus;

      return PlanSnapshot(
        weekly: weekly,
        nutrition: nutrition,
        tdee: resolvedTdee > 0 ? resolvedTdee : fallback.tdee,
        bmi: resolvedBmi,
        bmiStatus: resolvedBmiStatus,
      );
    } catch (error) {
      debugPrint('Plan response parse failed: $error');
      return null;
    }
  }

  Future<void> setWater(int water) async {
    await _updateTodayData(
      todayData.copyWith(water: water.clamp(0, _waterGoal)),
    );
  }

  Future<void> adjustWater(int delta) async {
    await setWater(todayData.water + delta);
  }

  Future<void> toggleMeal(MealSuggestion meal) async {
    if (todayData.mealsLogged.contains(meal.id)) {
      await _updateTodayData(
        todayData.copyWith(
          caloriesConsumed: max(0, todayData.caloriesConsumed - meal.calories),
          proteinConsumed: max(0, todayData.proteinConsumed - meal.protein),
          carbsConsumed: max(0, todayData.carbsConsumed - meal.carbs),
          fatConsumed: max(0, todayData.fatConsumed - meal.fat),
          mealsLogged: todayData.mealsLogged
              .where((String id) => id != meal.id)
              .toList(),
        ),
      );
      return;
    }
    await _updateTodayData(
      todayData.copyWith(
        caloriesConsumed: todayData.caloriesConsumed + meal.calories,
        proteinConsumed: todayData.proteinConsumed + meal.protein,
        carbsConsumed: todayData.carbsConsumed + meal.carbs,
        fatConsumed: todayData.fatConsumed + meal.fat,
        mealsLogged: <String>[...todayData.mealsLogged, meal.id],
      ),
    );
  }

  Future<void> addCustomMeal({
    required String name,
    required String mealType,
    required int calories,
    required int protein,
    required int carbs,
    required int fat,
  }) async {
    final String time = DateFormat('h:mm a').format(DateTime.now());
    final CustomMeal meal = CustomMeal(
      id: 'custom_${DateTime.now().millisecondsSinceEpoch}',
      name: name,
      calories: calories,
      protein: protein,
      carbs: carbs,
      fat: fat,
      time: time,
      mealType: mealType,
    );
    await _updateTodayData(
      todayData.copyWith(
        caloriesConsumed: todayData.caloriesConsumed + calories,
        proteinConsumed: todayData.proteinConsumed + protein,
        carbsConsumed: todayData.carbsConsumed + carbs,
        fatConsumed: todayData.fatConsumed + fat,
        customMeals: <CustomMeal>[...todayData.customMeals, meal],
      ),
    );
  }

  Future<void> deleteCustomMeal(String id) async {
    final CustomMeal? meal = todayData.customMeals
        .cast<CustomMeal?>()
        .firstWhere((CustomMeal? item) => item?.id == id, orElse: () => null);
    if (meal == null) return;
    await _updateTodayData(
      todayData.copyWith(
        caloriesConsumed: max(0, todayData.caloriesConsumed - meal.calories),
        proteinConsumed: max(0, todayData.proteinConsumed - meal.protein),
        carbsConsumed: max(0, todayData.carbsConsumed - meal.carbs),
        fatConsumed: max(0, todayData.fatConsumed - meal.fat),
        customMeals: todayData.customMeals
            .where((CustomMeal item) => item.id != id)
            .toList(),
      ),
    );
  }

  Future<void> toggleNotification(String id) async {
    notifications = notifications
        .map(
          (NotificationPreference item) =>
              item.id == id ? item.copyWith(enabled: !item.enabled) : item,
        )
        .toList();
    await _prefs?.setString(
      _notificationsStorageKey,
      jsonEncode(
        notifications
            .map((NotificationPreference item) => item.toJson())
            .toList(),
      ),
    );
    notifyListeners();
  }

  Future<void> enableRealtimeTracking({bool requestPermissions = true}) async {
    if (trackingBusy) return;
    trackingBusy = true;
    trackingEnabled = true;
    await _prefs?.setBool(_trackingEnabledKey, true);
    notifyListeners();
    try {
      await _startLiveStepTracking(requestPermission: requestPermissions);
      await _startGpsTracking(requestPermission: requestPermissions);
    } finally {
      trackingBusy = false;
      notifyListeners();
    }
  }

  Future<void> disableRealtimeTracking() async {
    trackingEnabled = false;
    trackingBusy = false;
    await _prefs?.setBool(_trackingEnabledKey, false);
    await _stepSubscription?.cancel();
    await _pedestrianStatusSubscription?.cancel();
    await _locationSubscription?.cancel();
    _stepSubscription = null;
    _pedestrianStatusSubscription = null;
    _locationSubscription = null;
    _lastTrackedPosition = null;
    liveTrackingAvailable = false;
    gpsTrackingAvailable = false;
    _refreshTrackingStatus(
      fallback:
          'Activity and GPS tracking are off. Enable them from Home or Settings when you are ready.',
    );
    notifyListeners();
  }

  Future<void> openTrackingSettings() async {
    await openAppSettings();
  }

  Future<void> logPeriodToday({
    required int cycleLength,
    required List<String> symptoms,
  }) async {
    if (!supportsPeriodTracking) return;
    final String today = _todayKey();
    final bool alreadyLogged = periodData.entries.any(
      (PeriodEntry entry) => entry.startDate == today,
    );
    if (alreadyLogged) return;
    periodData = PeriodData(
      entries: <PeriodEntry>[
        PeriodEntry(
          startDate: today,
          cycleLength: cycleLength,
          symptoms: symptoms,
        ),
        ...periodData.entries,
      ].take(12).toList(),
      cycleLength: cycleLength,
    );
    await _prefs?.setString(_periodKey, jsonEncode(periodData.toJson()));
    notifyListeners();
  }

  Future<void> connectDevice(DeviceInfo device) async {
    connectedDevice = device.copyWith(
      steps: todayData.stepsCompleted,
      lastSync: DateFormat('h:mm a').format(DateTime.now()),
    );
    await _prefs?.setString(_deviceKey, jsonEncode(connectedDevice!.toJson()));
    notifyListeners();
  }

  Future<void> disconnectDevice() async {
    connectedDevice = null;
    await _prefs?.remove(_deviceKey);
    notifyListeners();
  }

  Future<void> syncWatchSteps() async {
    if (connectedDevice == null) return;
    connectedDevice = connectedDevice!.copyWith(
      steps: todayData.stepsCompleted,
      lastSync: DateFormat('h:mm a').format(DateTime.now()),
    );
    await _prefs?.setString(_deviceKey, jsonEncode(connectedDevice!.toJson()));
    try {
      if (token?.isNotEmpty == true) {
        await api.syncSteps(todayData.stepsCompleted, todayData.date);
      }
    } catch (_) {}
    notifyListeners();
  }

  Future<void> sendCoachMessage(String text) async {
    final String trimmed = text.trim();
    if (trimmed.isEmpty || coachBusy) return;
    coachMessages = <ChatMessage>[
      ...coachMessages,
      ChatMessage(
        id: DateTime.now().microsecondsSinceEpoch.toString(),
        role: 'user',
        text: trimmed,
        time: DateFormat('h:mm a').format(DateTime.now()),
      ),
    ];
    coachBusy = true;
    notifyListeners();
    try {
      final List<Map<String, String>> history = coachMessages
          .take(max(0, coachMessages.length - 1))
          .skip(max(0, coachMessages.length - 10))
          .map(
            (ChatMessage message) => <String, String>{
              'role': message.role,
              'text': message.text,
            },
          )
          .toList();
      final String reply = await api.chat(message: trimmed, history: history);
      coachMessages = <ChatMessage>[
        ...coachMessages,
        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          role: 'assistant',
          text: reply,
          time: DateFormat('h:mm a').format(DateTime.now()),
        ),
      ];
    } catch (_) {
      coachMessages = <ChatMessage>[
        ...coachMessages,
        ChatMessage(
          id: DateTime.now().microsecondsSinceEpoch.toString(),
          role: 'assistant',
          text: 'I am having trouble connecting right now. Please try again.',
          time: DateFormat('h:mm a').format(DateTime.now()),
        ),
      ];
    } finally {
      coachBusy = false;
      notifyListeners();
    }
  }

  Future<void> refreshCoachTip({bool silent = false}) async {
    try {
      if (token?.isNotEmpty == true) {
        final String remoteTip = await api.getTip();
        if (remoteTip.trim().isNotEmpty) {
          coachTip = remoteTip.trim();
          notifyListeners();
          return;
        }
      }
    } catch (_) {}
    coachTip =
        _goalTips[user?.goal ?? FitnessGoalValue.maintain] ??
        _goalTips[FitnessGoalValue.maintain]!;
    notifyListeners();
  }

  Future<void> saveCompletedWorkout(WorkoutDay day, int durationSeconds) async {
    final WorkoutHistoryRecord record = WorkoutHistoryRecord(
      date: DateTime.now().toIso8601String(),
      dayName: day.name,
      duration: durationSeconds,
      exercises: day.exercises.length,
      calories: day.calories,
    );
    workoutHistory = <WorkoutHistoryRecord>[
      record,
      ...workoutHistory,
    ].take(30).toList();
    await _prefs?.setString(
      _historyKey,
      jsonEncode(
        workoutHistory
            .map((WorkoutHistoryRecord item) => item.toJson())
            .toList(),
      ),
    );
    await _updateTodayData(todayData.copyWith(workoutDone: true));
    try {
      if (token?.isNotEmpty == true) {
        await api.saveWorkout(<String, dynamic>{
          'dayNumber': day.dayNumber,
          'dayName': day.name,
          'exercises': day.exercises.length,
          'duration': durationSeconds,
          'calories': day.calories,
          'workoutDate': todayData.date,
        });
      }
    } catch (_) {}
  }

  Future<List<DayData>> getLastNDays(int count) async {
    final List<DayData> days = <DayData>[];
    final DateTime now = DateTime.now();
    for (int i = count - 1; i >= 0; i -= 1) {
      final DateTime date = now.subtract(Duration(days: i));
      final String key = DateFormat('yyyy-MM-dd').format(date);
      days.add(await _readDayData(key));
    }
    return days;
  }

  Future<String> exportLast30DaysCsv() async {
    final List<DayData> last30Days = await getLastNDays(30);
    final List<String> rows = <String>[
      'Date,Calories (kcal),Protein (g),Carbs (g),Fat (g),Water (glasses),Workout Done,Steps,Distance (km)',
    ];
    for (final DayData day in last30Days) {
      rows.add(
        '${day.date},${day.caloriesConsumed},${day.proteinConsumed},${day.carbsConsumed},${day.fatConsumed},${day.water},${day.workoutDone ? 'Yes' : 'No'},${day.stepsCompleted},${(day.distanceKm > 0 ? day.distanceKm : _calculateDistance(day.stepsCompleted)).toStringAsFixed(2)}',
      );
    }
    return rows.join('\n');
  }

  Future<String?> _readStoredToken() async {
    try {
      final String? secureToken = await _secureStorage?.read(key: _tokenKey);
      if (secureToken != null && secureToken.isNotEmpty) {
        await _prefs?.remove(_tokenKey);
        return secureToken;
      }
    } catch (error) {
      debugPrint('Secure token read failed: $error');
    }

    final String? legacyToken = _prefs?.getString(_tokenKey);
    if (legacyToken != null && legacyToken.isNotEmpty) {
      await _writeStoredToken(legacyToken);
      return legacyToken;
    }
    return null;
  }

  Future<void> _writeStoredToken(String? value) async {
    if (value == null || value.isEmpty) {
      await _clearStoredToken();
      return;
    }

    try {
      await _secureStorage?.write(key: _tokenKey, value: value);
      await _prefs?.remove(_tokenKey);
    } catch (error) {
      debugPrint('Secure token write failed: $error');
      await _prefs?.setString(_tokenKey, value);
    }
  }

  Future<void> _clearStoredToken() async {
    try {
      await _secureStorage?.delete(key: _tokenKey);
    } catch (error) {
      debugPrint('Secure token delete failed: $error');
    }
    await _prefs?.remove(_tokenKey);
  }

  Future<void> _completeAuthenticatedSession(
    Map<String, dynamic> response, {
    required String fallbackName,
    required String fallbackEmail,
    bool hydrateRemote = true,
  }) async {
    token = response['token']?.toString();
    api.setToken(token);
    await _writeStoredToken(token);
    user = AppUser(
      id: response['user']['id'].toString(),
      dbId: response['user']['id'] as int?,
      name: response['user']['name']?.toString() ?? fallbackName,
      email: response['user']['email']?.toString() ?? fallbackEmail,
      joinedAt: DateTime.now().toIso8601String(),
    );
    await _saveUser();
    await _loadNotifications();
    if (hydrateRemote) {
      await _hydrateRemoteState();
    } else {
      await _loadPlansForCurrentUser();
    }
    await refreshCoachTip(silent: true);
  }

  Future<void> _hydrateRemoteState() async {
    if (token?.isNotEmpty != true || user == null) return;

    bool didMutate = false;
    try {
      final Map<String, dynamic> profile = await api.getProfile();
      user = _mergeProfile(user!, profile);
      await _saveUser();
      didMutate = true;
    } catch (error) {
      debugPrint('Profile hydrate failed: $error');
    }

    try {
      final List<dynamic> remoteWorkouts = await api.getWorkouts();
      await _mergeRemoteWorkoutHistory(remoteWorkouts);
      didMutate = true;
    } catch (error) {
      debugPrint('Workout hydrate failed: $error');
    }

    try {
      final List<Map<String, dynamic>> remoteSteps = await api.getSteps();
      await _mergeRemoteStepHistory(remoteSteps);
      didMutate = true;
    } catch (error) {
      debugPrint('Step hydrate failed: $error');
    }

    if (didMutate) {
      await _loadPlansForCurrentUser();
      notifyListeners();
    }
  }

  Future<void> _mergeRemoteWorkoutHistory(List<dynamic> rows) async {
    if (rows.isEmpty) return;
    final Map<String, WorkoutHistoryRecord> merged =
        <String, WorkoutHistoryRecord>{};

    for (final WorkoutHistoryRecord record in workoutHistory) {
      merged[_workoutHistoryKey(record)] = record;
    }

    for (final dynamic item in rows) {
      if (item is! Map<dynamic, dynamic>) continue;
      final WorkoutHistoryRecord record = WorkoutHistoryRecord(
        date: _normalizeIsoDate(item['workoutDate'] ?? item['date']),
        dayName: item['dayName']?.toString() ?? 'Workout',
        duration: _asInt(item['duration']),
        exercises: _asInt(item['exercises']),
        calories: _asInt(item['calories']),
      );
      merged[_workoutHistoryKey(record)] = record;
    }

    workoutHistory = merged.values.toList()
      ..sort(
        (WorkoutHistoryRecord a, WorkoutHistoryRecord b) =>
            _sortDateDescending(a.date, b.date),
      );
    workoutHistory = workoutHistory.take(30).toList();
    await _prefs?.setString(
      _historyKey,
      jsonEncode(
        workoutHistory
            .map((WorkoutHistoryRecord item) => item.toJson())
            .toList(),
      ),
    );
  }

  Future<void> _mergeRemoteStepHistory(List<Map<String, dynamic>> rows) async {
    if (rows.isEmpty) return;
    for (final Map<String, dynamic> item in rows) {
      final String date = _normalizeDayKey(item['stepDate']);
      final int steps = _asInt(item['steps']);
      if (date.isEmpty || steps <= 0) continue;
      final DayData existing = await _readDayData(date);
      if (steps <= existing.stepsCompleted) continue;
      await _writeDayData(existing.copyWith(date: date, stepsCompleted: steps));
    }
    await _loadTodayData();
    _resetStepSession();
    await _refreshDerivedDailyHistory();
  }

  Future<void> _initializeGoogleSignIn() async {
    if (_googleInitialized) return;
    final bool isAndroid =
        !kIsWeb && defaultTargetPlatform == TargetPlatform.android;
    final String clientId = AppConfig.googleClientId;
    final String serverClientId = AppConfig.googleServerClientId;
    final String? resolvedServerClientId = serverClientId.isNotEmpty
        ? serverClientId
        : isAndroid && clientId.isNotEmpty
        ? clientId
        : null;
    final String? resolvedClientId = isAndroid || clientId.isEmpty
        ? null
        : clientId;
    try {
      await _googleSignIn.initialize(
        clientId: resolvedClientId,
        serverClientId: resolvedServerClientId,
      );
      _googleInitialized = true;
    } catch (error) {
      _googleInitialized = false;
      debugPrint('Google Sign-In init skipped: $error');
    }
  }

  Future<void> _startLiveStepTracking({bool requestPermission = true}) async {
    await _stepSubscription?.cancel();
    await _pedestrianStatusSubscription?.cancel();
    liveTrackingAvailable = false;

    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      _refreshTrackingStatus(
        fallback:
            'Live phone tracking works on Android and iPhone builds only.',
      );
      return;
    }

    final PermissionStatus permission = await _requestTrackingPermission(
      requestPermission: requestPermission,
    );
    if (!permission.isGranted && !permission.isLimited) {
      _refreshTrackingStatus(
        fallback: permission.isPermanentlyDenied
            ? 'Allow motion access from settings to enable step tracking.'
            : 'Allow motion access to enable step tracking.',
      );
      notifyListeners();
      return;
    }

    try {
      _resetStepSession();
      _stepSubscription = Pedometer.stepCountStream.listen(
        _handleStepCount,
        onError: _handleStepTrackingError,
        cancelOnError: false,
      );
      _pedestrianStatusSubscription = Pedometer.pedestrianStatusStream.listen(
        _handlePedestrianStatus,
        onError: (Object error) {},
        cancelOnError: false,
      );
      liveTrackingAvailable = true;
      _refreshTrackingStatus();
    } catch (error) {
      _refreshTrackingStatus(
        fallback: 'This device does not expose a step counter sensor.',
      );
      debugPrint('Live step tracking init failed: $error');
    }
    notifyListeners();
  }

  Future<PermissionStatus> _requestTrackingPermission({
    bool requestPermission = true,
  }) async {
    if (defaultTargetPlatform == TargetPlatform.android) {
      PermissionStatus status = await Permission.activityRecognition.status;
      if (status.isGranted || status.isLimited) return status;
      if (!requestPermission) return status;
      status = await Permission.activityRecognition.request();
      return status;
    }
    if (defaultTargetPlatform == TargetPlatform.iOS) {
      PermissionStatus status = await Permission.sensors.status;
      if (status.isGranted || status.isLimited) return status;
      if (!requestPermission) return status;
      status = await Permission.sensors.request();
      return status;
    }
    return PermissionStatus.granted;
  }

  Future<void> _startGpsTracking({bool requestPermission = true}) async {
    await _locationSubscription?.cancel();
    gpsTrackingAvailable = false;
    _lastTrackedPosition = null;

    if (kIsWeb ||
        (defaultTargetPlatform != TargetPlatform.android &&
            defaultTargetPlatform != TargetPlatform.iOS)) {
      _refreshTrackingStatus();
      return;
    }

    final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      _refreshTrackingStatus(
        fallback: 'Turn on location services to enable GPS distance tracking.',
      );
      notifyListeners();
      return;
    }

    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied && requestPermission) {
      permission = await Geolocator.requestPermission();
    }

    if (permission == LocationPermission.denied ||
        permission == LocationPermission.deniedForever) {
      _refreshTrackingStatus(
        fallback: permission == LocationPermission.deniedForever
            ? 'Allow location access from settings to enable GPS tracking.'
            : 'Allow location access to enable GPS tracking.',
      );
      notifyListeners();
      return;
    }

    try {
      _lastTrackedPosition = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
    } catch (_) {}

    try {
      _locationSubscription =
          Geolocator.getPositionStream(
            locationSettings: const LocationSettings(
              accuracy: LocationAccuracy.best,
              distanceFilter: 8,
            ),
          ).listen(
            _handleLocationPosition,
            onError: _handleLocationTrackingError,
            cancelOnError: false,
          );
      gpsTrackingAvailable = true;
      _refreshTrackingStatus();
    } catch (error) {
      _refreshTrackingStatus(
        fallback: 'GPS distance tracking is unavailable on this device.',
      );
      debugPrint('GPS tracking init failed: $error');
    }
    notifyListeners();
  }

  Future<void> _handleStepCount(StepCount event) async {
    if (_trackingWriteInFlight) return;
    _trackingWriteInFlight = true;
    try {
      if (todayData.date != _todayKey()) {
        await _loadTodayData();
        await _refreshDerivedDailyHistory();
      }
      if (_stepSessionDate != todayData.date) {
        _resetStepSession();
      }
      final int nextSteps = max(
        todayData.stepsCompleted,
        _stepSessionOffset + event.steps,
      );
      if (nextSteps == todayData.stepsCompleted) {
        return;
      }
      await _updateTodayData(
        todayData.copyWith(stepsCompleted: nextSteps),
        refreshHistory: false,
      );
      if (connectedDevice != null) {
        connectedDevice = connectedDevice!.copyWith(
          steps: nextSteps,
          lastSync: DateFormat('h:mm a').format(DateTime.now()),
        );
        await _prefs?.setString(
          _deviceKey,
          jsonEncode(connectedDevice!.toJson()),
        );
      }
      await _refreshRecentDaysWindow();
      notifyListeners();
    } finally {
      _trackingWriteInFlight = false;
    }
  }

  Future<void> _handleLocationPosition(Position position) async {
    final Position? previous = _lastTrackedPosition;
    _lastTrackedPosition = position;

    if (todayData.date != _todayKey()) {
      await _loadTodayData();
      await _refreshDerivedDailyHistory();
    }

    if (previous == null) {
      return;
    }

    if (previous.accuracy > 60 || position.accuracy > 60) {
      return;
    }

    final double deltaMeters = Geolocator.distanceBetween(
      previous.latitude,
      previous.longitude,
      position.latitude,
      position.longitude,
    );
    if (deltaMeters < 3 || deltaMeters > 250) {
      return;
    }

    final double nextDistanceKm = double.parse(
      (todayData.distanceKm + (deltaMeters / 1000)).toStringAsFixed(2),
    );
    final int nextSteps = liveTrackingAvailable
        ? todayData.stepsCompleted
        : max(
            todayData.stepsCompleted,
            _estimateStepsFromDistance(nextDistanceKm),
          );

    await _updateTodayData(
      todayData.copyWith(distanceKm: nextDistanceKm, stepsCompleted: nextSteps),
      refreshHistory: false,
    );
    await _refreshRecentDaysWindow();
    notifyListeners();
  }

  void _handlePedestrianStatus(PedestrianStatus event) {
    if (!liveTrackingAvailable) return;
    final String nextStatus = event.status == 'walking'
        ? gpsTrackingAvailable
              ? 'Walking detected. Phone steps and GPS distance are updating.'
              : 'Walking detected. Live steps are updating.'
        : gpsTrackingAvailable
        ? 'Phone pedometer and GPS tracking are ready.'
        : 'Live step tracking is ready.';
    if (liveTrackingStatus == nextStatus) return;
    liveTrackingStatus = nextStatus;
    notifyListeners();
  }

  void _handleStepTrackingError(Object error) {
    liveTrackingAvailable = false;
    _refreshTrackingStatus(
      fallback: gpsTrackingAvailable
          ? 'GPS distance tracking is active. Steps are estimated from movement.'
          : 'This device does not expose a step counter sensor.',
    );
    debugPrint('Live step tracking error: $error');
    notifyListeners();
  }

  void _handleLocationTrackingError(Object error) {
    gpsTrackingAvailable = false;
    _refreshTrackingStatus(
      fallback: liveTrackingAvailable
          ? 'Phone step tracking is active. GPS distance tracking is unavailable.'
          : 'GPS distance tracking is unavailable on this device.',
    );
    debugPrint('GPS tracking error: $error');
    notifyListeners();
  }

  void _resetStepSession() {
    _stepSessionDate = todayData.date;
    _stepSessionOffset = todayData.stepsCompleted;
  }

  void _startStepSync() {
    _syncTimer?.cancel();
    _syncTimer = Timer.periodic(const Duration(minutes: 1), (Timer _) async {
      if (token?.isEmpty != false || todayData.stepsCompleted == 0) return;
      try {
        await api.syncSteps(todayData.stepsCompleted, todayData.date);
      } catch (_) {}
    });
  }

  double _calculateDistance(int steps) {
    final double heightCm = _safeProfileDouble(user?.height, 170);
    final double strideMeters = heightCm * 0.0041;
    return double.parse(((steps * strideMeters) / 1000).toStringAsFixed(2));
  }

  int _estimateStepsFromDistance(double distanceKm) {
    final double heightCm = _safeProfileDouble(user?.height, 170);
    final double strideMeters = heightCm * 0.0041;
    if (strideMeters <= 0) return 0;
    return ((distanceKm * 1000) / strideMeters).round();
  }

  int _calculateStepCalories(int steps) {
    final double weightKg = _safeProfileDouble(user?.weight, 70);
    return (steps * 0.04 * (weightKg / 70)).round();
  }

  void _refreshTrackingStatus({String? fallback}) {
    if (!trackingEnabled) {
      liveTrackingStatus =
          'Activity and GPS tracking are off. Enable them from Home or Settings when you are ready.';
      return;
    }
    if (liveTrackingAvailable && gpsTrackingAvailable) {
      liveTrackingStatus =
          'Phone pedometer + GPS distance tracking are active.';
      return;
    }
    if (liveTrackingAvailable) {
      liveTrackingStatus =
          'Phone pedometer is active. Allow GPS for real distance tracking.';
      return;
    }
    if (gpsTrackingAvailable) {
      liveTrackingStatus =
          'GPS distance tracking is active. Steps are estimated from movement.';
      return;
    }
    if (fallback != null && fallback.isNotEmpty) {
      liveTrackingStatus = fallback;
      return;
    }
    liveTrackingStatus = 'Live phone tracking is unavailable right now.';
  }

  double _safeProfileDouble(String? value, double fallback) {
    final double? parsed = double.tryParse(value ?? '');
    return parsed == null || parsed <= 0 ? fallback : parsed;
  }

  Future<void> _loadUser() async {
    final String? raw = _prefs?.getString(_userKey);
    if (raw != null && raw.isNotEmpty) {
      user = AppUser.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
  }

  Future<void> _saveUser() async {
    if (user == null) return;
    await _prefs?.setString(_userKey, jsonEncode(user!.toJson()));
  }

  Future<void> _loadTodayData() async {
    todayData = await _readDayData(_todayKey());
  }

  Future<DayData> _readDayData(String date) async {
    final DayData? cached = _dayDataCache[date];
    if (cached != null) {
      return cached;
    }
    final String? raw = _prefs?.getString(_dayStorageKey(date));
    final DayData resolved = raw == null || raw.isEmpty
        ? DayData.empty(date)
        : DayData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    _dayDataCache[date] = resolved;
    return resolved;
  }

  Future<void> _writeDayData(DayData value) async {
    _dayDataCache[value.date] = value;
    await _prefs?.setString(
      _dayStorageKey(value.date),
      jsonEncode(value.toJson()),
    );
  }

  Future<void> _updateTodayData(
    DayData next, {
    bool refreshHistory = true,
  }) async {
    final String previousDate = todayData.date;
    todayData = next.copyWith(date: _todayKey());
    await _writeDayData(todayData);
    if (refreshHistory) {
      _resetStepSession();
      if (previousDate == todayData.date) {
        await _refreshRecentDaysWindow();
      } else {
        await _refreshDerivedDailyHistory();
      }
      notifyListeners();
    }
  }

  Future<void> _refreshDerivedDailyHistory() async {
    await _refreshRecentDaysWindow();
    streak = await _calculateStreak();
  }

  Future<void> _refreshRecentDaysWindow() async {
    recentDays7 = await getLastNDays(7);
  }

  Future<int> _calculateStreak() async {
    int total = 0;
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final DateTime now = DateTime.now();
    for (int i = 1; i <= 365; i += 1) {
      final String key = formatter.format(now.subtract(Duration(days: i)));
      final DayData day = await _readDayData(key);
      if (day.stepsCompleted > 0 || day.workoutDone) {
        total += 1;
      } else {
        break;
      }
    }
    return total;
  }

  Future<void> _loadNotifications() async {
    final String? raw = _prefs?.getString(_notificationsStorageKey);
    if (raw == null || raw.isEmpty) {
      notifications = _defaultNotifications;
      return;
    }
    final List<dynamic> parsed = jsonDecode(raw) as List<dynamic>;
    final List<NotificationPreference> saved = parsed
        .map(
          (dynamic item) =>
              NotificationPreference.fromJson(item as Map<String, dynamic>),
        )
        .toList();
    notifications = _defaultNotifications
        .map(
          (NotificationPreference base) => saved.firstWhere(
            (NotificationPreference item) => item.id == base.id,
            orElse: () => base,
          ),
        )
        .toList();
  }

  Future<void> _loadPeriodData() async {
    final String? raw = _prefs?.getString(_periodKey);
    if (raw != null && raw.isNotEmpty) {
      periodData = PeriodData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
    }
  }

  Future<void> _loadConnectedDevice() async {
    final String? raw = _prefs?.getString(_deviceKey);
    if (raw != null && raw.isNotEmpty) {
      connectedDevice = DeviceInfo.fromJson(
        jsonDecode(raw) as Map<String, dynamic>,
      );
    }
  }

  Future<void> _loadWorkoutHistory() async {
    final String? raw = _prefs?.getString(_historyKey);
    if (raw != null && raw.isNotEmpty) {
      workoutHistory = (jsonDecode(raw) as List<dynamic>)
          .map(
            (dynamic item) =>
                WorkoutHistoryRecord.fromJson(item as Map<String, dynamic>),
          )
          .toList();
    }
  }

  AppUser _mergeProfile(AppUser base, Map<String, dynamic> profile) {
    return base.copyWith(
      name: profile['name']?.toString() ?? base.name,
      email: profile['email']?.toString() ?? base.email,
      height: profile['heightCm']?.toString() ?? base.height,
      weight: profile['weightKg']?.toString() ?? base.weight,
      age: profile['age']?.toString() ?? base.age,
      goal: profile['goal']?.toString() ?? base.goal,
      fitnessLevel: profile['fitnessLevel']?.toString() ?? base.fitnessLevel,
      activityLevel: profile['activityLevel']?.toString() ?? base.activityLevel,
      gender: profile['gender']?.toString() ?? base.gender,
      dietType: profile['dietType']?.toString() ?? base.dietType,
      workoutDaysPerWeek:
          profile['workoutDaysPerWeek'] as int? ?? base.workoutDaysPerWeek,
      workoutTime: profile['workoutTime']?.toString() ?? base.workoutTime,
    );
  }

  AppUser _patchUser(AppUser current, Map<String, dynamic> patch) {
    return current.copyWith(
      height: patch['height']?.toString() ?? current.height,
      weight: patch['weight']?.toString() ?? current.weight,
      age: patch['age']?.toString() ?? current.age,
      goal: patch['goal']?.toString() ?? current.goal,
      fitnessLevel: patch['fitnessLevel']?.toString() ?? current.fitnessLevel,
      activityLevel:
          patch['activityLevel']?.toString() ?? current.activityLevel,
      workoutDaysPerWeek:
          patch['workoutDaysPerWeek'] as int? ?? current.workoutDaysPerWeek,
      workoutTime: patch['workoutTime']?.toString() ?? current.workoutTime,
      gender: patch['gender']?.toString() ?? current.gender,
      dietType: patch['dietType']?.toString() ?? current.dietType,
      name: patch['name']?.toString() ?? current.name,
      email: patch['email']?.toString() ?? current.email,
    );
  }

  String _planStorageKey(String userId) => '${_planKey}_$userId';
  String _weekStorageKey(String userId) => '${_weekKey}_$userId';
  String _weekNumStorageKey(String userId) => '${_weekNumKey}_$userId';

  String get _notificationsStorageKey =>
      '$_notificationsPrefix${user?.id ?? 'default'}';

  String _planSignature(AppUser targetUser, int week) {
    return <String?>[
      targetUser.id,
      targetUser.goal,
      targetUser.fitnessLevel,
      targetUser.workoutDaysPerWeek?.toString(),
      targetUser.weight,
      targetUser.height,
      targetUser.age,
      targetUser.activityLevel,
      targetUser.gender,
      targetUser.dietType ?? DietTypeValue.nonVeg,
      '$week',
    ].join('|');
  }

  String _googleSignInMessage(Object error) {
    final String message = error.toString();
    final String lower = message.toLowerCase();
    if (lower.contains('canceled')) {
      return defaultTargetPlatform == TargetPlatform.android
          ? 'Google Sign-In stopped after account selection. Check the Android SHA keys, package name com.codeuppath.kartikai, and GOOGLE_SERVER_CLIENT_ID.'
          : 'Google Sign-In was cancelled.';
    }
    if (lower.contains('clientid') ||
        lower.contains('configuration') ||
        lower.contains('sign_in_failed') ||
        lower.contains('code=10')) {
      return 'Google Sign-In is not configured for this build yet. Use the web OAuth client as GOOGLE_SERVER_CLIENT_ID and register this Android build for com.codeuppath.kartikai.';
    }
    if (lower.contains('not configured on the server')) {
      return 'Google Sign-In is not configured on the backend yet.';
    }
    if (lower.contains('invalid google token') ||
        lower.contains('email is not verified')) {
      return 'Google account verification failed. Please try another account.';
    }
    if (lower.contains('timed out')) {
      return 'Cannot connect to the server right now.';
    }
    return 'Google Sign-In failed. Please try again.';
  }

  String _dayStorageKey(String date) => '$_dayPrefix$date';

  String _workoutHistoryKey(WorkoutHistoryRecord record) {
    return '${record.dayName}|${_normalizeDayKey(record.date)}';
  }

  String _normalizeIsoDate(dynamic value) {
    if (value == null) return DateTime.now().toIso8601String();
    final String raw = value.toString();
    final DateTime? parsed = DateTime.tryParse(raw);
    return parsed?.toIso8601String() ?? raw;
  }

  String _normalizeDayKey(dynamic value) {
    if (value == null) return '';
    final String raw = value.toString();
    final DateTime? parsed = DateTime.tryParse(raw);
    if (parsed != null) {
      return DateFormat('yyyy-MM-dd').format(parsed);
    }
    return raw.length >= 10 ? raw.substring(0, 10) : raw;
  }

  int _sortDateDescending(String left, String right) {
    final DateTime? leftDate = DateTime.tryParse(left);
    final DateTime? rightDate = DateTime.tryParse(right);
    if (leftDate == null || rightDate == null) {
      return right.compareTo(left);
    }
    return rightDate.compareTo(leftDate);
  }

  int _asInt(dynamic value) {
    if (value is int) return value;
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  static String _todayKey() => DateFormat('yyyy-MM-dd').format(DateTime.now());
}
