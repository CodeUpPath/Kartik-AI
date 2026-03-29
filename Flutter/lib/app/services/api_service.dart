import 'dart:async';
import 'dart:convert';
import 'dart:typed_data';

import 'package:http/http.dart' as http;

import '../config.dart';

class ApiException implements Exception {
  const ApiException(this.message);

  final String message;

  @override
  String toString() => message;
}

class ApiService {
  ApiService({http.Client? client}) : _client = client ?? http.Client();

  final http.Client _client;
  String? _token;

  void setToken(String? token) {
    _token = token;
  }

  String get _baseUrl {
    final String baseUrl = AppConfig.resolvedApiBaseUrl;
    if (baseUrl.isNotEmpty) {
      return baseUrl;
    }
    throw const ApiException(
      'The app is missing a production API URL. Rebuild with --dart-define=API_BASE_URL=https://your-domain/api',
    );
  }

  Future<Map<String, dynamic>> signup(
    String name,
    String email,
    String password,
  ) async {
    final dynamic response = await _request(
      'POST',
      '/auth/signup',
      body: <String, dynamic>{
        'name': name,
        'email': email,
        'password': password,
      },
    );
    return _asMap(response);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    final dynamic response = await _request(
      'POST',
      '/auth/login',
      body: <String, dynamic>{'email': email, 'password': password},
    );
    return _asMap(response);
  }

  Future<Map<String, dynamic>> googleAuth(
    String idToken,
    String name,
    String email,
  ) async {
    final dynamic response = await _request(
      'POST',
      '/auth/google',
      body: <String, dynamic>{'idToken': idToken, 'name': name, 'email': email},
    );
    return _asMap(response);
  }

  Future<void> resetPassword(String email) async {
    await _request(
      'POST',
      '/auth/reset-password',
      body: <String, dynamic>{'email': email},
    );
  }

  Future<Map<String, dynamic>> getProfile() async {
    final dynamic response = await _request(
      'GET',
      '/profile',
      authenticated: true,
    );
    return _asMap(response);
  }

  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final dynamic response = await _request(
      'PUT',
      '/profile',
      body: data,
      authenticated: true,
    );
    return _asMap(response);
  }

  Future<List<dynamic>> getWorkouts() async {
    final dynamic response = await _request(
      'GET',
      '/workouts',
      authenticated: true,
    );
    if (response is List<dynamic>) {
      return response;
    }
    return <dynamic>[];
  }

  Future<List<Map<String, dynamic>>> getSteps() async {
    final dynamic response = await _request(
      'GET',
      '/steps',
      authenticated: true,
    );
    if (response is! List<dynamic>) {
      return <Map<String, dynamic>>[];
    }
    return response
        .whereType<Map<dynamic, dynamic>>()
        .map(
          (Map<dynamic, dynamic> item) => item.map(
            (dynamic key, dynamic value) =>
                MapEntry<String, dynamic>(key.toString(), value),
          ),
        )
        .toList();
  }

  Future<void> saveWorkout(Map<String, dynamic> data) async {
    await _request('POST', '/workouts', body: data, authenticated: true);
  }

  Future<void> syncSteps(int steps, String stepDate) async {
    await _request(
      'POST',
      '/steps',
      body: <String, dynamic>{'steps': steps, 'stepDate': stepDate},
      authenticated: true,
    );
  }

  Future<String> getTip() async {
    final Map<String, dynamic> response = await _request(
      'GET',
      '/tips',
      authenticated: true,
    );
    return response['tip']?.toString() ?? '';
  }

  Future<String> chat({
    required String message,
    required List<Map<String, String>> history,
  }) async {
    final Map<String, dynamic> response = await _request(
      'POST',
      '/chat',
      body: <String, dynamic>{'message': message, 'history': history},
    );
    return response['reply']?.toString() ??
        'I am having trouble connecting right now. Please try again.';
  }

  Future<Map<String, dynamic>> generatePlan({
    required int week,
    required Map<String, dynamic> profile,
  }) async {
    final dynamic response = await _request(
      'POST',
      '/plans/generate',
      body: <String, dynamic>{'week': week, 'profile': profile},
      authenticated: true,
      timeout: const Duration(seconds: 25),
    );
    return _asMap(response);
  }

  Future<Uint8List> synthesizeSpeech(String text) async {
    final Uri uri = Uri.parse('$_baseUrl/tts');
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (_token?.isNotEmpty == true) {
      headers['Authorization'] = 'Bearer $_token';
    }

    late http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: headers,
            body: jsonEncode(<String, dynamic>{'text': text}),
          )
          .timeout(const Duration(seconds: 20));
    } on TimeoutException {
      throw const ApiException('TTS request timed out. Check your connection.');
    } catch (error) {
      throw ApiException(error.toString());
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      String message = 'HTTP ${response.statusCode}';
      if (response.body.isNotEmpty) {
        try {
          final dynamic decoded = jsonDecode(response.body);
          if (decoded is Map<String, dynamic> && decoded['error'] != null) {
            message = decoded['error'].toString();
          }
        } catch (_) {}
      }
      throw ApiException(message);
    }

    return response.bodyBytes;
  }

  Future<dynamic> _request(
    String method,
    String path, {
    Map<String, dynamic>? body,
    bool authenticated = false,
    Duration timeout = const Duration(seconds: 8),
  }) async {
    final Map<String, String> headers = <String, String>{
      'Content-Type': 'application/json',
    };
    if (authenticated && _token?.isNotEmpty == true) {
      headers['Authorization'] = 'Bearer $_token';
    }

    final Uri uri = Uri.parse('$_baseUrl$path');
    late http.Response response;
    try {
      switch (method) {
        case 'POST':
          response = await _client
              .post(
                uri,
                headers: headers,
                body: body == null ? null : jsonEncode(body),
              )
              .timeout(timeout);
          break;
        case 'PUT':
          response = await _client
              .put(
                uri,
                headers: headers,
                body: body == null ? null : jsonEncode(body),
              )
              .timeout(timeout);
          break;
        default:
          response = await _client.get(uri, headers: headers).timeout(timeout);
      }
    } on TimeoutException {
      throw const ApiException('Request timed out. Check your connection.');
    } catch (error) {
      throw ApiException(error.toString());
    }

    dynamic decoded;
    if (response.body.isNotEmpty) {
      decoded = jsonDecode(response.body);
    }

    if (response.statusCode < 200 || response.statusCode >= 300) {
      final String message =
          decoded is Map<String, dynamic> && decoded['error'] != null
          ? decoded['error'].toString()
          : 'HTTP ${response.statusCode}';
      throw ApiException(message);
    }

    return decoded ?? <String, dynamic>{};
  }

  Map<String, dynamic> _asMap(dynamic response) {
    if (response is Map<String, dynamic>) {
      return response;
    }
    return <String, dynamic>{};
  }
}
