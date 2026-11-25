import 'dart:io';
import 'package:flutter/foundation.dart';

class ApiConfig {
  ApiConfig._();

  /// Server port and path configuration:
  /// TechKart Core PHP server runs via PHP built-in server (`php -S 127.0.0.1:8000 -t public`)
  /// on port 8000 serving API endpoints under `/api/v1`.
  /// Alternatively, Apache XAMPP default port 80 serves `/techkart_backend/public/api/v1`.
  static const int phpBuiltInPort = 8000;
  static const int apachePort = 80;

  /// Override at build/run time:
  ///   flutter run --dart-define=API_BASE_URL=http://192.168.1.20:8000/api/v1
  static const String _envBaseUrl = String.fromEnvironment('API_BASE_URL');

  /// Default local development base URLs:
  /// - Web / iOS Simulator / Desktop / Windows loopback: 127.0.0.1:8000
  /// - Android with adb reverse: 127.0.0.1:8000
  /// - Android direct host Wi-Fi LAN IP fallback: 192.168.31.246:8000
  static const String lanHostIp = String.fromEnvironment(
    'API_LAN_HOST',
    defaultValue: '192.168.31.246',
  );

  static String get defaultBaseUrl {
    if (_envBaseUrl.isNotEmpty) {
      return _envBaseUrl;
    }
    if (kIsWeb) {
      return 'http://127.0.0.1:$phpBuiltInPort/api/v1';
    }
    if (Platform.isAndroid) {
      return 'http://127.0.0.1:$phpBuiltInPort/api/v1';
    }
    return 'http://127.0.0.1:$phpBuiltInPort/api/v1';
  }

  /// Secondary fallback URL for physical Android devices when adb reverse is detached
  static String get fallbackBaseUrl {
    return 'http://$lanHostIp:$phpBuiltInPort/api/v1';
  }

  /// Active base URL. Can be reassigned at startup or runtime (e.g., custom LAN IP).
  static String baseUrl = defaultBaseUrl;

  /// Returns the base origin without /api/v1 (e.g. 'http://127.0.0.1:8000')
  static String get serverOrigin {
    final uri = Uri.parse(baseUrl);
    return '${uri.scheme}://${uri.authority}';
  }

  /// Resolves an image path into a fully qualified URL or asset path
  static String resolveImageUrl(String path) {
    if (path.isEmpty) return '';
    if (path.startsWith('http://') || path.startsWith('https://')) return path;
    final clean = path.startsWith('/') ? path.substring(1) : path;
    return '$serverOrigin/$clean';
  }


  /// Separate connection and response timeout durations:
  /// - connectTimeout: TCP socket connection establishment limit
  /// - responseTimeout: Server processing & data stream reception limit
  static const Duration connectTimeout = Duration(seconds: 10);
  static const Duration responseTimeout = Duration(seconds: 25);
}
