import 'package:flutter/foundation.dart';

class AppConfig {
  AppConfig._();

  static const String apiBaseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: '',
  );
  static const String googleClientId = String.fromEnvironment(
    'GOOGLE_CLIENT_ID',
    defaultValue: '',
  );
  static const String googleServerClientId = String.fromEnvironment(
    'GOOGLE_SERVER_CLIENT_ID',
    defaultValue: '',
  );

  static bool get hasApiBaseUrl => apiBaseUrl.trim().isNotEmpty;

  static String get resolvedApiBaseUrl {
    if (hasApiBaseUrl) {
      return apiBaseUrl.trim();
    }
    if (kReleaseMode) {
      return '';
    }
    if (kIsWeb) {
      return 'http://localhost:8080/api';
    }
    if (defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8080/api';
    }
    return 'http://localhost:8080/api';
  }

  static bool get isGoogleSignInConfigured {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return googleServerClientId.trim().isNotEmpty;
    }
    return googleServerClientId.trim().isNotEmpty ||
        googleClientId.trim().isNotEmpty;
  }

  static List<String> get releaseWarnings {
    final List<String> warnings = <String>[];
    if (kReleaseMode && !hasApiBaseUrl) {
      warnings.add(
        'This release build is missing API_BASE_URL. Rebuild with your live HTTPS backend URL.',
      );
    }
    if (kReleaseMode && !isGoogleSignInConfigured) {
      warnings.add(
        'Google Sign-In is not configured for this release build yet.',
      );
    }
    return warnings;
  }
}
