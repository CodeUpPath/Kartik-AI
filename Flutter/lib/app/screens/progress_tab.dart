import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

import '../models.dart';
import '../state/app_model.dart';
import '../ui.dart';
import 'screen_helpers.dart';

class ProgressTab extends StatelessWidget {
  const ProgressTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final ({
      AppUser? user,
      List<WorkoutHistoryRecord> workoutHistory,
      List<DayData> recentDays7,
      bool hasRealtimeTracking,
      bool gpsTrackingAvailable,
      bool liveTrackingAvailable,
      String liveTrackingStatus,
      DayData todayData,
      int streak,
      NutritionPlan nutritionPlan,
      List<StepRecord> weeklyHistory,
      int stepGoal,
    })
    progress = context
        .select<
          AppModel,
          ({
            AppUser? user,
            List<WorkoutHistoryRecord> workoutHistory,
            List<DayData> recentDays7,
            bool hasRealtimeTracking,
            bool gpsTrackingAvailable,
            bool liveTrackingAvailable,
            String liveTrackingStatus,
            DayData todayData,
            int streak,
            NutritionPlan nutritionPlan,
            List<StepRecord> weeklyHistory,
            int stepGoal,
          })
        >(
          (AppModel model) => (
            user: model.user,
            workoutHistory: model.workoutHistory,
            recentDays7: model.recentDays7,
            hasRealtimeTracking: model.hasRealtimeTracking,
            gpsTrackingAvailable: model.gpsTrackingAvailable,
            liveTrackingAvailable: model.liveTrackingAvailable,
            liveTrackingStatus: model.liveTrackingStatus,
            todayData: model.todayData,
            streak: model.streak,
            nutritionPlan: model.nutritionPlan,
            weeklyHistory: model.weeklyHistory,
            stepGoal: model.stepGoal,
          ),
        );
    final String weight = userWeight(progress.user);
    final int totalWorkouts = progress.workoutHistory.length;
    final int workoutsThisWeek = progress.recentDays7
        .where((DayData day) => day.workoutDone)
        .length;

    return AppBackdrop(
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 100),
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Progress',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Track your transformation over time.',
                        style: TextStyle(color: palette.textSecondary),
                      ),
                    ],
                  ),
                ),
                FilledButton.tonal(
                  onPressed: () => _shareCsv(context),
                  child: const Text('Share CSV'),
                ),
              ],
            ),
            const SizedBox(height: 18),
            FitnessCard(
              gradient: LinearGradient(
                colors: <Color>[
                  palette.dark,
                  palette.primary,
                  palette.secondary,
                ],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderColor: Colors.transparent,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: <Widget>[
                      const StatusPill(
                        label: '30-day export ready',
                        background: Color(0x1FFFFFFF),
                        foreground: Colors.white,
                        icon: Icons.ios_share_rounded,
                      ),
                      StatusPill(
                        label: progress.hasRealtimeTracking
                            ? progress.gpsTrackingAvailable
                                  ? 'Phone + GPS tracking on'
                                  : 'Live step tracking on'
                            : 'Manual sync mode',
                        background: const Color(0x1FFFFFFF),
                        foreground: Colors.white,
                        icon: progress.gpsTrackingAvailable
                            ? Icons.explore_outlined
                            : progress.liveTrackingAvailable
                            ? Icons.directions_walk
                            : Icons.watch_outlined,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Your consistency is now visible.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    progress.liveTrackingStatus,
                    style: const TextStyle(
                      color: Color(0xD9FFFFFF),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 18),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _HeroMetric(
                          label: 'This week',
                          value: '$workoutsThisWeek',
                          detail: 'workouts done',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _HeroMetric(
                          label: 'Today',
                          value: '${progress.todayData.stepsCompleted}',
                          detail: 'steps logged',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _HeroMetric(
                          label: 'Current streak',
                          value: '${progress.streak}',
                          detail: 'days active',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            Row(
              children: <Widget>[
                Expanded(
                  child: _StatCard(
                    label: 'Weight',
                    value: weight,
                    detail: 'kg',
                    accent: palette.info,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    label: 'Workouts',
                    value: '$totalWorkouts',
                    detail: 'total',
                    accent: palette.primary,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: _StatCard(
                    label: 'Streak',
                    value: '${progress.streak}',
                    detail: 'days',
                    accent: palette.warning,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            SectionHeader(title: '7-Day Calories'),
            FitnessCard(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 140,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: progress.recentDays7
                          .map(
                            (DayData day) => Expanded(
                              child: _BarPoint(
                                value: day.caloriesConsumed.toDouble(),
                                maxValue: progress.nutritionPlan.calories
                                    .toDouble()
                                    .clamp(1, 100000),
                                label: dayLetter(day.date),
                                highlight: day.date == progress.todayData.date,
                                activeColor: palette.primary,
                                mutedColor: palette.primaryLight,
                                caption: day.caloriesConsumed > 0
                                    ? '${day.caloriesConsumed}'
                                    : '0',
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Text(
                        'Goal: ${progress.nutritionPlan.calories} kcal',
                        style: TextStyle(color: palette.textSecondary),
                      ),
                      const Spacer(),
                      Text(
                        'Today: ${progress.todayData.caloriesConsumed} kcal',
                        style: TextStyle(color: palette.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SectionHeader(title: 'Weekly Consistency'),
            FitnessCard(
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: progress.recentDays7
                        .map(
                          (DayData day) => Column(
                            children: <Widget>[
                              Container(
                                width: 38,
                                height: 56,
                                decoration: BoxDecoration(
                                  color: day.workoutDone
                                      ? palette.primary
                                      : day.date == progress.todayData.date
                                      ? palette.primaryLight
                                      : palette.surface,
                                  borderRadius: BorderRadius.circular(16),
                                  border: day.date == progress.todayData.date
                                      ? Border.all(color: palette.primary)
                                      : null,
                                ),
                                child: Icon(
                                  day.workoutDone ? Icons.check : Icons.remove,
                                  color: day.workoutDone
                                      ? Colors.white
                                      : day.date == progress.todayData.date
                                      ? palette.primary
                                      : palette.textLight,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                dayLetter(day.date),
                                style: TextStyle(
                                  color: day.date == progress.todayData.date
                                      ? palette.primary
                                      : palette.textSecondary,
                                  fontWeight:
                                      day.date == progress.todayData.date
                                      ? FontWeight.w800
                                      : FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                  const SizedBox(height: 14),
                  Text(
                    '$workoutsThisWeek/7 workouts completed this week',
                    style: TextStyle(color: palette.textSecondary),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SectionHeader(title: 'Weekly Steps'),
            FitnessCard(
              child: Column(
                children: <Widget>[
                  SizedBox(
                    height: 140,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: progress.weeklyHistory
                          .map(
                            (StepRecord record) => Expanded(
                              child: _BarPoint(
                                value: record.steps.toDouble(),
                                maxValue: progress.stepGoal.toDouble(),
                                label: dayLetter(record.date),
                                highlight:
                                    record.date == progress.todayData.date,
                                activeColor: palette.info,
                                mutedColor: palette.info.withValues(
                                  alpha: 0.26,
                                ),
                                caption: record.steps >= 1000
                                    ? '${(record.steps / 1000).toStringAsFixed(1)}k'
                                    : '${record.steps}',
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Text(
                        'Goal: ${progress.stepGoal} steps/day',
                        style: TextStyle(color: palette.textSecondary),
                      ),
                      const Spacer(),
                      Text(
                        'Today: ${progress.todayData.stepsCompleted}',
                        style: TextStyle(color: palette.textSecondary),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SectionHeader(title: 'Workout History'),
            if (progress.workoutHistory.isEmpty)
              FitnessCard(
                child: Column(
                  children: <Widget>[
                    Icon(
                      Icons.fitness_center,
                      size: 36,
                      color: palette.textLight,
                    ),
                    const SizedBox(height: 10),
                    Text(
                      'No completed workouts yet',
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Complete a session to start building history.',
                      style: TextStyle(color: palette.textSecondary),
                    ),
                  ],
                ),
              )
            else
              ...progress.workoutHistory
                  .take(10)
                  .map(
                    (WorkoutHistoryRecord record) => FitnessCard(
                      key: ValueKey<String>(record.date),
                      child: Row(
                        children: <Widget>[
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: palette.primaryLight.withValues(
                                alpha: 0.55,
                              ),
                              borderRadius: BorderRadius.circular(16),
                            ),
                            child: Icon(
                              Icons.fitness_center,
                              color: palette.primary,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  record.dayName,
                                  style: TextStyle(
                                    color: palette.textPrimary,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  formatShortDate(record.date),
                                  style: TextStyle(
                                    color: palette.textSecondary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: <Widget>[
                              Text(
                                _duration(record.duration),
                                style: TextStyle(
                                  color: palette.textPrimary,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                '${record.calories} kcal',
                                style: TextStyle(color: palette.textLight),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  String userWeight(AppUser? user) {
    final double? weight = double.tryParse(user?.weight ?? '');
    if (weight == null || weight <= 0) return '0.0';
    return weight.toStringAsFixed(1);
  }

  String _duration(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainder = seconds % 60;
    return '${minutes}m ${remainder.toString().padLeft(2, '0')}s';
  }

  Future<void> _shareCsv(BuildContext context) async {
    final AppModel model = context.read<AppModel>();
    final String csv = await model.exportLast30DaysCsv();
    await SharePlus.instance.share(
      ShareParams(
        text: 'Kartik Ai progress export',
        subject: '30-day fitness export',
        files: <XFile>[XFile.fromData(utf8.encode(csv), mimeType: 'text/csv')],
        fileNameOverrides: const <String>['kartik-ai-progress.csv'],
      ),
    );
    if (!context.mounted) return;
    showAppSnackBar(context, '30-day CSV ready to share.');
  }
}

class _HeroMetric extends StatelessWidget {
  const _HeroMetric({
    required this.label,
    required this.value,
    required this.detail,
  });

  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0x1AFFFFFF),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            detail,
            style: const TextStyle(color: Color(0xB3FFFFFF), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.detail,
    required this.accent,
  });

  final String label;
  final String value;
  final String detail;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return FitnessCard(
      margin: EdgeInsets.zero,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: accent,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            detail,
            style: TextStyle(color: palette.textLight, fontSize: 12),
          ),
          const SizedBox(height: 8),
          Text(label, style: TextStyle(color: palette.textSecondary)),
        ],
      ),
    );
  }
}

class _BarPoint extends StatelessWidget {
  const _BarPoint({
    required this.value,
    required this.maxValue,
    required this.label,
    required this.highlight,
    required this.activeColor,
    required this.mutedColor,
    required this.caption,
  });

  final double value;
  final double maxValue;
  final String label;
  final bool highlight;
  final Color activeColor;
  final Color mutedColor;
  final String caption;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final double height = (value / maxValue).clamp(0, 1) * 88;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          Text(
            caption,
            style: TextStyle(color: palette.textSecondary, fontSize: 11),
          ),
          const SizedBox(height: 6),
          Expanded(
            child: Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                width: 28,
                height: height < 8 ? 8 : height,
                decoration: BoxDecoration(
                  color: highlight ? activeColor : mutedColor,
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(12),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Text(
            label,
            style: TextStyle(
              color: highlight ? activeColor : palette.textSecondary,
              fontWeight: highlight ? FontWeight.w800 : FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
