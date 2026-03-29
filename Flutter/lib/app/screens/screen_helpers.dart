import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models.dart';

Color colorFromHex(String value, {Color fallback = const Color(0xFF2ECC71)}) {
  final String hex = value.replaceAll('#', '').trim();
  if (hex.isEmpty) return fallback;
  final String normalized = hex.length == 6 ? 'FF$hex' : hex;
  return Color(int.tryParse(normalized, radix: 16) ?? fallback.toARGB32());
}

String greetingForNow() {
  final int hour = DateTime.now().hour;
  if (hour < 12) return 'Good Morning';
  if (hour < 17) return 'Good Afternoon';
  return 'Good Evening';
}

String prettyGoal(String? goal) {
  switch (goal) {
    case FitnessGoalValue.loseWeight:
      return 'Lose Fat';
    case FitnessGoalValue.gainMuscle:
      return 'Gain Muscle';
    case FitnessGoalValue.improveEndurance:
      return 'Build Endurance';
    case FitnessGoalValue.maintain:
      return 'Maintain Fitness';
    default:
      return 'Complete your profile';
  }
}

String formatShortDate(String isoDate) {
  try {
    return DateFormat('MMM d').format(DateTime.parse(isoDate));
  } catch (_) {
    return isoDate;
  }
}

String dayLetter(String isoDate) {
  try {
    const List<String> letters = <String>['M', 'T', 'W', 'T', 'F', 'S', 'S'];
    final DateTime date = DateTime.parse(isoDate);
    final int weekday = date.weekday.clamp(1, 7);
    return letters[weekday - 1];
  } catch (_) {
    return '?';
  }
}

class PeriodPhaseInfo {
  const PeriodPhaseInfo({
    required this.phase,
    required this.dayOfCycle,
    required this.daysToNext,
    required this.color,
  });

  final String phase;
  final int dayOfCycle;
  final int daysToNext;
  final Color color;
}

PeriodPhaseInfo? latestPeriodPhase(PeriodData data) {
  if (data.entries.isEmpty) return null;
  final PeriodEntry latest = data.entries.first;
  final DateTime start = DateTime.tryParse(latest.startDate) ?? DateTime.now();
  final int dayOfCycle = DateTime.now().difference(start).inDays + 1;
  final int cycleLength = latest.cycleLength <= 0 ? 28 : latest.cycleLength;
  String phase = 'Luteal';
  Color color = const Color(0xFF9B59B6);
  if (dayOfCycle <= 5) {
    phase = 'Menstrual';
    color = const Color(0xFFE74C3C);
  } else if (dayOfCycle <= 13) {
    phase = 'Follicular';
    color = const Color(0xFFF39C12);
  } else if (dayOfCycle <= 15) {
    phase = 'Ovulatory';
    color = const Color(0xFF2ECC71);
  }
  final int daysToNext = cycleLength - dayOfCycle;
  return PeriodPhaseInfo(
    phase: phase,
    dayOfCycle: dayOfCycle,
    daysToNext: daysToNext,
    color: color,
  );
}
