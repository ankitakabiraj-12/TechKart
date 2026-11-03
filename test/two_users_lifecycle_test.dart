import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:techkart/core/session_manager.dart';
import 'package:techkart/core/network/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Two Independent Customers Lifecycle Test', () {
    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
    });

    test('User 1 and User 2 authenticate and switch cleanly without cross-contamination', () async {
      final sessionManager = SessionManager();
      await sessionManager.clearSession();

      // --- USER 1: Tanmoy Das (Male) ---
      final user1Data = {
        'id': 101,
        'role': 'customer',
        'full_name': 'Tanmoy Das',
        'email': 'tanmoy.das@example.com',
        'phone': '9876500001',
        'gender': 'male',
      };
      await sessionManager.saveSession(token: 'jwt_token_tanmoy_101', userData: user1Data);

      // Verify SessionManager holds User 1 identity
      expect(sessionManager.userName, equals('Tanmoy Das'));
      expect(sessionManager.userEmail, equals('tanmoy.das@example.com'));
      expect(sessionManager.userGender, equals('male'));
      expect(sessionManager.avatarAssetPath, equals('asset/male_avatar.jpg'));

      // Verify persistent secure storage has User 1 data
      final rawUser1 = await TokenStorage().getUserData();
      expect(rawUser1, isNotNull);
      final decoded1 = jsonDecode(rawUser1!);
      expect(decoded1['full_name'], equals('Tanmoy Das'));
      expect(decoded1['gender'], equals('male'));

      // --- SIMULATE APP RESTART FOR USER 1 ---
      // Clear in-memory instance reference state and re-initialize from storage
      final restartedSession1 = SessionManager();
      await restartedSession1.initialize();
      expect(restartedSession1.userName, equals('Tanmoy Das'));
      expect(restartedSession1.avatarAssetPath, equals('asset/male_avatar.jpg'));

      // --- USER 1 LOGOUT ---
      await restartedSession1.clearSession();
      expect(restartedSession1.currentUser, isNull);
      expect(restartedSession1.userName, isNull);
      expect(await TokenStorage().getToken(), isNull);
      expect(await TokenStorage().getUserData(), isNull);

      // --- USER 2: Riya Sen (Female) ---
      final user2Data = {
        'id': 102,
        'role': 'customer',
        'full_name': 'Riya Sen',
        'email': 'riya.sen@example.com',
        'phone': '9876500002',
        'gender': 'female',
      };
      await sessionManager.saveSession(token: 'jwt_token_riya_102', userData: user2Data);

      // Verify SessionManager holds User 2 identity completely (no trace of User 1)
      expect(sessionManager.userName, equals('Riya Sen'));
      expect(sessionManager.userEmail, equals('riya.sen@example.com'));
      expect(sessionManager.userGender, equals('female'));
      expect(sessionManager.avatarAssetPath, equals('asset/female_avatar.jpg'));

      // Verify storage holds User 2 data
      final rawUser2 = await TokenStorage().getUserData();
      expect(rawUser2, isNotNull);
      final decoded2 = jsonDecode(rawUser2!);
      expect(decoded2['full_name'], equals('Riya Sen'));
      expect(decoded2['gender'], equals('female'));

      // --- SIMULATE APP RESTART FOR USER 2 ---
      final restartedSession2 = SessionManager();
      await restartedSession2.initialize();
      expect(restartedSession2.userName, equals('Riya Sen'));
      expect(restartedSession2.avatarAssetPath, equals('asset/female_avatar.jpg'));

      // --- USER 2 LOGOUT ---
      await restartedSession2.clearSession();
      expect(restartedSession2.currentUser, isNull);
      expect(await TokenStorage().getToken(), isNull);
      expect(await TokenStorage().getUserData(), isNull);
    });
  });
}
