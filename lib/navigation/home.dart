import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/api_client.dart';
import '../core/network/api_config.dart';
import '../core/network/catalog_models.dart';
import '../core/network/product_resolver.dart';
import '../core/session_manager.dart';
import '../theme/bottom_navbar.dart';
import '../theme/profile_avatar.dart';

/// TechKart Storefront Home Screen
///
/// 100% visual fidelity reproduction of the Storefront Home reference screen:
/// - Light airy background (#F5FAFF)
/// - Top bar: TechKart brand mark + "TechKart", Notification bell with red badge, user avatar.
/// - Location & Status Bar:
///   - "Delivering to Mumbai 400001" on left, "⚡ 24-h Fast" on right.
/// - Search Bar:
///   - Rounded search field (#EAF5FF) with search icon, "Search hardware, ecosystems, gear...",
///     voice mic icon, and AI camera visual search icon.
/// - Hero Showcase Card:
///   - Tag: "FLAGSHIP RELEASE"
///   - Heart wishlist button on top-right.
///   - Product image: `asset/apex_fold_buds_pro.jpg`
///   - Title: "Apex Fold & Buds Pro" in Domine bold serif.
///   - Subtitle: "The dual-display ultra-book paired with spatial acoustics. Engineered in 99% pure titanium with zero-gap dual screen hinge."
///   - Price: "PRE-ORDER FROM / ₹1,49,999" ($1,799 in INR)
///   - Action button: "Reserve →" (Dark navy)
///   - 2-dot carousel indicator.
/// - Categories Row:
///   - "Categories" header with right-aligned "BROWSE ALL (24)".
///   - Circular icon pills with label underneath:
///     - "Audio" (Headphones icon in soft sky-blue circle)
///     - "Phones" (Phone icon)
///     - "Docks" (Hub/dock icon)
///     - "Wearables" (Watch icon)
/// - Section: "Curated Drops" (Subtitle: "Selected by TechKart Engineering Partners", View All >):
///   - 2x2 Grid of Product Cards (White rounded 18px cards with tag, image, rating, title, specs, INR price, plus button):
///     1. "Aura Studio ANC" | Tag: "FLAGSHIP" | ★ 4.9 (1.2k) | "Dual 40mm beryllium drivers..." | ₹28,999
///     2. "Lumina Fold OLED" | Tag: "PRE-ORDER SPECIAL" | ★ 4.9 (480) | "144Hz folding display..." | ₹99,999
///     3. "Chronos Ultra X" | Tag: "AEROSPACE" | ★ 4.9 (2.1k) | "Titanium case with LTE..." | ₹28,999
///     4. "Volta 65W GaN" | Tag: "FAST CHARGE" | ★ 4.8 (3.4k) | "Dual Type-C ports, travel..." | ₹3,499
/// - Section: "Flagship Deals" (Subtitle: "Verified Hardware with Direct Warranty", View All >):
///   - 2x2 Grid:
///     1. "Apex Fold" | Tag: "ALL-IN-ONE" | ★ 4.9 (840) | "Pure titanium dual-screen..." | ₹1,24,999
///     2. "Omni Dock Station" | Tag: "COMPACT" | ★ 4.8 (920) | "Triple 4K display output..." | ₹12,999
///     3. "HyperDrive GaN" | Tag: "GaN" | ★ 4.9 (1.8k) | "High-efficiency thermal..." | ₹18,999
///     4. "Nova Buds Case" | Tag: "AUDIO" | ★ 4.7 (1.5k) | "40h total battery backup..." | ₹15,999
/// - Section: "Trending Audio & Wearables":
///   - 2x2 Grid:
///     1. "Aura Pro ANC 4" | ★ 4.9 (1.9k) | ₹12,499
///     2. "Chronos Light" | ★ 4.8 (890) | ₹15,999
///     3. "Revel Ear ANC" | ★ 4.9 (1.4k) | ₹18,999
///     4. "Orbit Band Track" | ★ 4.7 (760) | ₹24,999
/// - Section: "Workspace & Desk Setup":
///   - 2x2 Grid:
///     1. "SilentDesk Mat Pad" | Tag: "SUPPLE" | ★ 4.8 (1.1k) | ₹4,499
///     2. "NeoMonitor Hub" | Tag: "COPPER" | ★ 4.9 (610) | ₹9,499
///     3. "TetherDesk Magpad" | Tag: "SLATE" | ★ 4.7 (420) | ₹4,999
///     4. "AuraBar Max3" | Tag: "ALUMINUM" | ★ 4.8 (730) | ₹6,499
/// - Section: "Accessories & Fast Power":
///   - 2x2 Grid:
///     1. "AmpVolt GaN" | Tag: "65W POWER" | ★ 4.8 (2.4k) | ₹4,299
///     2. "Ambient Screen" | Tag: "SCREEN" | ★ 4.7 (890) | ₹7,999
///     3. "Terra Carbon Band" | Tag: "49MM" | ★ 4.9 (610) | ₹8,499
///     4. "VoltFast 140W Pro" | Tag: "140W OUTPUT" | ★ 4.9 (1.3k) | ₹7,499
/// - Bottom Guarantee Banner:
///   - Gold circular badge (G), "TECHKART DIRECT 1-YEAR",
///     "Direct replacement warranty, zero-question returns on verified hardware units."
///   - "Explore Return Policy →"
/// - Floating Bottom Navigation Bar (Home active).
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
  final Set<String> _wishlisted = {'apex_fold_hero'};
  final ApiClient _apiClient = ApiClient();

  late final ScrollController _scrollController;
  final ValueNotifier<double> _scrollOffsetNotifier = ValueNotifier<double>(0.0);

  late final PageController _campaignPageController;
  Timer? _campaignAutoTimer;
  int _currentCampaignIndex = 0;

  static const List<Map<String, String>> _campaignBanners = [
    {
      'id': 'camp_1',
      'tag': 'LIMITED EDITION',
      'headline': 'ULTIMATE TECH\nCOLLECTION',
      'scriptSub': 'Everything you need to conquer the day',
      'body': 'Handcrafted titanium gear, unified workspace ecosystems, and all-day wireless performance.',
      'buttonText': 'Explore Drop',
      'image': 'asset/campaigns/ultimate_tech_collection.png',
      'targetSlug': 'apex_fold_buds_pro',
      'bgGradientStart': '0xFF0D1420',
      'bgGradientEnd': '0xFF070B12',
      'accentColor': '0xFF00C6FF',
    },
    {
      'id': 'camp_2',
      'tag': 'STUDIO ACOUSTICS',
      'headline': 'SOUND WITHOUT\nLIMITS',
      'scriptSub': 'Hear every single dimension in pure silence',
      'body': 'Beryllium custom drivers, spatial audio tracking, and hybrid active noise cancellation.',
      'buttonText': 'Listen Now',
      'image': 'asset/campaigns/sound_without_limits.png',
      'targetSlug': 'aura_studio_anc',
      'bgGradientStart': '0xFF1A1528',
      'bgGradientEnd': '0xFF0A0714',
      'accentColor': '0xFFD4AF37',
    },
    {
      'id': 'camp_3',
      'tag': 'AEROSPACE GRADE',
      'headline': 'UPGRADE YOUR\nWRIST',
      'scriptSub': 'Forged in titanium for the extremes',
      'body': 'Sapphire crystal display, 100m water resistance, and multi-day telemetry tracking.',
      'buttonText': 'Order Now',
      'image': 'asset/campaigns/upgrade_your_wrist.png',
      'targetSlug': 'chronos_ultra_2',
      'bgGradientStart': '0xFF1A1A24',
      'bgGradientEnd': '0xFF0C0E14',
      'accentColor': '0xFFFF7A00',
    },
    {
      'id': 'camp_4',
      'tag': 'WORK & PLAY',
      'headline': 'POWER YOUR\nSETUP',
      'scriptSub': 'Peak mechanical tactility and precision flow',
      'body': 'Custom gasket-mounted keyboards, zero-lag ergonomic sensors, and high-fidelity desk DACs.',
      'buttonText': 'Upgrade Setup',
      'image': 'asset/campaigns/power_your_setup.png',
      'targetSlug': 'pro_ergo_mechanical_keyboard',
      'bgGradientStart': '0xFF0F1E29',
      'bgGradientEnd': '0xFF060D14',
      'accentColor': '0xFF1B365D',
    },
    {
      'id': 'camp_5',
      'tag': 'FLAGSHIP RELEASE',
      'headline': 'NEXT-LEVEL\nSMARTPHONES',
      'scriptSub': 'Cinematic optics with ultra-fast silicon',
      'body': 'Ultra-bright 144Hz AMOLED screen, periscope optical zoom, and ceramic nano-shielding.',
      'buttonText': 'Pre-Order',
      'image': 'asset/campaigns/next_level_smartphones.png',
      'targetSlug': 'aura_fold_pro',
      'bgGradientStart': '0xFF1F1124',
      'bgGradientEnd': '0xFF0B0512',
      'accentColor': '0xFFFF3366',
    },
    {
      'id': 'camp_6',
      'tag': 'FAST CHARGE',
      'headline': 'CHARGE\nFASTER',
      'scriptSub': 'Maximum wattage, minimum footprint',
      'body': '140W gallium nitride multi-port architecture with intelligent thermal dissipation.',
      'buttonText': 'Get Yours',
      'image': 'asset/campaigns/charge_faster.png',
      'targetSlug': 'carousel_fast_gan_charger',
      'bgGradientStart': '0xFF16212E',
      'bgGradientEnd': '0xFF080E17',
      'accentColor': '0xFFFFB300',
    },
    {
      'id': 'camp_7',
      'tag': 'TRAVEL ESSENTIAL',
      'headline': 'POWER THAT\nTRAVELS',
      'scriptSub': 'Magnetic snap-and-go energy anywhere',
      'body': 'Ultra-slim magnetic power cells with real-time percentage readout and pass-through flow.',
      'buttonText': 'Shop Power',
      'image': 'asset/campaigns/power_that_travels.png',
      'targetSlug': 'carousel_powerbank_mag',
      'bgGradientStart': '0xFF171B26',
      'bgGradientEnd': '0xFF090D17',
      'accentColor': '0xFF00FFC2',
    },
    {
      'id': 'camp_8',
      'tag': 'NEXT GENERATION',
      'headline': 'FUTURE IN\nYOUR HANDS',
      'scriptSub': 'Dual-screen zero-gap folding mastery',
      'body': 'Revolutionary micro-gear hinge engineered for seamless transitions and multi-tasking.',
      'buttonText': 'Reserve Now',
      'image': 'asset/campaigns/future_in_your_hands.png',
      'targetSlug': 'apex_fold_hero',
      'bgGradientStart': '0xFF1B162E',
      'bgGradientEnd': '0xFF0B0717',
      'accentColor': '0xFFB388FF',
    },
    {
      'id': 'camp_9',
      'tag': 'CREATOR ECOSYSTEM',
      'headline': 'BUILD YOUR\nDREAM SETUP',
      'scriptSub': 'Architectural balance for deep focus work',
      'body': 'Curved panoramic displays, acoustic paneling, studio monitors, and tailored ambient glow.',
      'buttonText': 'Design Now',
      'image': 'asset/campaigns/build_your_dream_setup.png',
      'targetSlug': 'silentdesk_mat_pad',
      'bgGradientStart': '0xFF191F26',
      'bgGradientEnd': '0xFF0A0D12',
      'accentColor': '0xFFFF9100',
    },
    {
      'id': 'camp_10',
      'tag': 'SMART INNOVATION',
      'headline': 'DISCOVER\nWHAT\'S NEXT',
      'scriptSub': 'Ambient intelligence woven into your space',
      'body': 'Holographic smart rings, floating status projectors, and touchless home automation.',
      'buttonText': 'Discover',
      'image': 'asset/campaigns/discover_whats_next.png',
      'targetSlug': 'neomonitor_hub',
      'bgGradientStart': '0xFF12222E',
      'bgGradientEnd': '0xFF061017',
      'accentColor': '0xFF00E676',
    },
  ];

  List<ProductModel> _newArrivals = [];
  bool _isLoadingNewArrivals = false;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(_onScroll);
    _campaignPageController = PageController();
    _startCampaignAutoSlide();
    _loadWishlistFromBackend();
    _loadNewArrivals();
  }

  void _onScroll() {
    if (_scrollController.hasClients) {
      _scrollOffsetNotifier.value = _scrollController.offset;
    }
  }

  Future<void> _loadNewArrivals() async {
    if (_isLoadingNewArrivals) return;
    setState(() => _isLoadingNewArrivals = true);
    try {
      final res = await _apiClient.getProducts(limit: 6);
      if (res.success && res.data != null && mounted) {
        setState(() {
          _newArrivals = res.data!;
          _isLoadingNewArrivals = false;
        });
      } else if (mounted) {
        setState(() => _isLoadingNewArrivals = false);
      }
    } catch (_) {
      if (mounted) setState(() => _isLoadingNewArrivals = false);
    }
  }

  void _startCampaignAutoSlide() {
    _campaignAutoTimer?.cancel();
    _campaignAutoTimer = Timer.periodic(const Duration(seconds: 4), (_) {
      if (!mounted || !_campaignPageController.hasClients) return;
      final nextIndex = (_currentCampaignIndex + 1) % _campaignBanners.length;
      _campaignPageController.animateToPage(
        nextIndex,
        duration: const Duration(milliseconds: 550),
        curve: Curves.easeInOutCubic,
      );
    });
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    _scrollOffsetNotifier.dispose();
    _campaignAutoTimer?.cancel();
    _campaignPageController.dispose();
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
          // Sync any known slugs or IDs
          for (final item in res.data!.items) {
            _wishlisted.add(item.slug);
            _wishlisted.add('${item.productId}');
          }
          if (ids.contains(12)) _wishlisted.add('chronos_ultra_2');
          if (ids.contains(16)) _wishlisted.add('carousel_fast_gan_charger');
          if (ids.contains(17)) _wishlisted.add('pro_ergo_mechanical_keyboard');
          if (ids.contains(19)) _wishlisted.add('aura_fold_pro');
          if (ids.contains(104)) _wishlisted.add('apex_fold_hero');
          if (ids.contains(101)) _wishlisted.add('aura_studio_anc');
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
      // Revert if API fails
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
          style: GoogleFonts.literata(fontSize: 13.5),
        ),
        backgroundColor: const Color(0xFF0D1B2A),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  Widget _buildPromotionalCarousel() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 220,
          child: PageView.builder(
            controller: _campaignPageController,
            itemCount: _campaignBanners.length,
            onPageChanged: (index) {
              setState(() {
                _currentCampaignIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final banner = _campaignBanners[index];
              final isFavorite = _wishlisted.contains(banner['id']!);
              final startColor = Color(int.parse(banner['bgGradientStart']!));
              final endColor = Color(int.parse(banner['bgGradientEnd']!));
              final accentColor = Color(int.parse(banner['accentColor']!));

              return GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  AppNavigator.toProductDetails(
                    context,
                    productId: banner['targetSlug']!,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 2),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [startColor, endColor],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.18),
                        blurRadius: 16,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(22),
                    child: Stack(
                      children: [
                        // Right half: Gadget Photography Hero Image
                        Positioned(
                          top: 0,
                          bottom: 0,
                          right: -10,
                          width: MediaQuery.of(context).size.width * 0.54,
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                banner['image']!,
                                fit: BoxFit.cover,
                                cacheWidth: 700,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: Colors.white10,
                                  child: const Icon(
                                    Icons.devices_other_rounded,
                                    color: Colors.white38,
                                    size: 40,
                                  ),
                                ),
                              ),
                              // Soft fade out to merge seamlessly with dark left panel
                              DecoratedBox(
                                decoration: BoxDecoration(
                                  gradient: LinearGradient(
                                    begin: Alignment.centerLeft,
                                    end: Alignment.centerRight,
                                    colors: [
                                      startColor,
                                      startColor.withValues(alpha: 0.75),
                                      Colors.transparent,
                                    ],
                                    stops: const [0.0, 0.22, 0.6],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Left content: Wendy's reference layout
                        Padding(
                          padding: const EdgeInsets.fromLTRB(18, 16, 12, 16),
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width * 0.52,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Pill Tag: "LIMITED TIME", "FLAGSHIP", etc.
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 3.5,
                                      ),
                                      decoration: BoxDecoration(
                                        color: accentColor.withValues(alpha: 0.18),
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          color: accentColor.withValues(alpha: 0.4),
                                          width: 0.8,
                                        ),
                                      ),
                                      child: Text(
                                        banner['tag']!,
                                        style: GoogleFonts.literata(
                                          fontSize: 8.5,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.8,
                                          color: accentColor,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(height: 7),
                                    // Headline: Bold, Condensed / Impactful
                                    Text(
                                      banner['headline']!,
                                      style: GoogleFonts.domine(
                                        fontSize: 16.5,
                                        fontWeight: FontWeight.w800,
                                        color: const Color(0xFFF5EBDD),
                                        height: 1.05,
                                        letterSpacing: -0.2,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 3),
                                    // Italic Script / Serif Sub-Headline
                                    Text(
                                      banner['scriptSub']!,
                                      style: GoogleFonts.playfairDisplay(
                                        fontSize: 11,
                                        fontStyle: FontStyle.italic,
                                        fontWeight: FontWeight.w500,
                                        color: accentColor,
                                      ),
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    const SizedBox(height: 5),
                                    // Body description text
                                    Text(
                                      banner['body']!,
                                      style: GoogleFonts.literata(
                                        fontSize: 9.5,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFFB0BEC5),
                                        height: 1.25,
                                      ),
                                      maxLines: 2,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                  ],
                                ),

                                // Rounded Pill Button with forward arrow in circle
                                GestureDetector(
                                  onTap: () {
                                    HapticFeedback.lightImpact();
                                    AppNavigator.toProductDetails(
                                      context,
                                      productId: banner['targetSlug']!,
                                    );
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.fromLTRB(12, 6, 6, 6),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFFFF5722),
                                          const Color(0xFFFF7043),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(20),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(0xFFFF5722)
                                              .withValues(alpha: 0.35),
                                          blurRadius: 8,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Text(
                                          banner['buttonText']!,
                                          style: GoogleFonts.literata(
                                            fontSize: 11,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFFF5EBDD),
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                            color: Color(0xFFF5EBDD),
                                            shape: BoxShape.circle,
                                          ),
                                          child: const Center(
                                            child: Icon(
                                              Icons.arrow_forward_rounded,
                                              size: 11,
                                              color: Color(0xFFFF5722),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        // Wishlist Heart Button at top right
                        Positioned(
                          top: 10,
                          right: 10,
                          child: GestureDetector(
                            onTap: () => _toggleWishlistForProduct(banner['id']!),
                            child: Container(
                              width: 30,
                              height: 30,
                              decoration: BoxDecoration(
                                color: Colors.black.withValues(alpha: 0.38),
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: const Color(0xFFF5EBDD).withValues(alpha: 0.25),
                                  width: 0.8,
                                ),
                              ),
                              child: Center(
                                child: Icon(
                                  isFavorite
                                      ? Icons.favorite_rounded
                                      : Icons.favorite_border_rounded,
                                  size: 15,
                                  color: isFavorite
                                      ? const Color(0xFFFF4081)
                                      : const Color(0xFFF5EBDD),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),

        const SizedBox(height: 12),

        // 10 Pagination Dots with active pill indicator
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            _campaignBanners.length,
            (dotIndex) {
              final isActive = dotIndex == _currentCampaignIndex;
              return GestureDetector(
                onTap: () {
                  _campaignPageController.animateToPage(
                    dotIndex,
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeInOutCubic,
                  );
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  margin: const EdgeInsets.symmetric(horizontal: 2.5),
                  width: isActive ? 18 : 6,
                  height: 5,
                  decoration: BoxDecoration(
                    color: isActive
                        ? const Color(0xFFFF5722)
                        : const Color(0xFF0D1B2A).withValues(alpha: 0.22),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildProductCard({
    required String id,
    required String title,
    required String specs,
    required String rating,
    required String price,
    required String image,
    String? tag,
    bool isNetworkImage = false,
  }) {
    final isFavorite = _wishlisted.contains(id);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        AppNavigator.toProductDetails(context, productId: id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1B2A).withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image stage
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(18)),
              child: AspectRatio(
                aspectRatio: 1.25,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Builder(builder: (context) {
                      final isAsset = image.startsWith('asset/');

                      if (isAsset) {
                        return Image.asset(
                          image,
                          fit: BoxFit.cover,
                          cacheWidth: 500,
                          errorBuilder: (context, error, stackTrace) => Image.network(
                            ApiConfig.resolveImageUrl(image),
                            fit: BoxFit.cover,
                            cacheWidth: 500,
                            errorBuilder: (context, error2, stackTrace2) => Container(
                              color: const Color(0xFFE6C17A),
                              child: const Icon(Icons.devices_rounded, color: Color(0xFF0D1B2A)),
                            ),
                          ),
                        );
                      }

                      final fullUrl = image.startsWith('http') ? image : ApiConfig.resolveImageUrl(image);
                      return Image.network(
                        fullUrl,
                        fit: BoxFit.cover,
                        cacheWidth: 500,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFE6C17A),
                          child: const Icon(Icons.devices_rounded, color: Color(0xFF0D1B2A)),
                        ),
                      );
                    }),
                    if (tag != null)
                      Positioned(
                        top: 8,
                        left: 8,
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: tag == 'NEW'
                                ? const Color(0xFFB8860B)
                                : const Color(0xFFF5EBDD).withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.literata(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: tag == 'NEW'
                                  ? const Color(0xFFF5EBDD)
                                  : const Color(0xFF0D1B2A),
                              letterSpacing: 0.4,
                            ),
                          ),
                        ),
                      ),
                    Positioned(
                      top: 6,
                      right: 6,
                      child: GestureDetector(
                        onTap: () => _toggleWishlistForProduct(id),
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF5EBDD),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Icon(
                              isFavorite
                                  ? Icons.favorite_rounded
                                  : Icons.favorite_border_rounded,
                              size: 14,
                              color: isFavorite
                                  ? const Color(0xFFE53E3E)
                                  : const Color(0xFF1B365D),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 6, 10, 6),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: Color(0xFFB8860B),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          rating,
                          style: GoogleFonts.literata(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1B365D),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: GoogleFonts.domine(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    specs,
                    style: GoogleFonts.literata(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1B365D),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 5),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          price,
                          style: GoogleFonts.domine(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0D1B2A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: () => _onAddToCart(title),
                        child: Container(
                          width: 26,
                          height: 26,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE6C17A),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: Color(0xFF0D1B2A),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          ],
        ),
      ),
    );
  }

  // =========================================================================
  // REFERENCE-MATCHING PROMOTIONAL & CURATED PRODUCT SECTIONS
  // =========================================================================

  /// Fallback static New Arrivals & Launches list when backend is loading or unavailable
  final List<Map<String, dynamic>> _staticNewArrivals = [
    {
      'id': '102',
      'title': 'Apple iPhone 16 Pro Max',
      'specs': '48MP Fusion Camera, A18 Pro chip, Titanium build',
      'rating': '4.9 (1.4k)',
      'price': '₹1,39,900',
      'image': 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800&q=80',
      'tag': 'FLAGSHIP',
    },
    {
      'id': '12',
      'title': 'Apple Watch Ultra 2',
      'specs': 'Grade 5 Titanium, 49mm Cellular, 3000 nits Always-On',
      'rating': '4.9 (420)',
      'price': '₹84,900',
      'image': 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=800&q=80',
      'tag': 'NEW',
    },
    {
      'id': '19',
      'title': 'Samsung Galaxy Z Fold6 5G',
      'specs': '7.6" Dynamic AMOLED 2X 120Hz, Galaxy AI, Snapdragon 8 Gen 3',
      'rating': '4.8 (820)',
      'price': '₹1,54,999',
      'image': 'https://images.unsplash.com/photo-1511707171634-5f897ff02aa9?w=800&q=80',
      'tag': 'FOLDABLE',
    },
    {
      'id': '101',
      'title': 'Sony WH-1000XM5 ANC',
      'specs': 'Industry Leading ANC, LDAC Hi-Res Audio, 30h Battery',
      'rating': '4.9 (2.1k)',
      'price': '₹29,990',
      'image': 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=800&q=80',
      'tag': 'AUDIO',
    },
  ];

  /// 1. "ANKITA, still looking for these?" Top personalized recommendation banner
  Widget _buildPersonalizedRecommendationBanner() {
    return ValueListenableBuilder<Map<String, dynamic>?>(
      valueListenable: SessionManager().currentUserNotifier,
      builder: (context, user, _) {
        final fullName = (user?['full_name'] as String?)?.trim();
        final rawFirstName = (fullName != null && fullName.isNotEmpty)
            ? fullName.split(' ').first.toUpperCase()
            : 'ANKITA';

        return Container(
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xFFE53935),
                Color(0xFFD81B60),
                Color(0xFF8E24AA),
              ],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD81B60).withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header title with right-side badge
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      '$rawFirstName, still looking for these?',
                      style: GoogleFonts.domine(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF5EBDD),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFFB300),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      'DEALS',
                      style: GoogleFonts.literata(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w800,
                        color: const Color(0xFF0D1B2A),
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 3 horizontal mini cards
              Row(
                children: [
                  Expanded(
                    child: _buildPersonalizedMiniCard(
                      id: 'apex_buds_pro',
                      title: 'AURA PRO',
                      price: '₹14,999',
                      image: 'asset/apex_buds_pro.jpg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildPersonalizedMiniCard(
                      id: 'titan_pixel_9_pro',
                      title: 'TITAN 9 PRO',
                      price: '₹1,09,999',
                      image: 'asset/titan_pixel_9_pro.jpg',
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: _buildPersonalizedMiniCard(
                      id: 'carousel_wireless_speaker',
                      title: 'SONIC 360',
                      price: '₹12,499',
                      image: 'asset/carousel_wireless_speaker.jpg',
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildPersonalizedMiniCard({
    required String id,
    required String title,
    required String price,
    required String image,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        AppNavigator.toProductDetails(context, productId: id);
      },
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.08),
              blurRadius: 4,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisSize: MainAxisSize.min,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Image.asset(
                  image,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: const Color(0xFFE6C17A),
                    child: const Icon(Icons.devices_rounded, size: 20, color: Color(0xFF0D1B2A)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              title,
              style: GoogleFonts.literata(
                fontSize: 10.5,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0D1B2A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            const SizedBox(height: 1),
            Text(
              price,
              style: GoogleFonts.domine(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  /// 2. "Deals for You" 2-column clean product card grid
  Widget _buildDealsForYouSection(double gridChildAspectRatio) {
    final deals = [
      {
        'id': 'sony-wh1000xm5-wireless-headphones',
        'title': 'Sony WH-1000XM5 ANC',
        'rating': '4.9 ★',
        'price': '₹29,990',
        'mrp': '₹34,990',
        'image': 'asset/product_images/Audio-Headphones/sony-wh1000xm5-wireless-headphones.jpg',
      },
      {
        'id': 'samsung-galaxy-s25-ultra',
        'title': 'Samsung Galaxy S25 Ultra 5G',
        'rating': '4.8 ★',
        'price': '₹1,29,999',
        'mrp': '₹1,34,999',
        'image': 'asset/product_images/Mobiles/samsung-galaxy-s25-ultra.jpg',
      },
      {
        'id': 'dji-mavic-4-pro-drone',
        'title': 'DJI Mavic 4 Pro 4K Drone',
        'rating': '4.9 ★',
        'price': '₹1,84,900',
        'mrp': '₹2,09,900',
        'image': 'asset/product_images/Drones/dji-mavic-4-pro-drone.jpg',
      },
      {
        'id': 'playstation-5-pro-console',
        'title': 'Sony PlayStation 5 Pro 2TB',
        'rating': '4.9 ★',
        'price': '₹69,990',
        'mrp': '₹74,990',
        'image': 'asset/product_images/Gaming/playstation-5-pro-console.jpg',
      },
      {
        'id': 'apple-mac-studio-desktop',
        'title': 'Apple Mac Studio M2 Max',
        'rating': '4.9 ★',
        'price': '₹2,09,900',
        'mrp': '₹2,19,900',
        'image': 'asset/product_images/Computers/apple-mac-studio-desktop.jpg',
      },
      {
        'id': 'gan-65w-fast-wall-charger',
        'title': 'GaN 65W Fast Dual Charger',
        'rating': '4.8 ★',
        'price': '₹2,499',
        'mrp': '₹3,499',
        'image': 'asset/product_images/Chargers/gan-65w-fast-wall-charger.jpg',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Deals for You', 'Curated flash offers on verified tech'),
        const SizedBox(height: 4),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: deals.length,
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 12,
            childAspectRatio: 0.76,
          ),
          itemBuilder: (context, index) {
            final item = deals[index];
            return _buildCleanDealCard(
              id: item['id']!,
              title: item['title']!,
              rating: item['rating']!,
              price: item['price']!,
              mrp: item['mrp']!,
              image: item['image']!,
            );
          },
        ),
      ],
    );
  }

  Widget _buildCleanDealCard({
    required String id,
    required String title,
    required String rating,
    required String price,
    required String mrp,
    required String image,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        AppNavigator.toProductDetails(context, productId: id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1B2A).withValues(alpha: 0.04),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xFFFDFBCF),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFE6C17A),
                          child: const Icon(Icons.devices_rounded, color: Color(0xFF0D1B2A)),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 6,
                    left: 6,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF5EBDD).withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(4),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.08),
                            blurRadius: 3,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            rating,
                            style: GoogleFonts.literata(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF166534),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.literata(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0D1B2A),
                      height: 1.25,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 3),
                  Row(
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.domine(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text(
                        mrp,
                        style: GoogleFonts.literata(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1B365D),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 3. "Value 365" Banner & Categories
  Widget _buildValue365Section() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFFFFF0F5),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFFFD6E7), width: 1),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Value 365',
                style: GoogleFonts.domine(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1B2A),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Daily Deals',
                  style: GoogleFonts.literata(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFF5EBDD),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(
                child: _buildValueCategoryItem(
                  title: 'Pro Audio',
                  discount: 'Min. 40% Off',
                  image: 'asset/product_images/Audio-Headphones/sony-wh1000xm5-wireless-headphones.jpg',
                  onTap: () => AppNavigator.toCategories(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildValueCategoryItem(
                  title: 'Fast GaN',
                  discount: 'Under ₹2,499',
                  image: 'asset/product_images/Chargers/gan-65w-fast-wall-charger.jpg',
                  onTap: () => AppNavigator.toCategories(context),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _buildValueCategoryItem(
                  title: 'Smartwatches',
                  discount: 'Min. 35% Off',
                  image: 'asset/product_images/Wearables/garmin-instinct-2-smartwatch.jpg',
                  onTap: () => AppNavigator.toCategories(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueCategoryItem({
    required String title,
    required String discount,
    required String image,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (onTap != null) onTap();
      },
      child: Column(
        children: [
          Container(
            height: 95,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFF5EBDD),
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF0D1B2A).withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.asset(
                image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Container(
                  color: const Color(0xFFE6C17A),
                  child: const Icon(Icons.devices_rounded, color: Color(0xFF0D1B2A)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: GoogleFonts.literata(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0D1B2A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 1),
          Text(
            discount,
            style: GoogleFonts.literata(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: const Color(0xFFC2185B),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  /// 4. "Brands in Spotlight" 3-column banner cards
  Widget _buildBrandsInSpotlightSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('Brands in Spotlight', 'Official partners and flagship makers'),
        const SizedBox(height: 8),
        Row(
          children: [
            Expanded(
              child: _buildSpotlightBrandCard(
                badgeText: 'SONY',
                badgeColor: const Color(0xFFB8860B),
                image: 'asset/product_images/Cameras/sony-alpha-a7-iv-camera.jpg',
                offerText: 'Spl. price ₹1,74,990',
                subText: 'Lowest price drop',
                id: 'sony-alpha-a7-iv-camera',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSpotlightBrandCard(
                badgeText: 'DJI',
                badgeColor: const Color(0xFF16A34A),
                image: 'asset/product_images/Drones/dji-mini-drone.jpg',
                offerText: 'Min. 30% Off',
                subText: 'Top gimbals & drones',
                id: 'dji-mini-drone',
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: _buildSpotlightBrandCard(
                badgeText: 'GARMIN',
                badgeColor: const Color(0xFFEA580C),
                image: 'asset/product_images/Wearables/garmin-instinct-2-smartwatch.jpg',
                offerText: 'Up to 40% Off',
                subText: 'Rugged solar sport',
                id: 'garmin-instinct-2-smartwatch',
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildSpotlightBrandCard({
    required String badgeText,
    required Color badgeColor,
    required String image,
    required String offerText,
    required String subText,
    required String id,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        AppNavigator.toProductDetails(context, productId: id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1B2A).withValues(alpha: 0.05),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
                  child: AspectRatio(
                    aspectRatio: 1.05,
                    child: Image.asset(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFE6C17A),
                        child: const Icon(Icons.devices_rounded, color: Color(0xFF0D1B2A)),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 6,
                  left: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      badgeText,
                      style: GoogleFonts.literata(
                        fontSize: 8.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFF5EBDD),
                        letterSpacing: 0.4,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(7),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    offerText,
                    style: GoogleFonts.literata(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    subText,
                    style: GoogleFonts.literata(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF1B365D),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 5. Financial & value service shortcuts row
  Widget _buildFinancialServicesRow() {
    final services = [
      {'title': 'Credit Card', 'icon': Icons.credit_card_rounded, 'color': const Color(0xFF3B82F6)},
      {'title': 'TechKart UPI', 'icon': Icons.qr_code_scanner_rounded, 'color': const Color(0xFFEAB308)},
      {'title': 'Pay Later', 'icon': Icons.speed_rounded, 'color': const Color(0xFF10B981)},
      {'title': 'Loans', 'icon': Icons.account_balance_rounded, 'color': const Color(0xFF8B5CF6)},
      {'title': 'Insurance', 'icon': Icons.verified_user_rounded, 'color': const Color(0xFF06B6D4)},
    ];

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: services.map((s) {
        return Expanded(
          child: GestureDetector(
            onTap: () {
              HapticFeedback.selectionClick();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '${s['title']} is active for your verified TechKart profile.',
                    style: GoogleFonts.literata(fontSize: 12.5),
                  ),
                  backgroundColor: const Color(0xFF0D1B2A),
                  duration: const Duration(seconds: 2),
                ),
              );
            },
            child: Column(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: (s['color'] as Color).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(
                      s['icon'] as IconData,
                      size: 22,
                      color: s['color'] as Color,
                    ),
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  s['title'] as String,
                  style: GoogleFonts.literata(
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF0D1B2A),
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  /// 6. "More products for you" Staggered/Varied aspect feed
  Widget _buildMoreProductsForYouSection(double gridChildAspectRatio) {
    final feedProducts = [
      {
        'id': 'iphone-16-pro-max',
        'title': 'Apple iPhone 16 Pro Max 256GB',
        'badge': 'New Arrival',
        'badgeColor': const Color(0xFFB8860B),
        'rating': '4.9 ★ (12,410)',
        'price': '₹1,44,900',
        'mrp': '₹1,49,900',
        'offerTag': '₹1,39,900 with Bank offer',
        'image': 'asset/product_images/Mobiles/iphone-16-pro-max.jpg',
      },
      {
        'id': 'macbook-pro-16-space-black',
        'title': 'MacBook Pro 16" M3 Max 1TB',
        'badge': 'Lowest price',
        'badgeColor': const Color(0xFF4F46E5),
        'rating': '4.9 ★ (8,320)',
        'price': '₹3,49,900',
        'mrp': '₹3,99,900',
        'offerTag': '₹3,39,900 with Bank offer',
        'image': 'asset/product_images/Laptops/macbook-pro-16-space-black.jpg',
      },
      {
        'id': '4k-ultra-hd-smart-led-tv',
        'title': 'Sony Bravia 55" 4K Smart OLED',
        'badge': null,
        'badgeColor': null,
        'rating': '4.8 ★ (3,150)',
        'price': '₹1,19,990',
        'mrp': '₹1,49,990',
        'offerTag': '₹1,14,990 with Bank offer',
        'image': 'asset/product_images/TV-Home-Entertainment/4k-ultra-hd-smart-led-tv.jpg',
      },
      {
        'id': 'realme-p4s-5g',
        'title': 'Realme P4s 5G 128GB Mint',
        'badge': 'Special Deal',
        'badgeColor': const Color(0xFF16A34A),
        'rating': '4.7 ★ (1,840)',
        'price': '₹18,999',
        'mrp': '₹22,999',
        'offerTag': '₹17,499 with Bank offer',
        'image': 'asset/product_images/Mobiles/realme-p4s-5g.jpg',
      },
      {
        'id': 'ultrawide-curved-gaming-monitor',
        'title': 'Samsung Odyssey 34" Curved WQHD',
        'badge': 'Trending',
        'badgeColor': const Color(0xFFEA580C),
        'rating': '4.8 ★ (2,600)',
        'price': '₹54,999',
        'mrp': '₹69,999',
        'offerTag': '₹49,999 with Bank offer',
        'image': 'asset/product_images/Monitors/ultrawide-curved-gaming-monitor.jpg',
      },
      {
        'id': 'standalone-vr-gaming-headset',
        'title': 'Meta Quest 3 128GB VR Headset',
        'badge': 'Popular',
        'badgeColor': const Color(0xFFB8860B),
        'rating': '4.8 ★ (4,120)',
        'price': '₹48,990',
        'mrp': '₹54,990',
        'offerTag': '₹46,490 with Bank offer',
        'image': 'asset/product_images/VR-AR/standalone-vr-gaming-headset.jpg',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionHeader('More products for you', 'Based on your browsing and wishlists'),
        const SizedBox(height: 6),
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: feedProducts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            crossAxisSpacing: 10,
            mainAxisSpacing: 14,
            childAspectRatio: 0.60,
          ),
          itemBuilder: (context, index) {
            final prod = feedProducts[index];
            return _buildRichFeedCard(
              id: prod['id'] as String,
              title: prod['title'] as String,
              badge: prod['badge'] as String?,
              badgeColor: prod['badgeColor'] as Color?,
              rating: prod['rating'] as String,
              price: prod['price'] as String,
              mrp: prod['mrp'] as String,
              offerTag: prod['offerTag'] as String,
              image: prod['image'] as String,
            );
          },
        ),
      ],
    );
  }

  Widget _buildRichFeedCard({
    required String id,
    required String title,
    String? badge,
    Color? badgeColor,
    required String rating,
    required String price,
    required String mrp,
    required String offerTag,
    required String image,
  }) {
    final isFavorite = _wishlisted.contains(id);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        AppNavigator.toProductDetails(context, productId: id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0D1B2A).withValues(alpha: 0.05),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Image stage with badge and wishlist
            AspectRatio(
              aspectRatio: 1.15,
              child: Stack(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
                    child: Container(
                      width: double.infinity,
                      color: const Color(0xFFFDFBCF),
                      child: Image.asset(
                        image,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Container(
                          color: const Color(0xFFE6C17A),
                          child: const Icon(Icons.devices_rounded, color: Color(0xFF0D1B2A)),
                        ),
                      ),
                    ),
                  ),
                  if (badge != null)
                    Positioned(
                      top: 8,
                      left: 8,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                        decoration: BoxDecoration(
                          color: badgeColor ?? const Color(0xFFB8860B),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          badge,
                          style: GoogleFonts.literata(
                            fontSize: 8.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFF5EBDD),
                          ),
                        ),
                      ),
                    ),
                  Positioned(
                    top: 6,
                    right: 6,
                    child: GestureDetector(
                      onTap: () => _toggleWishlistForProduct(id),
                      child: Container(
                        width: 26,
                        height: 26,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EBDD).withValues(alpha: 0.9),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Icon(
                            isFavorite ? Icons.favorite_rounded : Icons.favorite_border_rounded,
                            size: 14,
                            color: isFavorite ? const Color(0xFFE53E3E) : const Color(0xFF1B365D),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Rating pill
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6C17A),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          rating,
                          style: GoogleFonts.literata(
                            fontSize: 9.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF166534),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    title,
                    style: GoogleFonts.literata(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0D1B2A),
                      height: 1.25,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: [
                      Text(
                        price,
                        style: GoogleFonts.domine(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        mrp,
                        style: GoogleFonts.literata(
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1B365D),
                          decoration: TextDecoration.lineThrough,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    offerTag,
                    style: GoogleFonts.literata(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFFB8860B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSectionHeader(String title, String subtitle) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.domine(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1B2A),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 8),
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
                      fontWeight: FontWeight.w500,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 15,
                    color: Color(0xFF1B365D),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: GoogleFonts.literata(
            fontSize: 11.5,
            fontWeight: FontWeight.w400,
            color: const Color(0xFF1B365D),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final screenWidth = mediaQuery.size.width;
    // Dynamically calculate the precise child aspect ratio so cards fit content snugly
    // without leaving excess empty vertical space inside the grid cells.
    final cardWidth = ((screenWidth - 32 - 12) / 2).clamp(130.0, 320.0);
    // Precise coordinated layout:
    // Image height: cardWidth / 1.25
    // Content block: Rating row (14) + title (18) + specs (14) + price/cart row (28) + gaps & vertical padding (26) = ~100px.
    // 102.0 provides the exact snug height to eliminate bottom overflow permanently while leaving zero excess white space.
    final cardContentHeight = (cardWidth / 1.25) + 98.0;
    final gridChildAspectRatio = cardWidth / cardContentHeight;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFFDFBCF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBCF),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: topPadding > 0 ? topPadding + 6 : 24),

            // ---------------------------------------------------------------
            // TOP BAR: Brand Mark, Bell, Avatar
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Image.asset(
                        'asset/app_logo.png',
                        height: 36,
                        width: 36,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'asset/app_launcher_icon.png',
                          height: 36,
                          width: 36,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'TechKart',
                        style: GoogleFonts.domine(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () {
                              HapticFeedback.selectionClick();
                              AppNavigator.toOrderHistory(context);
                            },
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              size: 23,
                              color: Color(0xFF1B365D),
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 34, minHeight: 34),
                          ),
                          Positioned(
                            top: 6,
                            right: 8,
                            child: Container(
                              width: 7,
                              height: 7,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE53E3E),
                                shape: BoxShape.circle,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(width: 6),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          AppNavigator.toCustomerProfileHub(context);
                        },
                        child: const ProfileAvatar(
                          size: 30,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // ---------------------------------------------------------------
            // LOCATION & STATUS STRIP
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.location_on_outlined,
                          size: 14,
                          color: Color(0xFF1B365D),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: ValueListenableBuilder<Map<String, dynamic>?>(
                            valueListenable: SessionManager().currentUserNotifier,
                            builder: (context, user, _) {
                              final rawCity = (user?['city'] ?? '').toString().trim();
                              final rawPincode = (user?['pincode'] ?? '').toString().trim();
                              final locationLabel = (rawCity.isNotEmpty || rawPincode.isNotEmpty)
                                  ? 'Delivering to ${[rawCity, rawPincode].where((s) => s.isNotEmpty).join(' ')}'
                                  : 'Delivering to Behala, Kolkata 700063';

                              return Text(
                                locationLabel,
                                style: GoogleFonts.literata(
                                  fontSize: 11.5,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF1B365D),
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(
                        Icons.bolt_rounded,
                        size: 15,
                        color: Color(0xFF0D1B2A),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '24-h Fast',
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------------
            // SEARCH BAR
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.selectionClick();
                  AppNavigator.toSearchOverlay(context);
                },
                child: Container(
                  height: 46,
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5EBDD),
                    borderRadius: BorderRadius.circular(24),
                    border: Border.all(color: const Color(0xFFE6C17A)),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        size: 19,
                        color: Color(0xFF1B365D),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Search hardware, ecosystems, gear...',
                          style: GoogleFonts.literata(
                            fontSize: 13,
                            color: const Color(0xFF1B365D),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.mic_none_rounded,
                        size: 19,
                        color: Color(0xFF1B365D),
                      ),
                      const SizedBox(width: 10),
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.selectionClick();
                          AppNavigator.toAiVisualSearchCamera(context);
                        },
                        child: const Icon(
                          Icons.camera_alt_outlined,
                          size: 19,
                          color: Color(0xFF1B365D),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------------
            // SCROLLABLE BODY
            // ---------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // -----------------------------------------------------
                      // PROMOTIONAL CAMPAIGN CAROUSEL (Reference 2 Layout + Reference 3 Gadget Photography)
                      // -----------------------------------------------------
                      _buildPromotionalCarousel(),

                      const SizedBox(height: 10),

                      // -----------------------------------------------------
                      // CATEGORIES CIRCLE RAIL
                      // -----------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              'Categories',
                              style: GoogleFonts.domine(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0D1B2A),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () => AppNavigator.toCategories(context),
                            child: Text(
                              'BROWSE ALL (24)',
                              style: GoogleFonts.literata(
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1B365D),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: _buildCategoryCircle(
                              label: 'Audio & Headphones',
                              icon: Icons.headphones_outlined,
                              isSelected: true,
                              categoryId: 6,
                            ),
                          ),
                          Expanded(
                            child: _buildCategoryCircle(
                              label: 'Mobiles & Smartphones',
                              icon: Icons.smartphone_outlined,
                              isSelected: false,
                              categoryId: 1,
                            ),
                          ),
                          Expanded(
                            child: _buildCategoryCircle(
                              label: 'Computer Accessories',
                              icon: Icons.hub_outlined,
                              isSelected: false,
                              categoryId: 5,
                            ),
                          ),
                          Expanded(
                            child: _buildCategoryCircle(
                              label: 'Wearables',
                              icon: Icons.watch_outlined,
                              isSelected: false,
                              categoryId: 7,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // -----------------------------------------------------
                      // SECTION: RECENT ARRIVALS & NEW LAUNCHES
                      // (Live Dynamic Catalog with Seamless Fallback)
                      // -----------------------------------------------------
                      _buildSectionHeader(
                        'New Arrivals & Launches',
                        'Freshly added certified hardware • Auto-updated',
                      ),
                      const SizedBox(height: 10),
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 12,
                          childAspectRatio: gridChildAspectRatio,
                        ),
                        itemCount: _newArrivals.isNotEmpty
                            ? _newArrivals.take(4).length
                            : _staticNewArrivals.length,
                        itemBuilder: (context, index) {
                          if (_newArrivals.isNotEmpty) {
                            final prod = _newArrivals[index];
                            final hasPrimaryImage = prod.primaryImageUrl != null && prod.primaryImageUrl!.isNotEmpty;
                            final fallbackImage = 'asset/chronos_ultra_2.jpg';
                            final imageStr = hasPrimaryImage ? prod.primaryImageUrl! : fallbackImage;
                            final badgeTag = prod.isNewArrival ? 'NEW' : 'FEATURED';

                            return _buildProductCard(
                              id: '${prod.id}',
                              title: prod.title,
                              specs: prod.description != null && prod.description!.isNotEmpty
                                  ? (prod.description!.length > 32
                                      ? '${prod.description!.substring(0, 32)}...'
                                      : prod.description!)
                                  : (prod.categoryName ?? 'Verified Hardware'),
                              rating: '5.0 (New)',
                              price: '₹${prod.price.toStringAsFixed(0)}',
                              image: imageStr,
                              tag: badgeTag,
                              isNetworkImage: hasPrimaryImage,
                            );
                          } else {
                            final item = _staticNewArrivals[index];
                            return _buildProductCard(
                              id: item['id'] as String,
                              title: item['title'] as String,
                              specs: item['specs'] as String,
                              rating: item['rating'] as String,
                              price: item['price'] as String,
                              image: item['image'] as String,
                              tag: item['tag'] as String?,
                              isNetworkImage: false,
                            );
                          }
                        },
                      ),
                      const SizedBox(height: 6),

                      // -----------------------------------------------------
                      // SECTION 1: USER PERSONALIZED RECOMMENDATION BANNER
                      // ("ANKITA, still looking for these?")
                      // -----------------------------------------------------
                      _buildPersonalizedRecommendationBanner(),

                      const SizedBox(height: 14),

                      // -----------------------------------------------------
                      // SECTION 2: DEALS FOR YOU
                      // -----------------------------------------------------
                      _buildDealsForYouSection(gridChildAspectRatio),

                      const SizedBox(height: 14),

                      // -----------------------------------------------------
                      // SECTION 3: VALUE 365 PROMOTIONAL CAROUSEL/BANNER
                      // -----------------------------------------------------
                      _buildValue365Section(),

                      const SizedBox(height: 14),

                      // -----------------------------------------------------
                      // SECTION 4: BRANDS IN SPOTLIGHT
                      // -----------------------------------------------------
                      _buildBrandsInSpotlightSection(),

                      const SizedBox(height: 12),

                      // -----------------------------------------------------
                      // SECTION 5: FINANCIAL & VALUE SERVICES SHORTCUTS ROW
                      // -----------------------------------------------------
                      _buildFinancialServicesRow(),

                      const SizedBox(height: 16),

                      // -----------------------------------------------------
                      // SECTION 6: MORE PRODUCTS FOR YOU
                      // -----------------------------------------------------
                      _buildMoreProductsForYouSection(gridChildAspectRatio),

                      const SizedBox(height: 14),

                      // -----------------------------------------------------
                      // GUARANTEE FOOTER CARD
                      // -----------------------------------------------------
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6C17A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5EBDD),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0D1B2A).withValues(alpha: 0.08),
                                    blurRadius: 6,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              padding: const EdgeInsets.all(5),
                              child: ClipOval(
                                child: Image.asset(
                                  'asset/app_logo.png',
                                  fit: BoxFit.contain,
                                  cacheWidth: 100,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    'asset/app_logo_circle.png',
                                    fit: BoxFit.contain,
                                    cacheWidth: 100,
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'TECHKART DIRECT 1-YEAR',
                                    style: GoogleFonts.literata(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 0.8,
                                      color: const Color(0xFFB8860B),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Direct replacement warranty, zero-question returns on verified hardware units.',
                                    style: GoogleFonts.literata(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF1B365D),
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Explore Return Policy →',
                                    style: GoogleFonts.literata(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF0D1B2A),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 70),
                    ],
                  ),
                ),
              ),
            ),

            // ---------------------------------------------------------------
            // BOTTOM NAVIGATION BAR
            // ---------------------------------------------------------------
            if (widget.showBottomNav)
              TechKartBottomNavBar(
                currentIndex: 0, // Home active
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

  Widget _buildCategoryCircle({
    required String label,
    required IconData icon,
    required bool isSelected,
    int? categoryId,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        if (categoryId != null) {
          AppNavigator.toSubcategoryProducts(
            context,
            category: CategoryModel(id: categoryId, name: label, slug: label.toLowerCase()),
            categoryName: label,
          );
        } else {
          AppNavigator.toCategories(context);
        }
      },
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFE6C17A)
                  : const Color(0xFFE6C17A),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 24,
                color: const Color(0xFF0D1B2A),
              ),
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            height: 32,
            child: Text(
              label,
              style: GoogleFonts.literata(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
                color: const Color(0xFF1B365D),
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}