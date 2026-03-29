import 'dart:async';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models.dart';
import '../state/app_model.dart';
import '../ui.dart';
import 'auth_screens.dart';
import 'onboarding_screens.dart';
import 'screen_helpers.dart';

enum _SessionPhase { ready, active, rest, complete }

class WorkoutPlanPage extends StatelessWidget {
  const WorkoutPlanPage({super.key, required this.day});

  final WorkoutDay day;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final Color accent = colorFromHex(day.color);
    return Scaffold(
      appBar: AppBar(title: Text('Day ${day.dayNumber} Plan')),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          FitnessCard(
            color: palette.card,
            borderColor: accent.withValues(alpha: 0.18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      width: 6,
                      height: 62,
                      decoration: BoxDecoration(
                        color: accent,
                        borderRadius: BorderRadius.circular(999),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Day ${day.dayNumber} • ${day.day}',
                            style: TextStyle(
                              color: palette.textSecondary,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            day.name,
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.w800,
                              color: palette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            day.isRestDay
                                ? 'Recovery and mobility focus.'
                                : '${day.category} • ${day.difficulty} • ${day.duration} • ${day.calories} kcal',
                            style: TextStyle(color: palette.textSecondary),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                if (!day.isRestDay) ...<Widget>[
                  const SizedBox(height: 16),
                  LinearProgressIndicator(
                    value: 1,
                    minHeight: 8,
                    backgroundColor: palette.surface,
                    color: accent,
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(height: 8),
          SectionHeader(title: 'Exercises'),
          if (day.exercises.isEmpty)
            FitnessCard(
              child: Text(
                'No exercises are available for this day.',
                style: TextStyle(color: palette.textSecondary),
              ),
            )
          else
            ...day.exercises.asMap().entries.map(
              (MapEntry<int, Exercise> entry) => FitnessCard(
                key: ValueKey<String>(entry.value.id),
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: palette.primaryLight.withValues(alpha: 0.6),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      alignment: Alignment.center,
                      child: Text(
                        '${entry.key + 1}',
                        style: TextStyle(
                          color: palette.primary,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    ExerciseIllustration(
                      name: entry.value.name,
                      color: accent,
                      size: 54,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            entry.value.name,
                            style: TextStyle(
                              color: palette.textPrimary,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '${entry.value.sets} sets • ${entry.value.reps} • Rest ${entry.value.rest}',
                            style: TextStyle(color: palette.textSecondary),
                          ),
                          const SizedBox(height: 6),
                          Wrap(
                            spacing: 8,
                            runSpacing: 8,
                            children: <Widget>[
                              _MiniBadge(
                                label: entry.value.muscle,
                                color: palette.surface,
                                foreground: palette.textSecondary,
                              ),
                              _MiniBadge(
                                label: entry.value.difficulty,
                                color: accent.withValues(alpha: 0.12),
                                foreground: accent,
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          const SizedBox(height: 12),
          if (!day.isRestDay)
            PrimaryButton(
              label: 'Start Workout',
              icon: Icons.play_arrow,
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute<void>(
                    builder: (_) => WorkoutSessionPage(day: day),
                  ),
                );
              },
            )
          else
            FitnessCard(
              child: Column(
                children: <Widget>[
                  Icon(
                    Icons.bedtime_outlined,
                    color: palette.primary,
                    size: 36,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Rest Day',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 20,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    'Light walking, stretching, and mobility work are enough for today.',
                    style: TextStyle(color: palette.textSecondary, height: 1.5),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

class WorkoutSessionPage extends StatefulWidget {
  const WorkoutSessionPage({super.key, required this.day});

  final WorkoutDay day;

  @override
  State<WorkoutSessionPage> createState() => _WorkoutSessionPageState();
}

class _WorkoutSessionPageState extends State<WorkoutSessionPage> {
  static const int _readySeconds = 3;
  static const int _defaultRestSeconds = 30;

  Timer? _timer;
  _SessionPhase _phase = _SessionPhase.ready;
  int _exerciseIndex = 0;
  int _countdown = _readySeconds;
  bool _paused = false;
  int _elapsedSeconds = 0;
  bool _saved = false;

  Exercise get _exercise => widget.day.exercises[_exerciseIndex];
  Exercise? get _nextExercise =>
      _exerciseIndex + 1 < widget.day.exercises.length
      ? widget.day.exercises[_exerciseIndex + 1]
      : null;

  @override
  void initState() {
    super.initState();
    _startReady();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startReady() {
    _phase = _SessionPhase.ready;
    _countdown = _readySeconds;
    _restartTicker(() {
      setState(() {
        if (_countdown <= 1) {
          _startExercise();
        } else {
          _countdown -= 1;
        }
      });
    });
  }

  void _startExercise() {
    _phase = _SessionPhase.active;
    _paused = false;
    _countdown = _exerciseSeconds(_exercise);
    _restartTicker(() {
      if (_paused) return;
      setState(() {
        _elapsedSeconds += 1;
        if (_countdown <= 1) {
          _startRest();
        } else {
          _countdown -= 1;
        }
      });
    });
  }

  void _startRest() {
    if (_exerciseIndex >= widget.day.exercises.length - 1) {
      _completeWorkout();
      return;
    }
    _phase = _SessionPhase.rest;
    _countdown = _restSeconds(_exercise);
    _restartTicker(() {
      setState(() {
        _elapsedSeconds += 1;
        if (_countdown <= 1) {
          _exerciseIndex += 1;
          _startExercise();
        } else {
          _countdown -= 1;
        }
      });
    });
  }

  void _restartTicker(VoidCallback tick) {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (_) => tick());
  }

  Future<void> _completeWorkout() async {
    _timer?.cancel();
    setState(() => _phase = _SessionPhase.complete);
    if (_saved) return;
    _saved = true;
    await context.read<AppModel>().saveCompletedWorkout(
      widget.day,
      _elapsedSeconds,
    );
  }

  int _exerciseSeconds(Exercise exercise) {
    if (exercise.duration != null && exercise.duration! > 0) {
      return exercise.duration!;
    }
    final Match? hold = RegExp(
      r'(\d+)\s*s',
      caseSensitive: false,
    ).firstMatch(exercise.reps);
    if (hold != null) {
      return (int.tryParse(hold.group(1)!) ?? 20) * exercise.sets;
    }
    final Match? reps = RegExp(r'(\d+)').firstMatch(exercise.reps);
    final int count = int.tryParse(reps?.group(1) ?? '') ?? 10;
    return count * exercise.sets * 3;
  }

  int _restSeconds(Exercise exercise) {
    final Match? rest = RegExp(r'(\d+)').firstMatch(exercise.rest);
    return int.tryParse(rest?.group(1) ?? '') ?? _defaultRestSeconds;
  }

  String _format(int seconds) {
    final int minutes = seconds ~/ 60;
    final int remainder = seconds % 60;
    return '$minutes:${remainder.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final Color accent = colorFromHex(widget.day.color);
    final double progress = widget.day.exercises.isEmpty
        ? 0
        : (_exerciseIndex + (_phase == _SessionPhase.complete ? 1 : 0)) /
              widget.day.exercises.length;

    if (widget.day.isRestDay || widget.day.exercises.isEmpty) {
      return Scaffold(
        appBar: AppBar(title: const Text('Workout Session')),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: FitnessCard(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Icon(
                    Icons.bedtime_outlined,
                    size: 40,
                    color: palette.primary,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'This day has no active workout.',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Go back and choose another plan or use the day for recovery.',
                    style: TextStyle(color: palette.textSecondary),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.day.name),
        actions: <Widget>[
          IconButton(
            onPressed: _completeWorkout,
            icon: const Icon(Icons.flag_outlined),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(999),
              child: LinearProgressIndicator(
                value: progress.clamp(0, 1),
                minHeight: 10,
                backgroundColor: palette.surface,
                color: accent,
              ),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: FitnessCard(
                margin: EdgeInsets.zero,
                child: Column(
                  children: <Widget>[
                    Text(
                      _phaseLabel(),
                      style: TextStyle(
                        color: accent,
                        fontWeight: FontWeight.w800,
                        letterSpacing: 1.2,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _phase == _SessionPhase.rest && _nextExercise != null
                          ? _nextExercise!.name
                          : _phase == _SessionPhase.complete
                          ? 'Workout Complete'
                          : _exercise.name,
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: palette.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 18),
                    ExerciseIllustration(
                      name:
                          _phase == _SessionPhase.rest && _nextExercise != null
                          ? _nextExercise!.name
                          : _exercise.name,
                      color: accent,
                      size: 120,
                    ),
                    const SizedBox(height: 20),
                    Container(
                      width: 190,
                      height: 190,
                      decoration: BoxDecoration(
                        color: accent.withValues(alpha: 0.1),
                        shape: BoxShape.circle,
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            _phase == _SessionPhase.complete
                                ? 'Done'
                                : _format(_countdown),
                            style: TextStyle(
                              fontSize: 38,
                              fontWeight: FontWeight.w800,
                              color: palette.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _phase == _SessionPhase.complete
                                ? 'Great work'
                                : _phase == _SessionPhase.rest
                                ? 'Rest time'
                                : 'Keep going',
                            style: TextStyle(color: palette.textSecondary),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      _phase == _SessionPhase.complete
                          ? 'You finished ${widget.day.exercises.length} exercises in ${_format(_elapsedSeconds)}.'
                          : '${_exercise.sets} sets • ${_exercise.reps} • Rest ${_exercise.rest}',
                      style: TextStyle(color: palette.textSecondary),
                      textAlign: TextAlign.center,
                    ),
                    const Spacer(),
                    if (_phase != _SessionPhase.complete)
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: PrimaryButton(
                              label: _paused ? 'Resume' : 'Pause',
                              outline: true,
                              onPressed: _phase == _SessionPhase.active
                                  ? () => setState(() => _paused = !_paused)
                                  : null,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: PrimaryButton(
                              label: _phase == _SessionPhase.rest
                                  ? 'Skip Rest'
                                  : 'Next',
                              onPressed: () {
                                if (_phase == _SessionPhase.rest) {
                                  setState(() {
                                    _exerciseIndex += 1;
                                    _startExercise();
                                  });
                                  return;
                                }
                                if (_exerciseIndex >=
                                    widget.day.exercises.length - 1) {
                                  _completeWorkout();
                                } else {
                                  setState(() => _startRest());
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    else
                      PrimaryButton(
                        label: 'Back to App',
                        onPressed: () => Navigator.of(context).pop(),
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

  String _phaseLabel() {
    switch (_phase) {
      case _SessionPhase.ready:
        return 'GET READY';
      case _SessionPhase.active:
        return 'ACTIVE';
      case _SessionPhase.rest:
        return 'REST';
      case _SessionPhase.complete:
        return 'COMPLETE';
    }
  }
}

class _MiniBadge extends StatelessWidget {
  const _MiniBadge({
    required this.label,
    required this.color,
    required this.foreground,
  });

  final String label;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: foreground,
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  String _units = 'Metric';

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final AppModel model = context.watch<AppModel>();
    return _PageShell(
      title: 'Settings',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          FitnessCard(
            onTap: _openProfileEditor,
            child: Row(
              children: <Widget>[
                CircleAvatar(
                  radius: 28,
                  backgroundColor: palette.primary,
                  child: Text(
                    _initials(model.user?.name ?? 'User'),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        model.user?.name ?? 'Guest',
                        style: TextStyle(
                          color: palette.textPrimary,
                          fontWeight: FontWeight.w800,
                          fontSize: 18,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        model.user?.email ?? '',
                        style: TextStyle(color: palette.textSecondary),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Goal: ${prettyGoal(model.user?.goal)}',
                        style: TextStyle(
                          color: palette.primary,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to update your profile details',
                        style: TextStyle(color: palette.textLight),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: palette.textLight),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _SectionTitle(label: 'Preferences'),
          FitnessCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  value: model.isDark,
                  onChanged: (_) => context.read<AppModel>().toggleTheme(),
                  title: const Text('Dark Mode'),
                  subtitle: const Text('Switch the app appearance'),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.language_outlined),
                  title: const Text('Language'),
                  subtitle: Text(_languageLabel(model.language)),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _showLanguageDialog(context, model.language),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.straighten_outlined),
                  title: const Text('Units'),
                  subtitle: Text(_units),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => setState(() {
                    _units = _units == 'Metric' ? 'Imperial' : 'Metric';
                  }),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _SectionTitle(label: 'Integrations'),
          FitnessCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                SwitchListTile(
                  value: model.trackingEnabled,
                  onChanged: model.trackingBusy
                      ? null
                      : (bool enabled) {
                          if (enabled) {
                            context.read<AppModel>().enableRealtimeTracking();
                          } else {
                            context.read<AppModel>().disableRealtimeTracking();
                          }
                        },
                  title: const Text('Phone Activity & GPS Tracking'),
                  subtitle: Text(model.liveTrackingStatus),
                  secondary: model.trackingBusy
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.route_outlined),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.watch_outlined),
                  title: const Text('Connect Smart Watch'),
                  subtitle: const Text('Noise, Fitbit, Garmin'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const WatchConnectPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.notifications_outlined),
                  title: const Text('Notifications'),
                  subtitle: Text(
                    '${model.notifications.where((NotificationPreference item) => item.enabled).length} active',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const NotificationsPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _SectionTitle(label: 'Account'),
          FitnessCard(
            padding: EdgeInsets.zero,
            child: Column(
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('Update Profile'),
                  subtitle: const Text(
                    'Edit your body stats, goal, and workout preferences',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: _openProfileEditor,
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.privacy_tip_outlined),
                  title: const Text('Privacy Policy'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const PrivacyPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.description_outlined),
                  title: const Text('Terms of Service'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const TermsPage(),
                      ),
                    );
                  },
                ),
                const Divider(height: 1),
                ListTile(
                  leading: Icon(Icons.logout, color: palette.danger),
                  title: Text(
                    'Log Out',
                    style: TextStyle(color: palette.danger),
                  ),
                  onTap: _logout,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _openProfileEditor() async {
    final bool? updated = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => const ProfileSetupPage(isEditing: true),
      ),
    );
    if (updated == true && mounted) {
      showAppSnackBar(context, 'Profile updated.');
    }
  }

  Future<void> _logout() async {
    final bool? confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Log Out'),
        content: const Text('Are you sure you want to log out?'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await context.read<AppModel>().logout();
    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const LoginPage()),
      (Route<dynamic> route) => false,
    );
  }

  Future<void> _showLanguageDialog(BuildContext context, String current) async {
    final String? language = await showDialog<String>(
      context: context,
      builder: (BuildContext context) => SimpleDialog(
        title: const Text('Select Language'),
        children: const <Widget>[
          _LanguageOption(code: 'en', label: 'English'),
          _LanguageOption(code: 'hi', label: 'Hindi'),
          _LanguageOption(code: 'es', label: 'Spanish'),
          _LanguageOption(code: 'fr', label: 'French'),
        ],
      ),
    );
    if (language == null || language == current || !context.mounted) return;
    await context.read<AppModel>().setLanguage(language);
  }

  String _initials(String name) {
    final List<String> parts = name
        .split(RegExp(r'\s+'))
        .where((String part) => part.isNotEmpty)
        .toList();
    if (parts.isEmpty) return 'U';
    return parts.take(2).map((String item) => item[0].toUpperCase()).join();
  }

  String _languageLabel(String code) {
    switch (code) {
      case 'hi':
        return 'Hindi';
      case 'es':
        return 'Spanish';
      case 'fr':
        return 'French';
      default:
        return 'English';
    }
  }
}

class NotificationsPage extends StatelessWidget {
  const NotificationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final AppModel model = context.watch<AppModel>();
    return _PageShell(
      title: 'Notifications',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          Text(
            '${model.notifications.where((NotificationPreference item) => item.enabled).length} of ${model.notifications.length} active',
            style: TextStyle(
              color: palette.textSecondary,
              fontWeight: FontWeight.w700,
            ),
          ),
          const SizedBox(height: 16),
          ...model.notifications.map(
            (NotificationPreference notification) => FitnessCard(
              key: ValueKey<String>(notification.id),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 46,
                    height: 46,
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Icon(
                      _notificationIcon(notification.icon),
                      color: palette.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          notification.title,
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.description,
                          style: TextStyle(color: palette.textSecondary),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          notification.time,
                          style: TextStyle(
                            color: palette.textLight,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Switch(
                    value: notification.enabled,
                    onChanged: (_) => context
                        .read<AppModel>()
                        .toggleNotification(notification.id),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  IconData _notificationIcon(String icon) {
    switch (icon) {
      case 'fitness_center':
        return Icons.fitness_center;
      case 'water_drop':
        return Icons.water_drop_outlined;
      case 'restaurant':
        return Icons.restaurant_outlined;
      case 'directions_walk':
        return Icons.directions_walk;
      case 'bedtime':
        return Icons.bedtime_outlined;
      default:
        return Icons.notifications_outlined;
    }
  }
}

class PeriodTrackerPage extends StatefulWidget {
  const PeriodTrackerPage({super.key});

  @override
  State<PeriodTrackerPage> createState() => _PeriodTrackerPageState();
}

class _PeriodTrackerPageState extends State<PeriodTrackerPage> {
  int _cycleLength = 28;
  final Set<String> _selectedSymptoms = <String>{};

  static const List<Map<String, String>> _symptoms = <Map<String, String>>[
    <String, String>{'key': 'cramps', 'label': 'Cramps'},
    <String, String>{'key': 'headache', 'label': 'Headache'},
    <String, String>{'key': 'fatigue', 'label': 'Fatigue'},
    <String, String>{'key': 'mood', 'label': 'Mood Swings'},
    <String, String>{'key': 'bloating', 'label': 'Bloating'},
    <String, String>{'key': 'backache', 'label': 'Back Pain'},
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _cycleLength = context.read<AppModel>().periodData.cycleLength;
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final AppModel model = context.watch<AppModel>();
    if (!model.supportsPeriodTracking) {
      return _PageShell(
        title: 'Period Tracker',
        child: ListView(
          padding: const EdgeInsets.all(20),
          children: <Widget>[
            FitnessCard(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Available for female profiles',
                    style: TextStyle(
                      color: palette.textPrimary,
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Period tracking is only enabled when your profile gender is set to female. Update your profile if you need this feature.',
                    style: TextStyle(color: palette.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 18),
                  PrimaryButton(
                    label: 'Update Profile',
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute<void>(
                          builder: (_) =>
                              const ProfileSetupPage(isEditing: true),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }
    final PeriodPhaseInfo? info = latestPeriodPhase(model.periodData);
    return _PageShell(
      title: 'Period Tracker',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          FitnessCard(
            borderColor: (info?.color ?? palette.primary).withValues(
              alpha: 0.16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  info == null ? 'No cycle logged yet' : '${info.phase} Phase',
                  style: TextStyle(
                    color: info?.color ?? palette.primary,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  info == null
                      ? 'Day 0'
                      : 'Day ${info.dayOfCycle} of $_cycleLength',
                  style: TextStyle(
                    color: palette.textPrimary,
                    fontWeight: FontWeight.w800,
                    fontSize: 24,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  info == null
                      ? 'Log your period today to start predictions and phase tracking.'
                      : info.daysToNext > 0
                      ? 'Next period in ${info.daysToNext} days.'
                      : 'Next period is due today.',
                  style: TextStyle(color: palette.textSecondary, height: 1.45),
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          SectionHeader(title: 'Log Today'),
          FitnessCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Cycle Length',
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  children: <Widget>[
                    IconButton(
                      onPressed: () => setState(
                        () => _cycleLength = (_cycleLength - 1).clamp(21, 40),
                      ),
                      icon: const Icon(Icons.remove_circle_outline),
                    ),
                    Expanded(
                      child: Center(
                        child: Text(
                          '$_cycleLength days',
                          style: TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: palette.textPrimary,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: () => setState(
                        () => _cycleLength = (_cycleLength + 1).clamp(21, 40),
                      ),
                      icon: const Icon(Icons.add_circle_outline),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                Text(
                  'Symptoms',
                  style: TextStyle(
                    color: palette.textSecondary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: _symptoms
                      .map(
                        (Map<String, String> symptom) => FilterChip(
                          label: Text(symptom['label']!),
                          selected: _selectedSymptoms.contains(symptom['key']),
                          onSelected: (bool selected) {
                            setState(() {
                              if (selected) {
                                _selectedSymptoms.add(symptom['key']!);
                              } else {
                                _selectedSymptoms.remove(symptom['key']);
                              }
                            });
                          },
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 20),
                PrimaryButton(
                  label: 'Log Period Today',
                  onPressed: () => _logToday(context),
                ),
              ],
            ),
          ),
          if (model.periodData.entries.isNotEmpty) ...<Widget>[
            const SizedBox(height: 8),
            SectionHeader(title: 'Recent History'),
            ...model.periodData.entries
                .take(6)
                .map(
                  (PeriodEntry entry) => FitnessCard(
                    key: ValueKey<String>(entry.startDate),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: const Color(
                              0xFFE74C3C,
                            ).withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Icon(
                            Icons.favorite_border,
                            color: Color(0xFFE74C3C),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                formatShortDate(entry.startDate),
                                style: TextStyle(
                                  color: palette.textPrimary,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Cycle ${entry.cycleLength} days • ${entry.symptoms.join(', ')}',
                                style: TextStyle(color: palette.textSecondary),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
          ],
        ],
      ),
    );
  }

  Future<void> _logToday(BuildContext context) async {
    await context.read<AppModel>().logPeriodToday(
      cycleLength: _cycleLength,
      symptoms: _selectedSymptoms.toList(),
    );
    if (!context.mounted) return;
    showAppSnackBar(context, 'Period logged for today.');
    setState(_selectedSymptoms.clear);
  }
}

class WatchConnectPage extends StatelessWidget {
  const WatchConnectPage({super.key});

  static const List<DeviceInfo> _devices = <DeviceInfo>[
    DeviceInfo(
      id: 'phone-motion',
      name: 'Phone Motion Sensor',
      model: 'Live step tracking from your phone',
      icon: 'phone',
    ),
    DeviceInfo(
      id: 'manual-watch-sync',
      name: 'Manual Watch Sync',
      model: 'Use current tracked steps as your sync source',
      icon: 'watch',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    final AppModel model = context.watch<AppModel>();
    final DeviceInfo? device = model.connectedDevice;
    return _PageShell(
      title: 'Connect Watch',
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: <Widget>[
          FitnessCard(
            child: Text(
              'This build supports live phone step tracking and manual sync using your current tracked steps. Direct Bluetooth watch pairing is not enabled here.',
              style: TextStyle(color: palette.textSecondary, height: 1.5),
            ),
          ),
          if (device != null)
            FitnessCard(
              borderColor: palette.primary.withValues(alpha: 0.16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      Container(
                        width: 54,
                        height: 54,
                        decoration: BoxDecoration(
                          color: palette.primary,
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: const Icon(Icons.watch, color: Colors.white),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              'Connected',
                              style: TextStyle(
                                color: palette.primary,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              device.name,
                              style: TextStyle(
                                color: palette.textPrimary,
                                fontWeight: FontWeight.w800,
                                fontSize: 20,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Battery ${device.battery ?? 0}% • Last sync ${device.lastSync ?? '-'}',
                              style: TextStyle(color: palette.textSecondary),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: PrimaryButton(
                          label: 'Sync Steps',
                          outline: true,
                          onPressed: () =>
                              context.read<AppModel>().syncWatchSteps(),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: PrimaryButton(
                          label: 'Disconnect',
                          onPressed: () =>
                              context.read<AppModel>().disconnectDevice(),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          const SizedBox(height: 8),
          SectionHeader(title: 'Available Sources'),
          ..._devices.map(
            (DeviceInfo candidate) => FitnessCard(
              key: ValueKey<String>(candidate.id),
              onTap: () => context.read<AppModel>().connectDevice(candidate),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: palette.surface,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Icon(
                      candidate.icon == 'phone'
                          ? Icons.phone_android_rounded
                          : Icons.watch_outlined,
                      color: palette.primary,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          candidate.name,
                          style: TextStyle(
                            color: palette.textPrimary,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${candidate.model} • Battery ${candidate.battery ?? 0}%',
                          style: TextStyle(color: palette.textSecondary),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    device?.id == candidate.id ? 'Selected' : 'Use',
                    style: TextStyle(
                      color: device?.id == candidate.id
                          ? palette.primary
                          : palette.textSecondary,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _LegalPage(
      title: 'Privacy Policy',
      sections: const <Map<String, String>>[
        <String, String>{
          'heading': 'Data We Store',
          'body':
              'Kartik Ai stores your profile, daily nutrition logs, workout history, notification preferences, and optional device sync data on your device and may sync selected data to your configured backend.',
        },
        <String, String>{
          'heading': 'Why We Use It',
          'body':
              'Your health and activity data are used to generate workout plans, meal suggestions, progress views, reminders, and coach responses that are tailored to your goals.',
        },
        <String, String>{
          'heading': 'Your Control',
          'body':
              'You can update or remove profile information, disconnect devices, and log out at any time. Local app data remains tied to the device unless your backend removes it separately.',
        },
      ],
    );
  }
}

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return _LegalPage(
      title: 'Terms of Service',
      sections: const <Map<String, String>>[
        <String, String>{
          'heading': 'Fitness Guidance',
          'body':
              'Kartik Ai provides general wellness guidance only. It is not medical advice, diagnosis, or treatment. Use your judgment and consult a qualified professional when needed.',
        },
        <String, String>{
          'heading': 'Account Responsibility',
          'body':
              'You are responsible for the accuracy of the information entered into the app and for maintaining access to any connected services used by your backend.',
        },
        <String, String>{
          'heading': 'Service Availability',
          'body':
              'Some features depend on backend APIs, network access, and device integrations. Those features may be unavailable or degraded without connectivity or supported credentials.',
        },
      ],
    );
  }
}

class _PageShell extends StatelessWidget {
  const _PageShell({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: SafeArea(top: false, child: child),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: palette.textSecondary,
          fontWeight: FontWeight.w800,
          letterSpacing: 0.8,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _LanguageOption extends StatelessWidget {
  const _LanguageOption({required this.code, required this.label});

  final String code;
  final String label;

  @override
  Widget build(BuildContext context) {
    return SimpleDialogOption(
      onPressed: () => Navigator.of(context).pop(code),
      child: Text(label),
    );
  }
}

class _LegalPage extends StatelessWidget {
  const _LegalPage({required this.title, required this.sections});

  final String title;
  final List<Map<String, String>> sections;

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return _PageShell(
      title: title,
      child: ListView(
        padding: const EdgeInsets.all(20),
        children: sections
            .map(
              (Map<String, String> section) => FitnessCard(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      section['heading']!,
                      style: TextStyle(
                        color: palette.textPrimary,
                        fontWeight: FontWeight.w800,
                        fontSize: 18,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      section['body']!,
                      style: TextStyle(
                        color: palette.textSecondary,
                        height: 1.55,
                      ),
                    ),
                  ],
                ),
              ),
            )
            .toList(),
      ),
    );
  }
}
