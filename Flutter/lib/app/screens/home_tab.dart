import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../state/app_model.dart';
import '../ui.dart';
import 'onboarding_screens.dart';
import 'screen_helpers.dart';
import 'secondary_screens.dart';

class HomeTab extends StatelessWidget {
  const HomeTab({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final ({
      AppUser? user,
      WorkoutDay? todayWorkout,
      bool supportsPeriodTracking,
      NutritionPlan nutritionPlan,
      DayData todayData,
      PeriodData periodData,
      int streak,
      bool trackingEnabled,
      bool trackingBusy,
      bool hasRealtimeTracking,
      bool gpsTrackingAvailable,
      bool liveTrackingAvailable,
      String liveTrackingStatus,
      String coachTip,
      bool isProfileCompleted,
      int tdee,
      int waterGoal,
      double distanceKm,
    })
    home = context
        .select<
          AppModel,
          ({
            AppUser? user,
            WorkoutDay? todayWorkout,
            bool supportsPeriodTracking,
            NutritionPlan nutritionPlan,
            DayData todayData,
            PeriodData periodData,
            int streak,
            bool trackingEnabled,
            bool trackingBusy,
            bool hasRealtimeTracking,
            bool gpsTrackingAvailable,
            bool liveTrackingAvailable,
            String liveTrackingStatus,
            String coachTip,
            bool isProfileCompleted,
            int tdee,
            int waterGoal,
            double distanceKm,
          })
        >(
          (AppModel model) => (
            user: model.user,
            todayWorkout: model.todayWorkout,
            supportsPeriodTracking: model.supportsPeriodTracking,
            nutritionPlan: model.nutritionPlan,
            todayData: model.todayData,
            periodData: model.periodData,
            streak: model.streak,
            trackingEnabled: model.trackingEnabled,
            trackingBusy: model.trackingBusy,
            hasRealtimeTracking: model.hasRealtimeTracking,
            gpsTrackingAvailable: model.gpsTrackingAvailable,
            liveTrackingAvailable: model.liveTrackingAvailable,
            liveTrackingStatus: model.liveTrackingStatus,
            coachTip: model.coachTip,
            isProfileCompleted: model.isProfileCompleted,
            tdee: model.tdee,
            waterGoal: model.waterGoal,
            distanceKm: model.distanceKm,
          ),
        );
    final AppUser? user = home.user;
    final WorkoutDay? todayWorkout = home.todayWorkout;
    final bool supportsPeriodTracking = home.supportsPeriodTracking;
    final bool trackingEnabled = home.trackingEnabled;
    final List<String> nameParts =
        user?.name.trim().split(RegExp(r'\s+')) ?? <String>[];
    final String firstName = nameParts.isEmpty ? 'User' : nameParts.first;
    final double calorieProgress = home.nutritionPlan.calories <= 0
        ? 0
        : home.todayData.caloriesConsumed / home.nutritionPlan.calories;
    final PeriodPhaseInfo? periodInfo = supportsPeriodTracking
        ? latestPeriodPhase(home.periodData)
        : null;

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
                        greetingForNow(),
                        style: TextStyle(
                          color: palette.textSecondary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        firstName,
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.w800,
                          color: palette.textPrimary,
                        ),
                      ),
                    ],
                  ),
                ),
                _HeaderButton(
                  icon: Icons.notifications_none,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const NotificationsPage(),
                      ),
                    );
                  },
                ),
                const SizedBox(width: 10),
                _HeaderButton(
                  icon: Icons.settings_outlined,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const SettingsPage(),
                      ),
                    );
                  },
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
                      StatusPill(
                        label: '${home.streak} day streak',
                        background: const Color(0x1FFFFFFF),
                        foreground: Colors.white,
                        icon: Icons.local_fire_department,
                      ),
                      StatusPill(
                        label: prettyGoal(user?.goal),
                        background: const Color(0x1FFFFFFF),
                        foreground: Colors.white,
                        icon: Icons.track_changes_rounded,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Keep today intentional.',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    home.streak > 0
                        ? 'You are building momentum. Stay on plan, hit your meals, and close the day strong.'
                        : 'Start with one clean day of movement, hydration, and protein.',
                    style: const TextStyle(
                      color: Color(0xD9FFFFFF),
                      height: 1.45,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: _HeroStat(
                          label: 'Tracking',
                          value: home.hasRealtimeTracking
                              ? home.gpsTrackingAvailable
                                    ? 'GPS'
                                    : 'Live'
                              : trackingEnabled
                              ? 'Pending'
                              : 'Off',
                          detail:
                              home.liveTrackingAvailable &&
                                  home.gpsTrackingAvailable
                              ? 'phone + gps'
                              : home.liveTrackingAvailable
                              ? 'phone steps'
                              : home.gpsTrackingAvailable
                              ? 'gps track'
                              : trackingEnabled
                              ? 'waiting'
                              : 'tap enable',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _HeroStat(
                          label: 'Water',
                          value: '${home.todayData.water}/${home.waterGoal}',
                          detail: 'glasses today',
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _HeroStat(
                          label: 'Coach',
                          value: home.coachTip.isEmpty ? 'Ready' : 'Live',
                          detail: 'guidance on',
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            FitnessCard(
              borderColor: trackingEnabled
                  ? palette.primary.withValues(alpha: 0.16)
                  : palette.warning.withValues(alpha: 0.18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 46,
                        height: 46,
                        decoration: BoxDecoration(
                          color: trackingEnabled
                              ? palette.primaryLight.withValues(alpha: 0.72)
                              : palette.warning.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          trackingEnabled
                              ? Icons.route_outlined
                              : Icons.motion_photos_on_outlined,
                          color: trackingEnabled
                              ? palette.primary
                              : palette.warning,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              trackingEnabled
                                  ? 'Phone tracking status'
                                  : 'Enable real phone tracking',
                              style: TextStyle(
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 17,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              home.liveTrackingStatus,
                              style: TextStyle(
                                color: palette.textSecondary,
                                height: 1.45,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: PrimaryButton(
                          label: trackingEnabled
                              ? 'Review Permissions'
                              : 'Enable Tracking',
                          loading: home.trackingBusy,
                          onPressed: trackingEnabled
                              ? () => context
                                    .read<AppModel>()
                                    .openTrackingSettings()
                              : () => context
                                    .read<AppModel>()
                                    .enableRealtimeTracking(),
                        ),
                      ),
                      if (trackingEnabled) ...<Widget>[
                        const SizedBox(width: 12),
                        Expanded(
                          child: PrimaryButton(
                            label: 'Turn Off',
                            outline: true,
                            onPressed: home.trackingBusy
                                ? null
                                : () => context
                                      .read<AppModel>()
                                      .disableRealtimeTracking(),
                          ),
                        ),
                      ],
                    ],
                  ),
                ],
              ),
            ),
            if (!home.isProfileCompleted) ...<Widget>[
              const SizedBox(height: 16),
              FitnessCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const ProfileSetupPage(),
                    ),
                  );
                },
                color: palette.primaryLight.withValues(alpha: 0.65),
                borderColor: palette.primary.withValues(alpha: 0.18),
                child: Row(
                  children: <Widget>[
                    Icon(
                      Icons.person_outline,
                      color: palette.primary,
                      size: 26,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Complete your profile',
                            style: TextStyle(
                              color: palette.primary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Unlock a personalized plan built around your goals.',
                            style: TextStyle(color: palette.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: palette.primary),
                  ],
                ),
              ),
            ],
            const SizedBox(height: 18),
            FitnessCard(
              child: Row(
                children: <Widget>[
                  ProgressRing(
                    value: calorieProgress,
                    size: 126,
                    strokeWidth: 12,
                    color: calorieProgress > 1
                        ? palette.danger
                        : palette.primary,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          '${home.todayData.caloriesConsumed}',
                          style: TextStyle(
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            color: palette.textPrimary,
                          ),
                        ),
                        Text(
                          'kcal',
                          style: TextStyle(color: palette.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 20),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Daily Goal',
                          style: TextStyle(color: palette.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${home.nutritionPlan.calories} kcal',
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: palette.textPrimary,
                          ),
                        ),
                        const SizedBox(height: 12),
                        _LegendRow(
                          color: palette.primary,
                          label: '${home.todayData.caloriesConsumed} eaten',
                        ),
                        const SizedBox(height: 6),
                        _LegendRow(
                          color: palette.accent,
                          label:
                              '${(home.nutritionPlan.calories - home.todayData.caloriesConsumed).clamp(0, 100000)} left',
                        ),
                        const SizedBox(height: 10),
                        Text(
                          'TDEE: ${home.tdee} kcal',
                          style: TextStyle(
                            color: palette.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            SectionHeader(
              title: "Today's Workout",
              actionLabel: 'Open',
              onAction: () {
                if (todayWorkout == null) return;
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => WorkoutPlanPage(day: todayWorkout),
                  ),
                );
              },
            ),
            FitnessCard(
              onTap: todayWorkout == null
                  ? () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => const ProfileSetupPage(),
                        ),
                      );
                    }
                  : () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) => WorkoutPlanPage(day: todayWorkout),
                        ),
                      );
                    },
              color: palette.dark,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.14),
                          borderRadius: BorderRadius.circular(999),
                        ),
                        child: Text(
                          todayWorkout == null
                              ? 'NO PLAN'
                              : todayWorkout.isRestDay
                              ? 'REST DAY'
                              : todayWorkout.category.toUpperCase(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                            letterSpacing: 0.6,
                          ),
                        ),
                      ),
                      const Spacer(),
                      if (todayWorkout != null)
                        Text(
                          todayWorkout.duration,
                          style: const TextStyle(color: Color(0xB3FFFFFF)),
                        ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Text(
                    todayWorkout?.name ?? 'Complete Profile Setup',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    todayWorkout == null
                        ? 'We need your profile details to generate a plan.'
                        : todayWorkout.isRestDay
                        ? 'Mobility, walking, and recovery work for today.'
                        : '${todayWorkout.exercises.length} exercises • ${todayWorkout.calories} kcal',
                    style: const TextStyle(
                      color: Color(0xB3FFFFFF),
                      height: 1.4,
                    ),
                  ),
                  if (todayWorkout != null &&
                      !todayWorkout.isRestDay) ...<Widget>[
                    const SizedBox(height: 14),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: todayWorkout.exercises
                          .take(3)
                          .map(
                            (Exercise exercise) => Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: 0.12),
                                borderRadius: BorderRadius.circular(999),
                              ),
                              child: Text(
                                exercise.muscle,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: <Widget>[
                Expanded(
                  child: FitnessCard(
                    child: _MetricTile(
                      icon: Icons.directions_walk,
                      iconColor: palette.info,
                      label: 'Steps',
                      value: home.todayData.stepsCompleted.toString(),
                      detail: '${home.distanceKm.toStringAsFixed(2)} km',
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FitnessCard(
                    child: _MetricTile(
                      icon: Icons.water_drop_outlined,
                      iconColor: palette.primary,
                      label: 'Water',
                      value: '${home.todayData.water}/${home.waterGoal}',
                      detail: 'glasses',
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            FitnessCard(
              borderColor: palette.primary.withValues(alpha: 0.12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Icon(
                        Icons.tips_and_updates_outlined,
                        color: palette.primary,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'Coach Tip',
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    home.coachTip,
                    style: TextStyle(
                      color: palette.textSecondary,
                      height: 1.55,
                    ),
                  ),
                ],
              ),
            ),
            if (supportsPeriodTracking) ...<Widget>[
              const SizedBox(height: 8),
              SectionHeader(
                title: "Women's Health",
                actionLabel: 'View',
                onAction: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PeriodTrackerPage(),
                    ),
                  );
                },
              ),
              FitnessCard(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (_) => const PeriodTrackerPage(),
                    ),
                  );
                },
                borderColor: (periodInfo?.color ?? palette.primary).withValues(
                  alpha: 0.16,
                ),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: (periodInfo?.color ?? palette.primary)
                            .withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.local_florist_outlined,
                        color: periodInfo?.color ?? palette.primary,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            periodInfo == null
                                ? 'Period Tracker'
                                : '${periodInfo.phase} Phase • Day ${periodInfo.dayOfCycle}',
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 3),
                          Text(
                            periodInfo == null
                                ? 'Log your cycle to start predictions and phase guidance.'
                                : periodInfo.daysToNext > 0
                                ? 'Next period in ${periodInfo.daysToNext} days'
                                : 'Next period is due today',
                            style: TextStyle(color: palette.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    Icon(Icons.chevron_right, color: palette.textLight),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _HeaderButton extends StatelessWidget {
  const _HeaderButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Material(
      color: palette.card,
      borderRadius: BorderRadius.circular(16),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: SizedBox(
          width: 48,
          height: 48,
          child: Icon(icon, color: palette.textPrimary),
        ),
      ),
    );
  }
}

class _LegendRow extends StatelessWidget {
  const _LegendRow({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Row(
      children: <Widget>[
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 8),
        Text(label, style: TextStyle(color: palette.textSecondary)),
      ],
    );
  }
}

class _MetricTile extends StatelessWidget {
  const _MetricTile({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.detail,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final String value;
  final String detail;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(icon, color: iconColor),
        const SizedBox(height: 14),
        Text(
          value,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.w800,
            color: palette.textPrimary,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(color: palette.textSecondary)),
        const SizedBox(height: 2),
        Text(detail, style: TextStyle(color: palette.textLight, fontSize: 12)),
      ],
    );
  }
}

class _HeroStat extends StatelessWidget {
  const _HeroStat({
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
              fontSize: 22,
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
