import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'screens/auth_screens.dart';
import 'state/app_model.dart';
import 'ui.dart';

class KartikAiFitApp extends StatelessWidget {
  const KartikAiFitApp({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isDark = context.select<AppModel, bool>(
      (AppModel model) => model.isDark,
    );
    final AppPalette palette = isDark ? darkPalette : lightPalette;
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Kartik Ai',
      theme: buildTheme(palette, isDark),
      home: const SplashPage(),
    );
  }
}
