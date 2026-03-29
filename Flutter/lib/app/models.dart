import 'dart:convert';

class FitnessGoalValue {
  static const loseWeight = 'lose_weight';
  static const gainMuscle = 'gain_muscle';
  static const maintain = 'maintain';
  static const improveEndurance = 'improve_endurance';

  static const all = <String>[
    loseWeight,
    gainMuscle,
    maintain,
    improveEndurance,
  ];
}

class FitnessLevelValue {
  static const beginner = 'beginner';
  static const intermediate = 'intermediate';
  static const advanced = 'advanced';

  static const all = <String>[beginner, intermediate, advanced];
}

class ActivityLevelValue {
  static const sedentary = 'sedentary';
  static const light = 'light';
  static const moderate = 'moderate';
  static const active = 'active';
  static const veryActive = 'veryActive';

  static const all = <String>[sedentary, light, moderate, active, veryActive];
}

class DietTypeValue {
  static const veg = 'veg';
  static const nonVeg = 'nonveg';

  static const all = <String>[veg, nonVeg];
}

class GenderValue {
  static const male = 'male';
  static const female = 'female';

  static const all = <String>[male, female];
}

class DifficultyValue {
  static const easy = 'Easy';
  static const intermediate = 'Intermediate';
  static const hard = 'Hard';
}

class AuthActionResult {
  const AuthActionResult({
    required this.success,
    this.error,
    this.isNewUser = false,
  });

  final bool success;
  final String? error;
  final bool isNewUser;
}

class AppUser {
  const AppUser({
    required this.id,
    required this.name,
    required this.email,
    required this.joinedAt,
    this.dbId,
    this.height,
    this.weight,
    this.age,
    this.goal,
    this.fitnessLevel,
    this.activityLevel,
    this.workoutDaysPerWeek,
    this.workoutTime,
    this.gender,
    this.dietType,
  });

  final String id;
  final int? dbId;
  final String name;
  final String email;
  final String joinedAt;
  final String? height;
  final String? weight;
  final String? age;
  final String? goal;
  final String? fitnessLevel;
  final String? activityLevel;
  final int? workoutDaysPerWeek;
  final String? workoutTime;
  final String? gender;
  final String? dietType;

  AppUser copyWith({
    String? id,
    int? dbId,
    String? name,
    String? email,
    String? joinedAt,
    String? height,
    String? weight,
    String? age,
    String? goal,
    String? fitnessLevel,
    String? activityLevel,
    int? workoutDaysPerWeek,
    String? workoutTime,
    String? gender,
    String? dietType,
  }) {
    return AppUser(
      id: id ?? this.id,
      dbId: dbId ?? this.dbId,
      name: name ?? this.name,
      email: email ?? this.email,
      joinedAt: joinedAt ?? this.joinedAt,
      height: height ?? this.height,
      weight: weight ?? this.weight,
      age: age ?? this.age,
      goal: goal ?? this.goal,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      activityLevel: activityLevel ?? this.activityLevel,
      workoutDaysPerWeek: workoutDaysPerWeek ?? this.workoutDaysPerWeek,
      workoutTime: workoutTime ?? this.workoutTime,
      gender: gender ?? this.gender,
      dietType: dietType ?? this.dietType,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'dbId': dbId,
      'name': name,
      'email': email,
      'joinedAt': joinedAt,
      'height': height,
      'weight': weight,
      'age': age,
      'goal': goal,
      'fitnessLevel': fitnessLevel,
      'activityLevel': activityLevel,
      'workoutDaysPerWeek': workoutDaysPerWeek,
      'workoutTime': workoutTime,
      'gender': gender,
      'dietType': dietType,
    };
  }

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      id: json['id']?.toString() ?? 'default',
      dbId: json['dbId'] as int?,
      name: json['name']?.toString() ?? 'User',
      email: json['email']?.toString() ?? '',
      joinedAt:
          json['joinedAt']?.toString() ?? DateTime.now().toIso8601String(),
      height: json['height']?.toString(),
      weight: json['weight']?.toString(),
      age: json['age']?.toString(),
      goal: json['goal']?.toString(),
      fitnessLevel: json['fitnessLevel']?.toString(),
      activityLevel: json['activityLevel']?.toString(),
      workoutDaysPerWeek: json['workoutDaysPerWeek'] as int?,
      workoutTime: json['workoutTime']?.toString(),
      gender: json['gender']?.toString(),
      dietType: json['dietType']?.toString(),
    );
  }
}

class Exercise {
  const Exercise({
    required this.id,
    required this.name,
    required this.sets,
    required this.reps,
    required this.rest,
    required this.muscle,
    required this.category,
    required this.difficulty,
    this.duration,
  });

  final String id;
  final String name;
  final int sets;
  final String reps;
  final String rest;
  final int? duration;
  final String muscle;
  final String category;
  final String difficulty;

  Exercise copyWith({
    String? id,
    String? name,
    int? sets,
    String? reps,
    String? rest,
    int? duration,
    String? muscle,
    String? category,
    String? difficulty,
  }) {
    return Exercise(
      id: id ?? this.id,
      name: name ?? this.name,
      sets: sets ?? this.sets,
      reps: reps ?? this.reps,
      rest: rest ?? this.rest,
      duration: duration ?? this.duration,
      muscle: muscle ?? this.muscle,
      category: category ?? this.category,
      difficulty: difficulty ?? this.difficulty,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'sets': sets,
      'reps': reps,
      'rest': rest,
      'duration': duration,
      'muscle': muscle,
      'category': category,
      'difficulty': difficulty,
    };
  }

  factory Exercise.fromJson(Map<String, dynamic> json) {
    return Exercise(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      sets: (json['sets'] as num?)?.toInt() ?? 0,
      reps: json['reps']?.toString() ?? '',
      rest: json['rest']?.toString() ?? '',
      duration: (json['duration'] as num?)?.toInt(),
      muscle: json['muscle']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      difficulty: json['difficulty']?.toString() ?? DifficultyValue.easy,
    );
  }
}

class WorkoutDay {
  const WorkoutDay({
    required this.day,
    required this.dayNumber,
    required this.name,
    required this.category,
    required this.duration,
    required this.difficulty,
    required this.calories,
    required this.color,
    required this.exercises,
    required this.isRestDay,
  });

  final String day;
  final int dayNumber;
  final String name;
  final String category;
  final String duration;
  final String difficulty;
  final int calories;
  final String color;
  final List<Exercise> exercises;
  final bool isRestDay;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'day': day,
      'dayNumber': dayNumber,
      'name': name,
      'category': category,
      'duration': duration,
      'difficulty': difficulty,
      'calories': calories,
      'color': color,
      'exercises': exercises.map((exercise) => exercise.toJson()).toList(),
      'isRestDay': isRestDay,
    };
  }

  factory WorkoutDay.fromJson(Map<String, dynamic> json) {
    return WorkoutDay(
      day: json['day']?.toString() ?? '',
      dayNumber: (json['dayNumber'] as num?)?.toInt() ?? 0,
      name: json['name']?.toString() ?? '',
      category: json['category']?.toString() ?? '',
      duration: json['duration']?.toString() ?? '',
      difficulty: json['difficulty']?.toString() ?? DifficultyValue.easy,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      color: json['color']?.toString() ?? '#2ECC71',
      exercises: (json['exercises'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic item) => Exercise.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      isRestDay: json['isRestDay'] as bool? ?? false,
    );
  }
}

class MealSuggestion {
  const MealSuggestion({
    required this.id,
    required this.type,
    required this.time,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.isVeg,
  });

  final String id;
  final String type;
  final String time;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final bool isVeg;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'type': type,
      'time': time,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'isVeg': isVeg,
    };
  }

  factory MealSuggestion.fromJson(Map<String, dynamic> json) {
    return MealSuggestion(
      id: json['id']?.toString() ?? '',
      type: json['type']?.toString() ?? 'Breakfast',
      time: json['time']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fat: (json['fat'] as num?)?.toInt() ?? 0,
      isVeg: json['isVeg'] as bool? ?? false,
    );
  }
}

class NutritionPlan {
  const NutritionPlan({
    required this.calories,
    required this.proteinGoal,
    required this.carbsGoal,
    required this.fatGoal,
    required this.meals,
  });

  final int calories;
  final int proteinGoal;
  final int carbsGoal;
  final int fatGoal;
  final List<MealSuggestion> meals;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'calories': calories,
      'proteinGoal': proteinGoal,
      'carbsGoal': carbsGoal,
      'fatGoal': fatGoal,
      'meals': meals.map((meal) => meal.toJson()).toList(),
    };
  }

  factory NutritionPlan.fromJson(Map<String, dynamic> json) {
    return NutritionPlan(
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      proteinGoal: (json['proteinGoal'] as num?)?.toInt() ?? 0,
      carbsGoal: (json['carbsGoal'] as num?)?.toInt() ?? 0,
      fatGoal: (json['fatGoal'] as num?)?.toInt() ?? 0,
      meals: (json['meals'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic item) =>
                MealSuggestion.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class PlanSnapshot {
  const PlanSnapshot({
    required this.weekly,
    required this.nutrition,
    required this.tdee,
    required this.bmi,
    required this.bmiStatus,
  });

  final List<WorkoutDay> weekly;
  final NutritionPlan nutrition;
  final int tdee;
  final double bmi;
  final String bmiStatus;
}

class CustomMeal {
  const CustomMeal({
    required this.id,
    required this.name,
    required this.calories,
    required this.protein,
    required this.carbs,
    required this.fat,
    required this.time,
    required this.mealType,
  });

  final String id;
  final String name;
  final int calories;
  final int protein;
  final int carbs;
  final int fat;
  final String time;
  final String mealType;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'calories': calories,
      'protein': protein,
      'carbs': carbs,
      'fat': fat,
      'time': time,
      'mealType': mealType,
    };
  }

  factory CustomMeal.fromJson(Map<String, dynamic> json) {
    return CustomMeal(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      calories: (json['calories'] as num?)?.toInt() ?? 0,
      protein: (json['protein'] as num?)?.toInt() ?? 0,
      carbs: (json['carbs'] as num?)?.toInt() ?? 0,
      fat: (json['fat'] as num?)?.toInt() ?? 0,
      time: json['time']?.toString() ?? '',
      mealType: json['mealType']?.toString() ?? 'Breakfast',
    );
  }
}

class DayData {
  const DayData({
    required this.date,
    required this.water,
    required this.caloriesConsumed,
    required this.proteinConsumed,
    required this.carbsConsumed,
    required this.fatConsumed,
    required this.workoutDone,
    required this.stepsCompleted,
    required this.distanceKm,
    required this.mealsLogged,
    required this.customMeals,
  });

  final String date;
  final int water;
  final int caloriesConsumed;
  final int proteinConsumed;
  final int carbsConsumed;
  final int fatConsumed;
  final bool workoutDone;
  final int stepsCompleted;
  final double distanceKm;
  final List<String> mealsLogged;
  final List<CustomMeal> customMeals;

  static DayData empty(String date) {
    return DayData(
      date: date,
      water: 0,
      caloriesConsumed: 0,
      proteinConsumed: 0,
      carbsConsumed: 0,
      fatConsumed: 0,
      workoutDone: false,
      stepsCompleted: 0,
      distanceKm: 0,
      mealsLogged: const <String>[],
      customMeals: const <CustomMeal>[],
    );
  }

  DayData copyWith({
    String? date,
    int? water,
    int? caloriesConsumed,
    int? proteinConsumed,
    int? carbsConsumed,
    int? fatConsumed,
    bool? workoutDone,
    int? stepsCompleted,
    double? distanceKm,
    List<String>? mealsLogged,
    List<CustomMeal>? customMeals,
  }) {
    return DayData(
      date: date ?? this.date,
      water: water ?? this.water,
      caloriesConsumed: caloriesConsumed ?? this.caloriesConsumed,
      proteinConsumed: proteinConsumed ?? this.proteinConsumed,
      carbsConsumed: carbsConsumed ?? this.carbsConsumed,
      fatConsumed: fatConsumed ?? this.fatConsumed,
      workoutDone: workoutDone ?? this.workoutDone,
      stepsCompleted: stepsCompleted ?? this.stepsCompleted,
      distanceKm: distanceKm ?? this.distanceKm,
      mealsLogged: mealsLogged ?? this.mealsLogged,
      customMeals: customMeals ?? this.customMeals,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date,
      'water': water,
      'caloriesConsumed': caloriesConsumed,
      'proteinConsumed': proteinConsumed,
      'carbsConsumed': carbsConsumed,
      'fatConsumed': fatConsumed,
      'workoutDone': workoutDone,
      'stepsCompleted': stepsCompleted,
      'distanceKm': distanceKm,
      'mealsLogged': mealsLogged,
      'customMeals': customMeals.map((meal) => meal.toJson()).toList(),
    };
  }

  factory DayData.fromJson(Map<String, dynamic> json) {
    return DayData(
      date: json['date']?.toString() ?? '',
      water: (json['water'] as num?)?.toInt() ?? 0,
      caloriesConsumed: (json['caloriesConsumed'] as num?)?.toInt() ?? 0,
      proteinConsumed: (json['proteinConsumed'] as num?)?.toInt() ?? 0,
      carbsConsumed: (json['carbsConsumed'] as num?)?.toInt() ?? 0,
      fatConsumed: (json['fatConsumed'] as num?)?.toInt() ?? 0,
      workoutDone: json['workoutDone'] as bool? ?? false,
      stepsCompleted: (json['stepsCompleted'] as num?)?.toInt() ?? 0,
      distanceKm: (json['distanceKm'] as num?)?.toDouble() ?? 0,
      mealsLogged: (json['mealsLogged'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList(),
      customMeals: (json['customMeals'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic item) => CustomMeal.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
    );
  }
}

class StepRecord {
  const StepRecord({
    required this.date,
    required this.steps,
    required this.distance,
    required this.calories,
  });

  final String date;
  final int steps;
  final double distance;
  final int calories;
}

class NotificationPreference {
  const NotificationPreference({
    required this.id,
    required this.title,
    required this.description,
    required this.time,
    required this.enabled,
    required this.icon,
  });

  final String id;
  final String title;
  final String description;
  final String time;
  final bool enabled;
  final String icon;

  NotificationPreference copyWith({
    String? id,
    String? title,
    String? description,
    String? time,
    bool? enabled,
    String? icon,
  }) {
    return NotificationPreference(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      time: time ?? this.time,
      enabled: enabled ?? this.enabled,
      icon: icon ?? this.icon,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'title': title,
      'description': description,
      'time': time,
      'enabled': enabled,
      'icon': icon,
    };
  }

  factory NotificationPreference.fromJson(Map<String, dynamic> json) {
    return NotificationPreference(
      id: json['id']?.toString() ?? '',
      title: json['title']?.toString() ?? '',
      description: json['description']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
      enabled: json['enabled'] as bool? ?? false,
      icon: json['icon']?.toString() ?? 'notifications',
    );
  }
}

class PeriodEntry {
  const PeriodEntry({
    required this.startDate,
    required this.cycleLength,
    required this.symptoms,
    this.endDate,
  });

  final String startDate;
  final String? endDate;
  final int cycleLength;
  final List<String> symptoms;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'startDate': startDate,
      'endDate': endDate,
      'cycleLength': cycleLength,
      'symptoms': symptoms,
    };
  }

  factory PeriodEntry.fromJson(Map<String, dynamic> json) {
    return PeriodEntry(
      startDate: json['startDate']?.toString() ?? '',
      endDate: json['endDate']?.toString(),
      cycleLength: (json['cycleLength'] as num?)?.toInt() ?? 28,
      symptoms: (json['symptoms'] as List<dynamic>? ?? <dynamic>[])
          .map((dynamic item) => item.toString())
          .toList(),
    );
  }
}

class PeriodData {
  const PeriodData({required this.entries, required this.cycleLength});

  final List<PeriodEntry> entries;
  final int cycleLength;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'entries': entries.map((entry) => entry.toJson()).toList(),
      'cycleLength': cycleLength,
    };
  }

  factory PeriodData.fromJson(Map<String, dynamic> json) {
    return PeriodData(
      entries: (json['entries'] as List<dynamic>? ?? <dynamic>[])
          .map(
            (dynamic item) =>
                PeriodEntry.fromJson(item as Map<String, dynamic>),
          )
          .toList(),
      cycleLength: (json['cycleLength'] as num?)?.toInt() ?? 28,
    );
  }
}

class DeviceInfo {
  const DeviceInfo({
    required this.id,
    required this.name,
    required this.model,
    required this.icon,
    this.steps,
    this.battery,
    this.lastSync,
  });

  final String id;
  final String name;
  final String model;
  final String icon;
  final int? steps;
  final int? battery;
  final String? lastSync;

  DeviceInfo copyWith({
    String? id,
    String? name,
    String? model,
    String? icon,
    int? steps,
    int? battery,
    String? lastSync,
  }) {
    return DeviceInfo(
      id: id ?? this.id,
      name: name ?? this.name,
      model: model ?? this.model,
      icon: icon ?? this.icon,
      steps: steps ?? this.steps,
      battery: battery ?? this.battery,
      lastSync: lastSync ?? this.lastSync,
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'model': model,
      'icon': icon,
      'steps': steps,
      'battery': battery,
      'lastSync': lastSync,
    };
  }

  factory DeviceInfo.fromJson(Map<String, dynamic> json) {
    return DeviceInfo(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? '',
      model: json['model']?.toString() ?? '',
      icon: json['icon']?.toString() ?? 'watch',
      steps: (json['steps'] as num?)?.toInt(),
      battery: (json['battery'] as num?)?.toInt(),
      lastSync: json['lastSync']?.toString(),
    );
  }
}

class WorkoutHistoryRecord {
  const WorkoutHistoryRecord({
    required this.date,
    required this.dayName,
    required this.duration,
    required this.exercises,
    required this.calories,
  });

  final String date;
  final String dayName;
  final int duration;
  final int exercises;
  final int calories;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date,
      'dayName': dayName,
      'duration': duration,
      'exercises': exercises,
      'calories': calories,
    };
  }

  factory WorkoutHistoryRecord.fromJson(Map<String, dynamic> json) {
    return WorkoutHistoryRecord(
      date: json['date']?.toString() ?? '',
      dayName: json['dayName']?.toString() ?? 'Workout',
      duration: (json['duration'] as num?)?.toInt() ?? 0,
      exercises: (json['exercises'] as num?)?.toInt() ?? 0,
      calories: (json['calories'] as num?)?.toInt() ?? 0,
    );
  }
}

class ChatMessage {
  const ChatMessage({
    required this.id,
    required this.role,
    required this.text,
    required this.time,
  });

  final String id;
  final String role;
  final String text;
  final String time;

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'role': role,
      'text': text,
      'time': time,
    };
  }

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      id: json['id']?.toString() ?? '',
      role: json['role']?.toString() ?? 'assistant',
      text: json['text']?.toString() ?? '',
      time: json['time']?.toString() ?? '',
    );
  }
}

String encodeJson(Object value) => jsonEncode(value);
