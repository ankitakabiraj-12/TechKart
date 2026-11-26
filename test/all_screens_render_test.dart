import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:techkart/authentication/splash_screen.dart';
import 'package:techkart/authentication/onboarding.dart';
import 'package:techkart/authentication/login.dart';
import 'package:techkart/authentication/create_account.dart';
import 'package:techkart/authentication/otp_verfification.dart';
import 'package:techkart/authentication/forgot_password.dart';
import 'package:techkart/authentication/set_new_password.dart';

import 'package:techkart/navigation/main_navigation_shell.dart';
import 'package:techkart/navigation/categories.dart';
import 'package:techkart/navigation/subcategory_products.dart';
import 'package:techkart/navigation/search_overlay.dart';
import 'package:techkart/navigation/search_result.dart';

import 'package:techkart/product_details/product_details.dart';
import 'package:techkart/product_details/product_gallery.dart';
import 'package:techkart/product_details/product_specifications.dart';
import 'package:techkart/product_details/customer_reviews.dart';
import 'package:techkart/product_details/write_reviews.dart';

import 'package:techkart/wishlist/shopping_cart.dart';
import 'package:techkart/wishlist/wishlist.dart';

import 'package:techkart/checkout/delivery_address.dart';
import 'package:techkart/checkout/edit_address.dart';
import 'package:techkart/checkout/payment_method.dart';
import 'package:techkart/checkout/order_review.dart';
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

import 'package:techkart/ai_assistant/ai_visual_search_camera.dart';
import 'package:techkart/ai_assistant/ai_image_processing.dart';
import 'package:techkart/ai_assistant/visual_search_results.dart';
import 'package:techkart/ai_assistant/conversational_shopping_assistant.dart';
import 'package:techkart/ai_assistant/ai_chat_sessions.dart';

void main() {
  setUp(() {
    TestWidgetsFlutterBinding.ensureInitialized();
  });

  Widget wrapScreen(Widget screen) {
    return MaterialApp(
      home: screen,
    );
  }

  group('TechKart All Screens Smoke & Render Verification', () {
    testWidgets('SplashScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const SplashScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SplashScreen), findsOneWidget);
    });

    testWidgets('OnboardingScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const OnboardingScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(OnboardingScreen), findsOneWidget);
    });

    testWidgets('LoginScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const LoginScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('CreateAccountScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const CreateAccountScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CreateAccountScreen), findsOneWidget);
    });

    testWidgets('OtpVerificationScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const OtpVerificationScreen(destinationTarget: 'user@example.com')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(OtpVerificationScreen), findsOneWidget);
    });

    testWidgets('ForgotPasswordScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const ForgotPasswordScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ForgotPasswordScreen), findsOneWidget);
    });

    testWidgets('SetNewPasswordScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const SetNewPasswordScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SetNewPasswordScreen), findsOneWidget);
    });

    testWidgets('MainNavigationShell renders without error across all 5 tabs', (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      await tester.pumpWidget(wrapScreen(const MainNavigationShell(initialIndex: 0)));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(MainNavigationShell), findsOneWidget);

      // Switch to tab 1 (Categories)
      MainNavigationShell.switchToTab(tester.element(find.byType(MainNavigationShell)), 1);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CategoriesScreen), findsOneWidget);

      // Switch to tab 2 (AI Assistant)
      MainNavigationShell.switchToTab(tester.element(find.byType(MainNavigationShell)), 2);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ConversationalShoppingAssistantScreen), findsOneWidget);

      // Switch to tab 3 (Cart)
      MainNavigationShell.switchToTab(tester.element(find.byType(MainNavigationShell)), 3);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ShoppingCartScreen), findsOneWidget);

      // Switch to tab 4 (Profile)
      MainNavigationShell.switchToTab(tester.element(find.byType(MainNavigationShell)), 4);
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CustomerProfileHubScreen), findsOneWidget);
    });

    testWidgets('SubcategoryProductsScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const SubcategoryProductsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SubcategoryProductsScreen), findsOneWidget);
    });

    testWidgets('SearchOverlayScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const SearchOverlayScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SearchOverlayScreen), findsOneWidget);
    });

    testWidgets('SearchResultScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const SearchResultScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SearchResultScreen), findsOneWidget);
    });

    testWidgets('ProductDetailsScreen renders without error', (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      await tester.pumpWidget(wrapScreen(const ProductDetailsScreen(productId: 'chronos_ultra_2')));
      await tester.pump(const Duration(milliseconds: 200));
      expect(find.byType(ProductDetailsScreen), findsOneWidget);
    });

    testWidgets('ProductGalleryScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const ProductGalleryScreen(productId: 'chronos_ultra_2')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ProductGalleryScreen), findsOneWidget);
    });

    testWidgets('ProductSpecificationsScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const ProductSpecificationsScreen(productId: 'chronos_ultra_2')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ProductSpecificationsScreen), findsOneWidget);
    });

    testWidgets('CustomerReviewsScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const CustomerReviewsScreen(productId: 'chronos_ultra_2')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CustomerReviewsScreen), findsOneWidget);
    });

    testWidgets('WriteReviewsScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const WriteReviewsScreen(productId: 'chronos_ultra_2')));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(WriteReviewsScreen), findsOneWidget);
    });

    testWidgets('ShoppingCartScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const ShoppingCartScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ShoppingCartScreen), findsOneWidget);
    });

    testWidgets('WishlistScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const WishlistScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(WishlistScreen), findsOneWidget);
    });

    testWidgets('DeliveryAddressScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const DeliveryAddressScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(DeliveryAddressScreen), findsOneWidget);
    });

    testWidgets('EditAddressScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const EditAddressScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(EditAddressScreen), findsOneWidget);
    });

    testWidgets('PaymentMethodScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const PaymentMethodScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(PaymentMethodScreen), findsOneWidget);
    });

    testWidgets('OrderReviewScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const OrderReviewScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(OrderReviewScreen), findsOneWidget);
    });

    testWidgets('SecurePaymentScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const SecurePaymentScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SecurePaymentScreen), findsOneWidget);
    });

    testWidgets('OrderConfirmationScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const OrderConfirmationScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(OrderConfirmationScreen), findsOneWidget);
    });

    testWidgets('OrderHistoryScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const OrderHistoryScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(OrderHistoryScreen), findsOneWidget);
    });

    testWidgets('OrderDetailsScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const OrderDetailsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(OrderDetailsScreen), findsOneWidget);
    });

    testWidgets('ShipmentTrackingScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const ShipmentTrackingScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ShipmentTrackingScreen), findsOneWidget);
    });

    testWidgets('ReturnRequestScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const ReturnRequestScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ReturnRequestScreen), findsOneWidget);
    });

    testWidgets('ReturnStatusScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const ReturnStatusScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ReturnStatusScreen), findsOneWidget);
    });

    testWidgets('CustomerProfileHubScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const CustomerProfileHubScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(CustomerProfileHubScreen), findsOneWidget);
    });

    testWidgets('EditProfileScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const EditProfileScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(EditProfileScreen), findsOneWidget);
    });

    testWidgets('AddressBookScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const AddressBookScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AddressBookScreen), findsOneWidget);
    });

    testWidgets('NotificationsScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const NotificationsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(NotificationsScreen), findsOneWidget);
    });

    testWidgets('SettingsScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const SettingsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(SettingsScreen), findsOneWidget);
    });

    testWidgets('AiVisualSearchCameraScreen renders without error', (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      await tester.pumpWidget(wrapScreen(const AiVisualSearchCameraScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AiVisualSearchCameraScreen), findsOneWidget);
    });

    testWidgets('AiImageProcessingScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const AiImageProcessingScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AiImageProcessingScreen), findsOneWidget);
    });

    testWidgets('VisualSearchResultsScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const VisualSearchResultsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(VisualSearchResultsScreen), findsOneWidget);
    });

    testWidgets('ConversationalShoppingAssistantScreen renders without error', (tester) async {
      tester.view.physicalSize = const Size(412, 915);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(() => tester.view.resetPhysicalSize());
      addTearDown(() => tester.view.resetDevicePixelRatio());

      await tester.pumpWidget(wrapScreen(const ConversationalShoppingAssistantScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(ConversationalShoppingAssistantScreen), findsOneWidget);
    });

    testWidgets('AiChatSessionsScreen renders without error', (tester) async {
      await tester.pumpWidget(wrapScreen(const AiChatSessionsScreen()));
      await tester.pump(const Duration(milliseconds: 100));
      expect(find.byType(AiChatSessionsScreen), findsOneWidget);
    });
  });
}
