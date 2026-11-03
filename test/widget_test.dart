import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:techkart/authentication/create_account.dart';
import 'package:techkart/authentication/forgot_password.dart';
import 'package:techkart/authentication/login.dart';
import 'package:techkart/authentication/onboarding.dart';
import 'package:techkart/authentication/otp_verfification.dart';
import 'package:techkart/authentication/set_new_password.dart';
import 'package:techkart/authentication/splash_screen.dart';
import 'package:techkart/navigation/main_navigation_shell.dart';
import 'package:techkart/theme/bottom_navbar.dart';
import 'package:techkart/navigation/home.dart';
import 'package:techkart/navigation/categories.dart';
import 'package:techkart/navigation/subcategory_products.dart';
import 'package:techkart/navigation/search_overlay.dart';
import 'package:techkart/navigation/search_result.dart';
import 'package:techkart/product_details/product_details.dart';
import 'package:techkart/product_details/product_gallery.dart';
import 'package:techkart/product_details/product_specifications.dart';
import 'package:techkart/product_details/customer_reviews.dart';
import 'package:techkart/product_details/write_reviews.dart';
import 'package:techkart/ai_assistant/ai_visual_search_camera.dart';
import 'package:techkart/ai_assistant/ai_image_processing.dart';
import 'package:techkart/ai_assistant/visual_search_results.dart';
import 'package:techkart/ai_assistant/conversational_shopping_assistant.dart';
import 'package:techkart/ai_assistant/ai_chat_sessions.dart';
import 'package:techkart/wishlist/wishlist.dart';
import 'package:techkart/wishlist/shopping_cart.dart';
import 'package:techkart/checkout/delivery_address.dart';
import 'package:techkart/checkout/edit_address.dart';
import 'package:techkart/checkout/order_review.dart';
import 'package:techkart/checkout/payment_method.dart';
import 'package:techkart/checkout/secure_payment.dart';
import 'package:techkart/checkout/order_confirmation.dart';
import 'package:techkart/orders/order_history.dart';
import 'package:techkart/orders/order_details.dart';
import 'package:techkart/orders/shipment_tracking.dart';
import 'package:techkart/orders/return_request.dart';
import 'package:techkart/orders/return_status.dart';
import 'package:techkart/profile_settings/customer_profile_hub.dart';
import 'package:techkart/profile_settings/edit_profile.dart';
import 'package:techkart/profile_settings/address_book.dart';
import 'package:techkart/profile_settings/notifications.dart';
import 'package:techkart/profile_settings/settings.dart';
import 'package:techkart/main.dart';

void main() {
  testWidgets('SplashScreen smoke test and animation pump', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verify SplashScreen is loaded
    expect(find.byType(SplashScreen), findsOneWidget);

    // Verify Get Started button and floating icons are present
    expect(find.text('Get Started'), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.headphones), findsOneWidget);
    expect(find.byIcon(CupertinoIcons.bolt_fill), findsOneWidget);

    // Advance animation by 1 second
    await tester.pump(const Duration(seconds: 1));

    // Tap Get Started button
    await tester.tap(find.text('Get Started'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 700));
  });

  testWidgets('OnboardingScreen renders and transitions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OnboardingScreen(),
      ),
    );

    // Verify OnboardingScreen elements
    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
    expect(find.textContaining('Smart tech curated'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.textContaining('Already have an account?'), findsOneWidget);

    // Tap Continue button
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();

    // Verify second slide headline
    expect(find.textContaining('Snap. Match.'), findsOneWidget);
  });

  testWidgets('LoginScreen renders all elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: LoginScreen(),
      ),
    );

    // Verify key UI components
    expect(find.byType(LoginScreen), findsOneWidget);
    expect(find.text('SECURE AUTHENTICATION'), findsOneWidget);
    expect(find.text('Welcome back.'), findsOneWidget);
    expect(find.text('Email or Mobile Phone'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Forgot password?'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);
    expect(find.text('Apple Keychain & Biometrics'), findsOneWidget);
    expect(find.textContaining('New to TechKart?'), findsOneWidget);

    // Enter email and password
    await tester.enterText(find.byType(TextFormField).first, 'alex@example.com');
    await tester.enterText(find.byType(TextFormField).last, 'Secret123!');
    await tester.pump();

    // Toggle password visibility
    await tester.tap(find.byIcon(CupertinoIcons.eye));
    await tester.pump();
    expect(find.byIcon(CupertinoIcons.eye_slash), findsOneWidget);

    // Tap Sign In button
    await tester.tap(find.text('Sign In'));
    await tester.pump(const Duration(milliseconds: 700));
    await tester.pump(const Duration(milliseconds: 300));
  });

  testWidgets('CreateAccountScreen renders all elements and handles registration', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CreateAccountScreen(),
      ),
    );

    // Verify key UI components
    expect(find.byType(CreateAccountScreen), findsOneWidget);
    expect(find.text('VERIFIED REGISTRATION'), findsOneWidget);
    expect(find.text('Create account.'), findsOneWidget);
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Email or Mobile Phone'), findsOneWidget);
    expect(find.text('Password'), findsOneWidget);
    expect(find.text('Strong password'), findsOneWidget);
    expect(find.text('Min. 8 characters'), findsOneWidget);
    expect(find.text('Terms of Service'), findsOneWidget);
    expect(find.text('Privacy Policy'), findsOneWidget);
    expect(find.text('Create Account'), findsOneWidget);
    expect(find.textContaining('Already have an account?'), findsOneWidget);

    // Enter Full Name, Email, Password
    await tester.enterText(find.byType(TextFormField).at(0), 'Alex Morgan');
    await tester.enterText(find.byType(TextFormField).at(1), 'alex@example.com');
    await tester.enterText(find.byType(TextFormField).at(2), 'Pass123!Secure');
    await tester.pump();

    // Toggle password visibility
    await tester.tap(find.byIcon(CupertinoIcons.eye));
    await tester.pump();
    expect(find.byIcon(CupertinoIcons.eye_slash), findsOneWidget);

    // Scroll and tap Create Account button
    await tester.ensureVisible(find.text('Create Account'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Create Account'));
    await tester.pumpAndSettle();
  });

  testWidgets('ForgotPasswordScreen renders all elements and sends reset code', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ForgotPasswordScreen(),
      ),
    );

    // Verify key UI components
    expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    expect(find.text('PASSWORD RECOVERY'), findsOneWidget);
    expect(find.text('Forgot password.'), findsOneWidget);
    expect(find.text('Email or Mobile Phone'), findsOneWidget);
    expect(find.textContaining("We'll send a 6-digit one-time code"), findsOneWidget);
    expect(find.text('Send Reset Code'), findsOneWidget);
    expect(find.text('Protected by TechKart Security'), findsOneWidget);
    expect(find.textContaining('Remember your password?'), findsOneWidget);

    // Enter email
    await tester.enterText(find.byType(TextFormField), 'alex@example.com');
    await tester.pump();

    // Tap Send Reset Code
    await tester.tap(find.text('Send Reset Code'));
    await tester.pumpAndSettle();
  });

  testWidgets('OtpVerificationScreen renders all elements and verifies code', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: OtpVerificationScreen(),
      ),
    );

    // Verify key UI components
    expect(find.byType(OtpVerificationScreen), findsOneWidget);
    expect(find.text('SECURE OTP VERIFICATION'), findsOneWidget);
    expect(find.text('Verify code.'), findsOneWidget);
    expect(find.textContaining('alex.m****@example.com'), findsOneWidget);
    expect(find.text('Edit email'), findsOneWidget);

    // Verify prefilled PIN digits 4, 8, 2, 9
    expect(find.text('4'), findsOneWidget);
    expect(find.text('8'), findsOneWidget);
    expect(find.text('2'), findsOneWidget);
    expect(find.text('9'), findsOneWidget);

    // Verify timer & security elements
    expect(find.textContaining('Resend code in'), findsOneWidget);
    expect(find.text('Resend Code'), findsOneWidget);
    expect(find.text('Encrypted Handshake'), findsOneWidget);
    expect(find.text('Verify & Continue'), findsOneWidget);
    expect(find.textContaining('Having trouble?'), findsOneWidget);

    // Tap Verify & Continue
    await tester.tap(find.text('Verify & Continue'));
    await tester.pumpAndSettle();
  });

  testWidgets('SetNewPasswordScreen renders all elements and updates password', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SetNewPasswordScreen(),
      ),
    );

    // Verify key UI components from the reference image
    expect(find.byType(SetNewPasswordScreen), findsOneWidget);
    expect(find.text('SECURITY & CREDENTIALS'), findsOneWidget);
    expect(find.text('Create new password.'), findsOneWidget);
    expect(find.textContaining('Your new password must be unique'), findsOneWidget);
    expect(find.text('New Password'), findsOneWidget);
    expect(find.text('Case-sensitive'), findsOneWidget);
    expect(find.text('Password Strength'), findsOneWidget);
    expect(find.text('Strong password'), findsOneWidget);
    expect(find.text('Min. 8 characters'), findsOneWidget);
    expect(find.text('Includes number & symbol'), findsOneWidget);
    expect(find.text('Uppercase letter'), findsOneWidget);
    expect(find.text('Confirm New Password'), findsOneWidget);
    expect(find.text('Passwords match'), findsOneWidget);
    expect(find.text('End-to-End Encryption'), findsOneWidget);
    expect(find.textContaining('All active sessions on secondary devices'), findsOneWidget);
    expect(find.text('Update Password'), findsOneWidget);
    expect(find.textContaining('Remembered your credentials?'), findsOneWidget);
    expect(find.text('Sign In'), findsOneWidget);

    // Toggle password visibility
    final eyeButtons = find.byIcon(CupertinoIcons.eye);
    expect(eyeButtons, findsNWidgets(2));
    await tester.tap(eyeButtons.first);
    await tester.pump();
    expect(find.byIcon(CupertinoIcons.eye_slash), findsOneWidget);

    // Enter a new valid password with uppercase, number, symbol
    await tester.enterText(find.byType(TextFormField).first, 'Secure@2026Pass');
    await tester.enterText(find.byType(TextFormField).last, 'Secure@2026Pass');
    await tester.pump();

    // Verify that strength label updates to Very strong
    expect(find.text('Very strong'), findsOneWidget);
    expect(find.text('Passwords match'), findsOneWidget);

    // Scroll and tap Update Password
    await tester.ensureVisible(find.text('Update Password'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Update Password'));
    await tester.pumpAndSettle();

    // Verify success dialog appears
    expect(find.text('Password Updated'), findsOneWidget);
    expect(find.text('Proceed to Sign In'), findsOneWidget);
  });

  testWidgets('MainNavigationShell renders reference screen elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: MainNavigationShell(),
      ),
    );

    // 1. Verify Top Header from HomeScreen
    expect(find.text('TechKart'), findsWidgets);
    expect(find.textContaining('94103 • SF'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Flagship Hero
    expect(find.text('FLAGSHIP RELEASE'), findsOneWidget);
    expect(find.text('Apex Fold & Buds Pro'), findsOneWidget);
    expect(find.text('₹1,69,861.58'), findsOneWidget);

    // 3. Verify Bottom Navigation Bar and embedded screen
    expect(find.byType(TechKartBottomNavBar), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.byType(HomeScreen), findsOneWidget);
  });

  testWidgets('HomeScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // 1. Verify Top Header
    expect(find.text('TechKart'), findsWidgets);
    expect(find.textContaining('94103 • SF'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Sub-header delivery and live stock
    expect(find.text('Deliver to SF 94103'), findsOneWidget);
    expect(find.text('LIVE STOCK'), findsOneWidget);

    // 3. Verify Search Bar
    expect(find.text('Search gadgets, neural chips, gear...'), findsOneWidget);
    expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.qr_code_scanner_rounded), findsOneWidget);

    // 4. Verify Hero Flagship card
    expect(find.text('FLAGSHIP RELEASE'), findsOneWidget);
    expect(find.text('Apex Fold & Buds Pro'), findsOneWidget);
    expect(find.textContaining('Titanium alloy unibody. Dual 120Hz foldable dynamic OLED'), findsOneWidget);
    expect(find.text('PRE-ORDER FROM'), findsOneWidget);
    expect(find.text('₹1,69,861.58'), findsOneWidget);
    expect(find.text('Discover'), findsOneWidget);

    // 5. Verify Categories Rail
    expect(find.text('Categories'), findsWidgets);
    expect(find.text('Explore Index'), findsOneWidget);
    expect(find.text('Audio'), findsOneWidget);
    expect(find.text('Phones'), findsOneWidget);
    expect(find.text('Desks'), findsOneWidget);
    expect(find.text('Wearables'), findsOneWidget);
    expect(find.text('Vision'), findsOneWidget);

    // 6. Verify Curated Drops
    expect(find.text('Curated Drops'), findsOneWidget);
    expect(find.text('Carefully verified hardware'), findsOneWidget);
    expect(find.text('View All'), findsOneWidget);

    expect(find.text('ACOUSTICS'), findsOneWidget);
    expect(find.text('Aura Studio ANC'), findsOneWidget);
    expect(find.text('4.9 (1.2k)'), findsOneWidget);
    expect(find.text('₹32,952.58'), findsOneWidget);

    expect(find.text('WORKSTATION'), findsOneWidget);
    expect(find.text('Lumix Pro Suite'), findsOneWidget);
    expect(find.text('4.8 (840)'), findsOneWidget);
    expect(find.text('₹17,845.38'), findsOneWidget);

    // 7. Verify Assistant AI Banner
    expect(find.text('TECHKART ASSISTANT'), findsOneWidget);
    expect(find.text('AI Beta'), findsOneWidget);
    expect(find.textContaining('Verify component pinouts, cross-ecosystem latency'), findsOneWidget);
    expect(find.text('Inquire specs & pairing'), findsOneWidget);

    // 8. Verify Bottom Navigation
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('AI Search'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // 9. Test Add to cart from Curated Drops
    final addButtons = find.byIcon(Icons.add_rounded);
    expect(addButtons, findsNWidgets(2));
    await tester.ensureVisible(addButtons.first);
    await tester.pumpAndSettle();
    await tester.tap(addButtons.first);
    await tester.pump();
    expect(find.text('Added Aura Studio ANC (₹32,952.58) to Cart'), findsOneWidget);
    expect(find.text('3'), findsOneWidget);
  });

  testWidgets('HomeScreen renders upgraded Diwali Tech Mahotsav, Carousels, and Ace Brands', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: HomeScreen(),
      ),
    );

    // 1. Verify Quick Services Row
    expect(find.text('15m Express'), findsOneWidget);
    expect(find.text('Diwali Utsav'), findsOneWidget);
    expect(find.text('365 Shield'), findsOneWidget);
    expect(find.text('Trade-In 2.0'), findsOneWidget);
    expect(find.text('0% EMI'), findsOneWidget);

    // 2. Verify Diwali Tech Mahotsav Section
    expect(find.text('DIWALI TECH MAHOTSAV'), findsOneWidget);
    expect(find.text('Festival of Lights • Mega Hardware Steals'), findsOneWidget);
    expect(find.text('🪔 UTSAV'), findsOneWidget);
    expect(find.text('Ends in 08h : 36m : 14s'), findsOneWidget);
    expect(find.text('10% Instant Card Off 🏛️'), findsOneWidget);

    // 3. Verify Diwali 2x2 Festive Steals
    expect(find.text('Chronos Watch Series X'), findsOneWidget);
    expect(find.text('Aura Pro ANC'), findsOneWidget);
    expect(find.text('Volta GaN 140W Hub'), findsOneWidget);
    expect(find.text('Apex Titanium Link'), findsOneWidget);
    expect(find.text('↓22% OFF'), findsOneWidget);
    expect(find.text('↓25% OFF'), findsOneWidget);

    // 4. Verify In The Spotlight / Ace Brands Section
    expect(find.text('In The Spotlight'), findsOneWidget);
    expect(find.text('ACE BRANDS'), findsOneWidget);
    expect(find.text('Apple Ecosystem'), findsOneWidget);
    expect(find.text('NVIDIA Blackwell AI'), findsOneWidget);
    expect(find.text('Sony Acoustics Lab'), findsOneWidget);
    expect(find.text('Lumix Workstations'), findsOneWidget);

    // 5. Verify TechKart LIVE Section
    expect(find.text('TechKart LIVE'), findsOneWidget);
    expect(find.text('LIVE'), findsOneWidget);
    expect(find.text('Apex Fold Hinge Durability Test'), findsOneWidget);
    expect(find.text('Hardware Teardowns'), findsOneWidget);

    // 6. Test interaction: Tap Quick Service pill
    await tester.tap(find.text('Diwali Utsav'));
    await tester.pump();
    expect(find.text('Diwali Utsav activated!'), findsOneWidget);
  });

  group('HomeScreen Viewport Width Tests', () {
    for (final width in [320.0, 360.0, 360.7, 390.0, 412.0]) {
      testWidgets('HomeScreen renders without overflow on screen width $width', (WidgetTester tester) async {
        tester.view.physicalSize = Size(width * 2.0, 1000.0 * 2.0);
        tester.view.devicePixelRatio = 2.0;
        addTearDown(() {
          tester.view.resetPhysicalSize();
          tester.view.resetDevicePixelRatio();
        });

        await tester.pumpWidget(
          const MaterialApp(
            home: HomeScreen(),
          ),
        );

        await tester.pumpAndSettle();

        expect(find.text('In The Spotlight'), findsOneWidget);
        expect(find.text('TechKart LIVE'), findsOneWidget);
        expect(tester.takeException(), isNull);
      });
    }
  });

  testWidgets('CategoriesScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CategoriesScreen(),
      ),
    );

    // 1. Verify Top Header
    expect(find.text('TechKart'), findsWidgets);
    expect(find.textContaining('94103 • SF'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Headline & Subtitle
    expect(find.text('Explore Categories'), findsOneWidget);
    expect(find.textContaining('Browse curated hardware by domain and'), findsOneWidget);

    // 3. Verify Search Bar
    expect(find.text('Filter 24+ hardware categories...'), findsOneWidget);

    // 4. Verify Filter Chips
    expect(find.text('All Categories'), findsOneWidget);
    expect(find.text('Audio'), findsOneWidget);
    expect(find.text('Wearables'), findsOneWidget);
    expect(find.text('Power'), findsOneWidget);

    // 5. Verify Category Cards
    expect(find.text('Earbuds & Au...'), findsOneWidget);
    expect(find.text('Flagship'), findsOneWidget);
    expect(find.text('Studio earbuds, spatial acousti...'), findsOneWidget);
    expect(find.text('48 Products'), findsOneWidget);

    expect(find.text('Smartwatches & Wea...'), findsOneWidget);
    expect(find.text('Titanium casings, biometric...'), findsOneWidget);
    expect(find.text('32 Products'), findsOneWidget);

    expect(find.text('Computer Acc...'), findsOneWidget);
    expect(find.text('New Gen'), findsOneWidget);
    expect(find.text('Mechanical keyboards,...'), findsOneWidget);
    expect(find.text('56 Products'), findsOneWidget);

    expect(find.text('Chargers & Power'), findsOneWidget);
    expect(find.text('GaN fast chargers, 140W hubs ...'), findsOneWidget);
    expect(find.text('27 Products'), findsOneWidget);

    expect(find.text('Power Banks & Backup'), findsOneWidget);
    expect(find.text('High-density battery packs &...'), findsOneWidget);
    expect(find.text('19 Products'), findsOneWidget);

    expect(find.text('Foldables & Optics'), findsOneWidget);
    expect(find.text('Dual-screen hinges, micro-...'), findsOneWidget);
    expect(find.text('14 Products'), findsOneWidget);

    // 6. Verify Ecosystem Sets Banner
    expect(find.text('ECOSYSTEM SETS'), findsOneWidget);
    expect(find.text('Desk & Sound Bundles'), findsOneWidget);
    expect(find.textContaining('Curated pairings calibrated for'), findsOneWidget);
    expect(find.text('Explore Kits'), findsOneWidget);

    // 7. Verify Bottom Navigation
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('AI Search'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // 8. Test Filter Chip Interaction
    await tester.tap(find.text('Power'));
    await tester.pump();
    expect(find.text('Chargers & Power'), findsOneWidget);
    expect(find.text('Power Banks & Backup'), findsOneWidget);
    // Other cards should be filtered out
    expect(find.text('Earbuds & Au...'), findsNothing);
  });

  testWidgets('SubcategoryProductsScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SubcategoryProductsScreen(),
      ),
    );

    // 1. Verify Top Header
    expect(find.text('TechKart'), findsWidgets);
    expect(find.textContaining('94103 • SF'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Navigation Action Bar
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    expect(find.byIcon(Icons.grid_view_rounded), findsWidgets);

    // 3. Verify Pre-title & Headline
    expect(find.text('FLAGSHIP ECOSYSTEM'), findsOneWidget);
    expect(find.text('Wearables & Watches'), findsOneWidget);
    expect(find.textContaining('18 flagship devices calibrated for precision health'), findsOneWidget);

    // 4. Verify Sort, Filters & Verification
    expect(find.text('Sort: Popular'), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('2'), findsWidgets); // Filter count badge & cart badge
    expect(find.byIcon(Icons.verified_outlined), findsOneWidget);

    // 5. Verify Subcategory Filter Chips
    expect(find.text('All (18)'), findsOneWidget);
    expect(find.text('Titanium'), findsOneWidget);
    expect(find.text('Cellular LTE'), findsOneWidget);
    expect(find.text('Bio-Sensors'), findsOneWidget);

    // 6. Verify 4 Product Cards
    expect(find.text('Chronos Ultra 2'), findsOneWidget);
    expect(find.text('FLAGSHIP'), findsOneWidget);
    expect(find.text('Titanium 49mm • Cellular'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);

    expect(find.text('Aura Watch Studio'), findsOneWidget);
    expect(find.text('NEW GEN'), findsOneWidget);
    expect(find.text('Ceramic bezel • Sapphire'), findsOneWidget);
    expect(find.text('₹36,729.38'), findsOneWidget);

    expect(find.text('Volta Dual Dock'), findsOneWidget);
    expect(find.text('ESSENTIAL DOCK'), findsOneWidget);
    expect(find.text('GaN 65W • MagSafe Duo'), findsOneWidget);
    expect(find.text('₹8,403.38'), findsOneWidget);

    expect(find.text('Apex Buds Pro'), findsOneWidget);
    expect(find.text('STUDIO AUDIO'), findsOneWidget);
    expect(find.text('Active ANC • 38h Battery'), findsOneWidget);
    expect(find.text('₹23,510.58'), findsOneWidget);

    // 7. Verify Precision Biometric Guarantee Card
    expect(find.text('Precision Biometric Guarantee'), findsOneWidget);
    expect(find.textContaining('All cellular watches include FDA-cleared ECG'), findsOneWidget);

    // 8. Verify Status Info Pill
    expect(find.text('Showing 4 of 18 products'), findsOneWidget);
    expect(find.text('SF 94103 2-hr'), findsOneWidget);

    // 9. Test Add to cart from Product Grid
    final addButtons = find.byIcon(Icons.add_rounded);
    expect(addButtons, findsNWidgets(4));
    await tester.ensureVisible(addButtons.first);
    await tester.pumpAndSettle();
    await tester.tap(addButtons.first);
    await tester.pump();
    expect(find.text('Added Chronos Ultra 2 (₹40,506.18) to Cart'), findsOneWidget);
  });

  testWidgets('SearchOverlayScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SearchOverlayScreen(),
      ),
    );

    // 1. Verify Top Search Bar
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('Titanium watch'), findsOneWidget);
    expect(find.byIcon(Icons.close_rounded), findsWidgets); // clear in search bar + recent pills
    expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);

    // 2. Verify Filter Chips
    expect(find.text('All Tech'), findsOneWidget);
    expect(find.text('Gadgets'), findsOneWidget);
    expect(find.text('Audio'), findsOneWidget);
    expect(find.text('Accessories'), findsOneWidget);

    // 3. Verify Instant Match Card
    expect(find.text('Chronos Titanium Watc...'), findsOneWidget);
    expect(find.text('IN\nSTOCK'), findsOneWidget);
    expect(find.text('Hardware category • 49mm Cellular Case'), findsOneWidget);
    expect(find.byIcon(Icons.north_west_rounded), findsOneWidget);

    // 4. Verify Recent Searches
    expect(find.text('RECENT SEARCHES'), findsOneWidget);
    expect(find.text('Clear All'), findsOneWidget);
    expect(find.text('Chronos Ultra 2'), findsOneWidget);
    expect(find.text('GaN 65W Fast Charger'), findsOneWidget);
    expect(find.text('ANC Headphones'), findsOneWidget);
    expect(find.text('Foldable OLED'), findsOneWidget);

    // 5. Verify Trending Searches
    expect(find.text('TRENDING SEARCHES'), findsOneWidget);
    expect(find.text('Apex Fold & Buds Pro'), findsOneWidget);
    expect(find.text('Hot Drop'), findsOneWidget);
    expect(find.text('Mechanical Tactile Keyboard'), findsOneWidget);
    expect(find.text('MagSafe Duo Charging Station'), findsOneWidget);
    expect(find.text('Titanium Cellular Watch 49mm'), findsOneWidget);
    expect(find.text('Spatial Acoustics Earbuds'), findsOneWidget);

    // 6. Verify TechKart Intelligence Card
    expect(find.text('TechKart Intelligence'), findsOneWidget);
    expect(find.textContaining('Ask our assistant about pinouts'), findsOneWidget);
    expect(find.text('Compare Chronos vs Aura Studio'), findsOneWidget);

    // 7. Test Clear All Recent Searches
    await tester.tap(find.text('Clear All'));
    await tester.pump();
    expect(find.text('No recent searches.'), findsOneWidget);
  });

  testWidgets('SearchResultScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: SearchResultScreen(),
      ),
    );

    // 1. Verify Top Header
    expect(find.text('TechKart'), findsWidgets);
    expect(find.textContaining('94103 • SF'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Search Bar
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('Titanium watch'), findsWidgets); // Input + Results header
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(find.byIcon(Icons.mic_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.camera_alt_outlined), findsOneWidget);

    // 3. Verify Results count badge & sort
    expect(find.text('14 items'), findsOneWidget);
    expect(find.text('Sort: Best Match'), findsOneWidget);

    // 4. Verify Filter chips
    expect(find.text('In Stock'), findsOneWidget);
    expect(find.text('Filters'), findsOneWidget);
    expect(find.text('Titanium Case'), findsOneWidget);
    expect(find.text('Cellular 4G/LTE'), findsOneWidget);

    // 5. Verify 4 Product Cards
    expect(find.text('Chronos Ultra 2'), findsOneWidget);
    expect(find.text('BEST MATCH'), findsOneWidget);
    expect(find.text('Titanium 49mm • Cellul...'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);

    expect(find.text('Aura Watch Studio'), findsOneWidget);
    expect(find.text('SAPPHIRE'), findsOneWidget);
    expect(find.text('Ceramic Bezel • Sapphire'), findsOneWidget);
    expect(find.text('₹36,729.38'), findsOneWidget);

    expect(find.text('Volta Dual GaN Do...'), findsOneWidget);
    expect(find.text('COMPANION'), findsOneWidget);
    expect(find.text('65W Fast Charge • Puck'), findsOneWidget);
    expect(find.text('₹8,403.38'), findsOneWidget);

    expect(find.text('Apex Titanium Link'), findsOneWidget);
    expect(find.text('ECOSYSTEM'), findsOneWidget);
    expect(find.text('Dual Biometrics • 7-day'), findsOneWidget);
    expect(find.text('₹51,836.58'), findsOneWidget);

    // 6. Verify Didn't find exact specs AI Matchmaking Card
    expect(find.text("Didn't find the exact specs?"), findsOneWidget);
    expect(find.textContaining('TechKart AI can match watch lugs'), findsOneWidget);
    expect(find.text('Compare Chronos battery vs Garmin Epix'), findsOneWidget);

    // 7. Test Add to cart
    final addButtons = find.byIcon(Icons.add_rounded);
    expect(addButtons, findsNWidgets(4));
    await tester.ensureVisible(addButtons.first);
    await tester.pumpAndSettle();
    await tester.tap(addButtons.first);
    await tester.pump();
    expect(find.text('Added Chronos Ultra 2 (₹40,506.18) to Cart'), findsOneWidget);
  });

  testWidgets('ProductDetailsScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductDetailsScreen(),
      ),
    );

    // 1. Verify Top Header
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('Product ...'), findsOneWidget);
    expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Hero Card & Badges
    expect(find.text('Titanium Grade 5'), findsOneWidget);
    expect(find.text('49mm Cellular'), findsOneWidget);
    expect(find.byIcon(Icons.rotate_right_rounded), findsOneWidget);

    // 3. Verify Breadcrumbs
    expect(find.text('Wearables'), findsOneWidget);
    expect(find.text('Watches'), findsOneWidget);
    expect(find.text('Chronos Series'), findsOneWidget);

    // 4. Verify Headline & Rating
    expect(find.text('Chronos Ultra 2'), findsOneWidget);
    expect(find.text('4.9'), findsOneWidget);
    expect(find.text('(420 reviews)'), findsOneWidget);
    expect(find.text('98% recommendation'), findsOneWidget);

    // 5. Verify Pricing Card
    expect(find.text('₹40,506.18'), findsOneWidget);
    expect(find.text('₹45,227.18'), findsOneWidget);
    expect(find.text('SAVE ₹4,721'), findsOneWidget);
    expect(find.textContaining('or ₹3,375.51/mo with 0% APR across 12 months'), findsOneWidget);
    expect(find.text('In Stock — SF 94103 2-hr delivery available'), findsOneWidget);

    // 6. Verify Case Finish Selector
    expect(find.text('Case Finish'), findsOneWidget);
    expect(find.text('Natural'), findsOneWidget);
    expect(find.text('Space Black'), findsOneWidget);
    expect(find.text('Starlight'), findsOneWidget);

    // 7. Verify Band Style & Fit
    expect(find.text('Band Style & Fit'), findsOneWidget);
    expect(find.text('Size Guide'), findsOneWidget);
    expect(find.text('Midnight Ocean Band — 49mm'), findsOneWidget);
    expect(find.text('High-performance elastomer for water sports'), findsOneWidget);
    expect(find.text('Alpine Loop — Orange 49mm'), findsOneWidget);
    expect(find.text('Seamless dual-layer weave with titanium G-hook'), findsOneWidget);
    expect(find.text('Trail Loop — Grey 49mm'), findsOneWidget);
    expect(find.text('Ultra-thin lightweight textile tab for runners'), findsOneWidget);

    // 8. Verify Specifications Matrix
    expect(find.text('SPECIFICATIONS MATRIX'), findsOneWidget);
    expect(find.text('BATTERY'), findsOneWidget);
    expect(find.text('Up to 72 hrs Low Power'), findsOneWidget);
    expect(find.text('WATER DEPTH'), findsOneWidget);
    expect(find.text('100m ISO 22810 Rated'), findsOneWidget);
    expect(find.text('RETINA DISPLAY'), findsOneWidget);
    expect(find.text('3,000 Nits Always-On'), findsOneWidget);
    expect(find.text('DIAGNOSTICS'), findsOneWidget);
    expect(find.text('Dual-Freq GPS & ECG'), findsOneWidget);

    // 9. Verify TechKart AI Fitment Advisor
    expect(find.text('TechKart AI Fitment Advisor'), findsOneWidget);
    expect(find.textContaining('Unsure about wrist drape or band swapping?'), findsOneWidget);
    expect(find.text('Check Wrist Size'), findsOneWidget);

    // 10. Verify Assurance Tiles
    expect(find.text('Free Priority Shipping'), findsOneWidget);
    expect(find.text('Arrives tomorrow, 2:00 PM to SF 94103'), findsOneWidget);
    expect(find.text('2-Year Titanium Care Guarantee'), findsOneWidget);
    expect(find.text('Hassle-free coverage & 30-day trial returns'), findsOneWidget);

    // 11. Verify Sticky Bottom Checkout Bar
    expect(find.text('TOTAL PRICE'), findsOneWidget);
    expect(find.text('₹84,883.58'), findsOneWidget);
    expect(find.text('Add to Cart'), findsOneWidget);

    // 12. Test Interactions:
    // Toggle Favorite
    await tester.tap(find.byIcon(Icons.favorite_border_rounded));
    await tester.pump();
    expect(find.byIcon(Icons.favorite_rounded), findsOneWidget);

    // Select Case Finish: Space Black
    await tester.ensureVisible(find.text('Space Black'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Space Black'));
    await tester.pumpAndSettle();
    expect(find.text('Space Black'), findsWidgets);

    // Tap Add to Cart
    await tester.tap(find.text('Add to Cart'));
    await tester.pump();
    expect(find.textContaining('Added Chronos Ultra 2 (Space Black) to Cart'), findsOneWidget);
  });

  testWidgets('ProductGalleryScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductGalleryScreen(),
      ),
    );

    // 1. Verify Top Navigation Bar
    expect(find.byIcon(Icons.chevron_left_rounded), findsOneWidget);
    expect(find.text('Chronos Ultra 2'), findsOneWidget);
    expect(find.text('1 / 4'), findsOneWidget);
    expect(find.byIcon(Icons.ios_share_rounded), findsOneWidget);
    expect(find.byIcon(Icons.crop_free_rounded), findsOneWidget);

    // 2. Verify Top Spec Pills
    expect(find.text('Grade 5 Titanium • 49mm'), findsOneWidget);
    expect(find.text('Sapphire Crystal'), findsOneWidget);

    // 3. Verify Hero Canvas Controls & Badges
    expect(find.byIcon(Icons.add), findsOneWidget);
    expect(find.text('1X'), findsOneWidget);
    expect(find.byIcon(Icons.remove), findsOneWidget);
    expect(find.text('Pinch or double-tap to inspect finish'), findsOneWidget);
    expect(find.text('1.0x'), findsOneWidget);

    // 4. Verify Perspective & Macro 4K badge
    expect(find.text('Perspective: Isometric bezel & crown profile'), findsOneWidget);
    expect(find.byIcon(Icons.verified_outlined), findsOneWidget);
    expect(find.text('MACRO'), findsOneWidget);
    expect(find.text('4K'), findsOneWidget);

    // 5. Verify Feature Info Banner
    expect(find.text('3000 Nit OLED Display'), findsOneWidget);
    expect(find.text('Edge-to-edge sapphire crystal shield'), findsOneWidget);
    expect(find.text('100M DIVE'), findsOneWidget);

    // 6. Verify Bottom Checkout Card
    expect(find.text('In Stock • Ships Tomorrow'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);
    expect(find.text('₹47,115.58'), findsOneWidget);
    expect(find.text('Add to Bag'), findsOneWidget);

    // 7. Test Zoom In Interaction
    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();
    expect(find.text('1.5x'), findsOneWidget);

    // 8. Test Thumbnail Selection (Switching to Crown Profile)
    final secondThumbnailFinder = find.byWidgetPredicate((widget) {
      if (widget is Image && widget.image is AssetImage) {
        return (widget.image as AssetImage).assetName == 'asset/chronos_side_angle.jpg';
      }
      return false;
    });
    await tester.ensureVisible(secondThumbnailFinder);
    await tester.pumpAndSettle();
    await tester.tap(secondThumbnailFinder);
    await tester.pumpAndSettle();
    expect(find.text('2 / 4'), findsOneWidget);
    expect(find.text('Perspective: Crown & action button profile'), findsOneWidget);
    expect(find.text('Titanium Digital Crown'), findsOneWidget);
    expect(find.text('PRECISION'), findsOneWidget);

    // 9. Test Add to Bag interaction
    await tester.ensureVisible(find.text('Add to Bag'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Add to Bag'));
    await tester.pump();
    expect(find.text('Added Chronos Ultra 2 to your Bag'), findsOneWidget);
  });

  testWidgets('ProductSpecificationsScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: ProductSpecificationsScreen(),
      ),
    );

    // 1. Verify Top Header
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('Product ...'), findsOneWidget);
    expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Search Bar
    expect(find.text('Filter specs (e.g., nits, GPS, battery)...'), findsOneWidget);

    // 3. Verify Category Filter Chips
    expect(find.text('Overview'), findsOneWidget);
    expect(find.text('Display & Case'), findsOneWidget);
    expect(find.text('Sensors & Health'), findsOneWidget);
    expect(find.text('Power'), findsOneWidget);
    expect(find.text('Connectivity'), findsOneWidget);
    expect(find.text('Materials'), findsOneWidget);

    // 4. Verify Product Mini Card
    expect(find.text('Chronos Ultra 2'), findsOneWidget);
    expect(find.text('SPECS'), findsOneWidget);
    expect(find.text('Grade 5 Titanium • 49mm Cellular'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);
    expect(find.text('In Stock • Model A2986'), findsOneWidget);

    // 5. Verify Highlight Metric Cards
    expect(find.text('PEAK BRIGHTNESS'), findsOneWidget);
    expect(find.text('3,000'), findsOneWidget);
    expect(find.text('nits'), findsOneWidget);
    expect(find.text('1 nit minimum in dark mode'), findsOneWidget);
    expect(find.text('WATER RATING'), findsOneWidget);
    expect(find.text('100m'), findsOneWidget);
    expect(find.text('ISO 22810'), findsOneWidget);
    expect(find.text('40m dive certified EN13319'), findsOneWidget);

    // 6. Verify Structured Specifications Sections
    expect(find.text('CASE & DIMENSIONS'), findsOneWidget);
    expect(find.text('49mm × 44mm × 14.4mm'), findsOneWidget);
    expect(find.text('DISPLAY & OPTICS'), findsOneWidget);
    expect(find.text('Always-On Retina LTPO OLED'), findsOneWidget);
    expect(find.text('HEALTH & BIO-TELEMETRY'), findsOneWidget);
    expect(find.text('POWER & ENDURANCE'), findsOneWidget);
    expect(find.text('CONNECTIVITY & AUDIO'), findsOneWidget);
    expect(find.text('MATERIALS & RESISTANCE'), findsOneWidget);

    // 7. Verify What's in the Box
    expect(find.text("What's in the Box"), findsOneWidget);
    expect(find.text('4 ITEMS INCLUDED'), findsOneWidget);
    expect(find.text('Chronos Ultra 2 Grade 5 Titanium Case'), findsOneWidget);
    expect(find.text('Midnight Ocean Band (49mm matching titanium buckle)'), findsOneWidget);
    expect(find.text('Magnetic Fast Charging USB-C Cable (1m braided)'), findsOneWidget);
    expect(find.text('Quick Start Guide & 2-Year International Warranty'), findsOneWidget);

    // 8. Verify Regulatory Disclaimer
    expect(find.textContaining('Chronos Ultra 2 is tested under controlled laboratory conditions'), findsOneWidget);

    // 9. Verify Bottom Sticky Bar
    expect(find.text('TOTAL PRICE'), findsOneWidget);
    expect(find.text('₹84,883.58'), findsOneWidget);
    expect(find.text('Add to Cart'), findsOneWidget);

    // 10. Test Search Filtering
    await tester.enterText(find.byType(TextField), 'GPS');
    await tester.pump();
    expect(find.text('CONNECTIVITY & AUDIO'), findsOneWidget);
    expect(find.textContaining('Precision dual-frequency GPS'), findsOneWidget);
    // CASE & DIMENSIONS should be filtered out
    expect(find.text('CASE & DIMENSIONS'), findsNothing);

    // Clear Search Field
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    expect(find.text('CASE & DIMENSIONS'), findsOneWidget);

    // 11. Test Add to Cart Interaction
    await tester.tap(find.text('Add to Cart'));
    await tester.pump();
    expect(find.text('Added Chronos Ultra 2 to Cart'), findsOneWidget);
  });

  testWidgets('CustomerReviewsScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: CustomerReviewsScreen(),
      ),
    );

    // 1. Verify Top Header
    expect(find.byIcon(Icons.arrow_back_rounded), findsOneWidget);
    expect(find.text('Cust...'), findsOneWidget);
    expect(find.byIcon(Icons.search_rounded), findsOneWidget);
    expect(find.byIcon(Icons.share_outlined), findsOneWidget);
    expect(find.byIcon(Icons.favorite_border_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Product Mini Header Card
    expect(find.text('Chronos Ultra 2'), findsOneWidget);
    expect(find.text('Grade 5 Titanium • 49mm Cellular'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);

    // 3. Verify Rating & Breakdown Overview Card
    expect(find.text('4.9'), findsOneWidget);
    expect(find.text('/ 5.0'), findsOneWidget);
    expect(find.text('Based on 420 verified reviews'), findsOneWidget);
    expect(find.text('98% recommend this product'), findsOneWidget);
    expect(find.text('370'), findsOneWidget);
    expect(find.text('34'), findsOneWidget);
    expect(find.text('11'), findsOneWidget);
    expect(find.text('3'), findsWidgets);
    expect(find.text('2'), findsWidgets);

    // 4. Verify Filters Rail
    expect(find.text('Sort: Most Relevant'), findsOneWidget);
    expect(find.text('Verified Only'), findsOneWidget);
    expect(find.text('With Photos (48)'), findsOneWidget);

    // 5. Verify Customer Review Cards
    expect(find.text('Marcus R.'), findsOneWidget);
    expect(find.text('Unrivaled build quality and extreme GPS accuracy'), findsOneWidget);
    expect(find.textContaining('Upgraded from the Series 7'), findsOneWidget);
    expect(find.text('Helpful (34)'), findsOneWidget);

    expect(find.text('Elena L.'), findsOneWidget);
    expect(find.text('Surprisingly lightweight for aerospace titanium'), findsOneWidget);
    expect(find.text('Helpful (19)'), findsOneWidget);

    expect(find.text('David K.'), findsOneWidget);
    expect(find.text('Phenomenal hardware, companion app syncing is fast'), findsOneWidget);
    expect(find.text('Helpful (8)'), findsOneWidget);

    // 6. Verify Bottom Action Bar
    expect(find.text('Have this product?'), findsOneWidget);
    expect(find.text('Share your experience'), findsOneWidget);
    expect(find.text('Write a Review'), findsOneWidget);

    // 7. Test Helpful Upvote
    await tester.ensureVisible(find.text('Helpful (34)'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Helpful (34)'));
    await tester.pump();
    expect(find.text('Helpful (35)'), findsOneWidget);

    // 8. Test Write a Review Navigation
    await tester.tap(find.text('Write a Review'));
    await tester.pumpAndSettle();
    expect(find.byType(WriteReviewsScreen), findsOneWidget);
    expect(find.text('Write A Review'), findsOneWidget);
    expect(find.text('Verified Purchase'), findsOneWidget);
  });

  testWidgets('WriteReviewsScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: WriteReviewsScreen(),
      ),
    );

    // 1. Verify Top Header
    expect(find.byIcon(Icons.close_rounded), findsWidgets);
    expect(find.text('Write A Review'), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Verified Product Banner
    expect(find.text('Verified Purchase'), findsOneWidget);
    expect(find.text('Chronos Ultra 2'), findsOneWidget);
    expect(find.text('Grade 5 Titanium • 49mm Cellular • ₹40,506.18'), findsOneWidget);

    // 3. Verify Star Rating Card
    expect(find.text('How would you rate this product?'), findsOneWidget);
    expect(find.text('Tap a star to rate your experience'), findsOneWidget);
    expect(find.text('5.0 — Exceptional'), findsOneWidget);

    // 4. Verify WHAT STOOD OUT? tags
    expect(find.text('WHAT STOOD OUT?'), findsOneWidget);
    expect(find.text('Build Quality'), findsOneWidget);
    expect(find.text('Battery Life'), findsOneWidget);
    expect(find.text('Screen Brightness'), findsOneWidget);
    expect(find.text('Accurate GPS'), findsOneWidget);
    expect(find.text('Comfortable Band'), findsOneWidget);

    // 5. Verify Review Title and Body Fields
    expect(find.text('Review Title'), findsOneWidget);
    expect(find.text('Required'), findsOneWidget);
    expect(find.text("Best titanium smartwatch I've owned"), findsOneWidget);

    expect(find.text('Your Review'), findsOneWidget);
    expect(find.text('Min. 20 characters'), findsOneWidget);
    expect(find.textContaining('The lightweight feel of the Grade 5 titanium chassis'), findsOneWidget);
    expect(find.textContaining('/ 500'), findsOneWidget);

    // 6. Verify Add Photos Section
    expect(find.text('Add Photos (Optional)'), findsOneWidget);
    expect(find.text('Share real shots of wrist fit, finishes, or unboxing (up to 4)'), findsOneWidget);
    expect(find.text('Add'), findsOneWidget);
    expect(find.byIcon(Icons.add_a_photo_outlined), findsOneWidget);

    // 7. Verify Would you recommend this item?
    expect(find.text('Would you recommend this item?'), findsOneWidget);
    expect(find.text('Helps other verified buyers make choices'), findsOneWidget);
    expect(find.text('Yes'), findsOneWidget);
    expect(find.text('No'), findsOneWidget);

    // 8. Verify Submit Review Button & Disclaimer
    expect(find.text('Submit Review'), findsOneWidget);
    expect(find.text('Reviews are moderated under TechKart Community Guidelines'), findsOneWidget);

    // 9. Test Interactions:
    // Toggle a tag
    await tester.tap(find.text('Screen Brightness'));
    await tester.pump();

    // Toggle recommendation to No
    await tester.ensureVisible(find.text('No'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('No'));
    await tester.pump();

    // Tap Submit Review
    await tester.ensureVisible(find.text('Submit Review'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Submit Review'));
    await tester.pump();
    expect(find.textContaining('Review submitted successfully!'), findsOneWidget);
  });

  testWidgets('AiVisualSearchCameraScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    await tester.pumpWidget(
      const MaterialApp(
        home: AiVisualSearchCameraScreen(),
      ),
    );

    // 1. Verify Top Header
    expect(find.text('TechKart'), findsWidgets);
    expect(find.textContaining('94103 • SF'), findsOneWidget);
    expect(find.byIcon(Icons.notifications_none_rounded), findsOneWidget);
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Top Camera Controls
    expect(find.byIcon(Icons.flash_auto_rounded), findsOneWidget);
    expect(find.text('Object AI'), findsOneWidget);
    expect(find.text('Barcode'), findsOneWidget);
    expect(find.byIcon(Icons.history_rounded), findsOneWidget);

    // 3. Verify Instruction Pill
    expect(find.text('Point at gadget, connector, or box'), findsOneWidget);

    // 4. Verify AI Reticle Readouts
    expect(find.text('Smartwatch'), findsOneWidget);
    expect(find.text('98% match'), findsOneWidget);
    expect(find.text('SCR-19'), findsOneWidget);
    expect(find.text('10:09 AM  92%  85°F'), findsOneWidget);
    expect(find.text('SEARCHING...'), findsOneWidget);
    expect(find.text('Titanium 46mm GPS'), findsOneWidget);
    expect(find.text('₹28,231.58'), findsOneWidget);

    // 5. Verify Quick Action Pills
    expect(find.text('Identify\nSpecs'), findsOneWidget);
    expect(find.text('Compare\nPrice'), findsOneWidget);
    expect(find.text('Cable\nMatch'), findsOneWidget);

    // 6. Verify Shutter Controls
    expect(find.text('Gallery'), findsOneWidget);
    expect(find.byIcon(Icons.auto_awesome), findsWidgets);
    expect(find.text('1x Optical'), findsOneWidget);

    // 7. Verify AI Sensor Banner
    expect(find.text('Tap shutter to analyze internal components & best deals'), findsOneWidget);

    // 8. Verify Bottom Navigation Tabs
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('AI Search'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // 9. Test Interactions:
    // Switch Mode to Barcode
    await tester.tap(find.text('Barcode'));
    await tester.pump();

    // Toggle Optical Zoom
    await tester.tap(find.text('1x Optical'));
    await tester.pump();
    expect(find.text('2x Optical'), findsOneWidget);

    // Tap Shutter Button to trigger recognition bottom sheet
    await tester.tap(find.byIcon(Icons.auto_awesome).first);
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Chronos Titanium 46mm GPS'), findsWidgets);
    expect(find.text('Inspect Full Specifications Matrix'), findsOneWidget);

    // Close bottom sheet
    await tester.tap(find.text('Inspect Full Specifications Matrix'), warnIfMissed: false);
    await tester.pump(const Duration(milliseconds: 500));
  });

  testWidgets('AiImageProcessingScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    bool closed = false;
    bool retakeTriggered = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AiImageProcessingScreen(
          onClose: () => closed = true,
          onRetakePhoto: () => retakeTriggered = true,
        ),
      ),
    );

    // Initial pump to let animations schedule
    await tester.pump(const Duration(milliseconds: 100));

    // 1. Verify Top Bar Elements
    expect(find.byIcon(Icons.close_rounded), findsOneWidget);
    expect(find.text('VISUAL SEARCH'), findsOneWidget);

    // 2. Verify Hardware Preview Card Badges & Reticles
    expect(find.text('Analyzing'), findsOneWidget);
    expect(find.text('98.4% FRAME LOCK'), findsOneWidget);

    // 3. Verify Editorial Heading and Description
    expect(find.text('Identifying Hardware'), findsOneWidget);
    expect(
      find.text('Cross-referencing telemetry with 45,000+ certified smart devices, components, and live stock.'),
      findsOneWidget,
    );

    // 4. Verify 3 Detection Feature Pills
    expect(find.text('Wearable Detected'), findsOneWidget);
    expect(find.text('Titanium Chassis • Round Bezel'), findsOneWidget);
    expect(find.text('Digital Crown Calibrated'), findsOneWidget);

    // 5. Verify Action Button and Footer Tip
    expect(find.text('Retake Photo'), findsOneWidget);
    expect(find.byIcon(Icons.refresh_rounded), findsOneWidget);
    expect(
      find.text('Keep device in centered, bright ambient lighting for instant match.'),
      findsOneWidget,
    );

    // 6. Test Interactions:
    // Tap Preview Card to trigger telemetry diagnostics sheet
    await tester.tap(find.text('98.4% FRAME LOCK'));
    await tester.pump(const Duration(milliseconds: 500));
    expect(find.text('Neural Telemetry Stream'), findsOneWidget);
    expect(find.text('Chronos Ultra Titanium 46mm'), findsOneWidget);
    expect(find.text('Dismiss Diagnostics'), findsOneWidget);

    // Close Diagnostics Sheet
    Navigator.of(tester.element(find.text('Dismiss Diagnostics'))).pop();
    await tester.pump(const Duration(milliseconds: 400));

    // Tap Retake Photo Button
    final retakeFinder = find.text('Retake Photo');
    await tester.ensureVisible(retakeFinder);
    await tester.pump(const Duration(milliseconds: 100));
    await tester.tap(retakeFinder);
    await tester.pump();
    expect(retakeTriggered, isTrue);

    // Tap Close Button
    await tester.tap(find.byIcon(Icons.close_rounded));
    await tester.pump();
    expect(closed, isTrue);
  });

  testWidgets('VisualSearchResultsScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    bool backPressed = false;
    bool retakePressed = false;
    String? selectedProduct;

    await tester.pumpWidget(
      MaterialApp(
        home: VisualSearchResultsScreen(
          onBack: () => backPressed = true,
          onRetake: () => retakePressed = true,
          onProductSelected: (p) => selectedProduct = p,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Top Bar
    expect(find.text('Visual Search Results'), findsOneWidget);
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsOneWidget);

    // 2. Verify Visual Query Detected Card
    expect(find.text('VISUAL QUERY DETECTED'), findsOneWidget);
    expect(find.text('Titanium Smartwatch'), findsOneWidget);
    expect(find.text('98% Exact Match'), findsOneWidget);
    expect(find.text('Retake'), findsOneWidget);

    // 3. Verify Filter Tabs
    expect(find.text('Exact Match  (3)'), findsOneWidget);
    expect(find.text('Compatible Bands  (12)'), findsOneWidget);

    // 4. Verify Hero Match Card (Chronos Ultra 2)
    expect(find.text('99% Match • Best Price'), findsOneWidget);
    expect(find.text('Chronos Ultra 2'), findsOneWidget);
    expect(find.text('49mm Cellular • Grade 5 Titanium'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);
    expect(find.text('View Details'), findsOneWidget);

    // 5. Verify Section Header
    expect(find.text('MATCHED DEVICES & GEAR'), findsOneWidget);
    expect(find.text('Real-Time Catalog'), findsOneWidget);

    // 6. Verify 2x2 Product Grid Items
    expect(find.text('Chronos Active Pro'), findsOneWidget);
    expect(find.text('Aura Fold Pro & Pods'), findsOneWidget);

    // 7. Verify Refine Banner
    expect(find.text('Not the right match?'), findsOneWidget);
    expect(find.text('Refine with text query or adjust crop box'), findsOneWidget);
    expect(find.text('Refine'), findsOneWidget);

    // 8. Test Interactions:
    // Switch filter tab
    await tester.tap(find.text('Compatible Bands  (12)'));
    await tester.pumpAndSettle();

    // Tap Hero View Details Button
    await tester.tap(find.text('View Details'));
    await tester.pumpAndSettle();
    expect(selectedProduct, 'Chronos Ultra 2');

    // Tap Retake
    await tester.tap(find.text('Retake'));
    await tester.pumpAndSettle();
    expect(retakePressed, isTrue);

    // Tap Quick Add (+) Button on first grid product
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();
    expect(find.text('3'), findsWidgets); // Cart count incremented from 2 to 3

    // Open Refine modal sheet
    await tester.tap(find.byIcon(Icons.tune_rounded));
    await tester.pumpAndSettle();
    expect(find.text('Refine Visual Match'), findsOneWidget);
    expect(find.text('Apply Visual Filter'), findsOneWidget);

    // Close Refine modal
    Navigator.of(tester.element(find.text('Apply Visual Filter'))).pop();
    await tester.pumpAndSettle();

    // Tap Back Button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('ConversationalShoppingAssistantScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(430, 932);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() => tester.view.resetPhysicalSize());
    addTearDown(() => tester.view.resetDevicePixelRatio());

    bool backPressed = false;
    bool bundleAdded = false;
    String? selectedProduct;

    await tester.pumpWidget(
      MaterialApp(
        home: ConversationalShoppingAssistantScreen(
          onBack: () => backPressed = true,
          onBundleAdded: () => bundleAdded = true,
          onProductSelected: (p) => selectedProduct = p,
        ),
      ),
    );

    await tester.pumpAndSettle();

    // 1. Verify Top App Bar & Specialist Header
    expect(find.text('AI Shopping Assistant'), findsOneWidget);
    expect(find.text('TechKart Specialist'), findsOneWidget);
    expect(find.text('AI VERIFIED'), findsOneWidget);
    expect(find.text('• Online • Live Specs & Inventory'), findsOneWidget);

    // 2. Verify Session Date Pill
    expect(find.text('Today • Hardware Advisory Session'), findsOneWidget);

    // 3. Verify Message 1 (AI Greeting)
    expect(find.text('Welcome to TechKart Advisory'), findsOneWidget);
    expect(
      find.text('I review dual-channel benchmarks, durability tiers, and live warehouse inventory. Share your target budget, terrain demands, or specific gear pairings.'),
      findsOneWidget,
    );

    // 4. Verify Message 2 (User Query)
    expect(
      find.text('Looking for an ultra-durable titanium smartwatch for trail workouts, plus a 65W GaN dual fast charger under ₹47,210 total.'),
      findsOneWidget,
    );

    // 5. Verify Message 3 (AI Recommendation Cards & Bundle)
    expect(find.text('Chronos Ultra 2 (49mm ...'), findsOneWidget);
    expect(find.text('VoltFast 65W GaN Dual ...'), findsOneWidget);
    expect(find.text('Curated Bundle Total'), findsOneWidget);
    expect(find.text('₹44,188.56'), findsOneWidget);

    // 6. Verify Quick Action Suggestion Pills
    expect(find.text('Compare battery life'), findsOneWidget);
    expect(find.text('Check trail GPS accuracy'), findsOneWidget);
    expect(find.text('Add Bundle to Cart'), findsOneWidget);

    // 7. Verify Chat Input Bar & Disclaimer
    expect(find.text('Ask about specs, compatibility, deals...'), findsOneWidget);
    expect(
      find.text('TechKart AI verifies authentic local warranty & live Dhaka stock.'),
      findsOneWidget,
    );

    // 8. Test Interactions:
    // Open Specs Modal on Chronos Ultra 2
    final specsFinder = find.text('Specs');
    await tester.ensureVisible(specsFinder);
    await tester.pumpAndSettle();
    await tester.tap(specsFinder);
    await tester.pumpAndSettle();
    expect(find.text('Chronos Ultra 2 Matrix'), findsOneWidget);
    expect(find.text('Close Specifications'), findsOneWidget);

    // Dismiss Specs Modal
    await tester.tap(find.text('Close Specifications'));
    await tester.pumpAndSettle();

    // Tap View Product on first card
    final viewProductFinder = find.text('View Product').first;
    await tester.ensureVisible(viewProductFinder);
    await tester.pumpAndSettle();
    await tester.tap(viewProductFinder);
    await tester.pumpAndSettle();
    expect(selectedProduct, 'Chronos Ultra 2 (49mm Titanium GPS)');

    // Tap Add Bundle to Cart pill
    final addBundleFinder = find.text('Add Bundle to Cart');
    await tester.ensureVisible(addBundleFinder);
    await tester.pumpAndSettle();
    await tester.tap(addBundleFinder);
    await tester.pumpAndSettle();
    expect(bundleAdded, isTrue);

    // Type and send a chat message
    await tester.enterText(find.byType(TextField), 'Is express delivery free?');
    await tester.testTextInput.receiveAction(TextInputAction.send);
    await tester.pumpAndSettle();
    expect(find.text('Is express delivery free?'), findsOneWidget);

    // Tap Back Arrow
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('AiChatSessionsScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    // Set a large phone surface size to ensure all items are visible and render cleanly
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool newChatPressed = false;
    bool manageMemoryPressed = false;
    String? selectedSessionId;

    await tester.pumpWidget(
      MaterialApp(
        home: AiChatSessionsScreen(
          onBack: () => backPressed = true,
          onNewChat: () => newChatPressed = true,
          onManageMemory: () => manageMemoryPressed = true,
          onSessionSelected: (id) => selectedSessionId = id,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top Bar Elements
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('AI Chat Sessions'), findsOneWidget);
    expect(find.byIcon(Icons.tune_rounded), findsWidgets); // top bar filter & badges
    expect(find.byIcon(Icons.shopping_bag_outlined), findsWidgets); // top bar cart & nav cart

    // 2. Verify Header & New Chat button
    expect(find.text('Archived Intelligence'), findsOneWidget);
    expect(find.text('Chat Sessions'), findsOneWidget);
    expect(find.text('New Chat'), findsOneWidget);

    // 3. Verify Search Bar
    expect(find.text('Search conversations...'), findsOneWidget);

    // 4. Verify Category Filter Tabs
    expect(find.text('All Sessions'), findsOneWidget);
    expect(find.text('Recommendations'), findsOneWidget);
    expect(find.text('Spec Checks'), findsOneWidget);

    // 5. Verify Chronological Group Headers
    expect(find.text('RECENT'), findsOneWidget);
    expect(find.text('LAST 7 DAYS'), findsOneWidget);
    expect(find.text('PREVIOUS MONTH'), findsOneWidget);

    // 6. Verify Session Items
    expect(find.text('Titanium Smartwatch ...'), findsOneWidget);
    expect(find.text('AI Concierge Summary ready'), findsOneWidget);

    expect(find.text('Foldable Phone vs Compact ...'), findsOneWidget);
    expect(find.text('Comparison table exported'), findsOneWidget);

    expect(find.text('Mechanical Wireless Keyboard ...'), findsOneWidget);
    expect(find.text('Filter: Hot-swappable'), findsOneWidget);

    expect(find.text('ANC Noise Cancelling Studio H...'), findsOneWidget);
    expect(find.text('Fast Delivery Verified'), findsOneWidget);

    expect(find.text('MagSafe 3-in-1 Charging Stan...'), findsOneWidget);
    expect(find.text('Compatibility Confirmed'), findsOneWidget);

    expect(find.text('বাংলা পরামর্শ — বাজেট গেমিং ল্যাপটপ'), findsOneWidget);
    expect(find.text('Multilingual Engine (Bangla)'), findsOneWidget);

    // 7. Verify Personalized Hardware Memory Banner
    expect(find.text('Personalized Hardware Memory'), findsOneWidget);
    expect(find.text('Preferences saved across your sessions'), findsOneWidget);
    expect(find.text('Manage'), findsOneWidget);

    // 8. Interaction Testing:
    // Tap "New Chat"
    await tester.tap(find.text('New Chat'));
    await tester.pumpAndSettle();
    expect(newChatPressed, isTrue);

    // Tap "Manage" button in Hardware Memory banner
    final manageFinder = find.text('Manage');
    await tester.ensureVisible(manageFinder);
    await tester.pumpAndSettle();
    await tester.tap(manageFinder);
    await tester.pumpAndSettle();
    expect(manageMemoryPressed, isTrue);
    expect(find.text('Hardware Memory Cache'), findsOneWidget);
    expect(find.text('Save Preferences'), findsOneWidget);

    // Close Manage sheet
    await tester.tap(find.text('Save Preferences'));
    await tester.pumpAndSettle();
    expect(find.text('Hardware Memory Cache'), findsNothing);

    // Filter switching: Tap "Recommendations" tab
    final recTabFinder = find.text('Recommendations');
    await tester.ensureVisible(recTabFinder);
    await tester.pumpAndSettle();
    await tester.tap(recTabFinder);
    await tester.pumpAndSettle();

    // Verify Recommendations filtered content:
    expect(find.text('Titanium Smartwatch ...'), findsOneWidget);
    expect(find.text('ANC Noise Cancelling Studio H...'), findsOneWidget);
    expect(find.text('Foldable Phone vs Compact ...'), findsNothing);

    // Switch back to "All Sessions"
    await tester.tap(find.text('All Sessions'));
    await tester.pumpAndSettle();
    expect(find.text('Foldable Phone vs Compact ...'), findsOneWidget);

    // Search query filtering
    await tester.enterText(find.byType(TextField), 'Mechanical');
    await tester.pumpAndSettle();
    expect(find.text('Mechanical Wireless Keyboard ...'), findsOneWidget);
    expect(find.text('Titanium Smartwatch ...'), findsNothing);

    // Clear search query
    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();
    expect(find.text('Titanium Smartwatch ...'), findsOneWidget);

    // Tap card to select session
    final cardFinder = find.text('Titanium Smartwatch ...');
    await tester.ensureVisible(cardFinder);
    await tester.pumpAndSettle();
    await tester.tap(cardFinder);
    await tester.pumpAndSettle();
    expect(selectedSessionId, 'Titanium Smartwatch for Trail Workouts');

    // Tap 3-dots popup sheet
    final moreIconFinder = find.byIcon(Icons.more_vert_rounded).first;
    await tester.ensureVisible(moreIconFinder);
    await tester.pumpAndSettle();
    await tester.tap(moreIconFinder);
    await tester.pumpAndSettle();
    expect(find.text('Pin Session to Top'), findsOneWidget);
    expect(find.text('Export Advisory Summary'), findsOneWidget);
    expect(find.text('Delete Session History'), findsOneWidget);

    // Tap Export Advisory Summary to dismiss
    await tester.tap(find.text('Export Advisory Summary'));
    await tester.pumpAndSettle();
    expect(find.text('Export Advisory Summary'), findsNothing);

    // Tap Back Arrow
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('WishlistScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    // Set a large phone surface size to ensure all items are visible and render cleanly
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool searchPressed = false;
    bool cartPressed = false;
    bool profilePressed = false;
    bool addAllToCartPressed = false;
    bool consultAiPressed = false;
    String? selectedProductId;
    String? movedToCartId;

    await tester.pumpWidget(
      MaterialApp(
        home: WishlistScreen(
          onBack: () => backPressed = true,
          onSearch: () => searchPressed = true,
          onCartPressed: () => cartPressed = true,
          onProfilePressed: () => profilePressed = true,
          onAddAllToCart: () => addAllToCartPressed = true,
          onConsultAi: () => consultAiPressed = true,
          onProductSelected: (id) => selectedProductId = id,
          onMoveToCart: (id) => movedToCartId = id,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsWidgets); // top bar + move to cart + bottom nav
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Curated Selection Header
    expect(find.text('CURATED SELECTION'), findsOneWidget);
    expect(find.text('My Saved Items'), findsOneWidget);
    expect(find.text('4 items saved'), findsOneWidget);

    // 3. Verify Action Buttons
    expect(find.text('Add All to Cart'), findsOneWidget);
    expect(find.text('Sort & Filter'), findsOneWidget);

    // 4. Verify Category Filter Tabs
    expect(find.text('All (4)'), findsOneWidget);
    expect(find.text('In Stock (3)'), findsOneWidget);
    expect(find.text('Price Drop (2)'), findsOneWidget);
    expect(find.text('Wearables (1)'), findsOneWidget);

    // 5. Verify Wishlist Items
    // Item 1: Chronos Ultra 2
    expect(find.text('Chronos Ultra 2 (49mm...'), findsOneWidget);
    expect(find.text('Titanium Smartwatch • LTPO'), findsOneWidget);
    expect(find.text('In Stock (3 units left)'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);
    expect(find.text('₹47,115.58'), findsOneWidget);
    expect(find.text('Grade 5 Titanium • 3000 Nit LTPO'), findsOneWidget);
    expect(find.text('Price dropped by ₹6,609.40 since saved'), findsOneWidget);

    // Item 2: VoltFast 65W GaN Dual
    expect(find.text('VoltFast 65W GaN Dual...'), findsOneWidget);
    expect(find.text('Ultra-compact • 45W+20W split'), findsOneWidget);
    expect(find.text('In Stock'), findsWidgets);
    expect(find.text('₹4,626.58'), findsOneWidget);
    expect(find.text('Dual charging • Foldable pins'), findsOneWidget);
    expect(find.text('Next-day dispatch'), findsOneWidget);

    // Item 3: KeyChron Pro Wireless
    expect(find.text('KeyChron Pro Wireless...'), findsOneWidget);
    expect(find.text('Hot-swappable tactile • Mac/Win'), findsOneWidget);
    expect(find.text('Low Stock'), findsOneWidget);
    expect(find.text('₹11,235.98'), findsOneWidget);
    expect(find.text('₹13,124.38'), findsOneWidget);
    expect(find.text('RGB Backlit • Bluetooth 5.1'), findsOneWidget);
    expect(find.text('Price drop (₹1,888.40 saved)'), findsOneWidget);
    expect(find.text('Only 2 left'), findsOneWidget);

    // Item 4: Aura Fold Pro Smartphone
    expect(find.text('Aura Fold Pro Smartphone'), findsOneWidget);
    expect(find.text('7.9" Foldable OLED • 512GB'), findsOneWidget);
    expect(find.text('₹1,41,535.58'), findsOneWidget);
    expect(find.text('Titanium Grey • 120Hz LTPO'), findsOneWidget);
    expect(find.text('TechKart Verified Care Included'), findsOneWidget);

    // Move to Cart buttons & Heart toggle buttons
    expect(find.text('Move to Cart'), findsNWidgets(4));
    expect(find.byIcon(Icons.favorite_border_rounded), findsNWidgets(4));

    // 6. Verify "Looking for more?" AI Advisory Card
    expect(find.text('Looking for more?'), findsOneWidget);
    expect(
      find.text('Ask TechKart AI to find matching accessories, cables, or bundled offers for your saved gear.'),
      findsOneWidget,
    );
    expect(find.text('Consult TechKart AI'), findsOneWidget);

    // 7. Verify Bottom Navigation Bar
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('AI Search'), findsOneWidget);
    expect(find.text('Cart'), findsWidgets);
    expect(find.text('Profile'), findsOneWidget);

    // 8. Interaction Testing:
    // Tap Top Bar icons
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(searchPressed, isTrue);

    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(profilePressed, isTrue);

    await tester.tap(find.byKey(const Key('wishlist_cart_button')));
    await tester.pumpAndSettle();
    expect(cartPressed, isTrue);

    // Tap "Sort & Filter" button
    await tester.tap(find.text('Sort & Filter'));
    await tester.pumpAndSettle();
    expect(find.text('Sort & Filter Wishlist'), findsOneWidget);
    expect(find.text('Price: Low to High'), findsOneWidget);

    // Select "Price: Low to High"
    await tester.tap(find.text('Price: Low to High'));
    await tester.pumpAndSettle();
    expect(find.text('Sort & Filter Wishlist'), findsNothing);

    // Tap Filter Pill: "Price Drop (2)"
    final priceDropPill = find.text('Price Drop (2)');
    await tester.ensureVisible(priceDropPill);
    await tester.pumpAndSettle();
    await tester.tap(priceDropPill);
    await tester.pumpAndSettle();

    // Verify filtered items
    expect(find.text('Chronos Ultra 2 (49mm...'), findsOneWidget);
    expect(find.text('KeyChron Pro Wireless...'), findsOneWidget);
    expect(find.text('VoltFast 65W GaN Dual...'), findsNothing);

    // Reset back to "All (4)"
    final allPill = find.text('All (4)');
    await tester.ensureVisible(allPill);
    await tester.pumpAndSettle();
    await tester.tap(allPill);
    await tester.pumpAndSettle();
    expect(find.text('VoltFast 65W GaN Dual...'), findsOneWidget);

    // Tap Product Card to select product
    final cardFinder = find.text('Chronos Ultra 2 (49mm...');
    await tester.ensureVisible(cardFinder);
    await tester.pumpAndSettle();
    await tester.tap(cardFinder);
    await tester.pumpAndSettle();
    expect(selectedProductId, 'chronos_ultra_2');

    // Move first item to cart
    final moveFirstFinder = find.text('Move to Cart').first;
    await tester.ensureVisible(moveFirstFinder);
    await tester.pumpAndSettle();
    await tester.tap(moveFirstFinder);
    await tester.pumpAndSettle();
    expect(movedToCartId, isNotNull);
    expect(find.textContaining('Moved "'), findsOneWidget);

    // Tap "Consult TechKart AI"
    final consultAiFinder = find.text('Consult TechKart AI');
    await tester.ensureVisible(consultAiFinder);
    await tester.pumpAndSettle();
    await tester.tap(consultAiFinder);
    await tester.pumpAndSettle();
    expect(consultAiPressed, isTrue);

    // Tap "Add All to Cart"
    final addAllFinder = find.text('Add All to Cart');
    await tester.ensureVisible(addAllFinder);
    await tester.pumpAndSettle();
    await tester.tap(addAllFinder);
    await tester.pumpAndSettle();
    expect(addAllToCartPressed, isTrue);
    expect(find.textContaining('Added all'), findsOneWidget);

    // Tap Back Arrow
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('ShoppingCartScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    // Set a large phone surface size to ensure all items are visible and render cleanly
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool searchPressed = false;
    bool cartPressed = false;
    bool profilePressed = false;
    bool checkoutPressed = false;
    bool clearCartPressed = false;
    String? selectedProductId;

    await tester.pumpWidget(
      MaterialApp(
        home: ShoppingCartScreen(
          onBack: () => backPressed = true,
          onSearch: () => searchPressed = true,
          onCartPressed: () => cartPressed = true,
          onProfilePressed: () => profilePressed = true,
          onCheckout: () => checkoutPressed = true,
          onClearCart: () => clearCartPressed = true,
          onProductSelected: (id) => selectedProductId = id,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.byIcon(Icons.search), findsOneWidget);
    expect(find.byIcon(Icons.shopping_bag_outlined), findsWidgets); // top bar + bottom nav
    expect(find.byIcon(Icons.person), findsOneWidget);

    // 2. Verify Header
    expect(find.text('My Cart'), findsOneWidget);
    expect(find.text('2 items selected for checkout'), findsOneWidget);
    expect(find.text('Clear'), findsOneWidget);

    // 3. Verify Free Express Shipping Banner
    expect(find.text('Free Express Shipping Unlocked!'), findsOneWidget);
    expect(find.text('100% QUALIFIED'), findsOneWidget);
    expect(find.text('Next-day priority dispatch guaranteed for your order.'), findsOneWidget);

    // 4. Verify Cart Items
    // Item 1
    expect(find.text('Chronos Ultra 2 (49mm...'), findsOneWidget);
    expect(find.text('SALE'), findsOneWidget);
    expect(find.text('Grade 5 Titanium • Midnight Band'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);
    expect(find.text('₹47,115.58'), findsOneWidget);

    // Item 2
    expect(find.text('VoltFast 65W GaN Char...'), findsOneWidget);
    expect(find.text('BUNDLE'), findsOneWidget);
    expect(find.text('Space Grey • Dual USB-C'), findsOneWidget);
    expect(find.text('₹4,626.58'), findsOneWidget);

    // Quantity steppers and trash icons
    expect(find.text('1'), findsNWidgets(2));
    expect(find.byIcon(Icons.add), findsNWidgets(2));
    expect(find.byIcon(Icons.remove), findsNWidgets(2));
    expect(find.byIcon(Icons.delete_outline_rounded), findsNWidgets(3)); // 2 on cards + 1 in clear button

    // 5. Verify Promo Code Card
    expect(find.text('TECECO10'), findsOneWidget);
    expect(find.text('Applied'), findsOneWidget);

    // 6. Verify Order Summary Section
    expect(find.text('Subtotal (2 items)'), findsOneWidget);
    expect(find.text('₹45,132.76'), findsOneWidget);
    expect(find.text('Bundle Promotion'), findsOneWidget);
    expect(find.text('-10%'), findsOneWidget);
    expect(find.text('-₹944.20'), findsOneWidget);
    expect(find.text('Estimated Tax & Duty'), findsOneWidget);
    expect(find.text('₹1,746.77'), findsOneWidget);
    expect(find.text('Express Delivery'), findsOneWidget);
    expect(find.text('FREE'), findsOneWidget);
    expect(find.text('Total'), findsOneWidget);
    expect(find.text('Including VAT & customs'), findsOneWidget);
    expect(find.text('₹45,935.33'), findsNWidgets(2)); // in summary + in checkout button

    // 7. Verify Checkout Button & Trust Badge
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);
    expect(find.text('Guaranteed Safe & 256-Bit Encrypted Checkout'), findsOneWidget);

    // 8. Verify Bottom Nav Bar
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('AI Search'), findsOneWidget);
    expect(find.text('Cart'), findsWidgets);
    expect(find.text('Profile'), findsOneWidget);

    // 9. Interaction Testing:
    // Tap top bar icons
    await tester.tap(find.byIcon(Icons.search));
    await tester.pumpAndSettle();
    expect(searchPressed, isTrue);

    await tester.tap(find.byIcon(Icons.person));
    await tester.pumpAndSettle();
    expect(profilePressed, isTrue);

    await tester.tap(find.byKey(const Key('cart_top_bar_button')));
    await tester.pumpAndSettle();
    expect(cartPressed, isTrue);

    // Tap product card
    await tester.tap(find.text('Chronos Ultra 2 (49mm...'));
    await tester.pumpAndSettle();
    expect(selectedProductId, 'chronos_ultra_2');

    // Tap "+" to increment quantity of first item
    await tester.tap(find.byIcon(Icons.add).first);
    await tester.pumpAndSettle();
    // Subtotal should now be 40506.18 * 2 + 4626.58 = 85638.94
    expect(find.text('2'), findsWidgets);
    expect(find.text('Subtotal (3 items)'), findsOneWidget);
    expect(find.text('₹85,638.94'), findsOneWidget);

    // Tap "-" to decrement quantity back to 1
    await tester.tap(find.byIcon(Icons.remove).first);
    await tester.pumpAndSettle();
    expect(find.text('Subtotal (2 items)'), findsOneWidget);
    expect(find.text('₹45,132.76'), findsOneWidget);

    // Toggle Promo code
    await tester.tap(find.text('Applied'));
    await tester.pumpAndSettle();
    expect(find.text('Apply'), findsOneWidget);
    expect(find.text('-₹0.00'), findsOneWidget);

    // Re-apply Promo code
    await tester.tap(find.text('Apply'));
    await tester.pumpAndSettle();
    expect(find.text('Applied'), findsOneWidget);
    expect(find.text('-₹944.20'), findsOneWidget);

    // Tap Checkout button
    final checkoutBtnFinder = find.byKey(const Key('checkout_button'));
    await tester.ensureVisible(checkoutBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(checkoutBtnFinder);
    await tester.pumpAndSettle();
    expect(checkoutPressed, isTrue);

    // Tap Clear button
    final clearFinder = find.text('Clear');
    await tester.ensureVisible(clearFinder);
    await tester.pumpAndSettle();
    await tester.tap(clearFinder);
    await tester.pumpAndSettle();
    expect(clearCartPressed, isTrue);
    expect(find.text('Your cart is empty'), findsOneWidget);

    // Restore Cart Items from empty state
    await tester.tap(find.text('Restore Cart Items'));
    await tester.pumpAndSettle();
    expect(find.text('Chronos Ultra 2 (49mm...'), findsOneWidget);

    // Tap Back Arrow
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('DeliveryAddressScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    // Set a large phone surface size to ensure all items are visible and render cleanly
    tester.view.physicalSize = const Size(800, 1800);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool lockPressed = false;
    bool profilePressed = false;
    bool continueToPaymentPressed = false;
    DeliveryAddress? selectedAddressCallback;

    await tester.pumpWidget(
      MaterialApp(
        home: DeliveryAddressScreen(
          onBack: () => backPressed = true,
          onLockPressed: () => lockPressed = true,
          onProfilePressed: () => profilePressed = true,
          onContinueToPayment: () => continueToPaymentPressed = true,
          onAddressSelected: (addr) => selectedAddressCallback = addr,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byKey(const Key('checkout_lock_button')), findsOneWidget);
    expect(find.byKey(const Key('checkout_profile_button')), findsOneWidget);

    // 2. Verify Stepper Elements
    expect(find.text('ADDRESS'), findsOneWidget);
    expect(find.text('PAYMENT'), findsOneWidget);
    expect(find.text('REVIEW'), findsOneWidget);
    expect(find.byIcon(Icons.location_on), findsOneWidget);
    expect(find.byIcon(Icons.credit_card_outlined), findsOneWidget);
    expect(find.byIcon(Icons.verified_outlined), findsOneWidget);

    // 3. Verify Sub-header
    expect(find.text('• STEP 1 OF 3'), findsOneWidget);
    expect(find.text('Select Delivery Address'), findsOneWidget);
    expect(find.text('Choose where you would like your TechKart order delivered.'), findsOneWidget);

    // 4. Verify Address Cards
    // Card 1: Home
    expect(find.text('Home'), findsWidgets);
    expect(find.text('DEFAULT'), findsOneWidget);
    expect(find.text('+880 1712-345678'), findsOneWidget);
    expect(find.text('House 42, Road 11, Block D, Banani, Dhaka - 1213, Bangladesh'), findsOneWidget);
    expect(find.textContaining('Tomorrow, Oct 27 (Express)'), findsOneWidget);

    // Card 2: Office
    expect(find.text('Office'), findsWidgets);
    expect(find.text('(TechKart HQ)'), findsOneWidget);
    expect(find.text('+880 1819-876543'), findsOneWidget);
    expect(find.text('Level 8, Crystal Palace, Gulshan 2, Dhaka - 1212, Bangladesh'), findsOneWidget);
    expect(find.text('Standard Delivery (2-3 business days)'), findsOneWidget);

    // Card 3: Other
    expect(find.text('Other'), findsWidgets);
    expect(find.text('Nasreen Sultana'), findsOneWidget);
    expect(find.text('+880 1911-223344'), findsOneWidget);
    expect(find.text('Apartment 5B, Green Valley, Dhanmondi 27, Dhaka - 1209'), findsOneWidget);

    // 5. Verify Add New Delivery Address Card
    expect(find.text('Add New Delivery Address'), findsOneWidget);
    expect(find.text('Add a home, office, or pickup location'), findsOneWidget);

    // 6. Verify Delivery Preference Card
    expect(find.text('Delivery Preference'), findsOneWidget);
    expect(
      find.text('Leave package at front door with building guard if unavailable'),
      findsOneWidget,
    );

    // 7. Verify Bottom Bar
    expect(find.text('Delivering to: '), findsOneWidget);
    expect(find.text('Home (Banani, Dhaka)'), findsOneWidget);
    expect(find.text('FREE SHIPPING'), findsOneWidget);
    expect(find.text('Continue to Payment'), findsOneWidget);
    expect(find.text('Secure SSL 256-bit Encrypted Checkout'), findsOneWidget);

    // 8. Interaction Testing:
    // Tap Top Bar buttons
    await tester.tap(find.byKey(const Key('checkout_lock_button')));
    await tester.pumpAndSettle();
    expect(lockPressed, isTrue);

    await tester.tap(find.byKey(const Key('checkout_profile_button')));
    await tester.pumpAndSettle();
    expect(profilePressed, isTrue);

    // Tap Card 2 (Office) to change delivery destination
    final officeCardFinder = find.text('Level 8, Crystal Palace, Gulshan 2, Dhaka - 1212, Bangladesh');
    await tester.ensureVisible(officeCardFinder);
    await tester.pumpAndSettle();
    await tester.tap(officeCardFinder);
    await tester.pumpAndSettle();
    expect(selectedAddressCallback?.id, 'addr_2');
    expect(find.text('Office (Gulshan 2, Dhaka)'), findsOneWidget);

    // Tap Card 1 (Home) to switch back to Home
    final homeCardFinder = find.text('House 42, Road 11, Block D, Banani, Dhaka - 1213, Bangladesh');
    await tester.ensureVisible(homeCardFinder);
    await tester.pumpAndSettle();
    await tester.tap(homeCardFinder);
    await tester.pumpAndSettle();
    expect(selectedAddressCallback?.id, 'addr_1');
    expect(find.text('Home (Banani, Dhaka)'), findsOneWidget);

    // Toggle Delivery Preference checkbox
    final prefCardFinder = find.text('Delivery Preference');
    await tester.ensureVisible(prefCardFinder);
    await tester.pumpAndSettle();
    await tester.tap(prefCardFinder);
    await tester.pumpAndSettle();

    // Tap "Add New Delivery Address" card to open sheet
    final addCardFinder = find.byKey(const Key('add_new_address_card'));
    await tester.ensureVisible(addCardFinder);
    await tester.pumpAndSettle();
    await tester.tap(addCardFinder);
    await tester.pumpAndSettle();
    expect(find.text('Add Delivery Address'), findsOneWidget);
    expect(find.text('Save & Deliver Here'), findsOneWidget);

    // Close the sheet
    Navigator.of(tester.element(find.text('Add Delivery Address'))).pop();
    await tester.pumpAndSettle();
    expect(find.text('Add Delivery Address'), findsNothing);

    // Tap "Continue to Payment" button
    final continueBtnFinder = find.byKey(const Key('continue_to_payment_button'));
    await tester.ensureVisible(continueBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(continueBtnFinder);
    await tester.pumpAndSettle();
    expect(continueToPaymentPressed, isTrue);

    // Tap Back Arrow
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('EditAddressScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool lockPressed = false;
    bool profilePressed = false;
    DeliveryAddress? savedAddressResult;

    await tester.pumpWidget(
      MaterialApp(
        home: EditAddressScreen(
          onBack: () => backPressed = true,
          onLockPressed: () => lockPressed = true,
          onProfilePressed: () => profilePressed = true,
          onSaveAddress: (addr) => savedAddressResult = addr,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byKey(const Key('edit_address_lock_button')), findsOneWidget);
    expect(find.byKey(const Key('edit_address_profile_button')), findsOneWidget);

    // 2. Verify Step & Header
    expect(find.text('• CHECKOUT STEP 1 OF 3'), findsOneWidget);
    expect(find.text('Delivery Details'), findsOneWidget);
    expect(find.text('Add New Address'), findsOneWidget);
    expect(
      find.text('Enter your delivery location details to ensure fast and accurate shipment of your order.'),
      findsOneWidget,
    );

    // 3. Verify GPS Banner
    expect(find.text('Use Current GPS Location'), findsOneWidget);
    expect(find.text('Instant Fill'), findsOneWidget);

    // 4. Verify Contact Information Fields
    expect(find.text('CONTACT INFORMATION'), findsOneWidget);
    expect(find.text('Recipient Full Name *'), findsOneWidget);
    expect(find.text('Tanvir Ahmed'), findsOneWidget);
    expect(find.text('Phone Number *'), findsOneWidget);
    expect(find.text('+880'), findsOneWidget);
    expect(find.text('1712-345678'), findsOneWidget);
    expect(find.text('Used for delivery updates & SMS courier tracking'), findsOneWidget);

    // 5. Verify Address Details Fields
    expect(find.text('ADDRESS DETAILS'), findsOneWidget);
    expect(find.text('Street Address & House / Flat No. *'), findsOneWidget);
    expect(find.text('House 42, Road 11, Block D, Flat 4B'), findsOneWidget);
    expect(find.text('Locality / Landmark'), findsOneWidget);
    expect(find.text('Near Banani Police Station or Gulshan Club'), findsOneWidget);
    expect(find.text('City *'), findsOneWidget);
    expect(find.text('Dhaka'), findsOneWidget);
    expect(find.text('State / Division *'), findsOneWidget);
    expect(find.text('Dhaka Division'), findsOneWidget);
    expect(find.text('Postal Code *'), findsOneWidget);
    expect(find.text('1213'), findsOneWidget);
    expect(find.text('Country *'), findsOneWidget);
    expect(find.text('Bangladesh'), findsOneWidget);

    // 6. Verify Save Address As Options
    expect(find.text('SAVE ADDRESS AS'), findsOneWidget);
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Office'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);

    // 7. Verify Delivery Instructions
    expect(find.text('Delivery Instructions'), findsOneWidget);
    expect(find.text('Call before arrival, ring bell at Flat 4B directly.'), findsOneWidget);

    // 8. Verify Default Address Toggle
    expect(find.text('Set as default delivery address'), findsOneWidget);
    expect(find.text('Use this address as primary for upcoming TechKart purchases'), findsOneWidget);
    expect(find.byType(Switch), findsOneWidget);

    // 9. Verify Bottom Bar
    expect(find.text('Save & Use Address'), findsOneWidget);
    expect(find.text('SSL Encrypted • 100% Secure Checkout & Data Privacy'), findsOneWidget);

    // 10. Interactions:
    // Tap Top Bar buttons
    await tester.tap(find.byKey(const Key('edit_address_lock_button')));
    await tester.pumpAndSettle();
    expect(lockPressed, isTrue);

    await tester.tap(find.byKey(const Key('edit_address_profile_button')));
    await tester.pumpAndSettle();
    expect(profilePressed, isTrue);

    // Tap Instant Fill
    await tester.tap(find.text('Instant Fill'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Banani'), findsWidgets);

    // Select "Office" chip
    await tester.tap(find.text('Office'));
    await tester.pumpAndSettle();

    // Toggle default switch
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();

    // Tap "Save & Use Address" button
    final saveBtnFinder = find.byKey(const Key('save_and_use_address_button'));
    await tester.ensureVisible(saveBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(saveBtnFinder);
    await tester.pumpAndSettle();
    expect(savedAddressResult, isNotNull);
    expect(savedAddressResult?.label, 'Office');

    // Tap Back Arrow
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('OrderReviewScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool lockPressed = false;
    bool profilePressed = false;
    bool changeAddressPressed = false;
    bool editCartPressed = false;
    bool continueToPaymentPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: OrderReviewScreen(
          onBack: () => backPressed = true,
          onLockPressed: () => lockPressed = true,
          onProfilePressed: () => profilePressed = true,
          onChangeAddress: () => changeAddressPressed = true,
          onEditCart: () => editCartPressed = true,
          onContinueToPayment: () => continueToPaymentPressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byKey(const Key('order_review_lock_button')), findsOneWidget);
    expect(find.byKey(const Key('order_review_profile_button')), findsOneWidget);

    // 2. Verify Top Banner
    expect(find.textContaining('Step 2 of 3 • Delivery & Order'), findsOneWidget);
    expect(find.textContaining('Order #TK-'), findsOneWidget);

    // 3. Verify Stepper
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);
    expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
    expect(find.byIcon(Icons.credit_card_outlined), findsOneWidget);

    // 4. Verify Sub-header
    expect(find.text('Review Your Order'), findsOneWidget);
    expect(
      find.text('Verify your delivery destination and item breakdown before proceeding to secure payment.'),
      findsOneWidget,
    );

    // 5. Verify Delivering to Card
    expect(find.text('Delivering to'), findsOneWidget);
    expect(find.text('HOME'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);
    expect(find.text('Tanvir Ahmed'), findsOneWidget);
    expect(find.text('+880 1712-345678'), findsOneWidget);
    expect(find.text('House 42, Road 11, Block D, Banani, Dhaka - 1213, Bangladesh'), findsOneWidget);
    expect(find.textContaining('Delivery Note:'), findsOneWidget);

    // 6. Verify Shipping Method Card
    expect(find.text('TechKart Express Priority'), findsOneWidget);
    expect(find.text('FREE'), findsWidgets); // shipping card + price breakdown
    expect(find.text('Dispatched from Banani Central Fulfillment Hub'), findsOneWidget);
    expect(find.textContaining('Tomorrow, Oct 27 (by 6:00 PM)'), findsOneWidget);

    // 7. Verify Items in Shipment
    expect(find.text('Items in Shipment (2)'), findsOneWidget);
    expect(find.text('Edit Cart'), findsOneWidget);
    expect(find.text('Chronos Ultra 2 (49mm GPS)'), findsOneWidget);
    expect(find.text('Grade 5 Titanium • Qty: 1'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);
    expect(find.text('₹47,115.58'), findsOneWidget);
    expect(find.text('-₹6,609.40'), findsOneWidget);

    expect(find.text('VoltFast 65W GaN Dual USB-C'), findsOneWidget);
    expect(find.text('Space Grey • Qty: 1'), findsOneWidget);
    expect(find.text('Bundle Deal'), findsOneWidget);
    expect(find.text('₹4,626.58'), findsOneWidget);
    expect(find.text('₹5,570.78'), findsOneWidget);

    // 8. Verify Price Breakdown
    expect(find.text('PRICE BREAKDOWN'), findsOneWidget);
    expect(find.text('Items Subtotal (2 products)'), findsOneWidget);
    expect(find.text('₹45,132.76'), findsOneWidget);
    expect(find.text('Bundle Promotion'), findsOneWidget);
    expect(find.text('-₹944.20'), findsOneWidget);
    expect(find.text('Estimated Tax & VAT (5%)'), findsOneWidget);
    expect(find.text('₹1,746.77'), findsOneWidget);
    expect(find.text('Express Priority Dispatch'), findsOneWidget);
    expect(find.text('Total Amount'), findsOneWidget);
    expect(find.text('Includes taxes and courier insurance'), findsOneWidget);
    expect(find.text('₹45,935.33'), findsNWidgets(2)); // in breakdown + in bottom bar

    // 9. Verify Bottom Payment Bar
    expect(find.text('TO PAY'), findsOneWidget);
    expect(find.text('Continue to Payment'), findsOneWidget);
    expect(find.text('256-Bit SSL Encrypted Checkout • 100% Genuine Guarantee'), findsOneWidget);

    // 10. Interactions:
    // Tap top bar buttons
    await tester.tap(find.byKey(const Key('order_review_lock_button')));
    await tester.pumpAndSettle();
    expect(lockPressed, isTrue);

    await tester.tap(find.byKey(const Key('order_review_profile_button')));
    await tester.pumpAndSettle();
    expect(profilePressed, isTrue);

    // Tap Change address
    await tester.tap(find.text('Change'));
    await tester.pumpAndSettle();
    expect(changeAddressPressed, isTrue);

    // Tap Edit Cart
    await tester.tap(find.text('Edit Cart'));
    await tester.pumpAndSettle();
    expect(editCartPressed, isTrue);

    // Tap Continue to Payment
    final continuePaymentBtnFinder = find.byKey(const Key('review_continue_payment_button'));
    await tester.ensureVisible(continuePaymentBtnFinder);
    await tester.pumpAndSettle();
    await tester.tap(continuePaymentBtnFinder);
    await tester.pumpAndSettle();
    expect(continueToPaymentPressed, isTrue);

    // Tap Back Arrow
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('PaymentMethodScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool lockPressed = false;
    bool profilePressed = false;
    String? selectedMethodResult;
    bool proceedToPayPressed = false;
    bool addNewCardPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: PaymentMethodScreen(
          onBack: () => backPressed = true,
          onLockPressed: () => lockPressed = true,
          onProfilePressed: () => profilePressed = true,
          onPaymentMethodSelected: (m) => selectedMethodResult = m,
          onProceedToPay: () => proceedToPayPressed = true,
          onAddNewCard: () => addNewCardPressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byKey(const Key('payment_lock_button')), findsOneWidget);
    expect(find.byKey(const Key('payment_profile_button')), findsOneWidget);

    // 2. Verify Step Badges & Stepper
    expect(find.text('STEP 3 OF 3 • FINAL STEP'), findsOneWidget);
    expect(find.text('Order #TK-89421'), findsOneWidget);
    expect(find.text('Address'), findsOneWidget);
    expect(find.text('Review'), findsOneWidget);
    expect(find.text('Payment'), findsOneWidget);
    expect(find.byIcon(Icons.check), findsNWidgets(3)); // Address, Review, and Card Checkbox
    expect(find.byIcon(Icons.credit_card), findsOneWidget); // Payment

    // 3. Verify Header
    expect(find.text('Choose Payment\nMethod'), findsOneWidget);
    expect(
      find.text('Select your preferred secure payment channel to confirm reservation & dispatch.'),
      findsOneWidget,
    );

    // 4. Verify Cart Summary Bar
    expect(find.text('2 Selected Items'), findsOneWidget);
    expect(find.text('Chronos Ultra 2 + Volt...'), findsOneWidget);
    expect(find.text('₹45,935.33'), findsNWidgets(2)); // in cart bar + in bottom bar
    expect(find.text('Details'), findsOneWidget);

    // Expand Cart Details
    await tester.tap(find.text('Details'));
    await tester.pumpAndSettle();
    expect(find.text('1x Chronos Ultra 2 (49mm GPS)'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);
    expect(find.text('1x VoltFast 65W GaN Dual USB-C'), findsOneWidget);
    expect(find.text('₹4,626.58'), findsOneWidget);
    expect(find.text('Discount + Taxes & Duties'), findsOneWidget);
    expect(find.text('+₹802.57'), findsOneWidget);

    // 5. Verify Credit / Debit Card Option (Selected by Default)
    expect(find.text('Credit / Debit Card'), findsOneWidget);
    expect(find.text('Recommended'), findsOneWidget);
    expect(find.text('VISA'), findsOneWidget);
    expect(find.text('MC'), findsOneWidget);
    expect(find.text('Visa, Mastercard,\nAmerican Express'), findsOneWidget);

    // Saved Card Preview
    expect(find.text('TechKart Platinum'), findsOneWidget);
    expect(find.text('•••• 4829'), findsOneWidget);
    expect(find.text('CARDHOLDER'), findsOneWidget);
    expect(find.text('Tanvir Ahmed'), findsOneWidget);
    expect(find.text('EXPIRES'), findsOneWidget);
    expect(find.text('08/27'), findsOneWidget);

    // CVV input
    expect(find.text('CVV / CVC Security\nCode'), findsOneWidget);
    expect(find.text('3 or 4 digits located on signature strip'), findsOneWidget);

    // Save Card Checkbox
    expect(find.text('Save card securely for 1-click checkout'), findsOneWidget);
    await tester.tap(find.text('Save card securely for 1-click checkout'));
    await tester.pumpAndSettle();

    // + Add New Card
    expect(find.text('+ Add New Card'), findsOneWidget);
    await tester.tap(find.text('+ Add New Card'));
    await tester.pumpAndSettle();
    expect(addNewCardPressed, isTrue);

    // 6. Verify UPI & Mobile Wallet Option
    expect(find.text('UPI & Mobile Wallet'), findsOneWidget);
    expect(find.text('Instant'), findsOneWidget);
    expect(find.text('Google Pay, Apple Pay, PhonePe,\nbKash / Nagad'), findsOneWidget);
    expect(find.byIcon(Icons.qr_code_scanner), findsOneWidget);

    // Select UPI
    await tester.tap(find.text('UPI & Mobile Wallet'));
    await tester.pumpAndSettle();
    expect(selectedMethodResult, 'upi');

    // 7. Verify Net Banking Option
    expect(find.text('Net Banking'), findsOneWidget);
    expect(find.text('50+ authorized commercial &\nprivate banks'), findsOneWidget);
    expect(find.byIcon(Icons.account_balance_outlined), findsOneWidget);

    // Select Net Banking
    await tester.tap(find.text('Net Banking'));
    await tester.pumpAndSettle();
    expect(selectedMethodResult, 'netbanking');

    // 8. Verify Cash on Delivery Option
    expect(find.text('Cash on Delivery (COD)'), findsOneWidget);
    expect(find.text('Eligible'), findsOneWidget);
    expect(find.text('Pay via cash or POS card\nmachine at your doorstep'), findsOneWidget);
    expect(find.byIcon(Icons.payments_outlined), findsOneWidget);

    // Select COD
    await tester.tap(find.text('Cash on Delivery (COD)'));
    await tester.pumpAndSettle();
    expect(selectedMethodResult, 'cod');

    // 9. Verify Buyer Assurance Card
    expect(find.text('Bank-Grade 256-Bit SSL Protection'), findsOneWidget);
    expect(
      find.text('TechKart Buyer Assurance guarantees an immediate 100% refund for damaged packages, transit delays, or unfulfilled merchant orders.'),
      findsOneWidget,
    );

    // 10. Verify Bottom Payment Bar
    expect(find.text('TOTAL PAYABLE'), findsOneWidget);
    expect(find.text('INR'), findsOneWidget);
    expect(find.text('Pay ₹45,935.33'), findsOneWidget);
    expect(find.text('PCI-DSS Level 1 Compliant • Encrypted Checkout'), findsOneWidget);

    // Tap Pay Button
    await tester.tap(find.byKey(const Key('pay_now_button')));
    await tester.pumpAndSettle();
    expect(proceedToPayPressed, isTrue);

    // Tap Top Bar Buttons
    await tester.tap(find.byKey(const Key('payment_lock_button')));
    await tester.pumpAndSettle();
    expect(lockPressed, isTrue);

    await tester.tap(find.byKey(const Key('payment_profile_button')));
    await tester.pumpAndSettle();
    expect(profilePressed, isTrue);

    // Tap Back Arrow
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('SecurePaymentScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 1600);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SecurePaymentScreen(
          amount: 45935.33,
          currency: 'INR',
          orderId: 'TK-89421',
          cardLast4: '4829',
          autoSimulate: false,
          onBack: () => backPressed = true,
        ),
      ),
    );

    // Pump initial frames for animations
    await tester.pump(const Duration(milliseconds: 200));

    // 1. Verify Top SSL Badge
    expect(find.byKey(const Key('ssl_session_badge')), findsOneWidget);
    expect(find.text('256-BIT SSL ENCRYPTED SESSION'), findsOneWidget);
    expect(find.byIcon(Icons.lock_outline_rounded), findsOneWidget);

    // 2. Verify Central Animated Dial
    expect(find.byKey(const Key('secure_dial_indicator')), findsOneWidget);
    expect(find.byIcon(Icons.verified_user_outlined), findsOneWidget);

    // 3. Verify Amount Display
    expect(find.byKey(const Key('amount_display')), findsOneWidget);
    expect(find.text('₹45,935.33'), findsOneWidget);
    expect(find.text('INR'), findsOneWidget);

    // 4. Verify Order Pill
    expect(find.byKey(const Key('order_id_badge')), findsOneWidget);
    expect(find.text('Order #TK-89421'), findsOneWidget);

    // 5. Verify Headline
    expect(find.byKey(const Key('processing_title')), findsOneWidget);
    expect(find.text('Processing Payment\nsecurely...'), findsOneWidget);

    // 6. Verify Advisory Notice
    expect(
      find.text('Please do not refresh, close the\napp, or press back while we\ncommunicate with your bank.'),
      findsOneWidget,
    );

    // 7. Verify Card Authorization Status Pill
    expect(find.byKey(const Key('card_authorizing_pill')), findsOneWidget);
    expect(find.text('Authorizing card ending in •••• 4829'), findsOneWidget);
    expect(find.byIcon(Icons.credit_card_outlined), findsOneWidget);

    // 8. Verify Buyer Protection Footer
    expect(find.byKey(const Key('buyer_protection_footer')), findsOneWidget);
    expect(find.text('TechKart End-to-End Buyer Protection'), findsOneWidget);
    expect(find.byIcon(Icons.shield_outlined), findsOneWidget);

    // Verify Animation loop runs smoothly
    await tester.pump(const Duration(milliseconds: 500));
    await tester.pump(const Duration(milliseconds: 500));

    // Test Back press handler
    await tester.binding.handlePopRoute();
    await tester.pump();
    expect(backPressed, isTrue);

    // Verify simulation callback works when autoSimulate is true
    bool simulationDone = false;
    await tester.pumpWidget(
      MaterialApp(
        home: SecurePaymentScreen(
          autoSimulate: true,
          simulationDuration: const Duration(milliseconds: 100),
          onPaymentCompleted: () => simulationDone = true,
        ),
      ),
    );
    await tester.pump(const Duration(milliseconds: 150));
    expect(simulationDone, isTrue);
  });

  testWidgets('OrderConfirmationScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool trackOrderPressed = false;
    bool continueShoppingPressed = false;
    bool contactConciergePressed = false;
    bool copyOrderIdPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: OrderConfirmationScreen(
          orderId: 'TK-89421',
          customerName: 'Tanvir',
          customerFullName: 'Tanvir Ahmed',
          customerEmail: 'tanvir.ahmed@example.com',
          deliveryAddress: 'House 42, Road 11, Banani, Dhaka - 1213',
          estimatedDelivery: 'Tomorrow, Oct 27',
          guaranteedTime: 'Guaranteed delivery by 6:00 PM',
          cardLast4: '4829',
          cardBrand: 'Mastercard',
          authCode: '920831',
          totalAmount: 45935.33,
          dateTimeText: 'Oct 26, 2024 • 10:28 AM',
          onTrackOrder: () => trackOrderPressed = true,
          onContinueShopping: () => continueShoppingPressed = true,
          onContactConcierge: () => contactConciergePressed = true,
          onCopyOrderId: () => copyOrderIdPressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top Success Checkmark & Halo
    expect(find.byKey(const Key('order_confirmed_check')), findsOneWidget);
    expect(find.byIcon(Icons.check), findsOneWidget);

    // 2. Verify Payment Successful Badge
    expect(find.byKey(const Key('payment_successful_badge')), findsOneWidget);
    expect(find.text('Payment Successful'), findsOneWidget);

    // 3. Verify Headline & Thanks Message
    expect(find.text('Order Confirmed!'), findsOneWidget);
    expect(find.textContaining('Thank you, Tanvir! Your order #TK-89421'), findsOneWidget);
    expect(find.textContaining('has been placed and is being prepared for dispatch.'), findsOneWidget);

    // 4. Verify Reference & Payment Card
    expect(find.text('REFERENCE'), findsOneWidget);
    expect(find.text('#TK-89421'), findsOneWidget);
    expect(find.byKey(const Key('copy_order_id_button')), findsOneWidget);
    expect(find.text('DATE & TIME'), findsOneWidget);
    expect(find.text('Oct 26, 2024 • 10:28 AM'), findsOneWidget);
    expect(find.text('Mastercard ending in 4829'), findsOneWidget);
    expect(find.text('Auth Code • 920831'), findsOneWidget);
    expect(find.text('₹45,935.33'), findsOneWidget);
    expect(find.text('Paid'), findsOneWidget);

    // 5. Verify Estimated Delivery & Destination Card
    expect(find.text('ESTIMATED DELIVERY'), findsOneWidget);
    expect(find.text('EXPRESS PRIORITY'), findsOneWidget);
    expect(find.text('Tomorrow, Oct 27'), findsOneWidget);
    expect(find.text('Guaranteed delivery by 6:00 PM'), findsOneWidget);
    expect(find.text('Tanvir Ahmed'), findsOneWidget);
    expect(find.text('House 42, Road 11, Banani, Dhaka - 1213'), findsOneWidget);
    expect(find.byIcon(Icons.local_shipping_outlined), findsOneWidget);
    expect(find.byIcon(Icons.location_on_outlined), findsOneWidget);

    // 6. Verify Items in this Package
    expect(find.text('Items in this Package'), findsOneWidget);
    expect(find.text('2 items'), findsOneWidget);
    expect(find.text('Chronos Ultra 2 (49mm GPS)'), findsOneWidget);
    expect(find.text('Titanium Case  •  Qty: 1'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);
    expect(find.text('VoltFast 65W GaN Dual USB-C'), findsOneWidget);
    expect(find.text('Matte Off-White  •  Qty: 1'), findsOneWidget);
    expect(find.text('₹5,429.15'), findsOneWidget);

    // 7. Verify Email Receipt Banner
    expect(find.textContaining('Receipt & live courier tracking link sent to'), findsOneWidget);
    expect(find.textContaining('tanvir.ahmed@example.com'), findsOneWidget);
    expect(find.byIcon(Icons.mail_outline_rounded), findsOneWidget);

    // 8. Verify Primary Action Buttons
    expect(find.text('Track Order'), findsOneWidget);
    expect(find.text('Continue Shopping'), findsOneWidget);
    expect(find.byKey(const Key('track_order_button')), findsOneWidget);
    expect(find.byKey(const Key('continue_shopping_button')), findsOneWidget);

    // 9. Verify Footer Concierge Link
    expect(find.textContaining('Need assistance with this order?'), findsOneWidget);
    expect(find.text('Contact Concierge'), findsOneWidget);
    expect(find.byKey(const Key('contact_concierge_button')), findsOneWidget);

    // 10. Test User Interactions:
    // Tap Copy Order ID
    await tester.tap(find.byKey(const Key('copy_order_id_button')));
    await tester.pumpAndSettle();
    expect(copyOrderIdPressed, isTrue);

    // Tap Track Order
    await tester.tap(find.byKey(const Key('track_order_button')));
    await tester.pumpAndSettle();
    expect(trackOrderPressed, isTrue);

    // Tap Continue Shopping
    await tester.tap(find.byKey(const Key('continue_shopping_button')));
    await tester.pumpAndSettle();
    expect(continueShoppingPressed, isTrue);

    // Tap Contact Concierge
    await tester.tap(find.byKey(const Key('contact_concierge_button')));
    await tester.pumpAndSettle();
    expect(contactConciergePressed, isTrue);
  });

  testWidgets('OrderHistoryScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2200);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool lockPressed = false;
    bool profilePressed = false;
    String? selectedOrderId;
    String? trackedOrderId;
    String? reorderedOrderId;
    String? reviewOrderId;
    String? receiptOrderId;
    bool contactConciergePressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: OrderHistoryScreen(
          onBack: () => backPressed = true,
          onLockPressed: () => lockPressed = true,
          onProfilePressed: () => profilePressed = true,
          onOrderSelected: (id) => selectedOrderId = id,
          onTrackOrder: (id) => trackedOrderId = id,
          onReorder: (id) => reorderedOrderId = id,
          onWriteReview: (id) => reviewOrderId = id,
          onDownloadReceipt: (id) => receiptOrderId = id,
          onContactConcierge: () => contactConciergePressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byKey(const Key('order_history_lock_button')), findsOneWidget);
    expect(find.byKey(const Key('order_history_profile_button')), findsOneWidget);

    // 2. Verify Search Field & Filter Button
    expect(find.byKey(const Key('order_search_field')), findsOneWidget);
    expect(find.text('Search orders, items or serials...'), findsOneWidget);
    expect(find.byKey(const Key('order_filter_button')), findsOneWidget);

    // 3. Verify Filter Tabs
    expect(find.text('All Orders (14)'), findsOneWidget);
    expect(find.text('In Progress (2)'), findsOneWidget);
    expect(find.text('Delivered (11)'), findsOneWidget);
    expect(find.text('Cancelled (1)'), findsOneWidget);

    // 4. Verify Order 1 (In Progress: #TK-89421)
    expect(find.text('Order #TK-89421'), findsOneWidget);
    expect(find.text('Today, Oct 26, 2024'), findsOneWidget);
    expect(find.text('Preparing Dispatch'), findsOneWidget);
    expect(find.text('Chronos Ultra 2 (49...'), findsOneWidget);
    expect(find.text('+ 1 other item (VoltFast ...'), findsOneWidget);
    expect(find.text('₹45,935.33 (2 items)'), findsOneWidget);
    expect(find.textContaining('Expected Delivery:'), findsOneWidget);
    expect(find.textContaining('Tomorrow, Oct 27'), findsOneWidget);
    expect(find.text('Track Order'), findsOneWidget);
    expect(find.text('View Details'), findsWidgets);

    // 5. Verify Order 2 (Delivered: #TK-78210)
    expect(find.text('Order #TK-78210'), findsOneWidget);
    expect(find.text('Oct 14, 2024'), findsOneWidget);
    expect(find.text('Delivered'), findsNWidgets(2)); // Card 2 and Card 3
    expect(find.text('KeyPro Wireless Mechani...'), findsOneWidget);
    expect(find.textContaining('Tactile Brown Switch'), findsOneWidget);
    expect(find.text('₹17,845.38 (1 item)'), findsOneWidget);
    expect(find.text('Reorder'), findsNWidgets(2));
    expect(find.text('Write Review'), findsOneWidget);
    expect(find.byKey(const Key('receipt_TK-78210')), findsOneWidget);

    // 6. Verify Order 3 (Delivered: #TK-65934)
    expect(find.text('Order #TK-65934'), findsOneWidget);
    expect(find.text('Sep 28, 2024'), findsOneWidget);
    expect(find.text('Aura Pro ANC Headphones'), findsOneWidget);
    expect(find.text('Ivory White • Spatial Audio'), findsOneWidget);
    expect(find.text('₹32,952.58 (1 item)'), findsOneWidget);

    // 7. Verify Concierge Banner
    expect(find.text('Need assistance?'), findsOneWidget);
    expect(find.textContaining('TechKart 24/7 concierge'), findsOneWidget);
    expect(find.text('Contact'), findsOneWidget);

    // 8. Test Tab Switching
    // Switch to In Progress
    await tester.tap(find.text('In Progress (2)'));
    await tester.pumpAndSettle();
    expect(find.text('Order #TK-89421'), findsOneWidget);
    expect(find.text('Order #TK-78210'), findsNothing);

    // Switch to Delivered
    await tester.tap(find.text('Delivered (11)'));
    await tester.pumpAndSettle();
    expect(find.text('Order #TK-89421'), findsNothing);
    expect(find.text('Order #TK-78210'), findsOneWidget);
    expect(find.text('Order #TK-65934'), findsOneWidget);

    // Switch back to All Orders
    await tester.tap(find.text('All Orders (14)'));
    await tester.pumpAndSettle();
    expect(find.text('Order #TK-89421'), findsOneWidget);

    // 9. Test Card Actions
    await tester.tap(find.byKey(const Key('track_order_TK-89421')));
    await tester.pumpAndSettle();
    expect(trackedOrderId, 'TK-89421');

    await tester.tap(find.byKey(const Key('view_details_TK-89421')));
    await tester.pumpAndSettle();
    expect(selectedOrderId, 'TK-89421');

    await tester.tap(find.byKey(const Key('reorder_TK-78210')));
    await tester.pumpAndSettle();
    expect(reorderedOrderId, 'TK-78210');

    await tester.tap(find.byKey(const Key('write_review_TK-78210')));
    await tester.pumpAndSettle();
    expect(reviewOrderId, 'TK-78210');

    await tester.tap(find.byKey(const Key('receipt_TK-78210')));
    await tester.pumpAndSettle();
    expect(receiptOrderId, 'TK-78210');

    await tester.tap(find.byKey(const Key('contact_concierge_button')));
    await tester.pumpAndSettle();
    expect(contactConciergePressed, isTrue);

    // Top Bar actions
    await tester.tap(find.byKey(const Key('order_history_lock_button')));
    await tester.pumpAndSettle();
    expect(lockPressed, isTrue);

    await tester.tap(find.byKey(const Key('order_history_profile_button')));
    await tester.pumpAndSettle();
    expect(profilePressed, isTrue);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('OrderDetailsScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool lockPressed = false;
    bool profilePressed = false;
    bool trackShipmentPressed = false;
    String? buyAgainProductId;
    String? viewProductId;
    bool downloadInvoicePressed = false;
    bool cancelOrderPressed = false;
    bool needHelpPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: OrderDetailsScreen(
          orderId: 'TK-89421',
          orderDate: 'Oct 26, 2024',
          orderTime: '10:28 AM',
          estimatedDelivery: 'Tomorrow, Oct 27',
          guaranteedTime: 'Guaranteed delivery before 6:00 PM',
          recipientName: 'Tanvir Ahmed',
          recipientPhone: '+880 1712-345678',
          recipientAddress: 'House 42, Road 11, Block D, Banani,\nDhaka - 1213, Bangladesh',
          shippingMethod: 'TechKart Express Priority',
          courierPartner: 'Apex Courier Express',
          trackingId: 'APX-982140',
          cardLast4: '4829',
          authCode: '920831',
          subtotal: 45132.76,
          discount: 944.20,
          tax: 1746.77,
          totalAmount: 45935.33,
          onBack: () => backPressed = true,
          onLockPressed: () => lockPressed = true,
          onProfilePressed: () => profilePressed = true,
          onTrackShipment: () => trackShipmentPressed = true,
          onBuyAgain: (id) => buyAgainProductId = id,
          onViewProduct: (id) => viewProductId = id,
          onDownloadInvoice: () => downloadInvoicePressed = true,
          onCancelOrder: () => cancelOrderPressed = true,
          onNeedHelp: () => needHelpPressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byKey(const Key('order_details_lock_button')), findsOneWidget);
    expect(find.byKey(const Key('order_details_profile_button')), findsOneWidget);

    // 2. Verify Order Status Card
    expect(find.text('Order #TK-89421'), findsOneWidget);
    expect(find.byKey(const Key('copy_order_id_button')), findsOneWidget);
    expect(find.text('Preparing Dispatch'), findsOneWidget);
    expect(find.textContaining('Placed on Oct 26, 2024'), findsOneWidget);
    expect(find.textContaining('• 10:28 AM'), findsOneWidget);
    expect(find.textContaining('Expected Delivery:'), findsOneWidget);
    expect(find.textContaining('Tomorrow, Oct 27'), findsOneWidget);
    expect(find.text('Guaranteed delivery before 6:00 PM'), findsOneWidget);
    expect(find.text('Track Shipment'), findsOneWidget);

    // 3. Verify Items Section
    expect(find.text('Items in this Order (2)'), findsOneWidget);
    expect(find.text('2 packages'), findsOneWidget);
    expect(find.text('Chronos Ultra 2 (49mm G...'), findsOneWidget);
    expect(find.textContaining('Grade 5 Titanium'), findsOneWidget);
    expect(find.text('₹40,506.18'), findsOneWidget);
    expect(find.text('₹47,115.58'), findsOneWidget);
    expect(find.text('VoltFast 65W GaN Dual U...'), findsOneWidget);
    expect(find.textContaining('Matte Off-White'), findsOneWidget);
    expect(find.text('₹4,626.58'), findsOneWidget);
    expect(find.text('₹5,570.78'), findsOneWidget);
    expect(find.text('Buy Again >'), findsNWidgets(2));
    expect(find.text('View Product'), findsNWidgets(2));

    // 4. Verify Shipping Details Card
    expect(find.text('Shipping Details'), findsOneWidget);
    expect(find.textContaining('Tanvir Ahmed • +880 1712-345678'), findsOneWidget);
    expect(find.textContaining('House 42, Road 11, Block D, Banani'), findsOneWidget);
    expect(find.text('Shipping Method'), findsOneWidget);
    expect(find.text('TechKart Express Priority'), findsOneWidget);
    expect(find.text('Courier Partner'), findsOneWidget);
    expect(find.text('Apex Courier Express'), findsOneWidget);
    expect(find.text('Tracking ID'), findsOneWidget);
    expect(find.text('APX-982140'), findsOneWidget);
    expect(find.byKey(const Key('copy_tracking_id_button')), findsOneWidget);

    // 5. Verify Payment Information Card
    expect(find.text('Payment Information'), findsOneWidget);
    expect(find.text('Mastercard ending in •••• 4829'), findsOneWidget);
    expect(find.text('Auth #920831'), findsOneWidget);
    expect(find.text('Paid'), findsOneWidget);
    expect(find.text('Items Subtotal'), findsOneWidget);
    expect(find.text('₹45,132.76'), findsOneWidget);
    expect(find.text('Bundle Promotion'), findsOneWidget);
    expect(find.text('-₹944.20'), findsOneWidget);
    expect(find.text('Estimated Tax & VAT (5%)'), findsOneWidget);
    expect(find.text('₹1,746.77'), findsOneWidget);
    expect(find.text('Express Delivery'), findsOneWidget);
    expect(find.text('FREE'), findsOneWidget);
    expect(find.text('Total Amount Paid'), findsOneWidget);
    expect(find.text('₹45,935.33'), findsOneWidget);

    // 6. Verify Bottom Actions
    expect(find.text('Download Invoice (PDF)'), findsOneWidget);
    expect(find.text('Cancel Order'), findsOneWidget);
    expect(find.text('Eligible until 12:28 PM'), findsOneWidget);
    expect(find.text('Need Help with this Order?'), findsOneWidget);

    // 7. Test User Interactions:
    // Copy Order ID
    await tester.tap(find.byKey(const Key('copy_order_id_button')));
    await tester.pumpAndSettle();

    // Copy Tracking ID
    await tester.tap(find.byKey(const Key('copy_tracking_id_button')));
    await tester.pumpAndSettle();

    // Track Shipment
    await tester.tap(find.byKey(const Key('track_shipment_button')));
    await tester.pumpAndSettle();
    expect(trackShipmentPressed, isTrue);

    // Buy Again on Item 1
    await tester.tap(find.byKey(const Key('buy_again_chronos_ultra_2')));
    await tester.pumpAndSettle();
    expect(buyAgainProductId, 'chronos_ultra_2');

    // View Product on Item 1
    await tester.tap(find.byKey(const Key('view_product_chronos_ultra_2')));
    await tester.pumpAndSettle();
    expect(viewProductId, 'chronos_ultra_2');

    // Download Invoice
    await tester.tap(find.byKey(const Key('download_invoice_button')));
    await tester.pumpAndSettle();
    expect(downloadInvoicePressed, isTrue);

    // Cancel Order
    await tester.tap(find.byKey(const Key('cancel_order_button')));
    await tester.pumpAndSettle();
    expect(cancelOrderPressed, isTrue);

    // Need Help
    await tester.tap(find.byKey(const Key('need_help_button')));
    await tester.pumpAndSettle();
    expect(needHelpPressed, isTrue);

    // Top Bar actions
    await tester.tap(find.byKey(const Key('order_details_lock_button')));
    await tester.pumpAndSettle();
    expect(lockPressed, isTrue);

    await tester.tap(find.byKey(const Key('order_details_profile_button')));
    await tester.pumpAndSettle();
    expect(profilePressed, isTrue);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('ShipmentTrackingScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool sharePressed = false;
    bool gaugePressed = false;
    bool profilePressed = false;
    bool callCourierPressed = false;
    bool copyTrackingPressed = false;
    bool getSupportPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: ShipmentTrackingScreen(
          trackingId: 'APX-982140',
          orderId: 'TK-89421',
          estimatedDelivery: 'Tomorrow, Oct 27',
          estimatedTime: 'By 6:00 PM • On Schedule',
          currentStatus: 'In Transit — Regional Hub Transfer',
          nextStop: 'Next stop: North Banani Dispatch Center',
          recipientName: 'Tanvir Ahmed',
          recipientAddress: 'House 42, Road 11, Banani, Dhaka',
          courierName: 'Apex Courier Express',
          courierPhone: '+880 1700-112233',
          onBack: () => backPressed = true,
          onShare: () => sharePressed = true,
          onGaugePressed: () => gaugePressed = true,
          onProfilePressed: () => profilePressed = true,
          onCallCourier: () => callCourierPressed = true,
          onCopyTrackingId: () => copyTrackingPressed = true,
          onGetSupport: () => getSupportPressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.textContaining('Track Shipm'), findsOneWidget);
    expect(find.byKey(const Key('shipment_gauge_button')), findsOneWidget);
    expect(find.byKey(const Key('shipment_share_button')), findsOneWidget);
    expect(find.byKey(const Key('shipment_profile_button')), findsOneWidget);

    // 2. Verify Hero Card
    expect(find.text('EXPRESS PRIORITY'), findsOneWidget);
    expect(find.text('Live Tracking'), findsOneWidget);
    expect(find.text('Tomorrow, Oct 27'), findsOneWidget);
    expect(find.text('By 6:00 PM • On Schedule'), findsOneWidget);
    expect(find.text('In Transit — Regional Hub Transfer'), findsOneWidget);
    expect(find.text('Next stop: North Banani Dispatch Center'), findsOneWidget);
    expect(find.text('Step 3 of 4'), findsOneWidget);
    expect(find.text('75% Completed'), findsOneWidget);

    // 3. Verify Tracking Info Card
    expect(find.text('TRACKING NUMBER'), findsOneWidget);
    expect(find.text('APX-982140'), findsOneWidget);
    expect(find.byKey(const Key('copy_tracking_button')), findsOneWidget);
    expect(find.text('Apex Courier Express'), findsOneWidget);
    expect(find.byKey(const Key('call_courier_button')), findsOneWidget);
    expect(find.text('2 Items in Shipment'), findsOneWidget);
    expect(find.text('Chronos Ultra 2 + VoltFast GaN Ch...'), findsOneWidget);
    expect(find.text('Destination Address'), findsOneWidget);
    expect(find.textContaining('Tanvir Ahmed • House 42, Road 11, Banani, Dhaka'), findsOneWidget);

    // 4. Verify Delivery Progress Timeline Card
    expect(find.text('Delivery Progress'), findsOneWidget);
    expect(find.text('GMT+6'), findsOneWidget);
    expect(find.text('Departed Sorting Facility'), findsOneWidget);
    expect(find.text('Dhaka Central Hub'), findsOneWidget);
    expect(find.text('Package Scanned & Processed'), findsOneWidget);
    expect(find.text('Order Placed & Verified'), findsOneWidget);
    expect(find.text('Out for Delivery & Handover'), findsOneWidget);

    // 5. Verify Alerts Banner & Toggle
    expect(find.text('SMS & WhatsApp Alerts'), findsOneWidget);
    expect(find.text('Real-time status updates enabled'), findsOneWidget);
    expect(find.byKey(const Key('alerts_toggle_switch')), findsOneWidget);
    await tester.tap(find.byKey(const Key('alerts_toggle_switch')));
    await tester.pumpAndSettle();

    // 6. Verify Bottom Action Buttons
    expect(find.text('Share Status'), findsOneWidget);
    expect(find.text('Get Support'), findsOneWidget);
    expect(find.byKey(const Key('share_status_button')), findsOneWidget);
    expect(find.byKey(const Key('get_support_button')), findsOneWidget);

    // 7. Test Interactions:
    // Copy Tracking ID
    await tester.tap(find.byKey(const Key('copy_tracking_button')));
    await tester.pumpAndSettle();
    expect(copyTrackingPressed, isTrue);

    // Call Courier
    await tester.tap(find.byKey(const Key('call_courier_button')));
    await tester.pumpAndSettle();
    expect(callCourierPressed, isTrue);

    // Share Status
    await tester.tap(find.byKey(const Key('share_status_button')));
    await tester.pumpAndSettle();
    expect(sharePressed, isTrue);

    // Get Support
    await tester.tap(find.byKey(const Key('get_support_button')));
    await tester.pumpAndSettle();
    expect(getSupportPressed, isTrue);

    // Gauge action
    await tester.tap(find.byKey(const Key('shipment_gauge_button')));
    await tester.pumpAndSettle();
    expect(gaugePressed, isTrue);

    // Profile action
    await tester.tap(find.byKey(const Key('shipment_profile_button')));
    await tester.pumpAndSettle();
    expect(profilePressed, isTrue);

    // Back action
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('ReturnRequestScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool lockPressed = false;
    bool profilePressed = false;
    bool changePickupPressed = false;
    bool cancelAndKeepPressed = false;
    Map<String, dynamic>? submittedData;

    await tester.pumpWidget(
      MaterialApp(
        home: ReturnRequestScreen(
          orderId: 'TK-89421',
          deliveredDate: 'Delivered Oct 14',
          estimatedRefund: 17845.38,
          customerName: 'Tanvir Ahmed',
          customerPhone: '(+880) 1712-984420',
          pickupAddress: 'House 42, Road 11, Block D, Banani,\nDhaka 1213',
          onBack: () => backPressed = true,
          onLockPressed: () => lockPressed = true,
          onProfilePressed: () => profilePressed = true,
          onChangePickupAddress: () => changePickupPressed = true,
          onCancelAndKeep: () => cancelAndKeepPressed = true,
          onSubmitReturn: (data) => submittedData = data,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byKey(const Key('return_lock_button')), findsOneWidget);
    expect(find.byKey(const Key('return_profile_button')), findsOneWidget);

    // 2. Verify Order Reference Pill
    expect(find.text('Order #TK-89421'), findsOneWidget);
    expect(find.text('Delivered Oct 14'), findsOneWidget);
    expect(find.text('Eligible'), findsOneWidget);

    // 3. Verify Status & Guarantee Card
    expect(find.text('STATUS & GUARANTEE'), findsOneWidget);
    expect(find.text('7 Days Return Window'), findsOneWidget);
    expect(find.text('Full refund window valid until Oct 21, 2024'), findsOneWidget);
    expect(find.text('Estimated Refund'), findsOneWidget);
    expect(find.text('₹17,845.38'), findsNWidgets(2)); // in guarantee card + in product card

    // 4. Verify Product for Return Card
    expect(find.text('PRODUCT FOR RETURN'), findsOneWidget);
    expect(find.text('Chronos Ultra 2 GPS Editi...'), findsOneWidget);
    expect(find.text('Titanium Grey • 49mm Cellular Case'), findsOneWidget);
    expect(find.text('Complete in box'), findsOneWidget);
    expect(find.text('1x'), findsOneWidget);

    // 5. Verify Reason for Return Section
    expect(find.text('Reason for Return'), findsOneWidget);
    expect(find.text('Required *'), findsOneWidget);
    expect(find.text('Defective / Item Not Working'), findsOneWidget);
    expect(find.text('Wrong Item Delivered'), findsOneWidget);
    expect(find.text('Performance Not as Expected'), findsOneWidget);
    expect(find.text('Changed Mind / No Longer Needed'), findsOneWidget);
    expect(find.textContaining('Free reverse collection applies'), findsOneWidget);

    // Select 'Wrong Item Delivered'
    await tester.tap(find.byKey(const Key('reason_wrong_item')));
    await tester.pumpAndSettle();

    // 6. Verify Resolution Preference Section
    expect(find.text('Resolution Preference'), findsOneWidget);
    expect(find.text('Original Payment Method'), findsOneWidget);
    expect(find.text('TechKart Wallet Credit'), findsOneWidget);
    expect(find.text('+5% Bonus'), findsOneWidget);

    // Select Wallet Credit
    await tester.tap(find.byKey(const Key('resolution_wallet')));
    await tester.pumpAndSettle();

    // 7. Verify Issue Overview & Verification
    expect(find.text('Issue Overview & Verification'), findsOneWidget);
    expect(find.byKey(const Key('return_symptoms_field')), findsOneWidget);
    expect(find.textContaining('Visual Proof (Optional, Max 3)'), findsOneWidget);
    expect(find.text('Add Photo'), findsOneWidget);
    expect(find.text('Add Video'), findsOneWidget);

    // Tap Add Photo
    await tester.tap(find.byKey(const Key('add_photo_button')));
    await tester.pumpAndSettle();
    expect(find.text('2 of 3 added'), findsOneWidget);

    // Tap Remove Photo
    await tester.tap(find.byKey(const Key('remove_photo_button')));
    await tester.pumpAndSettle();
    expect(find.text('0 of 3 added'), findsOneWidget);

    // 8. Verify Pickup Details Card
    expect(find.text('Pickup Details'), findsOneWidget);
    expect(find.text('Change'), findsOneWidget);
    expect(find.textContaining('Tanvir Ahmed • (+880) 1712-984420'), findsOneWidget);
    expect(find.textContaining('House 42, Road 11, Block D, Banani'), findsOneWidget);
    expect(find.textContaining('Reverse collection by'), findsOneWidget);
    expect(find.textContaining('Apex Express'), findsOneWidget);

    // Tap Change pickup address
    await tester.tap(find.byKey(const Key('change_pickup_address_button')));
    await tester.pumpAndSettle();
    expect(changePickupPressed, isTrue);

    // 9. Verify Bottom Disclaimer & Actions
    expect(find.textContaining('By continuing, you confirm the item is packed'), findsOneWidget);
    expect(find.text('Submit Return Request'), findsOneWidget);
    expect(find.text('Cancel & Keep Item'), findsOneWidget);

    // Submit Return Request
    await tester.tap(find.byKey(const Key('submit_return_button')));
    await tester.pumpAndSettle();
    expect(submittedData, isNotNull);
    expect(submittedData?['reason'], 'wrong_item');
    expect(submittedData?['resolution'], 'wallet');

    // Cancel & Keep Item
    await tester.tap(find.byKey(const Key('cancel_keep_item_button')));
    await tester.pumpAndSettle();
    expect(cancelAndKeepPressed, isTrue);

    // Top Bar actions
    await tester.tap(find.byKey(const Key('return_lock_button')));
    await tester.pumpAndSettle();
    expect(lockPressed, isTrue);

    await tester.tap(find.byKey(const Key('return_profile_button')));
    await tester.pumpAndSettle();
    expect(profilePressed, isTrue);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pumpAndSettle();
    expect(backPressed, isTrue);
  });

  testWidgets('ReturnStatusScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool lockPressed = false;
    bool profilePressed = false;
    bool copyCaseIdPressed = false;
    bool trackAgentPressed = false;
    bool reschedulePressed = false;
    bool callCourierPressed = false;
    bool downloadSlipPressed = false;
    bool conciergeHelpPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: ReturnStatusScreen(
          onBack: () => backPressed = true,
          onLockPressed: () => lockPressed = true,
          onProfilePressed: () => profilePressed = true,
          onCopyCaseId: () => copyCaseIdPressed = true,
          onTrackAgent: () => trackAgentPressed = true,
          onReschedule: () => reschedulePressed = true,
          onCallCourier: () => callCourierPressed = true,
          onDownloadSlip: () => downloadSlipPressed = true,
          onConciergeHelp: () => conciergeHelpPressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byKey(const Key('return_status_lock_button')), findsOneWidget);
    expect(find.byKey(const Key('return_status_profile_button')), findsOneWidget);

    // 2. Verify Case ID & Order Reference Header
    expect(find.text('Case ID: #RET-84920'), findsOneWidget);
    expect(find.text('Order #TK-89421'), findsOneWidget);
    expect(find.byKey(const Key('copy_case_id_button')), findsOneWidget);

    // 3. Verify Status & Refund Hero Card
    expect(find.text('Pickup Scheduled'), findsNWidgets(2)); // in hero card badge + in timeline title
    expect(find.text('Visa •••• 4092'), findsOneWidget);
    expect(find.text('Estimated Refund'), findsOneWidget);
    expect(find.text('₹17,845.38'), findsNWidgets(2)); // in hero card + returned item card
    expect(find.text('Original payment method'), findsOneWidget);
    expect(find.text('Pickup: Tomorrow, Oct 28'), findsOneWidget);
    expect(find.textContaining('Between 10:00 AM – 2:00 PM'), findsOneWidget);
    expect(
      find.textContaining('Please hand over the device packed securely inside its original TechKart box'),
      findsOneWidget,
    );

    // 4. Verify Returned Item Card
    expect(find.text('RETURNED ITEM'), findsOneWidget);
    expect(find.text('Qty: 1'), findsOneWidget);
    expect(find.text('Chronos Ultra 2 GPS Edition'), findsOneWidget);
    expect(find.text('Titanium Grey • 49mm Cellular Case'), findsOneWidget);
    expect(find.text('Defective / Item Not Working'), findsOneWidget);

    // 5. Verify Lifecycle Progress Card
    expect(find.text('Lifecycle Progress'), findsOneWidget);
    expect(find.text('Updated 14m ago'), findsOneWidget);
    expect(find.text('Return Requested'), findsOneWidget);
    expect(find.text('Oct 26, 11:15 AM'), findsOneWidget);
    expect(find.textContaining('Approved instantly under TechKart 7-Day Hassle-Free Guarantee.'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.textContaining('Apex Express agent assigned to verify sealed packaging'), findsOneWidget);
    expect(find.text('Window: Tomorrow, 10:00 AM – 2:00 PM'), findsOneWidget);
    expect(find.text('Quality Inspection'), findsOneWidget);
    expect(find.text('Est. Oct 29'), findsOneWidget);
    expect(find.textContaining('Dhaka Hub diagnostics team evaluates touchscreen power failure diagnosis.'), findsOneWidget);
    expect(find.text('Refund Released'), findsOneWidget);
    expect(find.text('1–2 Business Days'), findsOneWidget);
    expect(find.textContaining('₹17,845.38 reversed to Visa card ending in 4092.'), findsOneWidget);

    // 6. Verify Logistics & Collection Card
    expect(find.text('Logistics & Collection'), findsOneWidget);
    expect(find.text('Reverse Logistics'), findsOneWidget);
    expect(find.text('Partner: Apex Express'), findsOneWidget);
    expect(find.text('APX-RET-4910'), findsOneWidget);
    expect(find.byKey(const Key('track_agent_button')), findsOneWidget);
    expect(find.text('Track Agent'), findsOneWidget);
    expect(find.textContaining('Tanvir Ahmed'), findsOneWidget);
    expect(find.textContaining('(+880) 1712-984420'), findsOneWidget);
    expect(find.text('House 42, Road 11, Block D, Banani, Dhaka 1213'), findsOneWidget);
    expect(find.byKey(const Key('reschedule_button')), findsOneWidget);
    expect(find.text('Reschedule'), findsOneWidget);
    expect(find.byKey(const Key('call_courier_button')), findsOneWidget);
    expect(find.text('Call Courier'), findsOneWidget);

    // 7. Verify Download Return Slip & Concierge Help
    expect(find.byKey(const Key('download_return_slip_button')), findsOneWidget);
    expect(find.text('Download Official Return Slip (PDF)'), findsOneWidget);
    expect(find.byKey(const Key('concierge_help_button')), findsOneWidget);
    expect(find.text('Need Concierge Help with this Return?'), findsOneWidget);

    // 8. Interaction Testing:
    // Copy Case ID
    await tester.tap(find.byKey(const Key('copy_case_id_button')));
    await tester.pump();
    expect(copyCaseIdPressed, isTrue);
    await tester.pump(const Duration(seconds: 3));
    await tester.pumpAndSettle();

    // Track Agent
    await tester.tap(find.byKey(const Key('track_agent_button')));
    await tester.pump();
    expect(trackAgentPressed, isTrue);

    // Reschedule
    await tester.tap(find.byKey(const Key('reschedule_button')));
    await tester.pump();
    expect(reschedulePressed, isTrue);

    // Call Courier
    await tester.tap(find.byKey(const Key('call_courier_button')));
    await tester.pump();
    expect(callCourierPressed, isTrue);

    // Download Slip
    await tester.tap(find.byKey(const Key('download_return_slip_button')));
    await tester.pump();
    expect(downloadSlipPressed, isTrue);

    // Concierge Help
    await tester.tap(find.byKey(const Key('concierge_help_button')));
    await tester.pump();
    expect(conciergeHelpPressed, isTrue);

    // Lock button
    await tester.tap(find.byKey(const Key('return_status_lock_button')));
    await tester.pump();
    expect(lockPressed, isTrue);

    // Profile button
    await tester.tap(find.byKey(const Key('return_status_profile_button')));
    await tester.pump();
    expect(profilePressed, isTrue);

    // Back button
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    expect(backPressed, isTrue);
  });

  testWidgets('CustomerProfileHubScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool notificationPressed = false;
    bool avatarPressed = false;
    bool editProfilePressed = false;
    bool settingsPressed = false;
    bool trackDeliveryPressed = false;
    bool orderHistoryPressed = false;
    bool returnsRefundsPressed = false;
    bool wishlistPressed = false;
    bool productReviewsPressed = false;
    bool savedAddressesPressed = false;
    bool paymentMethodsPressed = false;
    bool aiPreferencesPressed = false;
    bool notificationsAlertsPressed = false;
    bool languageRegionPressed = false;
    bool conciergeSupportPressed = false;
    bool appSettingsPressed = false;
    bool logoutPressed = false;
    int? selectedNavTab;

    await tester.pumpWidget(
      MaterialApp(
        home: CustomerProfileHubScreen(
          onNotificationPressed: () => notificationPressed = true,
          onProfileAvatarPressed: () => avatarPressed = true,
          onEditProfile: () => editProfilePressed = true,
          onSettings: () => settingsPressed = true,
          onTrackDelivery: () => trackDeliveryPressed = true,
          onOrderHistory: () => orderHistoryPressed = true,
          onReturnsRefunds: () => returnsRefundsPressed = true,
          onWishlist: () => wishlistPressed = true,
          onProductReviews: () => productReviewsPressed = true,
          onSavedAddresses: () => savedAddressesPressed = true,
          onPaymentMethods: () => paymentMethodsPressed = true,
          onAiPreferences: () => aiPreferencesPressed = true,
          onNotificationsAlerts: () => notificationsAlertsPressed = true,
          onLanguageRegion: () => languageRegionPressed = true,
          onConciergeSupport: () => conciergeSupportPressed = true,
          onAppSettings: () => appSettingsPressed = true,
          onLogout: () => logoutPressed = true,
          onNavTabSelected: (index) => selectedNavTab = index,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.text('TechKart'), findsOneWidget);
    expect(find.text('94103 • SF'), findsOneWidget);
    expect(find.byKey(const Key('hub_notifications_button')), findsOneWidget);
    expect(find.byKey(const Key('hub_profile_avatar_button')), findsOneWidget);

    // 2. Verify Title & Header Action Buttons
    expect(find.text('Account Hub'), findsOneWidget);
    expect(find.text('•'), findsWidgets);
    expect(find.byKey(const Key('hub_edit_profile_button')), findsOneWidget);
    expect(find.byKey(const Key('hub_settings_button')), findsOneWidget);

    // 3. Verify User Profile & VIP Card
    expect(find.text('Tanvir Ahmed'), findsOneWidget);
    expect(find.text('PLUS VIP'), findsOneWidget);
    expect(find.text('tanvir.ahmed@example.com'), findsOneWidget);
    expect(find.text('(+880) 1712-345678'), findsOneWidget);
    expect(find.text('14'), findsOneWidget);
    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('5'), findsOneWidget);
    expect(find.text('Wishlist'), findsOneWidget);
    expect(find.text('₹18,737.65'), findsOneWidget);
    expect(find.text('TechWallet'), findsOneWidget);

    // 4. Verify Active Delivery Banner
    expect(find.text('Sony WH-1000XM5 • Out for delivery'), findsOneWidget);
    expect(find.text('Arriving today by 5:30 PM • Banani'), findsOneWidget);
    expect(find.byKey(const Key('track_delivery_button')), findsOneWidget);

    // 5. Verify ORDERS & ACTIVITY Section
    expect(find.text('ORDERS & ACTIVITY'), findsOneWidget);
    expect(find.text('Order History'), findsOneWidget);
    expect(find.text('2 in progress'), findsOneWidget);
    expect(find.text('Returns & Refunds'), findsOneWidget);
    expect(find.text('1 active'), findsOneWidget);
    expect(find.text('Wishlist & Saved Items'), findsOneWidget);
    expect(find.text('5 items'), findsOneWidget);
    expect(find.text('Product Reviews'), findsOneWidget);
    expect(find.text('2 pending'), findsOneWidget);

    // 6. Verify PERSONAL & DELIVERY Section
    expect(find.text('PERSONAL & DELIVERY'), findsOneWidget);
    expect(find.text('Saved Addresses'), findsOneWidget);
    expect(find.text('House 42, Banani, Dhaka (Default)'), findsOneWidget);
    expect(find.text('Payment Methods'), findsOneWidget);
    expect(find.text('Mastercard •••• 4829, Visa •••• 4092'), findsOneWidget);
    expect(find.text('TechKart AI Preferences'), findsOneWidget);
    expect(find.text('Gadget alerts & smart specs matching'), findsOneWidget);

    // 7. Verify SUPPORT & PREFERENCES Section
    expect(find.text('SUPPORT & PREFERENCES'), findsOneWidget);
    expect(find.text('Notifications & Alerts'), findsOneWidget);
    expect(find.text('WhatsApp • ON'), findsOneWidget);
    expect(find.text('Language & Region'), findsOneWidget);
    expect(find.text('English (BD)'), findsOneWidget);
    expect(find.text('24/7 Concierge Support'), findsOneWidget);
    expect(find.text('Live Chat'), findsOneWidget);
    expect(find.text('App Settings & Privacy'), findsOneWidget);

    // 8. Verify Logout & Metadata
    expect(find.byKey(const Key('logout_button')), findsOneWidget);
    expect(find.text('Log Out of TechKart'), findsOneWidget);
    expect(find.text('TechKart iOS v2.4.1 (Build 4920)'), findsOneWidget);
    expect(find.text('Tailored with precision for Dhaka, BD'), findsOneWidget);

    // 9. Verify Bottom Nav Bar
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Categories'), findsOneWidget);
    expect(find.text('AI Search'), findsOneWidget);
    expect(find.text('Cart'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);

    // 10. Interactions:
    // Top Bar icons
    await tester.tap(find.byKey(const Key('hub_notifications_button')));
    await tester.pump();
    expect(notificationPressed, isTrue);

    await tester.tap(find.byKey(const Key('hub_profile_avatar_button')));
    await tester.pump();
    expect(avatarPressed, isTrue);

    // Header buttons
    await tester.tap(find.byKey(const Key('hub_edit_profile_button')));
    await tester.pump();
    expect(editProfilePressed, isTrue);

    await tester.tap(find.byKey(const Key('hub_settings_button')));
    await tester.pump();
    expect(settingsPressed, isTrue);

    // Stats tap
    await tester.tap(find.byKey(const Key('stat_orders_button')));
    await tester.pump();
    expect(orderHistoryPressed, isTrue);

    await tester.tap(find.byKey(const Key('stat_wishlist_button')));
    await tester.pump();
    expect(wishlistPressed, isTrue);

    await tester.tap(find.byKey(const Key('stat_wallet_button')));
    await tester.pump();
    expect(paymentMethodsPressed, isTrue);

    // Track button
    await tester.tap(find.byKey(const Key('track_delivery_button')));
    await tester.pump();
    expect(trackDeliveryPressed, isTrue);

    // List items tap
    await tester.tap(find.byKey(const Key('returns_refunds_item')));
    await tester.pump();
    expect(returnsRefundsPressed, isTrue);

    await tester.tap(find.byKey(const Key('product_reviews_item')));
    await tester.pump();
    expect(productReviewsPressed, isTrue);

    await tester.tap(find.byKey(const Key('saved_addresses_item')));
    await tester.pump();
    expect(savedAddressesPressed, isTrue);

    await tester.tap(find.byKey(const Key('ai_preferences_item')));
    await tester.pump();
    expect(aiPreferencesPressed, isTrue);

    await tester.tap(find.byKey(const Key('notifications_item')));
    await tester.pump();
    expect(notificationsAlertsPressed, isTrue);

    await tester.tap(find.byKey(const Key('language_region_item')));
    await tester.pump();
    expect(languageRegionPressed, isTrue);

    await tester.tap(find.byKey(const Key('concierge_support_item')));
    await tester.pump();
    expect(conciergeSupportPressed, isTrue);

    await tester.tap(find.byKey(const Key('app_settings_item')));
    await tester.pump();
    expect(appSettingsPressed, isTrue);

    // Logout tap
    await tester.tap(find.byKey(const Key('logout_button')));
    await tester.pump();
    expect(logoutPressed, isTrue);

    // Bottom nav tap
    await tester.tap(find.text('Home'));
    await tester.pump();
    expect(selectedNavTab, 0);
  });

  testWidgets('EditProfileScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool lockPressed = false;
    bool profilePressed = false;
    bool resetPressed = false;
    bool changePhotoPressed = false;
    bool removePhotoPressed = false;
    bool securityPressed = false;
    bool cancelPressed = false;
    Map<String, dynamic>? savedData;

    await tester.pumpWidget(
      MaterialApp(
        home: EditProfileScreen(
          onBack: () => backPressed = true,
          onLockPressed: () => lockPressed = true,
          onProfilePressed: () => profilePressed = true,
          onReset: () => resetPressed = true,
          onChangePhoto: () => changePhotoPressed = true,
          onRemovePhoto: () => removePhotoPressed = true,
          onManageSecurity: () => securityPressed = true,
          onSaveChanges: (data) => savedData = data,
          onCancel: () => cancelPressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byKey(const Key('edit_profile_lock_button')), findsOneWidget);
    expect(find.byKey(const Key('edit_profile_profile_button')), findsOneWidget);

    // 2. Verify Top Banner
    expect(find.text('SCR-38 • Profile Details'), findsOneWidget);
    expect(find.byKey(const Key('reset_profile_button')), findsOneWidget);
    expect(find.text('Reset'), findsOneWidget);

    // 3. Verify Photo Editor
    expect(find.byKey(const Key('change_photo_camera_button')), findsOneWidget);
    expect(find.byKey(const Key('change_photo_link')), findsOneWidget);
    expect(find.text('Change Photo'), findsOneWidget);
    expect(find.byKey(const Key('remove_photo_link')), findsOneWidget);
    expect(find.text('Remove'), findsOneWidget);
    expect(find.text('JPG, PNG or WEBP up to 5MB'), findsOneWidget);

    // 4. Verify Form Fields
    expect(find.text('Full Name'), findsOneWidget);
    expect(find.text('Legal Name'), findsOneWidget);
    expect(find.byKey(const Key('full_name_field')), findsOneWidget);

    expect(find.text('Email Address'), findsOneWidget);
    expect(find.byKey(const Key('email_field')), findsOneWidget);

    expect(find.text('Phone Number'), findsOneWidget);
    expect(find.text('+880'), findsOneWidget);
    expect(find.byKey(const Key('phone_field')), findsOneWidget);

    expect(find.text('Verified'), findsNWidgets(2)); // email + phone

    expect(find.text('Date of Birth'), findsOneWidget);
    expect(find.byKey(const Key('dob_field')), findsOneWidget);

    expect(find.text('Gender Preference'), findsOneWidget);
    expect(find.text('Male'), findsOneWidget);
    expect(find.text('Female'), findsOneWidget);
    expect(find.text('Other'), findsOneWidget);
    expect(find.text('Prefer not to say'), findsOneWidget);

    // 5. Verify Two-Step Verification Card
    expect(find.text('Two-Step Verification'), findsOneWidget);
    expect(find.text('Active'), findsOneWidget);
    expect(find.text('Active protection with SMS and Authenticator'), findsOneWidget);
    expect(find.byKey(const Key('manage_security_button')), findsOneWidget);
    expect(find.text('Manage Security Settings'), findsOneWidget);

    // 6. Verify Save & Cancel
    expect(find.byKey(const Key('save_changes_button')), findsOneWidget);
    expect(find.text('Save Changes'), findsOneWidget);
    expect(find.byKey(const Key('cancel_button')), findsOneWidget);
    expect(find.text('Cancel'), findsOneWidget);

    // 7. Interaction Testing:
    // Select Female Gender
    await tester.tap(find.byKey(const Key('gender_female')));
    await tester.pumpAndSettle();

    // Reset Form
    await tester.tap(find.byKey(const Key('reset_profile_button')));
    await tester.pumpAndSettle();
    expect(resetPressed, isTrue);

    // Change Photo Link
    await tester.tap(find.byKey(const Key('change_photo_link')));
    await tester.pump();
    expect(changePhotoPressed, isTrue);

    // Remove Photo Link
    await tester.tap(find.byKey(const Key('remove_photo_link')));
    await tester.pump();
    expect(removePhotoPressed, isTrue);

    // Camera button
    await tester.tap(find.byKey(const Key('change_photo_camera_button')));
    await tester.pump();

    // Manage Security
    await tester.tap(find.byKey(const Key('manage_security_button')));
    await tester.pump();
    expect(securityPressed, isTrue);

    // Save Changes
    await tester.tap(find.byKey(const Key('save_changes_button')));
    await tester.pumpAndSettle();
    expect(savedData, isNotNull);
    expect(savedData?['fullName'], 'Tanvir Ahmed');

    // Cancel
    await tester.tap(find.byKey(const Key('cancel_button')));
    await tester.pump();
    expect(cancelPressed, isTrue);

    // Top Bar actions
    await tester.tap(find.byKey(const Key('edit_profile_lock_button')));
    await tester.pump();
    expect(lockPressed, isTrue);

    await tester.tap(find.byKey(const Key('edit_profile_profile_button')));
    await tester.pump();
    expect(profilePressed, isTrue);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    expect(backPressed, isTrue);
  });

  testWidgets('AddressBookScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2000);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool lockPressed = false;
    bool profilePressed = false;
    SavedLocation? defaultSetResult;
    SavedLocation? editAddressResult;
    SavedLocation? deletedAddressResult;
    bool addNewAddressPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: AddressBookScreen(
          onBack: () => backPressed = true,
          onLockPressed: () => lockPressed = true,
          onProfilePressed: () => profilePressed = true,
          onSetDefault: (loc) => defaultSetResult = loc,
          onEditAddress: (loc) => editAddressResult = loc,
          onDeleteAddress: (loc) => deletedAddressResult = loc,
          onAddNewAddress: () => addNewAddressPressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Checkout'), findsOneWidget);
    expect(find.byKey(const Key('address_book_lock_button')), findsOneWidget);
    expect(find.byKey(const Key('address_book_profile_button')), findsOneWidget);

    // 2. Verify Saved Locations Header
    expect(find.text('Saved Locations'), findsOneWidget);
    expect(find.text('3 Addresses'), findsOneWidget);
    expect(find.text('Verified City Zone'), findsOneWidget);

    // 3. Verify Card 1: Home (Default)
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('DEFAULT ADDRESS'), findsOneWidget);
    expect(find.text('Tanvir Ahmed'), findsWidgets);
    expect(find.text('+880 1712-984420'), findsOneWidget);
    expect(find.text('House 42, Road 11, Block D'), findsOneWidget);
    expect(find.text('Banani, Dhaka - 1213, Bangladesh'), findsOneWidget);
    expect(find.text('Hand to reception if unavailable'), findsOneWidget);
    expect(find.text('Active for one-click checkout'), findsOneWidget);

    // 4. Verify Card 2: Office
    expect(find.text('Office'), findsOneWidget);
    expect(find.text('(TechKart HQ)'), findsOneWidget);
    expect(find.text('+880 1712-345678'), findsOneWidget);
    expect(find.text('Level 8, Silicon Tower, Gulshan-2 Avenue'), findsOneWidget);
    expect(find.text('Gulshan, Dhaka - 1212, Bangladesh'), findsOneWidget);
    expect(find.text('Mon–Fri: 9:00 AM – 6:00 PM'), findsOneWidget);

    // 5. Verify Card 3: Family Residence
    expect(find.text('Family Residence'), findsOneWidget);
    expect(find.text('Nusrat Jahan'), findsOneWidget);
    expect(find.text('+880 1911-554433'), findsOneWidget);
    expect(find.text('Apartment 4B, Green Lake Enclave, Sector 4'), findsOneWidget);
    expect(find.text('Uttara, Dhaka - 1230, Bangladesh'), findsOneWidget);

    // 6. Verify Dispatch Banner
    expect(
      find.text('Addresses are verified for guaranteed express dispatch across Dhaka metropolitan.'),
      findsOneWidget,
    );

    // 7. Verify Add New Address Button
    expect(find.byKey(const Key('add_new_address_button')), findsOneWidget);
    expect(find.text('Add New Address'), findsOneWidget);

    // 8. Interaction Testing:
    // Set Office as default
    await tester.tap(find.byKey(const Key('set_default_addr_office')));
    await tester.pumpAndSettle();
    expect(defaultSetResult?.id, 'addr_office');

    // Edit Home address
    await tester.tap(find.byKey(const Key('edit_address_addr_home')));
    await tester.pump();
    expect(editAddressResult?.id, 'addr_home');

    // Delete Family Residence
    await tester.tap(find.byKey(const Key('delete_address_addr_family')));
    await tester.pumpAndSettle();
    expect(deletedAddressResult?.id, 'addr_family');
    expect(find.text('Family Residence'), findsNothing);

    // Add New Address
    await tester.tap(find.byKey(const Key('add_new_address_button')));
    await tester.pump();
    expect(addNewAddressPressed, isTrue);

    // Top Bar actions
    await tester.tap(find.byKey(const Key('address_book_lock_button')));
    await tester.pump();
    expect(lockPressed, isTrue);

    await tester.tap(find.byKey(const Key('address_book_profile_button')));
    await tester.pump();
    expect(profilePressed, isTrue);

    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    expect(backPressed, isTrue);
  });

  testWidgets('NotificationsScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool profilePressed = false;
    bool markAllReadPressed = false;
    TechKartNotification? actionNotification;
    String? selectedFilter;

    await tester.pumpWidget(
      MaterialApp(
        home: NotificationsScreen(
          onBack: () => backPressed = true,
          onProfilePressed: () => profilePressed = true,
          onMarkAllRead: () => markAllReadPressed = true,
          onNotificationAction: (n) => actionNotification = n,
          onCategorySelected: (cat) => selectedFilter = cat,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.byKey(const Key('top_bar_mark_read_button')), findsOneWidget);
    expect(find.byKey(const Key('notifications_profile_button')), findsOneWidget);

    // 2. Verify Status Header
    expect(find.text('3 unread notifications'), findsOneWidget);
    expect(find.byKey(const Key('sub_header_mark_read_button')), findsOneWidget);

    // 3. Verify Filter Category Tabs
    expect(find.text('All (5)'), findsOneWidget);
    expect(find.text('Orders (2)'), findsOneWidget);
    expect(find.text('Deliveries (1)'), findsOneWidget);
    expect(find.text('Offers'), findsOneWidget);

    // 4. Verify Today Section
    expect(find.text('Today'), findsOneWidget);
    expect(find.text('2 New'), findsOneWidget);
    expect(find.text('Out for delivery today'), findsOneWidget);
    expect(find.text('12m ago'), findsOneWidget);
    expect(find.textContaining('Sony WH-1000XM5 is on the delivery van.'), findsOneWidget);
    expect(find.byKey(const Key('notif_action_notif_1')), findsOneWidget);
    expect(find.text('Track Courier'), findsOneWidget);

    expect(find.text('Return pickup scheduled #RET-8...'), findsOneWidget);
    expect(find.text('2h ago'), findsOneWidget);
    expect(find.textContaining('Apex Express agent pickup confirmed for tomorrow'), findsOneWidget);
    expect(find.byKey(const Key('notif_action_notif_2')), findsOneWidget);
    expect(find.text('View Status'), findsOneWidget);

    expect(find.text('Flash Sale: GaN Chargers & Cables'), findsOneWidget);
    expect(find.text('5h ago'), findsOneWidget);
    expect(find.textContaining('TECHFAST20'), findsOneWidget);

    // 5. Verify Yesterday Section
    expect(find.text('Yesterday'), findsOneWidget);
    expect(find.text('1 New'), findsOneWidget);
    expect(find.text('Two-Step Verification activated'), findsOneWidget);
    expect(find.text('4:15 PM'), findsOneWidget);
    expect(find.textContaining('New SMS verification device added'), findsOneWidget);
    expect(find.byKey(const Key('notif_action_notif_4')), findsOneWidget);
    expect(find.text('Review Security'), findsOneWidget);

    expect(find.text('Order #TK-89421 dispatched'), findsOneWidget);
    expect(find.text('10:30 AM'), findsOneWidget);
    expect(find.textContaining('Your Chronos Ultra 2 GPS Edition has departed'), findsOneWidget);

    // 6. Verify Earlier this week Section
    expect(find.text('Earlier this week'), findsOneWidget);
    expect(find.text('All Read'), findsOneWidget);
    expect(find.text('Welcome to TechKart VIP Plus'), findsOneWidget);
    expect(find.text('Oct 22'), findsOneWidget);
    expect(find.textContaining('5% bonus credit on all returns'), findsOneWidget);

    // 7. Interaction Testing:
    // Tap action button on Notification 1 (Track Courier)
    await tester.tap(find.byKey(const Key('notif_action_notif_1')));
    await tester.pump();
    expect(actionNotification?.id, 'notif_1');

    // Tap Category filter chip
    await tester.tap(find.byKey(const Key('filter_orders')));
    await tester.pumpAndSettle();
    expect(selectedFilter, 'Orders');

    // Switch back to All
    await tester.tap(find.byKey(const Key('filter_all')));
    await tester.pumpAndSettle();

    // Mark all read
    await tester.tap(find.byKey(const Key('sub_header_mark_read_button')));
    await tester.pumpAndSettle();
    expect(markAllReadPressed, isTrue);
    expect(find.text('0 unread notifications'), findsOneWidget);

    // Profile button
    await tester.tap(find.byKey(const Key('notifications_profile_button')));
    await tester.pump();
    expect(profilePressed, isTrue);

    // Back arrow
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    expect(backPressed, isTrue);
  });

  testWidgets('SettingsScreen renders all reference elements and handles interactions', (WidgetTester tester) async {
    tester.view.physicalSize = const Size(800, 2400);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(() {
      tester.view.resetPhysicalSize();
      tester.view.resetDevicePixelRatio();
    });

    bool backPressed = false;
    bool profilePressed = false;
    bool markAllReadPressed = false;
    String? searchQuery;
    bool appLanguagePressed = false;
    bool currencyDisplayPressed = false;
    bool appearancePressed = false;
    bool? orderAlertsVal;
    bool? dealsAlertsVal;
    bool? whatsappVal;
    bool changePasswordPressed = false;
    bool twoStepPressed = false;
    bool? biometricsVal;
    bool dataPrivacyPressed = false;
    bool helpCenterPressed = false;
    bool termsPressed = false;
    bool clearCachePressed = false;
    bool logoutPressed = false;

    await tester.pumpWidget(
      MaterialApp(
        home: SettingsScreen(
          onBack: () => backPressed = true,
          onProfilePressed: () => profilePressed = true,
          onMarkAllRead: () => markAllReadPressed = true,
          onSearchChanged: (q) => searchQuery = q,
          onAppLanguage: () => appLanguagePressed = true,
          onCurrencyDisplay: () => currencyDisplayPressed = true,
          onAppearance: () => appearancePressed = true,
          onOrderAlertsChanged: (v) => orderAlertsVal = v,
          onDealsAlertsChanged: (v) => dealsAlertsVal = v,
          onWhatsAppConciergeChanged: (v) => whatsappVal = v,
          onChangePassword: () => changePasswordPressed = true,
          onTwoStepVerification: () => twoStepPressed = true,
          onBiometricsChanged: (v) => biometricsVal = v,
          onDataPrivacy: () => dataPrivacyPressed = true,
          onHelpCenter: () => helpCenterPressed = true,
          onTermsOfService: () => termsPressed = true,
          onClearCache: () => clearCachePressed = true,
          onLogout: () => logoutPressed = true,
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1. Verify Top App Bar
    expect(find.byIcon(Icons.arrow_back), findsOneWidget);
    expect(find.text('Notifications'), findsOneWidget);
    expect(find.byKey(const Key('settings_mark_read_button')), findsOneWidget);
    expect(find.byKey(const Key('settings_profile_button')), findsOneWidget);

    // 2. Verify Search Bar
    expect(find.byKey(const Key('settings_search_field')), findsOneWidget);
    expect(find.text('Search settings, security, alerts...'), findsOneWidget);

    // 3. Verify PREFERENCES & LOCALIZATION
    expect(find.text('PREFERENCES & LOCALIZATION'), findsOneWidget);
    expect(find.text('App Language'), findsOneWidget);
    expect(find.text('English (US)'), findsOneWidget);
    expect(find.text('Currency Display'), findsOneWidget);
    expect(find.text('INR (₹) • Indian Rupee'), findsOneWidget);
    expect(find.text('Appearance'), findsOneWidget);
    expect(find.text('Light Mode (System Default)'), findsOneWidget);

    // 4. Verify NOTIFICATIONS & ALERTS
    expect(find.text('NOTIFICATIONS & ALERTS'), findsOneWidget);
    expect(find.text('Order & Delivery Alerts'), findsOneWidget);
    expect(find.text('Instant tracking updates via ...'), findsOneWidget);
    expect(find.byKey(const Key('switch_order_alerts')), findsOneWidget);

    expect(find.text('Deals & Price Drops'), findsOneWidget);
    expect(find.text('Flash discounts on saved wis...'), findsOneWidget);
    expect(find.byKey(const Key('switch_deals_alerts')), findsOneWidget);

    expect(find.text('WhatsApp Concierge'), findsOneWidget);
    expect(find.text('Dispatch OTPs and courier n...'), findsOneWidget);
    expect(find.byKey(const Key('switch_whatsapp_concierge')), findsOneWidget);

    // 5. Verify SECURITY & PRIVACY
    expect(find.text('SECURITY & PRIVACY'), findsOneWidget);
    expect(find.text('Change Password'), findsOneWidget);
    expect(find.text('Last updated 3 months ago'), findsOneWidget);

    expect(find.text('Two-Step Verification'), findsOneWidget);
    expect(find.text('ACTIVE'), findsOneWidget);
    expect(find.text('Primary method: SMS • (+1) •••• 892'), findsOneWidget);

    expect(find.text('Face ID / Biometrics'), findsOneWidget);
    expect(find.text('Fast checkout authentication'), findsOneWidget);
    expect(find.byKey(const Key('switch_biometrics')), findsOneWidget);

    expect(find.text('Data Privacy & Diagnostics'), findsOneWidget);
    expect(find.text('Manage shared device analytics'), findsOneWidget);

    // 6. Verify SUPPORT & LEGAL
    expect(find.text('SUPPORT & LEGAL'), findsOneWidget);
    expect(find.text('Help Center & FAQs'), findsOneWidget);
    expect(find.text('24/7 dedicated customer care'), findsOneWidget);

    expect(find.text('Terms of Service & 7-Day Guarantee'), findsOneWidget);
    expect(find.text('Buyer protection policies'), findsOneWidget);

    expect(find.text('Clear Local Cache'), findsOneWidget);
    expect(find.text('Free up 42.8 MB storage'), findsOneWidget);
    expect(find.byKey(const Key('clear_cache_button')), findsOneWidget);

    // 7. Verify Logout & Encryption Footer
    expect(find.byKey(const Key('settings_logout_button')), findsOneWidget);
    expect(find.text('Log Out of TechKart'), findsOneWidget);
    expect(find.text('End-to-End Encrypted Session'), findsOneWidget);
    expect(find.text('TechKart Mobile v2.4.1 (Build 4920) • Verified Build'), findsOneWidget);

    // 8. Interaction Testing:
    // Search field entry
    await tester.enterText(find.byKey(const Key('settings_search_field')), 'language');
    await tester.pump();
    expect(searchQuery, 'language');

    // Tap App Language
    await tester.tap(find.byKey(const Key('setting_app_language')));
    await tester.pump();
    expect(appLanguagePressed, isTrue);

    // Tap Currency Display
    await tester.tap(find.byKey(const Key('setting_currency_display')));
    await tester.pump();
    expect(currencyDisplayPressed, isTrue);

    // Tap Appearance
    await tester.tap(find.byKey(const Key('setting_appearance')));
    await tester.pump();
    expect(appearancePressed, isTrue);

    // Toggle Order Alerts switch
    await tester.tap(find.descendant(of: find.byKey(const Key('switch_order_alerts')), matching: find.byType(Switch)));
    await tester.pumpAndSettle();
    expect(orderAlertsVal, isFalse);

    // Toggle Deals Alerts switch
    await tester.tap(find.descendant(of: find.byKey(const Key('switch_deals_alerts')), matching: find.byType(Switch)));
    await tester.pumpAndSettle();
    expect(dealsAlertsVal, isTrue);

    // Toggle WhatsApp switch
    await tester.tap(find.descendant(of: find.byKey(const Key('switch_whatsapp_concierge')), matching: find.byType(Switch)));
    await tester.pumpAndSettle();
    expect(whatsappVal, isFalse);

    // Tap Change Password
    await tester.tap(find.byKey(const Key('setting_change_password')));
    await tester.pump();
    expect(changePasswordPressed, isTrue);

    // Tap Two-Step Verification
    await tester.tap(find.byKey(const Key('setting_two_step')));
    await tester.pump();
    expect(twoStepPressed, isTrue);

    // Toggle Biometrics switch
    await tester.tap(find.descendant(of: find.byKey(const Key('switch_biometrics')), matching: find.byType(Switch)));
    await tester.pumpAndSettle();
    expect(biometricsVal, isFalse);

    // Tap Data Privacy
    await tester.tap(find.byKey(const Key('setting_data_privacy')));
    await tester.pump();
    expect(dataPrivacyPressed, isTrue);

    // Tap Help Center
    await tester.tap(find.byKey(const Key('setting_help_center')));
    await tester.pump();
    expect(helpCenterPressed, isTrue);

    // Tap Terms of Service
    await tester.tap(find.byKey(const Key('setting_terms')));
    await tester.pump();
    expect(termsPressed, isTrue);

    // Tap Clear Cache
    await tester.tap(find.byKey(const Key('clear_cache_button')));
    await tester.pumpAndSettle();
    expect(clearCachePressed, isTrue);
    expect(find.text('Cache is currently clean (0.0 MB)'), findsOneWidget);

    // Tap Logout button
    await tester.tap(find.byKey(const Key('settings_logout_button')));
    await tester.pump();
    expect(logoutPressed, isTrue);

    // Mark all read button in top bar
    await tester.tap(find.byKey(const Key('settings_mark_read_button')));
    await tester.pump();
    expect(markAllReadPressed, isTrue);

    // Profile button
    await tester.tap(find.byKey(const Key('settings_profile_button')));
    await tester.pump();
    expect(profilePressed, isTrue);

    // Back arrow
    await tester.tap(find.byIcon(Icons.arrow_back));
    await tester.pump();
    expect(backPressed, isTrue);
  });
}
