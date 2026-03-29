import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../state/app_model.dart';
import '../ui.dart';
import 'screen_helpers.dart';
import 'secondary_screens.dart';

class WorkoutTab extends StatefulWidget {
  const WorkoutTab({super.key});

  @override
  State<WorkoutTab> createState() => _WorkoutTabState();
}

class _WorkoutTabState extends State<WorkoutTab> {
  String _selectedCategory = 'All';
  String _selectedDifficulty = 'All';
  int? _selectedDayNumber;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final ({
      String planSource,
      List<WorkoutDay> weeklyPlan,
      WorkoutDay? todayWorkout,
    })
    workout = context
        .select<
          AppModel,
          ({
            String planSource,
            List<WorkoutDay> weeklyPlan,
            WorkoutDay? todayWorkout,
          })
        >(
          (AppModel model) => (
            planSource: model.planSource,
            weeklyPlan: model.weeklyPlan,
            todayWorkout: model.todayWorkout,
          ),
        );
    final String planLabel = workout.planSource == 'ai'
        ? 'AI workout plan'
        : workout.planSource == 'fallback'
        ? 'Backup workout plan'
        : 'Profile workout plan';
    final List<WorkoutDay> weeklyPlan = workout.weeklyPlan;
    final WorkoutDay? displayDay = weeklyPlan.cast<WorkoutDay?>().firstWhere(
      (WorkoutDay? day) => day?.dayNumber == _selectedDayNumber,
      orElse: () =>
          workout.todayWorkout ??
          (weeklyPlan.isNotEmpty ? weeklyPlan.first : null),
    );
    final List<WorkoutDay> library = weeklyPlan
        .where((WorkoutDay day) => !day.isRestDay)
        .toList();
    final List<String> categories = <String>[
      'All',
      ...<String>{...library.map((WorkoutDay day) => day.category)},
    ];
    final List<String> difficulties = <String>[
      'All',
      DifficultyValue.easy,
      DifficultyValue.intermediate,
      DifficultyValue.hard,
    ];
    final List<WorkoutDay> filtered = library.where((WorkoutDay day) {
      final bool categoryMatch =
          _selectedCategory == 'All' || day.category == _selectedCategory;
      final bool difficultyMatch =
          _selectedDifficulty == 'All' || day.difficulty == _selectedDifficulty;
      return categoryMatch && difficultyMatch;
    }).toList();

    return AppBackdrop(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: <Widget>[
            Text(
              'Workout',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.w800,
                color: palette.textPrimary,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              'Push past your limits with your weekly plan.',
              style: TextStyle(color: palette.textSecondary),
            ),
            const SizedBox(height: 12),
            StatusPill(
              label: planLabel,
              background: palette.primaryLight.withValues(alpha: 0.7),
              foreground: palette.primary,
              icon: workout.planSource == 'ai'
                  ? Icons.auto_awesome_rounded
                  : Icons.fitness_center_rounded,
            ),
            const SizedBox(height: 20),
            SectionHeader(title: 'This Week'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: weeklyPlan
                    .map(
                      (WorkoutDay day) => Padding(
                        padding: const EdgeInsets.only(right: 10),
                        child: _DayChip(
                          day: day,
                          selected: displayDay?.dayNumber == day.dayNumber,
                          onTap: () => setState(
                            () => _selectedDayNumber = day.dayNumber,
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 18),
            SectionHeader(
              title: displayDay == null
                  ? "Today's Plan"
                  : "${displayDay.day}'s Plan",
            ),
            if (displayDay == null)
              FitnessCard(
                child: Text(
                  'Complete your profile to generate a workout plan.',
                  style: TextStyle(color: palette.textSecondary),
                ),
              )
            else
              FitnessCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          width: 5,
                          height: 44,
                          decoration: BoxDecoration(
                            color: colorFromHex(displayDay.color),
                            borderRadius: BorderRadius.circular(999),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                displayDay.name,
                                style: TextStyle(
                                  fontSize: 22,
                                  fontWeight: FontWeight.w800,
                                  color: palette.textPrimary,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                displayDay.isRestDay
                                    ? 'Active recovery and light mobility work.'
                                    : '${displayDay.exercises.length} exercises • ${displayDay.duration} • ${displayDay.calories} kcal',
                                style: TextStyle(color: palette.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: <Widget>[
                        _Badge(
                          label: displayDay.category,
                          background: palette.surface,
                          foreground: palette.textSecondary,
                        ),
                        _Badge(
                          label: _prettyDifficulty(displayDay.difficulty),
                          background: _difficultyBackground(
                            displayDay.difficulty,
                          ),
                          foreground: _difficultyColor(displayDay.difficulty),
                        ),
                        if (!displayDay.isRestDay)
                          _Badge(
                            label: displayDay.duration,
                            background: palette.surface,
                            foreground: palette.textSecondary,
                          ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    if (displayDay.isRestDay)
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: palette.primaryLight.withValues(alpha: 0.5),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Text(
                          'Take the day to walk, stretch, and recover well.',
                          style: TextStyle(
                            color: palette.textSecondary,
                            height: 1.5,
                          ),
                        ),
                      )
                    else
                      Column(
                        children: displayDay.exercises
                            .take(5)
                            .map(
                              (Exercise exercise) => Padding(
                                padding: const EdgeInsets.only(bottom: 10),
                                child: Row(
                                  children: <Widget>[
                                    ExerciseIllustration(
                                      name: exercise.name,
                                      size: 52,
                                      color: colorFromHex(displayDay.color),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Text(
                                            exercise.name,
                                            style: TextStyle(
                                              color: palette.textPrimary,
                                              fontWeight: FontWeight.w700,
                                            ),
                                          ),
                                          const SizedBox(height: 3),
                                          Text(
                                            '${exercise.sets} sets • ${exercise.reps} • Rest ${exercise.rest}',
                                            style: TextStyle(
                                              color: palette.textSecondary,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    _Badge(
                                      label: exercise.muscle,
                                      background: palette.surface,
                                      foreground: palette.textSecondary,
                                    ),
                                  ],
                                ),
                              ),
                            )
                            .toList(),
                      ),
                    if (displayDay.exercises.length > 5)
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          '+${displayDay.exercises.length - 5} more exercises',
                          style: TextStyle(color: palette.textLight),
                        ),
                      ),
                    const SizedBox(height: 18),
                    Row(
                      children: <Widget>[
                        Expanded(
                          child: PrimaryButton(
                            label: 'View Plan',
                            outline: true,
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) =>
                                      WorkoutPlanPage(day: displayDay),
                                ),
                              );
                            },
                          ),
                        ),
                        if (!displayDay.isRestDay) ...<Widget>[
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              label: 'Start',
                              icon: Icons.play_arrow,
                              onPressed: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        WorkoutSessionPage(day: displayDay),
                                  ),
                                );
                              },
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            const SizedBox(height: 8),
            SectionHeader(title: 'Workout Library'),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: categories
                    .map(
                      (String category) => ChipButton(
                        label: category,
                        selected: _selectedCategory == category,
                        onTap: () =>
                            setState(() => _selectedCategory = category),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: difficulties
                    .map(
                      (String difficulty) => ChipButton(
                        label: difficulty == 'All'
                            ? 'All'
                            : _prettyDifficulty(difficulty),
                        selected: _selectedDifficulty == difficulty,
                        onTap: () =>
                            setState(() => _selectedDifficulty = difficulty),
                      ),
                    )
                    .toList(),
              ),
            ),
            const SizedBox(height: 16),
            ...filtered.map(
              (WorkoutDay day) => FitnessCard(
                key: ValueKey<int>(day.dayNumber),
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => WorkoutPlanPage(day: day),
                    ),
                  );
                },
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 5,
                      height: 74,
                      decoration: BoxDecoration(
                        color: colorFromHex(day.color),
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            day.name,
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w800,
                              fontSize: 18,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            day.category,
                            style: TextStyle(color: palette.textSecondary),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            '${day.duration} • ${day.calories} kcal • ${day.exercises.length} exercises',
                            style: TextStyle(
                              color: palette.textLight,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                    ),
                    _Badge(
                      label: _prettyDifficulty(day.difficulty),
                      background: _difficultyBackground(day.difficulty),
                      foreground: _difficultyColor(day.difficulty),
                    ),
                  ],
                ),
              ),
            ),
            if (filtered.isEmpty)
              FitnessCard(
                child: Center(
                  child: Text(
                    'No workouts match the current filters.',
                    style: TextStyle(color: palette.textSecondary),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  String _prettyDifficulty(String difficulty) {
    switch (difficulty) {
      case DifficultyValue.easy:
        return 'Easy';
      case DifficultyValue.intermediate:
        return 'Intermediate';
      case DifficultyValue.hard:
        return 'Hard';
      default:
        return difficulty;
    }
  }

  Color _difficultyColor(String difficulty) {
    switch (difficulty) {
      case DifficultyValue.easy:
        return const Color(0xFF27AE60);
      case DifficultyValue.hard:
        return const Color(0xFFE74C3C);
      default:
        return const Color(0xFFF39C12);
    }
  }

  Color _difficultyBackground(String difficulty) {
    switch (difficulty) {
      case DifficultyValue.easy:
        return const Color(0xFFD5F5E3);
      case DifficultyValue.hard:
        return const Color(0xFFFADBD8);
      default:
        return const Color(0xFFFEF9E7);
    }
  }
}

class _DayChip extends StatelessWidget {
  const _DayChip({
    required this.day,
    required this.selected,
    required this.onTap,
  });

  final WorkoutDay day;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Material(
      color: selected ? palette.dark : palette.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          width: 68,
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: selected ? palette.dark : palette.border),
          ),
          child: Column(
            children: <Widget>[
              Text(
                day.day,
                style: TextStyle(
                  color: selected ? Colors.white : palette.textSecondary,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 8),
              Container(
                width: 10,
                height: 10,
                decoration: BoxDecoration(
                  color: day.isRestDay
                      ? palette.textLight
                      : colorFromHex(day.color),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                day.isRestDay ? 'Rest' : '${day.calories}',
                style: TextStyle(
                  color: selected ? const Color(0xB3FFFFFF) : palette.textLight,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Badge extends StatelessWidget {
  const _Badge({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontWeight: FontWeight.w700,
          fontSize: 12,
        ),
      ),
    );
  }
}
