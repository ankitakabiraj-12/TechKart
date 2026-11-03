import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:techkart/core/session_manager.dart';
import 'package:techkart/theme/profile_avatar.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('Centralized App-Wide Avatar Management Tests', () {
    late SessionManager sessionManager;

    setUp(() async {
      FlutterSecureStorage.setMockInitialValues({});
      sessionManager = SessionManager();
      await sessionManager.clearSession();
    });

    test('Guest user defaults to assets/avatar.png', () {
      expect(sessionManager.isAuthenticated, isFalse);
      expect(sessionManager.avatarAssetPath, 'assets/avatar.png');
    });

    test('Authenticated female user uses assets/female_avatar.png', () async {
      await sessionManager.updateUser({
        'id': 1,
        'full_name': 'Ananya Sharma',
        'email': 'ananya@example.com',
        'gender': 'female',
      });

      expect(sessionManager.isAuthenticated, isTrue);
      expect(sessionManager.userGender, 'female');
      expect(sessionManager.avatarAssetPath, 'assets/female_avatar.png');
    });

    test('Authenticated male user uses assets/male_avatar.png', () async {
      await sessionManager.updateUser({
        'id': 2,
        'full_name': 'Tanvir Ahmed',
        'email': 'tanvir@example.com',
        'gender': 'male',
      });

      expect(sessionManager.isAuthenticated, isTrue);
      expect(sessionManager.userGender, 'male');
      expect(sessionManager.avatarAssetPath, 'assets/male_avatar.png');
    });

    test('Authenticated user with unknown / null gender defaults to assets/avatar.png', () async {
      await sessionManager.updateUser({
        'id': 3,
        'full_name': 'Alex Jordan',
        'email': 'alex@example.com',
        'gender': null,
      });

      expect(sessionManager.isAuthenticated, isTrue);
      expect(sessionManager.userGender, isNull);
      expect(sessionManager.avatarAssetPath, 'assets/avatar.png');
    });

    testWidgets('ProfileAvatar updates reactively across state changes (guest -> female -> male -> logout)', (tester) async {
      await sessionManager.clearSession();

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: Center(
              child: ProfileAvatar(size: 32),
            ),
          ),
        ),
      );

      await tester.pump();
      // 1. Guest state
      Image image = tester.widget<Image>(find.byType(Image));
      expect((image.image as AssetImage).assetName, 'assets/avatar.png');

      // 2. Login as Female
      await sessionManager.updateUser({
        'id': 10,
        'full_name': 'Ananya',
        'gender': 'female',
      });
      await tester.pump();

      image = tester.widget<Image>(find.byType(Image));
      expect((image.image as AssetImage).assetName, 'assets/female_avatar.png');

      // 3. Edit profile gender to Male
      await sessionManager.updateUser({
        'id': 10,
        'full_name': 'Tanvir',
        'gender': 'male',
      });
      await tester.pump();

      image = tester.widget<Image>(find.byType(Image));
      expect((image.image as AssetImage).assetName, 'assets/male_avatar.png');

      // 4. Logout / Clear session -> returns immediately to Guest
      await sessionManager.clearSession();
      await tester.pump();

      image = tester.widget<Image>(find.byType(Image));
      expect((image.image as AssetImage).assetName, 'assets/avatar.png');
    });
  });
}
