import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// Authentication
import '../authentication/splash_screen.dart';
import '../authentication/onboarding.dart';
import '../authentication/login.dart';
import '../authentication/create_account.dart';
import '../authentication/otp_verfification.dart';
import '../authentication/forgot_password.dart';
import '../authentication/set_new_password.dart';

// Main Shell & Catalog Navigation
import '../core/network/catalog_models.dart';
import '../navigation/main_navigation_shell.dart';
import '../navigation/home.dart';
import '../navigation/categories.dart';
import '../navigation/subcategory_products.dart';
import '../navigation/search_overlay.dart';
import '../navigation/search_result.dart';

// Product Details
import '../product_details/product_details.dart';
import '../product_details/product_gallery.dart';
import '../product_details/product_specifications.dart';
import '../product_details/customer_reviews.dart';
import '../product_details/write_reviews.dart';

// Cart & Wishlist
import '../wishlist/shopping_cart.dart';
import '../wishlist/wishlist.dart';

// Checkout Flow
import '../checkout/delivery_address.dart';
import '../checkout/edit_address.dart';
import '../checkout/payment_method.dart';
import '../checkout/order_review.dart';
import '../checkout/secure_payment.dart';
import '../checkout/order_confirmation.dart';

// Orders & Tracking
import '../orders/order_history.dart';
import '../orders/order_details.dart';
import '../orders/shipment_tracking.dart';
import '../orders/return_request.dart';
import '../orders/return_status.dart';

// Profile & Settings
import '../profile_settings/customer_profile_hub.dart';
import '../profile_settings/edit_profile.dart';
import '../profile_settings/address_book.dart';
import '../profile_settings/notifications.dart';
import '../profile_settings/settings.dart';

// AI Assistant
import '../ai_assistant/ai_visual_search_camera.dart';
import '../ai_assistant/ai_image_processing.dart';
import '../ai_assistant/visual_search_results.dart';
import '../ai_assistant/conversational_shopping_assistant.dart';
import '../ai_assistant/ai_chat_sessions.dart';

// Admin Console
import '../admin/admin_dashboard.dart';
import '../admin/product_management.dart';
import '../admin/edit_product.dart';
import '../admin/inventory_management.dart';
import '../admin/admin_order_management.dart';

// System & Diagnostics
import '../system/offline_reconnection.dart';
import '../system/maintain_degradation.dart';

/// Centralized route constants for TechKart
class AppRoutes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String createAccount = '/create-account';
  static const String otpVerification = '/otp-verification';
  static const String forgotPassword = '/forgot-password';
  static const String setNewPassword = '/set-new-password';

  static const String mainShell = '/main-shell';
  static const String home = '/home';
  static const String categories = '/categories';
  static const String subcategoryProducts = '/subcategory-products';
  static const String searchOverlay = '/search-overlay';
  static const String searchResult = '/search-result';

  static const String productDetails = '/product-details';
  static const String productGallery = '/product-gallery';
  static const String productSpecifications = '/product-specifications';
  static const String customerReviews = '/customer-reviews';
  static const String writeReviews = '/write-reviews';

  static const String cart = '/cart';
  static const String wishlist = '/wishlist';
  static const String shoppingCart = '/shopping-cart';

  static const String deliveryAddress = '/delivery-address';
  static const String editAddress = '/edit-address';
  static const String paymentMethod = '/payment-method';
  static const String orderReview = '/order-review';
  static const String securePayment = '/secure-payment';
  static const String orderConfirmation = '/order-confirmation';

  static const String orderHistory = '/order-history';
  static const String orderDetails = '/order-details';
  static const String shipmentTracking = '/shipment-tracking';
  static const String returnRequest = '/return-request';
  static const String returnStatus = '/return-status';

  static const String customerProfileHub = '/customer-profile-hub';
  static const String editProfile = '/edit-profile';
  static const String addressBook = '/address-book';
  static const String notifications = '/notifications';
  static const String settings = '/settings';

  static const String aiVisualSearchCamera = '/ai-visual-search-camera';
  static const String aiImageProcessing = '/ai-image-processing';
  static const String visualSearchResults = '/visual-search-results';
  static const String conversationalShoppingAssistant =
      '/conversational-shopping-assistant';
  static const String aiChatSessions = '/ai-chat-sessions';

  static const String adminDashboard = '/admin-dashboard';
  static const String productManagement = '/product-management';
  static const String editProduct = '/edit-product';
  static const String inventoryManagement = '/inventory-management';
  static const String adminOrderManagement = '/admin-order-management';

  static const String offlineReconnection = '/offline-reconnection';
  static const String maintainDegradation = '/maintain-degradation';
}

/// Centralized App Navigator for TechKart
class AppNavigator {
  AppNavigator._();

  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();

  /// Custom smooth route transition builder
  static Route<T> _buildRoute<T>(Widget page, RouteSettings settings) {
    return PageRouteBuilder<T>(
      settings: settings,
      transitionDuration: const Duration(milliseconds: 320),
      reverseTransitionDuration: const Duration(milliseconds: 280),
      pageBuilder: (context, animation, secondaryAnimation) => page,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        final curvedAnimation = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutCubic,
        );
        return FadeTransition(
          opacity: curvedAnimation,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(0.04, 0),
              end: Offset.zero,
            ).animate(curvedAnimation),
            child: child,
          ),
        );
      },
    );
  }

  /// OnGenerateRoute handler registering all TechKart screens
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    final args = settings.arguments;

    switch (settings.name) {
      case AppRoutes.splash:
        return _buildRoute(const SplashScreen(), settings);

      case AppRoutes.onboarding:
        return _buildRoute(const OnboardingScreen(), settings);

      case AppRoutes.login:
        return _buildRoute(const LoginScreen(), settings);

      case AppRoutes.createAccount:
        return _buildRoute(const CreateAccountScreen(), settings);

      case AppRoutes.otpVerification:
        final target = args is String ? args : 'alex.m****@example.com';
        return _buildRoute(
          OtpVerificationScreen(destinationTarget: target),
          settings,
        );

      case AppRoutes.forgotPassword:
        return _buildRoute(const ForgotPasswordScreen(), settings);

      case AppRoutes.setNewPassword:
        return _buildRoute(const SetNewPasswordScreen(), settings);

      case AppRoutes.mainShell:
        final initialIndex = args is int ? args : 0;
        return _buildRoute(
          MainNavigationShell(initialIndex: initialIndex),
          settings,
        );

      case AppRoutes.home:
        return _buildRoute(const HomeScreen(), settings);

      case AppRoutes.categories:
        final tab = args is int ? args : 1;
        return _buildRoute(CategoriesScreen(initialTabIndex: tab), settings);

      case AppRoutes.subcategoryProducts:
        if (args is CategoryModel) {
          return _buildRoute(SubcategoryProductsScreen(category: args), settings);
        } else if (args is Map<String, dynamic>) {
          final cat = CategoryModel(
            id: args['id'] ?? 0,
            name: args['name'] ?? 'Category',
            slug: args['slug'] ?? '',
          );
          return _buildRoute(SubcategoryProductsScreen(category: cat), settings);
        }
        return _buildRoute(const SubcategoryProductsScreen(), settings);

      case AppRoutes.searchOverlay:
        final query = args is String ? args : 'Titanium watch';
        return _buildRoute(SearchOverlayScreen(initialQuery: query), settings);

      case AppRoutes.searchResult:
        final query = args is String ? args : 'Titanium watch';
        return _buildRoute(SearchResultScreen(query: query), settings);

      case AppRoutes.productDetails:
        final productId = args is String ? args : 'chronos_ultra_2';
        return _buildRoute(
          ProductDetailsScreen(productId: productId),
          settings,
        );

      case AppRoutes.productGallery:
        final productId = args is String ? args : 'chronos_ultra_2';
        return _buildRoute(
          ProductGalleryScreen(productId: productId),
          settings,
        );

      case AppRoutes.productSpecifications:
        final productId = args is String ? args : 'chronos_ultra_2';
        return _buildRoute(
          ProductSpecificationsScreen(productId: productId),
          settings,
        );

      case AppRoutes.customerReviews:
        final productId = args is String ? args : 'chronos_ultra_2';
        return _buildRoute(
          CustomerReviewsScreen(productId: productId),
          settings,
        );

      case AppRoutes.writeReviews:
        final productId = args is String ? args : 'chronos_ultra_2';
        return _buildRoute(WriteReviewsScreen(productId: productId), settings);

      case AppRoutes.cart:
        return _buildRoute(const ShoppingCartScreen(), settings);

      case AppRoutes.wishlist:
        return _buildRoute(const WishlistScreen(), settings);

      case AppRoutes.shoppingCart:
        return _buildRoute(const ShoppingCartScreen(), settings);

      case AppRoutes.deliveryAddress:
        return _buildRoute(const DeliveryAddressScreen(), settings);

      case AppRoutes.editAddress:
        final initialAddr = args is DeliveryAddress ? args : null;
        return _buildRoute(
          EditAddressScreen(initialAddress: initialAddr),
          settings,
        );

      case AppRoutes.paymentMethod:
        return _buildRoute(const PaymentMethodScreen(), settings);

      case AppRoutes.orderReview:
        final selectedAddr = args is DeliveryAddress ? args : null;
        return _buildRoute(
          OrderReviewScreen(selectedAddress: selectedAddr),
          settings,
        );

      case AppRoutes.securePayment:
        return _buildRoute(const SecurePaymentScreen(), settings);

      case AppRoutes.orderConfirmation:
        final orderId = args is String ? args : 'TK-89421';
        return _buildRoute(OrderConfirmationScreen(orderId: orderId), settings);

      case AppRoutes.orderHistory:
        return _buildRoute(const OrderHistoryScreen(), settings);

      case AppRoutes.orderDetails:
        final orderId = args is String ? args : 'TK-89421';
        return _buildRoute(OrderDetailsScreen(orderId: orderId), settings);

      case AppRoutes.shipmentTracking:
        final trackingId = args is String ? args : 'APX-982140';
        return _buildRoute(
          ShipmentTrackingScreen(trackingId: trackingId),
          settings,
        );

      case AppRoutes.returnRequest:
        final orderId = args is String ? args : 'TK-89421';
        return _buildRoute(ReturnRequestScreen(orderId: orderId), settings);

      case AppRoutes.returnStatus:
        final orderId = args is String ? args : 'TK-89421';
        return _buildRoute(ReturnStatusScreen(orderId: orderId), settings);

      case AppRoutes.customerProfileHub:
        return _buildRoute(const CustomerProfileHubScreen(), settings);

      case AppRoutes.editProfile:
        return _buildRoute(const EditProfileScreen(), settings);

      case AppRoutes.addressBook:
        return _buildRoute(const AddressBookScreen(), settings);

      case AppRoutes.notifications:
        return _buildRoute(const NotificationsScreen(), settings);

      case AppRoutes.settings:
        return _buildRoute(const SettingsScreen(), settings);

      case AppRoutes.aiVisualSearchCamera:
        return _buildRoute(const AiVisualSearchCameraScreen(), settings);

      case AppRoutes.aiImageProcessing:
        return _buildRoute(const AiImageProcessingScreen(), settings);

      case AppRoutes.visualSearchResults:
        return _buildRoute(const VisualSearchResultsScreen(), settings);

      case AppRoutes.conversationalShoppingAssistant:
        return _buildRoute(
          const ConversationalShoppingAssistantScreen(),
          settings,
        );

      case AppRoutes.aiChatSessions:
        return _buildRoute(const AiChatSessionsScreen(), settings);

      case AppRoutes.adminDashboard:
        return _buildRoute(const AdminDashboardScreen(), settings);

      case AppRoutes.productManagement:
        final filter = args is String ? args : null;
        return _buildRoute(
          ProductManagementScreen(initialFilter: filter),
          settings,
        );

      case AppRoutes.editProduct:
        if (args is Map<String, dynamic>) {
          return _buildRoute(
            EditProductScreen(
              productName: args['productName'] ?? 'Chronos Ultra 2 (49mm GPS)',
              sku: args['sku'] ?? 'TK-W9842',
              price: (args['price'] as num?)?.toDouble() ?? 429.00,
              compareAtPrice:
                  (args['compareAtPrice'] as num?)?.toDouble() ?? 499.00,
              stock: (args['stock'] as num?)?.toInt() ?? 3,
            ),
            settings,
          );
        }
        return _buildRoute(const EditProductScreen(), settings);

      case AppRoutes.inventoryManagement:
        final filter = args is String ? args : null;
        return _buildRoute(
          InventoryManagementScreen(initialFilter: filter),
          settings,
        );

      case AppRoutes.adminOrderManagement:
        return _buildRoute(const AdminOrderManagementScreen(), settings);

      case AppRoutes.offlineReconnection:
        return _buildRoute(const OfflineReconnectionScreen(), settings);

      case AppRoutes.maintainDegradation:
        return _buildRoute(const MaintainDegradationScreen(), settings);

      default:
        return _buildRoute(const SplashScreen(), settings);
    }
  }

  // ---------------------------------------------------------------------------
  // Core Generic Navigation Methods
  // ---------------------------------------------------------------------------

  static Future<T?> push<T>(BuildContext context, Widget screen) {
    return Navigator.of(context).push<T>(
      _buildRoute(screen, RouteSettings(name: screen.runtimeType.toString())),
    );
  }

  static Future<T?> replace<T, TO>(BuildContext context, Widget screen) {
    return Navigator.of(context).pushReplacement<T, TO>(
      _buildRoute(screen, RouteSettings(name: screen.runtimeType.toString())),
    );
  }

  static Future<T?> pushAndRemoveUntil<T>(BuildContext context, Widget screen) {
    return Navigator.of(context).pushAndRemoveUntil<T>(
      _buildRoute(screen, RouteSettings(name: screen.runtimeType.toString())),
      (route) => false,
    );
  }

  static Future<T?> pushNamedAndRemoveUntil<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamedAndRemoveUntil<T>(
      routeName,
      (route) => false,
      arguments: arguments,
    );
  }

  static Future<T?> replaceAll<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return pushNamedAndRemoveUntil<T>(context, routeName, arguments: arguments);
  }

  static Future<T?> pushNamed<T>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(context).pushNamed<T>(routeName, arguments: arguments);
  }

  static Future<T?> replaceNamed<T, TO>(
    BuildContext context,
    String routeName, {
    Object? arguments,
  }) {
    return Navigator.of(
      context,
    ).pushReplacementNamed<T, TO>(routeName, arguments: arguments);
  }

  static void pop<T>(BuildContext context, [T? result]) {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop<T>(result);
    }
  }

  // ---------------------------------------------------------------------------
  // Five-Tab Shell Helper (Home, Categories, AI Search, Cart, Profile)
  // ---------------------------------------------------------------------------

  /// Switches the active tab inside MainNavigationShell cleanly without duplicate pushes
  static void switchShellTab(BuildContext context, int tabIndex) {
    MainNavigationShell.switchToTab(context, tabIndex);
  }

  /// Pops all stacked screens until reaching MainNavigationShell, then switches tab
  static void popToRootAndSwitchTab(BuildContext context, int tabIndex) {
    Navigator.of(context).popUntil((route) => route.isFirst);
    MainNavigationShell.switchToTab(context, tabIndex);
  }

  // ---------------------------------------------------------------------------
  // Explicit Typed Screen Transitions
  // ---------------------------------------------------------------------------

  static Future<void> toSplash(BuildContext context) =>
      pushAndRemoveUntil(context, const SplashScreen());

  static Future<void> toOnboarding(BuildContext context) =>
      replace(context, const OnboardingScreen());

  static Future<void> toLogin(BuildContext context) =>
      replace(context, const LoginScreen());

  static Future<void> toCreateAccount(BuildContext context) =>
      push(context, const CreateAccountScreen());

  static Future<void> toOtpVerification(
    BuildContext context, {
    String? destination,
    String? destinationTarget,
    OtpFlowType flowType = OtpFlowType.passwordReset,
  }) => push(
    context,
    OtpVerificationScreen(
      destinationTarget: destinationTarget ?? destination ?? '',
      flowType: flowType,
    ),
  );

  static Future<void> toForgotPassword(BuildContext context) =>
      push(context, const ForgotPasswordScreen());

  static Future<void> toSetNewPassword(
    BuildContext context, {
    String email = '',
    String resetToken = '',
  }) =>
      push(
        context,
        SetNewPasswordScreen(
          email: email,
          resetToken: resetToken,
        ),
      );

  static Future<void> toMainShell(
    BuildContext context, {
    int initialIndex = 0,
  }) => pushAndRemoveUntil(
    context,
    MainNavigationShell(initialIndex: initialIndex),
  );

  static Future<void> toHome(BuildContext context) =>
      push(context, const HomeScreen());

  static Future<void> toCategories(
    BuildContext context, {
    int initialIndex = 1,
  }) => push(context, CategoriesScreen(initialTabIndex: initialIndex));

  static Future<void> toSubcategoryProducts(
    BuildContext context, {
    CategoryModel? category,
    String? categoryName,
    int? categoryId,
    String? categorySlug,
  }) {
    CategoryModel? cat = category;
    if (cat == null && (categoryName != null || categoryId != null)) {
      cat = CategoryModel(
        id: categoryId ?? 0,
        name: categoryName ?? 'Category',
        slug: categorySlug ?? '',
      );
    }
    return push(
      context,
      SubcategoryProductsScreen(category: cat),
    );
  }

  static Future<void> toSearchOverlay(
    BuildContext context, {
    String initialQuery = 'Titanium watch',
  }) => push(context, SearchOverlayScreen(initialQuery: initialQuery));

  static Future<void> toSearchResult(
    BuildContext context, {
    String query = 'Titanium watch',
    int? categoryId,
    int? subcategoryId,
    String? categoryName,
  }) => push(
        context,
        SearchResultScreen(
          query: query,
          categoryId: categoryId,
          subcategoryId: subcategoryId,
          categoryName: categoryName,
        ),
      );

  static Future<void> toProductDetails(
    BuildContext context, {
    String productId = 'chronos_ultra_2',
  }) => push(context, ProductDetailsScreen(productId: productId));

  static Future<void> toProductGallery(
    BuildContext context, {
    String productId = 'chronos_ultra_2',
  }) => push(context, ProductGalleryScreen(productId: productId));

  static Future<void> toProductSpecifications(
    BuildContext context, {
    String productId = 'chronos_ultra_2',
  }) => push(context, ProductSpecificationsScreen(productId: productId));

  static Future<void> toCustomerReviews(
    BuildContext context, {
    String productId = 'chronos_ultra_2',
  }) => push(context, CustomerReviewsScreen(productId: productId));

  static Future<void> toWriteReviews(
    BuildContext context, {
    String productId = 'chronos_ultra_2',
  }) => push(context, WriteReviewsScreen(productId: productId));

  static Future<void> toCart(BuildContext context) =>
      push(context, const ShoppingCartScreen());

  static Future<void> toWishlist(BuildContext context) =>
      push(context, const WishlistScreen());

  static Future<void> toShoppingCart(BuildContext context) =>
      push(context, const ShoppingCartScreen());

  static Future<void> toDeliveryAddress(BuildContext context) =>
      push(context, const DeliveryAddressScreen());

  static Future<void> toEditAddress(
    BuildContext context, {
    DeliveryAddress? initialAddress,
  }) => push(context, EditAddressScreen(initialAddress: initialAddress));

  static Future<void> toPaymentMethod(BuildContext context) =>
      push(context, const PaymentMethodScreen());

  static Future<void> toOrderReview(
    BuildContext context, {
    DeliveryAddress? selectedAddress,
  }) => push(context, OrderReviewScreen(selectedAddress: selectedAddress));

  static Future<void> toSecurePayment(BuildContext context) =>
      push(context, const SecurePaymentScreen());

  static Future<void> toOrderConfirmation(
    BuildContext context, {
    String orderId = 'TK-89421',
  }) => replace(context, OrderConfirmationScreen(orderId: orderId));

  static Future<void> toOrderHistory(BuildContext context) =>
      push(context, const OrderHistoryScreen());

  static Future<void> toOrderDetails(
    BuildContext context, {
    String orderId = 'TK-89421',
  }) => push(context, OrderDetailsScreen(orderId: orderId));

  static Future<void> toShipmentTracking(
    BuildContext context, {
    String trackingId = 'APX-982140',
  }) => push(context, ShipmentTrackingScreen(trackingId: trackingId));

  static Future<void> toReturnRequest(
    BuildContext context, {
    String orderId = 'TK-89421',
  }) => push(context, ReturnRequestScreen(orderId: orderId));

  static Future<void> toReturnStatus(
    BuildContext context, {
    String orderId = 'TK-89421',
    String? caseId,
  }) => push(
    context,
    ReturnStatusScreen(orderId: orderId, caseId: caseId ?? 'RET-84920'),
  );

  static Future<void> toCustomerProfileHub(BuildContext context) {
    if (MainNavigationShell.switchToTab(context, 4)) {
      Navigator.of(context).popUntil((route) => route.isFirst);
      return Future.value();
    }
    return push(context, const CustomerProfileHubScreen());
  }

  static Future<void> toProfile(BuildContext context) =>
      toCustomerProfileHub(context);

  static Future<void> toEditProfile(BuildContext context) =>
      push(context, const EditProfileScreen());

  static Future<void> toAddressBook(BuildContext context) =>
      push(context, const AddressBookScreen());

  static Future<void> toNotifications(BuildContext context) =>
      push(context, const NotificationsScreen());

  static Future<void> toSettings(BuildContext context) =>
      push(context, const SettingsScreen());

  static Future<void> toAiVisualSearchCamera(BuildContext context) =>
      push(context, const AiVisualSearchCameraScreen());

  static Future<void> toAiImageProcessing(BuildContext context) =>
      push(context, const AiImageProcessingScreen());

  static Future<void> toVisualSearchResults(BuildContext context) =>
      push(context, const VisualSearchResultsScreen());

  static Future<void> toConversationalShoppingAssistant(BuildContext context) =>
      push(context, const ConversationalShoppingAssistantScreen());

  static Future<void> toAiChatSessions(BuildContext context) =>
      push(context, const AiChatSessionsScreen());

  static Future<void> toAdminDashboard(BuildContext context) =>
      push(context, const AdminDashboardScreen());

  static Future<void> toProductManagement(
    BuildContext context, {
    String? filter,
  }) => push(context, ProductManagementScreen(initialFilter: filter));

  static Future<void> toEditProduct(
    BuildContext context, {
    String? productName,
    String? sku,
    double? price,
    double? compareAtPrice,
    int? stock,
  }) => push(
    context,
    EditProductScreen(
      productName: productName ?? 'Chronos Ultra 2 (49mm GPS)',
      sku: sku ?? 'TK-W9842',
      price: price ?? 40506.18,
      compareAtPrice: compareAtPrice ?? 47115.58,
      stock: stock ?? 3,
    ),
  );

  static Future<void> toInventoryManagement(
    BuildContext context, {
    String? filter,
  }) => push(context, InventoryManagementScreen(initialFilter: filter));

  static Future<void> toAdminOrderManagement(BuildContext context) =>
      push(context, const AdminOrderManagementScreen());

  static Future<void> toOfflineReconnection(BuildContext context) =>
      push(context, const OfflineReconnectionScreen());

  static Future<void> toMaintainDegradation(BuildContext context) =>
      push(context, const MaintainDegradationScreen());

  // Convenience aliases and workflow helpers
  static Future<void> toNotificationCenter(BuildContext context) =>
      toNotifications(context);

  static Future<void> toAiAssistantMain(BuildContext context) =>
      toConversationalShoppingAssistant(context);

  static Future<void> toSupportChat(BuildContext context) =>
      toConversationalShoppingAssistant(context);

  static Future<void> toOrderStatusDetails(
    BuildContext context, {
    String orderId = 'TK-89421',
  }) => toOrderDetails(context, orderId: orderId);

  static Future<void> toOrderTracking(
    BuildContext context, {
    String trackingId = 'APX-982140',
  }) => toShipmentTracking(context, trackingId: trackingId);

  static Future<void> toPaymentMethods(BuildContext context) =>
      toPaymentMethod(context);

  static Future<void> toReturnsRefunds(
    BuildContext context, {
    String orderId = 'TK-89421',
  }) => toReturnStatus(context, orderId: orderId);

  static Future<void> toSavedAddresses(BuildContext context) =>
      toAddressBook(context);

  static Future<void> toAiPreferences(BuildContext context) =>
      toConversationalShoppingAssistant(context);

  static Future<void> toLanguageRegion(BuildContext context) =>
      toSettings(context);
}
