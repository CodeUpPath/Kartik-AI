import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'app/app.dart';
import 'app/state/app_model.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    ChangeNotifierProvider<AppModel>(
      create: (_) => AppModel()..bootstrap(),
      child: const KartikAiFitApp(),
    ),
  );
}
