import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../state/app_model.dart';
import '../ui.dart';
import 'main_shell.dart';

const List<Map<String, String>> _languages = <Map<String, String>>[
  <String, String>{
    'code': 'en',
    'label': 'English',
    'native': 'English',
    'flag': '🇺🇸',
  },
  <String, String>{
    'code': 'hi',
    'label': 'Hindi',
    'native': 'हिन्दी',
    'flag': '🇮🇳',
  },
  <String, String>{
    'code': 'es',
    'label': 'Spanish',
    'native': 'Español',
    'flag': '🇪🇸',
  },
  <String, String>{
    'code': 'fr',
    'label': 'French',
    'native': 'Français',
    'flag': '🇫🇷',
  },
  <String, String>{
    'code': 'de',
    'label': 'German',
    'native': 'Deutsch',
    'flag': '🇩🇪',
  },
  <String, String>{
    'code': 'ar',
    'label': 'Arabic',
    'native': 'العربية',
    'flag': '🇸🇦',
  },
  <String, String>{
    'code': 'zh',
    'label': 'Chinese',
    'native': '中文',
    'flag': '🇨🇳',
  },
  <String, String>{
    'code': 'ja',
    'label': 'Japanese',
    'native': '日本語',
    'flag': '🇯🇵',
  },
];

const List<Map<String, String>> _goals = <Map<String, String>>[
  <String, String>{
    'id': FitnessGoalValue.loseWeight,
    'title': 'Lose Fat',
    'subtitle': 'Burn calories and tone up',
  },
  <String, String>{
    'id': FitnessGoalValue.gainMuscle,
    'title': 'Gain Muscle',
    'subtitle': 'Build strength and mass',
  },
  <String, String>{
    'id': FitnessGoalValue.maintain,
    'title': 'Stay Fit',
    'subtitle': 'Maintain and improve fitness',
  },
  <String, String>{
    'id': FitnessGoalValue.improveEndurance,
    'title': 'Build Endurance',
    'subtitle': 'Improve cardiovascular health',
  },
];

class LanguagePage extends StatefulWidget {
  const LanguagePage({super.key});

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String _selected = 'en';

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Scaffold(
      backgroundColor: palette.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: palette.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'STEP 1 OF 3',
                  style: TextStyle(
                    color: palette.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                'Choose Your Language',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "Select the language you're most comfortable with.",
                style: TextStyle(color: palette.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: GridView.builder(
                  itemCount: _languages.length,
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    mainAxisSpacing: 10,
                    crossAxisSpacing: 10,
                    childAspectRatio: 1.1,
                  ),
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, String> language = _languages[index];
                    final bool selected = _selected == language['code'];
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () =>
                          setState(() => _selected = language['code']!),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selected ? palette.primaryLight : palette.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected ? palette.primary : palette.border,
                            width: 1.5,
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              language['flag']!,
                              style: const TextStyle(fontSize: 28),
                            ),
                            const SizedBox(height: 10),
                            Text(
                              language['label']!,
                              style: TextStyle(
                                color: selected
                                    ? palette.primary
                                    : palette.textPrimary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              language['native']!,
                              style: TextStyle(
                                color: palette.textSecondary,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              PrimaryButton(
                label: 'Continue',
                onPressed: () async {
                  await context.read<AppModel>().setLanguage(_selected);
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(builder: (_) => const GoalPage()),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class GoalPage extends StatefulWidget {
  const GoalPage({super.key});

  @override
  State<GoalPage> createState() => _GoalPageState();
}

class _GoalPageState extends State<GoalPage> {
  String _selected = FitnessGoalValue.gainMuscle;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(title: const Text('Goal')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: palette.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'STEP 2 OF 3',
                  style: TextStyle(
                    color: palette.primary,
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(height: 14),
              Text(
                "What's Your Goal?",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  color: palette.textPrimary,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                "We'll customize your workouts and nutrition plan around this.",
                style: TextStyle(color: palette.textSecondary, height: 1.5),
              ),
              const SizedBox(height: 22),
              Expanded(
                child: ListView.separated(
                  itemCount: _goals.length,
                  separatorBuilder: (_, int index) =>
                      const SizedBox(height: 10),
                  itemBuilder: (BuildContext context, int index) {
                    final Map<String, String> goal = _goals[index];
                    final bool selected = _selected == goal['id'];
                    return InkWell(
                      borderRadius: BorderRadius.circular(16),
                      onTap: () => setState(() => _selected = goal['id']!),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: selected
                              ? palette.primaryLight.withValues(alpha: 0.4)
                              : palette.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: selected ? palette.primary : palette.border,
                            width: 1.5,
                          ),
                        ),
                        child: Row(
                          children: <Widget>[
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    goal['title']!,
                                    style: TextStyle(
                                      color: selected
                                          ? palette.primary
                                          : palette.textPrimary,
                                      fontWeight: FontWeight.w800,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    goal['subtitle']!,
                                    style: TextStyle(
                                      color: palette.textSecondary,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Icon(
                              selected
                                  ? Icons.check_circle
                                  : Icons.radio_button_unchecked,
                              color: selected
                                  ? palette.primary
                                  : palette.border,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
              PrimaryButton(
                label: 'Set My Goal',
                onPressed: () async {
                  await context.read<AppModel>().updateProfile(
                    <String, dynamic>{'goal': _selected},
                  );
                  if (!context.mounted) return;
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileSetupPage(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ProfileSetupPage extends StatefulWidget {
  const ProfileSetupPage({super.key, this.isEditing = false});

  final bool isEditing;

  @override
  State<ProfileSetupPage> createState() => _ProfileSetupPageState();
}

class _ProfileSetupPageState extends State<ProfileSetupPage> {
  late final TextEditingController _nameController;
  late double _heightCm;
  late double _weightKg;
  late int _age;
  String _gender = GenderValue.male;
  String _dietType = DietTypeValue.veg;
  String _fitnessLevel = FitnessLevelValue.beginner;
  String _activityLevel = ActivityLevelValue.moderate;
  int _workoutDays = 3;
  String _workoutTime = 'morning';

  @override
  void initState() {
    super.initState();
    final AppUser? user = context.read<AppModel>().user;
    _nameController = TextEditingController(text: user?.name ?? '');
    _heightCm = double.tryParse(user?.height ?? '175') ?? 175;
    _weightKg = double.tryParse(user?.weight ?? '70') ?? 70;
    _age = int.tryParse(user?.age ?? '25') ?? 25;
    _gender = user?.gender ?? GenderValue.male;
    _dietType = user?.dietType ?? DietTypeValue.veg;
    _fitnessLevel = user?.fitnessLevel ?? FitnessLevelValue.beginner;
    _activityLevel = user?.activityLevel ?? ActivityLevelValue.moderate;
    _workoutDays = user?.workoutDaysPerWeek ?? 3;
    _workoutTime = user?.workoutTime ?? 'morning';
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  double get _bmi => _weightKg / ((_heightCm / 100) * (_heightCm / 100));

  Future<void> _save() async {
    final String trimmedName = _nameController.text.trim();
    if (trimmedName.isEmpty) {
      showAppSnackBar(context, 'Please enter your name.');
      return;
    }
    await context.read<AppModel>().updateProfile(<String, dynamic>{
      'name': trimmedName,
      'height': _heightCm.round().toString(),
      'weight': _weightKg.toStringAsFixed(1),
      'age': _age.toString(),
      'gender': _gender,
      'dietType': _dietType,
      'fitnessLevel': _fitnessLevel,
      'activityLevel': _activityLevel,
      'workoutDaysPerWeek': _workoutDays,
      'workoutTime': _workoutTime,
    });
    if (!mounted) return;
    if (widget.isEditing) {
      Navigator.of(context).pop(true);
      return;
    }
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const AppShell()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final Color bmiColor = _bmi < 18.5
        ? palette.info
        : _bmi < 25
        ? palette.primary
        : _bmi < 30
        ? palette.warning
        : palette.danger;
    return Scaffold(
      backgroundColor: palette.background,
      appBar: AppBar(
        title: Text(widget.isEditing ? 'Update Profile' : 'Your Profile'),
      ),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            if (!widget.isEditing)
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: palette.primaryLight,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  'STEP 3 OF 3',
                  style: TextStyle(
                    color: palette.primary,
                    fontWeight: FontWeight.w800,
                    fontSize: 11,
                  ),
                ),
              ),
            const SizedBox(height: 14),
            Text(
              widget.isEditing ? 'Update Your Profile' : 'Your Profile',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              widget.isEditing
                  ? 'Adjust your stats and preferences anytime.'
                  : 'Help us personalize your experience.',
              style: TextStyle(color: palette.textSecondary, height: 1.5),
            ),
            const SizedBox(height: 20),
            AppTextField(
              controller: _nameController,
              label: 'Full Name',
              hint: 'Enter your full name',
              prefix: const Icon(Icons.person_outline_rounded),
            ),
            const SizedBox(height: 20),
            _buildChoiceGroup(
              context,
              title: 'Gender',
              values: const <Map<String, String>>[
                <String, String>{'id': GenderValue.male, 'label': 'Male'},
                <String, String>{'id': GenderValue.female, 'label': 'Female'},
              ],
              selected: _gender,
              onSelected: (String value) => setState(() => _gender = value),
            ),
            _buildChoiceGroup(
              context,
              title: 'Diet Preference',
              values: const <Map<String, String>>[
                <String, String>{
                  'id': DietTypeValue.veg,
                  'label': 'Vegetarian',
                },
                <String, String>{
                  'id': DietTypeValue.nonVeg,
                  'label': 'Non-Vegetarian',
                },
              ],
              selected: _dietType,
              onSelected: (String value) => setState(() => _dietType = value),
            ),
            _buildStepper(
              context,
              title: 'Height',
              value: '${_heightCm.round()} cm',
              onMinus: () =>
                  setState(() => _heightCm = (_heightCm - 1).clamp(100, 250)),
              onPlus: () =>
                  setState(() => _heightCm = (_heightCm + 1).clamp(100, 250)),
            ),
            _buildStepper(
              context,
              title: 'Weight',
              value: '${_weightKg.toStringAsFixed(1)} kg',
              onMinus: () =>
                  setState(() => _weightKg = (_weightKg - 0.5).clamp(30, 200)),
              onPlus: () =>
                  setState(() => _weightKg = (_weightKg + 0.5).clamp(30, 200)),
            ),
            _buildStepper(
              context,
              title: 'Age',
              value: '$_age years',
              onMinus: () => setState(() => _age = (_age - 1).clamp(10, 90)),
              onPlus: () => setState(() => _age = (_age + 1).clamp(10, 90)),
            ),
            FitnessCard(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'BMI Preview',
                        style: TextStyle(color: palette.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        _bmi.toStringAsFixed(1),
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: bmiColor.withValues(alpha: 0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      _bmi < 18.5
                          ? 'Underweight'
                          : _bmi < 25
                          ? 'Normal'
                          : _bmi < 30
                          ? 'Overweight'
                          : 'Obese',
                      style: TextStyle(
                        color: bmiColor,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            _buildChoiceGroup(
              context,
              title: 'Fitness Level',
              values: const <Map<String, String>>[
                <String, String>{
                  'id': FitnessLevelValue.beginner,
                  'label': 'Beginner',
                },
                <String, String>{
                  'id': FitnessLevelValue.intermediate,
                  'label': 'Intermediate',
                },
                <String, String>{
                  'id': FitnessLevelValue.advanced,
                  'label': 'Advanced',
                },
              ],
              selected: _fitnessLevel,
              onSelected: (String value) =>
                  setState(() => _fitnessLevel = value),
            ),
            _buildChoiceGroup(
              context,
              title: 'Daily Activity Level',
              values: const <Map<String, String>>[
                <String, String>{
                  'id': ActivityLevelValue.sedentary,
                  'label': 'Sedentary',
                },
                <String, String>{
                  'id': ActivityLevelValue.light,
                  'label': 'Lightly Active',
                },
                <String, String>{
                  'id': ActivityLevelValue.moderate,
                  'label': 'Moderately Active',
                },
                <String, String>{
                  'id': ActivityLevelValue.active,
                  'label': 'Active',
                },
                <String, String>{
                  'id': ActivityLevelValue.veryActive,
                  'label': 'Very Active',
                },
              ],
              selected: _activityLevel,
              onSelected: (String value) =>
                  setState(() => _activityLevel = value),
            ),
            const SizedBox(height: 8),
            Text(
              'Workout Days Per Week',
              style: TextStyle(
                color: palette.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <int>[2, 3, 4, 5, 6]
                  .map(
                    (int dayCount) => ChoiceChip(
                      label: Text('$dayCount days'),
                      selected: _workoutDays == dayCount,
                      onSelected: (_) =>
                          setState(() => _workoutDays = dayCount),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 20),
            Text(
              'Preferred Workout Time',
              style: TextStyle(
                color: palette.textSecondary,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: <String>['morning', 'afternoon', 'evening']
                  .map(
                    (String time) => ChoiceChip(
                      label: Text(time[0].toUpperCase() + time.substring(1)),
                      selected: _workoutTime == time,
                      onSelected: (_) => setState(() => _workoutTime = time),
                    ),
                  )
                  .toList(),
            ),
            const SizedBox(height: 28),
            PrimaryButton(
              label: widget.isEditing ? 'Save Changes' : 'Complete Setup',
              onPressed: _save,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChoiceGroup(
    BuildContext context, {
    required String title,
    required List<Map<String, String>> values,
    required String selected,
    required ValueChanged<String> onSelected,
  }) {
    final AppPalette palette = paletteOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            color: palette.textSecondary,
            fontWeight: FontWeight.w700,
          ),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: values
              .map(
                (Map<String, String> item) => ChoiceChip(
                  label: Text(item['label']!),
                  selected: selected == item['id'],
                  onSelected: (_) => onSelected(item['id']!),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildStepper(
    BuildContext context, {
    required String title,
    required String value,
    required VoidCallback onMinus,
    required VoidCallback onPlus,
  }) {
    final AppPalette palette = paletteOf(context);
    return FitnessCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: TextStyle(
              color: palette.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: <Widget>[
              IconButton(
                onPressed: onMinus,
                icon: const Icon(Icons.remove),
                style: IconButton.styleFrom(backgroundColor: palette.surface),
              ),
              Expanded(
                child: Center(
                  child: Text(
                    value,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: palette.textPrimary,
                    ),
                  ),
                ),
              ),
              IconButton(
                onPressed: onPlus,
                icon: const Icon(Icons.add),
                style: IconButton.styleFrom(backgroundColor: palette.surface),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
