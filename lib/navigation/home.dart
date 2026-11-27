import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/api_client.dart';
import '../core/network/catalog_models.dart';
import '../core/network/product_resolver.dart';
import '../core/session_manager.dart';
import '../theme/bottom_navbar.dart';
import '../system/currency_service.dart';

/// TechKart Customer App – Home Screen
///
/// Pixel-perfect reproduction matching reference design and HTML structure:
/// 1. Native Status Bar respect via SafeArea.
/// 2. Header with logo, refined greeting ("Hello, Ankita!" subtly smaller, "Good morning ! ✨" prominent), notifications & profile.
/// 3. Oblong search input with dark navy camera/visual search button.
/// 4. Promotional Banner with "FLAGSHIP TECH" tag, headline, black CTA ("Shop Now →"), gadget composition & dot indicators.
/// 5. Categories shortcut rail with accurate vector icons for all 8 categories.
/// 6. New Arrivals & Launches with authentic local product images and black Add to Cart CTAs.
/// 7. Best Sellers compact product carousel with real product photography.
/// 8. Still Looking For These? horizontal card with actual thumbnail and dynamic history integration.
/// 9. Deals For You functional multi-slide promotional image carousel with pure black CTAs.
/// 10. Brands Spotlight with authentic official logos for Apple, Samsung, Sony, Dell, boAt, OnePlus, and JBL.
/// 11. More Products For You 2-column grid with authentic local assets and black Add to Cart CTAs.
/// 12. Preserved bottom navigation bar and dynamic backend integration.
class HomeScreen extends StatefulWidget {
  final int initialTabIndex;
  final bool showBottomNav;
  final ValueChanged<int>? onNavTabSelected;

  const HomeScreen({
    super.key,
    this.initialTabIndex = 0,
    this.showBottomNav = true,
    this.onNavTabSelected,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final Set<String> _wishlisted = {'samsung-galaxy-s24-ultra', 'apple-airpods-pro-2'};
  final ApiClient _apiClient = ApiClient();

  /// Dynamic browsing & search history tracker for "Still Looking for These?"
  static final List<Map<String, dynamic>> _browsingHistory = [];

  void _recordProductView({
    required String id,
    required String title,
    required String price,
    required String image,
    String? category,
    String? specs,
  }) {
    if (!mounted) return;
    setState(() {
      _browsingHistory.removeWhere((item) => item['id'] == id);
      _browsingHistory.insert(0, {
        'id': id,
        'title': title,
        'price': price,
        'image': image,
        'category': category ?? 'Electronics',
        'specs': specs ?? 'Verified Hardware',
      });
      if (_browsingHistory.length > 10) {
        _browsingHistory.removeLast();
      }
    });
  }

  late final ScrollController _scrollController;
  final ValueNotifier<double> _scrollOffsetNotifier = ValueNotifier<double>(0.0);

  // Deals For You Carousel Controller
  late final PageController _dealsPageController;
  int _currentDealsIndex = 0;
  Timer? _dealsAutoTimer;

  // Banner Carousel Indicator state
  int _currentBannerIndex = 0;

  List<ProductModel> _newArrivals = [];

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _dealsPageController = PageController();
    _startDealsAutoSlide();
    _loadWishlistFromBackend();
    _loadNewArrivals();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      _scrollOffsetNotifier.value = _scrollController.offset;
    }
  }

  void _startDealsAutoSlide() {
    _dealsAutoTimer?.cancel();
    _dealsAutoTimer = Timer.periodic(const Duration(seconds: 5), (_) {
      if (!mounted || !_dealsPageController.hasClients) return;
      final nextIndex = (_currentDealsIndex + 1) % _dealsSlides.length;
      _dealsPageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  Future<void> _loadNewArrivals() async {
    try {
      final res = await _apiClient.getProducts(limit: 6);
      if (res.success && res.data != null && mounted) {
        setState(() {
          _newArrivals = res.data!;
        });
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffsetNotifier.dispose();
    _dealsAutoTimer?.cancel();
    _dealsPageController.dispose();
    _apiClient.close();
    super.dispose();
  }

  Future<void> _loadWishlistFromBackend() async {
    final token = await _apiClient.tokenStorage.getToken();
    if (token == null || token.isEmpty) return;

    try {
      final res = await _apiClient.getWishlist();
      if (res.success && res.data != null && mounted) {
        final ids = res.data!.items.map((i) => i.productId).toSet();
        setState(() {
          for (final item in res.data!.items) {
            _wishlisted.add(item.slug);
            _wishlisted.add('${item.productId}');
          }
          if (ids.contains(102)) _wishlisted.add('apple-iphone-15-pro');
          if (ids.contains(101)) _wishlisted.add('sony-wh1000xm5-anc');
        });
      }
    } catch (_) {}
  }

  Future<void> _toggleWishlistForProduct(String id) async {
    HapticFeedback.selectionClick();
    final isFavorite = _wishlisted.contains(id);
    final targetId = ProductResolver.toProductId(id);

    setState(() {
      if (isFavorite) {
        _wishlisted.remove(id);
      } else {
        _wishlisted.add(id);
      }
    });

    try {
      if (!isFavorite) {
        final res = await _apiClient.addToWishlist(targetId);
        if (res.success && res.data != null) {
          SessionManager().updateWishlistCount(res.data!.summary.totalItems);
        }
      } else {
        final res = await _apiClient.removeFromWishlist(targetId);
        if (res.success && res.data != null) {
          SessionManager().updateWishlistCount(res.data!.summary.totalItems);
        }
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          if (isFavorite) {
            _wishlisted.add(id);
          } else {
            _wishlisted.remove(id);
          }
        });
      }
    }
  }

  void _onAddToCart(String title) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '$title added to cart.',
          style: GoogleFonts.literata(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        backgroundColor: const Color(0xFF000000),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 2),
      ),
    );
  }

  // =========================================================================
  // DATA COLLECTIONS FOR REFERENCE RECREATION
  // =========================================================================

  /// Categories specification with genuine representative icons
  static const List<Map<String, dynamic>> _categories = [
    {
      'name': 'Mobiles',
      'icon': Icons.smartphone_rounded,
      'categoryId': 1,
    },
    {
      'name': 'Laptops',
      'icon': Icons.laptop_mac_rounded,
      'categoryId': 2,
    },
    {
      'name': 'Audio',
      'icon': Icons.headphones_rounded,
      'categoryId': 6,
    },
    {
      'name': 'Gaming',
      'icon': Icons.sports_esports_rounded,
      'categoryId': 9,
    },
    {
      'name': 'Watches',
      'icon': Icons.watch_rounded,
      'categoryId': 7,
    },
    {
      'name': 'Cameras',
      'icon': Icons.camera_alt_rounded,
      'categoryId': 3,
    },
    {
      'name': 'Tablets',
      'icon': Icons.tablet_android_rounded,
      'categoryId': 13,
    },
    {
      'name': 'Accessories',
      'icon': Icons.cable_rounded,
      'categoryId': 5,
    },
  ];

  /// Brands with authentic local brand assets
  static const List<Map<String, String>> _brands = [
    {
      'name': 'Apple',
      'subtitle': 'Authorized',
      'logo': 'asset/brands/apple.png',
    },
    {
      'name': 'Samsung',
      'subtitle': 'Official',
      'logo': 'asset/brands/samsung.png',
    },
    {
      'name': 'Sony',
      'subtitle': 'Audio Pro',
      'logo': 'asset/brands/sony.png',
    },
    {
      'name': 'Dell',
      'subtitle': 'Computers',
      'logo': 'asset/brands/dell.png',
    },
    {
      'name': 'boAt',
      'subtitle': 'Lifestyle',
      'logo': 'asset/brands/boat.png',
    },
    {
      'name': 'OnePlus',
      'subtitle': 'Never Settle',
      'logo': 'asset/brands/oneplus.png',
    },
    {
      'name': 'JBL',
      'subtitle': 'Harman',
      'logo': 'asset/brands/jbl.png',
    },
  ];

  /// Deals For You promotional slides
  static const List<Map<String, dynamic>> _dealsSlides = [
    {
      'tag': 'Flash Deal ⚡',
      'timer': 'Ends in 03h:42m',
      'title': 'Up to 40% Off on Premium Audio & Gaming Gear',
      'mini1': {
        'tag': 'GAMING RIGS',
        'title': 'Razer BlackWidow V4',
        'price': '₹11,499',
        'mrp': '₹15,999',
        'image': 'asset/product_images/Computer-Accessories/rgb-mechanical-gaming-keyboard.jpg',
        'id': 'razer-blackwidow-v4',
      },
      'mini2': {
        'tag': 'STUDIO AUDIO',
        'title': 'JBL Boombox 3 Wi-Fi',
        'price': '₹36,999',
        'mrp': '₹49,999',
        'image': 'asset/carousel_wireless_speaker.jpg',
        'id': 'jbl-boombox-3',
      },
    },
    {
      'tag': 'Mega Drop ⚡',
      'timer': 'Ends in 05h:15m',
      'title': 'Next-Gen Foldables & Flagship Studio Acoustics',
      'mini1': {
        'tag': 'FOLDABLE TECH',
        'title': 'Aura Fold Ultra 5G',
        'price': '₹99,999',
        'mrp': '₹1,24,999',
        'image': 'asset/sug_lumina_fold.jpg',
        'id': 'aura-fold-ultra',
      },
      'mini2': {
        'tag': 'SPATIAL AUDIO',
        'title': 'Aura Studio ANC 4',
        'price': '₹18,999',
        'mrp': '₹24,999',
        'image': 'asset/aura_studio_anc.jpg',
        'id': 'aura-studio-anc',
      },
    },
    {
      'tag': 'Workspace Deal ⚡',
      'timer': 'Ends in 08h:30m',
      'title': 'Ultra-Fast GaN Architecture & Pro Creator Setups',
      'mini1': {
        'tag': 'FAST CHARGE',
        'title': 'GaN 65W Multi-Port',
        'price': '₹2,499',
        'mrp': '₹3,499',
        'image': 'asset/product_images/Chargers/gan-65w-fast-wall-charger.jpg',
        'id': 'gan-65w-charger',
      },
      'mini2': {
        'tag': 'CREATOR GEAR',
        'title': 'Pro Aluminum Stand',
        'price': '₹3,299',
        'mrp': '₹4,999',
        'image': 'asset/product_images/Electronic-Accessories/adjustable-aluminum-laptop-stand.jpg',
        'id': 'pro-aluminum-stand',
      },
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final screenWidth = mediaQuery.size.width;

    // Responsive 2-column grid child aspect ratio
    final double gridChildAspectRatio;
    if (screenWidth < 360) {
      gridChildAspectRatio = 0.58;
    } else if (screenWidth < 400) {
      gridChildAspectRatio = 0.63;
    } else {
      gridChildAspectRatio = 0.67;
    }

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFFFFFFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FD),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            // ===============================================================
            // SECTION 1: HEADER & GREETING
            // Starts strictly below actual Android system status bar
            // ===============================================================
            _buildTopHeader(topPadding),

            // ===============================================================
            // SCROLLABLE SCREEN CONTENT
            // ===============================================================
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 8),

                    // SECTION 2: SEARCH BAR
                    _buildSearchBar(),

                    const SizedBox(height: 10),

                    // SECTION 3: PROMOTIONAL HERO BANNER
                    _buildHeroPromotionalBanner(),

                    const SizedBox(height: 14),

                    // SECTION 4: CATEGORY SHORTCUTS
                    _buildCategoryShortcuts(),

                    const SizedBox(height: 16),

                    // SECTION 5: NEW ARRIVALS & LAUNCHES
                    _buildNewArrivalsSection(),

                    const SizedBox(height: 16),

                    // SECTION 6: BEST SELLERS
                    _buildBestSellersSection(),

                    const SizedBox(height: 16),

                    // SECTION 7: STILL LOOKING FOR THESE?
                    _buildStillLookingForTheseSection(),

                    const SizedBox(height: 16),

                    // SECTION 8: DEALS FOR YOU (FUNCTIONAL CAROUSEL)
                    _buildDealsForYouCarousel(),

                    const SizedBox(height: 16),

                    // SECTION 9: BRANDS SPOTLIGHT
                    _buildBrandsSpotlightSection(),

                    const SizedBox(height: 16),

                    // SECTION 10: MORE PRODUCTS FOR YOU
                    _buildMoreProductsForYouSection(gridChildAspectRatio),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ===============================================================
            // EXISTING BOTTOM NAVIGATION BAR (PRESERVED 100%)
            // ===============================================================
            if (widget.showBottomNav)
              TechKartBottomNavBar(
                currentIndex: 0, // Home tab active
                onTabSelected: (index) {
                  if (widget.onNavTabSelected != null) {
                    widget.onNavTabSelected!(index);
                  } else {
                    if (index == 1) {
                      AppNavigator.toCategories(context);
                    } else if (index == 2) {
                      AppNavigator.toConversationalShoppingAssistant(context);
                    } else if (index == 3) {
                      AppNavigator.toCart(context);
                    } else if (index == 4) {
                      AppNavigator.toCustomerProfileHub(context);
                    }
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // SECTION BUILDERS
  // =========================================================================

  /// 1. Top Header with Logo, adjusted Greeting, Bell & Profile buttons
  Widget _buildTopHeader(double topPadding) {
    return Container(
      color: Colors.white,
      padding: EdgeInsets.fromLTRB(20, topPadding > 0 ? topPadding + 6 : 14, 20, 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Logo & Greeting column
          Expanded(
            child: Row(
              children: [
                // Brand logo container: 48x48 rounded-2xl
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(7),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'asset/app_logo.png',
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) => Image.asset(
                        'asset/TechKart_Logo.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error2, stackTrace2) => const Icon(
                          Icons.shopping_bag_rounded,
                          color: Color(0xFF142D4E),
                          size: 24,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Greeting Texts
                Expanded(
                  child: ValueListenableBuilder<Map<String, dynamic>?>(
                    valueListenable: SessionManager().currentUserNotifier,
                    builder: (context, user, _) {
                      final fullName = (user?['full_name'] as String?)?.trim();
                      final firstName = (fullName != null && fullName.isNotEmpty)
                          ? fullName.split(' ').first
                          : 'Ankita';

                      final rawCity = (user?['city'] ?? '').toString().trim();
                      final rawPincode = (user?['pincode'] ?? '').toString().trim();
                      final locationLabel = (rawCity.isNotEmpty || rawPincode.isNotEmpty)
                          ? 'Deliver to ${[rawCity, rawPincode].where((s) => s.isNotEmpty).join(' ')}'
                          : 'Deliver to Behala 700064';

                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          // "Hello, Ankita!" - subtly reduced size as requested
                          Text(
                            'Hello, $firstName!',
                            style: GoogleFonts.literata(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000000),
                              letterSpacing: -0.1,
                              height: 1.15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 1.5),

                          // "Good morning ! ✨" - visually more prominent
                          Text(
                            'Good morning ! ✨',
                            style: GoogleFonts.literata(
                              fontSize: 19.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000000),
                              letterSpacing: -0.3,
                              height: 1.15,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2.0),

                          // Delivery location
                          Text(
                            locationLabel,
                            style: GoogleFonts.literata(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF64748B),
                              height: 1.1,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(width: 8),

          // Action buttons: Notification Bell with dark badge & Profile Avatar
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Notification button with dark badge (#142D4E)
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  AppNavigator.toOrderHistory(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: Stack(
                    clipBehavior: Clip.none,
                    alignment: Alignment.center,
                    children: [
                      const Icon(
                        Icons.notifications_none_rounded,
                        size: 21,
                        color: Color(0xFF000000),
                      ),
                      Positioned(
                        top: -2,
                        right: -1,
                        child: Container(
                          width: 16,
                          height: 16,
                          decoration: BoxDecoration(
                            color: const Color(0xFF142D4E),
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white,
                              width: 1.8,
                            ),
                          ),
                          child: const Center(
                            child: Text(
                              '3',
                              style: TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                                height: 1.0,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(width: 8),

              // Profile Avatar button
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  AppNavigator.toCustomerProfileHub(context);
                },
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFE2E8F0),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.04),
                        blurRadius: 4,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_outline_rounded,
                      size: 21,
                      color: Color(0xFF000000),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// 2. Search bar with oblong input and Navy Camera button
  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          // Oblong search input pill
          Expanded(
            child: GestureDetector(
              onTap: () {
                HapticFeedback.selectionClick();
                AppNavigator.toSearchOverlay(context);
              },
              child: Container(
                height: 48,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: const Color(0xFFE2E8F0),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 20,
                      color: Color(0xFF64748B),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        'Search for smartphones, laptops & more...',
                        style: GoogleFonts.literata(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF000000),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),

          const SizedBox(width: 10),

          // Navy Filter / Camera Button (#142D4E)
          GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              AppNavigator.toAiVisualSearchCamera(context);
            },
            child: Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xFF142D4E),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: const Color(0xFF142D4E).withValues(alpha: 0.28),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Center(
                child: Icon(
                  Icons.camera_alt_outlined,
                  size: 21,
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// 3. Promotional Hero Banner matching reference design and HTML layout
  Widget _buildHeroPromotionalBanner() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        children: [
          Container(
            height: 204,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFF142D4E),
              borderRadius: BorderRadius.circular(24),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF142D4E).withValues(alpha: 0.22),
                  blurRadius: 18,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(24),
              child: Stack(
                children: [
                  // Right side: Realistic Gadget Composition Mockup matching reference
                  Positioned(
                    right: 6,
                    top: 14,
                    bottom: 14,
                    width: 154,
                    child: Stack(
                      alignment: Alignment.center,
                      clipBehavior: Clip.none,
                      children: [
                        // Glowing Background Ring
                        Container(
                          width: 130,
                          height: 130,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.12),
                              width: 1.2,
                            ),
                          ),
                        ),

                        // Tablet Mockup in Background
                        Positioned(
                          right: 28,
                          top: 12,
                          child: Container(
                            width: 82,
                            height: 112,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0A192F),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF475569),
                                width: 2.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 10,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(6),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 18,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF475569),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: const Color(0xFF334155),
                                      width: 1,
                                    ),
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.smart_display_rounded,
                                      size: 16,
                                      color: Color(0xFF00FFC2),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: double.infinity,
                                  height: 3,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF1E293B),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Phone Mockup in Foreground
                        Positioned(
                          right: 12,
                          bottom: 12,
                          child: Container(
                            width: 58,
                            height: 98,
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F223A),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: const Color(0xFF94A3B8),
                                width: 2.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.5),
                                  blurRadius: 12,
                                  offset: const Offset(0, 5),
                                ),
                              ],
                            ),
                            padding: const EdgeInsets.all(4),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Container(
                                  width: 4,
                                  height: 4,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF00E5FF),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                Center(
                                  child: Text(
                                    'AI S24',
                                    style: GoogleFonts.literata(
                                      fontSize: 7.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFFCBD5E1),
                                    ),
                                  ),
                                ),
                                Container(
                                  width: 12,
                                  height: 2,
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF64748B),
                                    borderRadius: BorderRadius.circular(2),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Small Watch / Disc Gadget in front
                        Positioned(
                          right: 50,
                          bottom: 4,
                          child: Container(
                            width: 38,
                            height: 24,
                            decoration: BoxDecoration(
                              color: const Color(0xFFCBD5E1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: Colors.white,
                                width: 1.0,
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.35),
                                  blurRadius: 6,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.watch_rounded,
                                size: 14,
                                color: Color(0xFF0F172A),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  // Left Content
                  Padding(
                    padding: const EdgeInsets.fromLTRB(20, 18, 14, 18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            // Flagship Tech Tag
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 4,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.black,
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: Colors.black45,
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Container(
                                    width: 5,
                                    height: 5,
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Text(
                                    'FLAGSHIP TECH',
                                    style: GoogleFonts.literata(
                                      fontSize: 9.5,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                            const SizedBox(height: 8),

                            // Headline
                            Text(
                              'Upgrade Your Tech,\nElevate Life',
                              style: GoogleFonts.literata(
                                fontSize: 18.0,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                                height: 1.15,
                                letterSpacing: -0.2,
                              ),
                              maxLines: 2,
                            ),

                            const SizedBox(height: 4),

                            // Subtitle
                            SizedBox(
                              width: 175,
                              child: Text(
                                'Discover the latest technology and premium electronics at...',
                                style: GoogleFonts.literata(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFFCBD5E1),
                                  height: 1.25,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),

                        // Pure Black CTA Button (#000000) with pure white text
                        GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            AppNavigator.toCategories(context);
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF000000),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withValues(alpha: 0.4),
                                  blurRadius: 8,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'Shop Now',
                                  style: GoogleFonts.literata(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFFFFFFF),
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.arrow_forward_rounded,
                                  size: 13,
                                  color: Color(0xFFFFFFFF),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 8),

          // 4 Carousel Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(4, (dotIndex) {
              final isActive = dotIndex == _currentBannerIndex;
              return GestureDetector(
                onTap: () {
                  setState(() => _currentBannerIndex = dotIndex);
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: isActive ? 20 : 5,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF000000)
                        : (dotIndex == 1
                            ? const Color(0xFF142D4E)
                            : const Color(0xFFCBD5E1)),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  /// 4. Category shortcuts horizontal rail with accurate vector icons
  Widget _buildCategoryShortcuts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'CATEGORIES',
                style: GoogleFonts.literata(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: const Color(0xFF000000),
                ),
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  AppNavigator.toCategories(context);
                },
                child: Text(
                  'Explore All',
                  style: GoogleFonts.literata(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF142D4E),
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 8),

        SizedBox(
          height: 88,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _categories.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final cat = _categories[index];
              final String name = cat['name'] as String;
              final IconData iconData = cat['icon'] as IconData;
              final int categoryId = cat['categoryId'] as int;

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  AppNavigator.toSubcategoryProducts(
                    context,
                    category: CategoryModel(
                      id: categoryId,
                      name: name,
                      slug: name.toLowerCase(),
                    ),
                    categoryName: name,
                  );
                },
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // 56x56 circular icon pill
                    Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F4F8), // brand mist
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFFE5ECF4), // brand ice
                          width: 1.0,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.02),
                            blurRadius: 4,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Center(
                        child: Icon(
                          iconData,
                          size: 24,
                          color: const Color(0xFF142D4E),
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      name,
                      style: GoogleFonts.literata(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 5. New Arrivals & Launches Horizontal Rail with real local assets
  Widget _buildNewArrivalsSection() {
    final List<Map<String, dynamic>> itemsToShow;

    if (_newArrivals.isNotEmpty) {
      itemsToShow = _newArrivals.take(4).map((prod) {
        return {
          'id': '${prod.id}',
          'brand': prod.brandName ?? (prod.categoryName ?? 'TechKart'),
          'title': prod.title,
          'specs': prod.description != null && prod.description!.isNotEmpty
              ? (prod.description!.length > 28 ? '${prod.description!.substring(0, 28)}...' : prod.description!)
              : (prod.categoryName ?? 'Verified Hardware'),
          'price': CurrencyService.formatInr(prod.price, showDecimals: false),
          'mrp': CurrencyService.formatInr(
              (prod.mrp != null && prod.mrp! > prod.price)
                  ? prod.mrp!
                  : prod.price * 1.1,
              showDecimals: false),
          'image': prod.primaryImageUrl ?? 'asset/product_images/Mobiles/samsung-galaxy-s25-ultra.jpg',
        };
      }).toList();
    } else {
      itemsToShow = [
        {
          'id': 'samsung-galaxy-s24-ultra',
          'brand': 'Samsung',
          'title': 'Galaxy S24 Ultra 5G',
          'specs': 'Titanium Gray • 256GB',
          'price': '₹1,29,999',
          'mrp': '₹1,34,999',
          'image': 'asset/product_images/Mobiles/samsung-galaxy-s25-ultra.jpg',
        },
        {
          'id': 'apple-macbook-pro-14',
          'brand': 'Apple',
          'title': 'MacBook Pro 14"',
          'specs': 'Space Black • 18GB/512GB',
          'price': '₹1,69,900',
          'mrp': '₹1,79,900',
          'image': 'asset/product_images/Laptops/macbook-pro-16-space-black.jpg',
        },
        {
          'id': 'pixel-watch-2-lte',
          'brand': 'Google',
          'title': 'Pixel Watch 2 LTE',
          'specs': 'Matte Black • Active Band',
          'price': '₹39,900',
          'mrp': '₹43,900',
          'image': 'asset/subcategories/07_smartwatches.jpg',
        },
      ];
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Section Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'NEW ARRIVALS & LAUNCHES',
                    style: GoogleFonts.literata(
                      fontSize: 15.0,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.2,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 1),
                  Text(
                    "Discover What's New in Tech",
                    style: GoogleFonts.literata(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  AppNavigator.toCategories(context);
                },
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Explore',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF142D4E),
                      ),
                    ),
                    const SizedBox(width: 2),
                    const Icon(
                      Icons.chevron_right_rounded,
                      size: 15,
                      color: Color(0xFF142D4E),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Horizontal Product Cards
        SizedBox(
          height: 278,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: itemsToShow.length,
            separatorBuilder: (_, _) => const SizedBox(width: 14),
            itemBuilder: (context, index) {
              final item = itemsToShow[index];
              final String id = item['id'] as String;
              final isFavorite = _wishlisted.contains(id);

              return Container(
                width: 194,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE5ECF4),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.03),
                      blurRadius: 8,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Top row: NEW badge & Wishlist Heart
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 7,
                            vertical: 2.5,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF173D32), // Evergreen
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            'NEW',
                            style: GoogleFonts.literata(
                              fontSize: 8.5,
                              fontWeight: FontWeight.w800,
                              color: Colors.white,
                              letterSpacing: 0.5,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleWishlistForProduct(id),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 17,
                            color: isFavorite
                                ? const Color(0xFFE11D48)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),

                    // Product Image: Real local asset with BoxFit.contain
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _recordProductView(
                          id: id,
                          title: item['title'] as String,
                          price: item['price'] as String,
                          image: item['image'] as String,
                          category: item['brand'] as String,
                          specs: item['specs'] as String,
                        );
                        AppNavigator.toProductDetails(context, productId: id);
                      },
                      child: Container(
                        height: 112,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          item['image'] as String,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(
                              Icons.devices_other_rounded,
                              size: 40,
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Product Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          (item['brand'] as String).toUpperCase(),
                          style: GoogleFonts.literata(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 0.6,
                            color: const Color(0xFF142D4E),
                          ),
                        ),
                        const SizedBox(height: 1),
                        Text(
                          item['title'] as String,
                          style: GoogleFonts.literata(
                            fontSize: 12.0,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000000),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item['specs'] as String,
                          style: GoogleFonts.literata(
                            fontSize: 10.0,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              item['price'] as String,
                              style: GoogleFonts.literata(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            const SizedBox(width: 5),
                            Text(
                              item['mrp'] as String,
                              style: GoogleFonts.literata(
                                fontSize: 10.0,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF94A3B8),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Add to Cart Button: Pure Black (#000000) with Pure White (#FFFFFF) text
                    GestureDetector(
                      onTap: () => _onAddToCart(item['title'] as String),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(
                              Icons.add_rounded,
                              size: 14,
                              color: Color(0xFFFFFFFF),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              'Add to Cart',
                              style: GoogleFonts.literata(
                                fontSize: 11.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFFFFFFF),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 6. Best Sellers compact product carousel with real assets
  Widget _buildBestSellersSection() {
    final bestSellers = [
      {
        'id': 'apple-iphone-15-pro',
        'title': 'iPhone 15 Pro',
        'specs': 'Natural • 128GB',
        'rating': '4.9',
        'reviews': '(1.2k)',
        'price': '₹1,27,990',
        'mrp': '₹1,34,900',
        'image': 'asset/product_images/Mobiles/iphone-16-pro-max.jpg',
      },
      {
        'id': 'sony-wh1000xm5-anc',
        'title': 'Sony WH-1000XM5',
        'specs': 'Silver • Wireless ANC',
        'rating': '4.8',
        'reviews': '(850)',
        'price': '₹29,990',
        'mrp': '₹34,990',
        'image': 'asset/product_images/Audio-Headphones/sony-wh1000xm5-wireless-headphones.jpg',
      },
      {
        'id': 'samsung-galaxy-tab-s9',
        'title': 'Galaxy Tab S9',
        'specs': 'Graphite • 128GB Wi-Fi',
        'rating': '4.7',
        'reviews': '(420)',
        'price': '₹68,999',
        'mrp': '₹74,999',
        'image': 'asset/subcategories/13_android-tablets-13.jpg',
      },
      {
        'id': 'dell-xps-13-oled',
        'title': 'Dell XPS 13 OLED',
        'specs': 'Platinum • Intel Evo i7',
        'rating': '4.8',
        'reviews': '(310)',
        'price': '₹1,39,990',
        'mrp': '₹1,49,990',
        'image': 'asset/subcategories/02_thin-light-laptops-2.jpg',
      },
    ];

    return Container(
      color: const Color(0xFFFBFBFD),
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'BEST SELLERS',
                      style: GoogleFonts.literata(
                        fontSize: 15.0,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.2,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      'Top customer favorites this week',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    AppNavigator.toCategories(context);
                  },
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'View All',
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF142D4E),
                        ),
                      ),
                      const SizedBox(width: 3),
                      const Icon(
                        Icons.arrow_forward_rounded,
                        size: 13,
                        color: Color(0xFF142D4E),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Horizontal Carousel
          SizedBox(
            height: 208,
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              itemCount: bestSellers.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) {
                final item = bestSellers[index];
                final String id = item['id']!;
                final isFavorite = _wishlisted.contains(id);

                return Container(
                  width: 148,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE5ECF4),
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 6,
                        offset: const Offset(0, 2),
                      ),
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      // Image stage with top-right wishlist icon
                      Stack(
                        children: [
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              _recordProductView(
                                id: id,
                                title: item['title']!,
                                price: item['price']!,
                                image: item['image']!,
                                specs: item['specs']!,
                              );
                              AppNavigator.toProductDetails(context, productId: id);
                            },
                            child: Container(
                              height: 94,
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF1F4F8).withValues(alpha: 0.7),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(6),
                              child: Image.asset(
                                item['image']!,
                                fit: BoxFit.contain,
                                errorBuilder: (context, error, stackTrace) =>
                                    const Icon(
                                  Icons.devices_rounded,
                                  size: 32,
                                  color: Color(0xFFCBD5E1),
                                ),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: GestureDetector(
                              onTap: () => _toggleWishlistForProduct(id),
                              child: Icon(
                                isFavorite
                                    ? Icons.favorite_rounded
                                    : Icons.favorite_border_rounded,
                                size: 15,
                                color: isFavorite
                                    ? const Color(0xFFE11D48)
                                    : const Color(0xFF64748B),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // Info
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item['title']!,
                            style: GoogleFonts.literata(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000000),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            item['specs']!,
                            style: GoogleFonts.literata(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF64748B),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 2),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                size: 12,
                                color: Color(0xFFF59E0B),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                item['rating']!,
                                style: GoogleFonts.literata(
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(width: 2),
                              Text(
                                item['reviews']!,
                                style: GoogleFonts.literata(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF94A3B8),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      // Price and Compact Add (+) Button
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['price']!,
                                  style: GoogleFonts.literata(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF000000),
                                    height: 1.1,
                                  ),
                                ),
                                Text(
                                  item['mrp']!,
                                  style: GoogleFonts.literata(
                                    fontSize: 8.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF94A3B8),
                                    decoration: TextDecoration.lineThrough,
                                    height: 1.1,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _onAddToCart(item['title']!),
                            child: Container(
                              width: 24,
                              height: 24,
                              decoration: BoxDecoration(
                                color: const Color(0xFF142D4E),
                                borderRadius: BorderRadius.circular(7),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.15),
                                    blurRadius: 3,
                                    offset: const Offset(0, 1),
                                  ),
                                ],
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.add_rounded,
                                  size: 15,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  /// 7. Still Looking For These? horizontal card
  Widget _buildStillLookingForTheseSection() {
    final Map<String, dynamic> targetItem;
    if (_browsingHistory.isNotEmpty) {
      targetItem = _browsingHistory.first;
    } else {
      targetItem = {
        'id': 'oneplus-12-5g',
        'title': 'OnePlus 12 5G (Flowy Emerald)',
        'price': '₹64,999',
        'image': 'asset/carousel_flagship_phone.jpg',
        'specs': 'Special Offer Available',
      };
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'STILL LOOKING FOR THESE?',
            style: GoogleFonts.literata(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: const Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            'Pick up where you left off.',
            style: GoogleFonts.literata(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 10),

          // Horizontal Rediscovery Card
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              gradient: const LinearGradient(
                colors: [
                  Color(0xFFF1F4F8),
                  Color(0xFFFFFFFF),
                ],
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
              ),
              borderRadius: BorderRadius.circular(18),
              border: Border.all(
                color: const Color(0xFFE5ECF4),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                // Product Thumbnail with real asset
                Container(
                  width: 58,
                  height: 58,
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: const Color(0xFF1E293B),
                      width: 1.0,
                    ),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(13),
                    child: Image.asset(
                      targetItem['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Center(
                        child: Text(
                          '1+ 12',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF10B981),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                const SizedBox(width: 12),

                // Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'RECENTLY VIEWED',
                        style: GoogleFonts.literata(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.6,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        targetItem['title'] as String,
                        style: GoogleFonts.literata(
                          fontSize: 12.0,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        spacing: 6,
                        children: [
                          Text(
                            targetItem['price'] as String,
                            style: GoogleFonts.literata(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF142D4E),
                            ),
                          ),
                          Text(
                            targetItem['specs'] as String? ?? 'Special Offer Available',
                            style: GoogleFonts.literata(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF173D32),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(width: 6),

                // View Product Button
                GestureDetector(
                  onTap: () {
                    HapticFeedback.selectionClick();
                    AppNavigator.toProductDetails(
                      context,
                      productId: targetItem['id'] as String,
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 8,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFE2E8F0),
                        width: 1.2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.03),
                          blurRadius: 4,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Text(
                      'View Product',
                      style: GoogleFonts.literata(
                        fontSize: 11.0,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF142D4E),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// 8. Deals For You functional promotional carousel
  Widget _buildDealsForYouCarousel() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'DEALS FOR YOU',
            style: GoogleFonts.literata(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: const Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            'Smart choices. Better prices.',
            style: GoogleFonts.literata(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 10),

          // Working Horizontal Promotional Carousel
          SizedBox(
            height: 246,
            child: PageView.builder(
              controller: _dealsPageController,
              itemCount: _dealsSlides.length,
              onPageChanged: (index) {
                setState(() {
                  _currentDealsIndex = index;
                });
              },
              itemBuilder: (context, index) {
                final slide = _dealsSlides[index];
                final mini1 = slide['mini1'] as Map<String, dynamic>;
                final mini2 = slide['mini2'] as Map<String, dynamic>;

                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF142D4E),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF142D4E).withValues(alpha: 0.25),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: Stack(
                      children: [
                        // Atmospheric Glow Spots
                        Positioned(
                          right: -30,
                          bottom: -30,
                          child: Container(
                            width: 140,
                            height: 140,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF173D32).withValues(alpha: 0.45),
                            ),
                          ),
                        ),
                        Positioned(
                          top: -20,
                          right: 60,
                          child: Container(
                            width: 110,
                            height: 110,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: const Color(0xFF5B2635).withValues(alpha: 0.45),
                            ),
                          ),
                        ),

                        // Slide Content
                        Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              // Flash deal tag & countdown timer
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 3,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF5B2635),
                                      borderRadius: BorderRadius.circular(16),
                                      border: Border.all(
                                        color: const Color(0xFFFDA4AF).withValues(alpha: 0.35),
                                        width: 1.0,
                                      ),
                                    ),
                                    child: Text(
                                      slide['tag'] as String,
                                      style: GoogleFonts.literata(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w700,
                                        color: Colors.white,
                                        letterSpacing: 0.5,
                                      ),
                                    ),
                                  ),
                                  Text(
                                    slide['timer'] as String,
                                    style: GoogleFonts.literata(
                                      fontSize: 11.0,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFFC5A46D), // brand gold
                                    ),
                                  ),
                                ],
                              ),

                              // Heading
                              Text(
                                slide['title'] as String,
                                style: GoogleFonts.literata(
                                  fontSize: 15.5,
                                  fontWeight: FontWeight.w700,
                                  color: Colors.white,
                                  height: 1.2,
                                ),
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                              ),

                              // 2 Nested Mini Deal Cards
                              Row(
                                children: [
                                  Expanded(
                                    child: _buildMiniDealCard(mini1),
                                  ),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: _buildMiniDealCard(mini2),
                                  ),
                                ],
                              ),

                              // Pure Black CTA Button (#000000) with white text
                              GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  AppNavigator.toCategories(context);
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 7.5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF000000),
                                    borderRadius: BorderRadius.circular(14),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.4),
                                        blurRadius: 6,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        'Shop Now',
                                        style: GoogleFonts.literata(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFFFFFFFF),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 13,
                                        color: Color(0xFFFFFFFF),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),

          const SizedBox(height: 8),

          // Deals Carousel Page Indicators
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(_dealsSlides.length, (idx) {
              final isActive = idx == _currentDealsIndex;
              return GestureDetector(
                onTap: () {
                  _dealsPageController.animateToPage(
                    idx,
                    duration: const Duration(milliseconds: 350),
                    curve: Curves.easeInOut,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: isActive ? 18 : 6,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFF142D4E)
                        : const Color(0xFFCBD5E1),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildMiniDealCard(Map<String, dynamic> mini) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        _recordProductView(
          id: mini['id'] as String,
          title: mini['title'] as String,
          price: mini['price'] as String,
          image: mini['image'] as String,
          specs: mini['tag'] as String,
        );
        AppNavigator.toProductDetails(
          context,
          productId: mini['id'] as String,
        );
      },
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Colors.white.withValues(alpha: 0.18),
            width: 1.0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    mini['tag'] as String,
                    style: GoogleFonts.literata(
                      fontSize: 8.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFC5A46D),
                      letterSpacing: 0.5,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: Colors.white10,
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Image.asset(
                      mini['image'] as String,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.flash_on_rounded, size: 12, color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Text(
              mini['title'] as String,
              style: GoogleFonts.literata(
                fontSize: 10.5,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Row(
              children: [
                Text(
                  mini['price'] as String,
                  style: GoogleFonts.literata(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF1F5F9),
                  ),
                ),
                const SizedBox(width: 4),
                Text(
                  mini['mrp'] as String,
                  style: GoogleFonts.literata(
                    fontSize: 8.5,
                    fontWeight: FontWeight.w400,
                    color: const Color(0xFF94A3B8),
                    decoration: TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /// 9. Brands Spotlight with genuine official brand logos
  Widget _buildBrandsSpotlightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'BRANDS SPOTLIGHT',
                style: GoogleFonts.literata(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.2,
                  color: const Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 1),
              Text(
                'Explore the brands you love.',
                style: GoogleFonts.literata(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w400,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        // Horizontal Brand Logo Cards
        SizedBox(
          height: 74,
          child: ListView.separated(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            scrollDirection: Axis.horizontal,
            physics: const BouncingScrollPhysics(),
            itemCount: _brands.length,
            separatorBuilder: (_, _) => const SizedBox(width: 10),
            itemBuilder: (context, index) {
              final b = _brands[index];

              return GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  AppNavigator.toCategories(context);
                },
                child: Container(
                  constraints: const BoxConstraints(minWidth: 88),
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F4F8), // brand mist
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: const Color(0xFFE5ECF4), // brand ice
                      width: 1.0,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 4,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Genuine Brand Logo
                      SizedBox(
                        height: 24,
                        child: Image.asset(
                          b['logo']!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) => Text(
                            b['name']!,
                            style: GoogleFonts.literata(
                              fontSize: 12.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        b['subtitle']!,
                        style: GoogleFonts.literata(
                          fontSize: 9.0,
                          fontWeight: FontWeight.w500,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  /// 10. More Products For You 2-column grid with authentic local assets & pure black CTAs
  Widget _buildMoreProductsForYouSection(double gridChildAspectRatio) {
    final products = [
      {
        'id': 'apple-airpods-pro-2',
        'badge': 'APPLE',
        'title': 'AirPods Pro (2nd Gen)',
        'specs': 'USB-C MagSafe Case',
        'rating': '4.9',
        'reviews': '(2.1k)',
        'price': '₹22,999',
        'mrp': '₹24,900',
        'image': 'asset/apex_buds_pro.jpg',
      },
      {
        'id': 'logitech-mx-master-3s',
        'badge': 'LOGITECH',
        'title': 'MX Master 3S Mouse',
        'specs': 'Performance Bluetooth',
        'rating': '4.8',
        'reviews': '(940)',
        'price': '₹8,995',
        'mrp': '₹10,995',
        'image': 'asset/product_images/Computer-Accessories/ergonomic-wireless-optical-mouse.jpg',
      },
      {
        'id': 'anker-735-gan-prime',
        'badge': 'ANKER',
        'title': 'Anker 735 GaN Prime',
        'specs': '3-Port Fast Charger',
        'rating': '4.7',
        'reviews': '(510)',
        'price': '₹4,499',
        'mrp': '₹5,999',
        'image': 'asset/product_images/Chargers/gan-65w-fast-wall-charger.jpg',
      },
      {
        'id': 'sony-ps5-dualsense',
        'badge': 'SONY',
        'title': 'PS5 DualSense Wireless',
        'specs': 'Midnight Black',
        'rating': '4.9',
        'reviews': '(1.8k)',
        'price': '₹5,790',
        'mrp': '₹6,390',
        'image': 'asset/festive_pulsepad_controller.jpg',
      },
    ];

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Text(
            'MORE PRODUCTS FOR YOU',
            style: GoogleFonts.literata(
              fontSize: 15.0,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.2,
              color: const Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 1),
          Text(
            'Explore more technology picked for you.',
            style: GoogleFonts.literata(
              fontSize: 11.5,
              fontWeight: FontWeight.w400,
              color: const Color(0xFF64748B),
            ),
          ),

          const SizedBox(height: 12),

          // 2-Column Responsive Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: gridChildAspectRatio,
            ),
            itemBuilder: (context, index) {
              final item = products[index];
              final String id = item['id']!;
              final isFavorite = _wishlisted.contains(id);

              return Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: const Color(0xFFE5ECF4),
                    width: 1.0,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.02),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Badge and Wishlist
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFE5ECF4), // brand ice
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            item['badge']!,
                            style: GoogleFonts.literata(
                              fontSize: 8.0,
                              fontWeight: FontWeight.w800,
                              color: const Color(0xFF142D4E),
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                        GestureDetector(
                          onTap: () => _toggleWishlistForProduct(id),
                          child: Icon(
                            isFavorite
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 15,
                            color: isFavorite
                                ? const Color(0xFFE11D48)
                                : const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),

                    // Product Image: Real asset with BoxFit.contain in light container
                    GestureDetector(
                      onTap: () {
                        HapticFeedback.lightImpact();
                        _recordProductView(
                          id: id,
                          title: item['title']!,
                          price: item['price']!,
                          image: item['image']!,
                          category: item['badge']!,
                          specs: item['specs']!,
                        );
                        AppNavigator.toProductDetails(context, productId: id);
                      },
                      child: Container(
                        height: 96,
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(6),
                        child: Image.asset(
                          item['image']!,
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) =>
                              const Center(
                            child: Icon(
                              Icons.devices_rounded,
                              size: 36,
                              color: Color(0xFFCBD5E1),
                            ),
                          ),
                        ),
                      ),
                    ),

                    // Details
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['title']!,
                          style: GoogleFonts.literata(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000000),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          item['specs']!,
                          style: GoogleFonts.literata(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF64748B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            const Icon(
                              Icons.star_rounded,
                              size: 12,
                              color: Color(0xFFF59E0B),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              item['rating']!,
                              style: GoogleFonts.literata(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            const SizedBox(width: 2),
                            Text(
                              item['reviews']!,
                              style: GoogleFonts.literata(
                                fontSize: 8.5,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF94A3B8),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 3),
                        Row(
                          children: [
                            Text(
                              item['price']!,
                              style: GoogleFonts.literata(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            const SizedBox(width: 4),
                            Text(
                              item['mrp']!,
                              style: GoogleFonts.literata(
                                fontSize: 9.5,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF94A3B8),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),

                    // Add to Cart Button: Pure Black (#000000) with Pure White (#FFFFFF) text
                    GestureDetector(
                      onTap: () => _onAddToCart(item['title']!),
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(vertical: 7),
                        decoration: BoxDecoration(
                          color: const Color(0xFF000000),
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.25),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Center(
                          child: Text(
                            'Add to Cart',
                            style: GoogleFonts.literata(
                              fontSize: 11.0,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFFFFFFFF),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
