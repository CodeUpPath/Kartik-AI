import 'package:flutter/material.dart';

import 'coach_tab.dart';
import 'home_tab.dart';
import 'nutrition_tab.dart';
import 'progress_tab.dart';
import '../ui.dart';
import 'workout_tab.dart';

class AppShell extends StatefulWidget {
  const AppShell({super.key, this.initialIndex = 0});

  final int initialIndex;

  @override
  State<AppShell> createState() => _AppShellState();
}

class _AppShellState extends State<AppShell> {
  late int _index;

  late final List<Widget> _tabs = <Widget>[
    const HomeTab(),
    const NutritionTab(),
    const WorkoutTab(),
    const ProgressTab(),
    const CoachTab(),
  ];

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, _tabs.length - 1);
  }

  @override
  Widget build(BuildContext context) {
    final AppPalette palette = paletteOf(context);
    return Scaffold(
      body: IndexedStack(index: _index, children: _tabs),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.fromLTRB(14, 0, 14, 12),
        child: FitnessCard(
          margin: EdgeInsets.zero,
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          color: palette.tabBar,
          radius: 28,
          child: NavigationBar(
            selectedIndex: _index,
            onDestinationSelected: (int nextIndex) {
              setState(() => _index = nextIndex);
            },
            destinations: const <NavigationDestination>[
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon: Icon(Icons.home),
                label: 'Home',
              ),
              NavigationDestination(
                icon: Icon(Icons.restaurant_outlined),
                selectedIcon: Icon(Icons.restaurant),
                label: 'Nutrition',
              ),
              NavigationDestination(
                icon: Icon(Icons.fitness_center_outlined),
                selectedIcon: Icon(Icons.fitness_center),
                label: 'Workout',
              ),
              NavigationDestination(
                icon: Icon(Icons.bar_chart_outlined),
                selectedIcon: Icon(Icons.bar_chart),
                label: 'Progress',
              ),
              NavigationDestination(
                icon: Icon(Icons.smart_toy_outlined),
                selectedIcon: Icon(Icons.smart_toy),
                label: 'Coach',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
