import 'package:flutter_test/flutter_test.dart';
import 'package:techkart/core/session_manager.dart';
import 'package:techkart/core/network/token_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('TechKart Authentication & Session Tests', () {
    setUp(() {
      FlutterSecureStorage.setMockInitialValues({});
    });

    test('SessionManager handles new user vs returning user session', () async {
      final sessionManager = SessionManager();
      await sessionManager.clearSession();

      // Initially no user (guest)
      expect(sessionManager.currentUser, isNull);
      expect(sessionManager.avatarAssetPath, equals('assets/avatar.png'));

      // Check onboarding initial state
      final initialOnboarding = await sessionManager.isOnboardingCompleted();
      expect(initialOnboarding, isFalse);

      // Complete onboarding
      await sessionManager.setOnboardingCompleted();
      expect(await sessionManager.isOnboardingCompleted(), isTrue);

      // Save male user session
      final maleUser = {
        'id': 1,
        'role': 'customer',
        'full_name': 'Rahul Sharma',
        'email': 'rahul.sharma@techkart.com',
        'phone': '9876543210',
        'gender': 'male',
      };
      await sessionManager.saveSession(token: 'mock_jwt_token_123', userData: maleUser);

      expect(sessionManager.userName, equals('Rahul Sharma'));
      expect(sessionManager.userGender, equals('male'));
      expect(sessionManager.avatarAssetPath, equals('assets/male_avatar.png'));

      // Save female user session
      final femaleUser = {
        'id': 16,
        'role': 'customer',
        'full_name': 'Ananya Roy',
        'email': 'ananya.roy@example.in',
        'phone': '9830112233',
        'gender': 'female',
      };
      await sessionManager.saveSession(token: 'mock_jwt_token_456', userData: femaleUser);

      expect(sessionManager.userName, equals('Ananya Roy'));
      expect(sessionManager.userGender, equals('female'));
      expect(sessionManager.avatarAssetPath, equals('assets/female_avatar.png'));

      // Test session logout
      await sessionManager.clearSession();
      expect(sessionManager.currentUser, isNull);
      expect(await TokenStorage().getToken(), isNull);
    });
  });
}
