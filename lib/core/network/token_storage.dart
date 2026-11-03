import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class TokenStorage {
  static const String _keyToken = 'techkart_customer_jwt_token';
  static const String _keyRefreshToken = 'techkart_customer_refresh_token';
  static const String _keyUser = 'techkart_customer_user_data';
  static const String _keyOnboardingDone = 'techkart_customer_onboarding_completed';

  final FlutterSecureStorage _storage;

  TokenStorage({FlutterSecureStorage? storage})
      : _storage = storage ?? const FlutterSecureStorage();

  Future<void> saveToken(String token) async {
    await _storage.write(key: _keyToken, value: token);
  }

  Future<String?> getToken() async {
    return await _storage.read(key: _keyToken);
  }

  Future<void> saveRefreshToken(String refreshToken) async {
    await _storage.write(key: _keyRefreshToken, value: refreshToken);
  }

  Future<String?> getRefreshToken() async {
    return await _storage.read(key: _keyRefreshToken);
  }

  Future<void> saveUserData(String userDataJson) async {
    await _storage.write(key: _keyUser, value: userDataJson);
  }

  Future<String?> getUserData() async {
    return await _storage.read(key: _keyUser);
  }

  Future<bool> isOnboardingCompleted() async {
    final value = await _storage.read(key: _keyOnboardingDone);
    return value == 'true';
  }

  Future<void> setOnboardingCompleted() async {
    await _storage.write(key: _keyOnboardingDone, value: 'true');
  }

  Future<void> clearAuth() async {
    await _storage.delete(key: _keyToken);
    await _storage.delete(key: _keyRefreshToken);
    await _storage.delete(key: _keyUser);
  }

  Future<bool> hasToken() async {
    final token = await getToken();
    return token != null && token.trim().isNotEmpty;
  }
}
