import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/api_client.dart';
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
      'accentColor': '0xFF00E5FF',
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

  @override
  void initState() {
    super.initState();
    _campaignPageController = PageController();
    _startCampaignAutoSlide();
    _loadWishlistFromBackend();
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
        backgroundColor: const Color(0xFF00344B),
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
                                        color: Colors.white,
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
                                            color: Colors.white,
                                            letterSpacing: 0.2,
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        Container(
                                          width: 18,
                                          height: 18,
                                          decoration: const BoxDecoration(
                                            color: Colors.white,
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
                                  color: Colors.white.withValues(alpha: 0.25),
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
                                      : Colors.white,
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
                        : const Color(0xFF00344B).withValues(alpha: 0.22),
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
  }) {
    final isFavorite = _wishlisted.contains(id);

    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        AppNavigator.toProductDetails(context, productId: id);
      },
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00344B).withValues(alpha: 0.04),
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
                    Image.asset(
                      image,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFFF1F5F9),
                        child: const Icon(
                          Icons.devices_rounded,
                          color: Color(0xFF00344B),
                        ),
                      ),
                    ),
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
                            color: Colors.white.withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            tag,
                            style: GoogleFonts.literata(
                              fontSize: 8,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00344B),
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
                            color: Colors.white,
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
                                  : const Color(0xFF718096),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      const Icon(
                        Icons.star_rounded,
                        size: 13,
                        color: Color(0xFF8B6B2B),
                      ),
                      const SizedBox(width: 3),
                      Flexible(
                        child: Text(
                          rating,
                          style: GoogleFonts.literata(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF4A5568),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(
                    title,
                    style: GoogleFonts.domine(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00344B),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    specs,
                    style: GoogleFonts.literata(
                      fontSize: 10,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF718096),
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 6),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Flexible(
                        child: Text(
                          price,
                          style: GoogleFonts.domine(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00344B),
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
                            color: Color(0xFFEAF5FF),
                            shape: BoxShape.circle,
                          ),
                          child: const Center(
                            child: Icon(
                              Icons.add_rounded,
                              size: 16,
                              color: Color(0xFF00344B),
                            ),
                          ),
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
                  color: const Color(0xFF00344B),
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
                      color: const Color(0xFF48587E),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right_rounded,
                    size: 15,
                    color: Color(0xFF48587E),
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
            color: const Color(0xFF718096),
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 12),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final screenWidth = mediaQuery.size.width;
    final gridChildAspectRatio = screenWidth < 360 ? 0.61 : 0.68;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF5FAFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
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
                        height: 32,
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) =>
                            Image.asset(
                          'asset/app_launcher_icon.png',
                          height: 32,
                          fit: BoxFit.contain,
                        ),
                      ),
                      const SizedBox(width: 8),
                      Text(
                        'TechKart',
                        style: GoogleFonts.domine(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00344B),
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
                              AppNavigator.toNotifications(context);
                            },
                            icon: const Icon(
                              Icons.notifications_none_rounded,
                              size: 23,
                              color: Color(0xFF2D3748),
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
                          color: Color(0xFF718096),
                        ),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            'Delivering to Mumbai 400001',
                            style: GoogleFonts.literata(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF4A5568),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
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
                        color: Color(0xFF00344B),
                      ),
                      const SizedBox(width: 3),
                      Text(
                        '24-h Fast',
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF00344B),
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
                    color: const Color(0xFFEAF5FF),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        size: 19,
                        color: Color(0xFF718096),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Search hardware, ecosystems, gear...',
                          style: GoogleFonts.literata(
                            fontSize: 13,
                            color: const Color(0xFFA0AEC0),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.mic_none_rounded,
                        size: 19,
                        color: Color(0xFF718096),
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
                          color: Color(0xFF718096),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------------------------------------
            // SCROLLABLE BODY
            // ---------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
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

                      const SizedBox(height: 20),

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
                                color: const Color(0xFF00344B),
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
                                color: const Color(0xFF48587E),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      Row(
                        children: [
                          Expanded(
                            child: _buildCategoryCircle(
                              label: 'Audio',
                              icon: Icons.headphones_outlined,
                              isSelected: true,
                            ),
                          ),
                          Expanded(
                            child: _buildCategoryCircle(
                              label: 'Phones',
                              icon: Icons.smartphone_outlined,
                              isSelected: false,
                            ),
                          ),
                          Expanded(
                            child: _buildCategoryCircle(
                              label: 'Docks',
                              icon: Icons.hub_outlined,
                              isSelected: false,
                            ),
                          ),
                          Expanded(
                            child: _buildCategoryCircle(
                              label: 'Wearables',
                              icon: Icons.watch_outlined,
                              isSelected: false,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // -----------------------------------------------------
                      // SECTION 1: CURATED DROPS
                      // -----------------------------------------------------
                      _buildSectionHeader(
                        'Curated Drops',
                        'Selected by TechKart Engineering Partners',
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: gridChildAspectRatio,
                        children: [
                          _buildProductCard(
                            id: 'aura_studio_anc',
                            title: 'Aura Studio ANC',
                            specs: 'Dual 40mm beryllium drivers...',
                            rating: '4.9 (1.2k)',
                            price: '₹28,999',
                            image: 'asset/aura_studio_anc.jpg',
                            tag: 'FLAGSHIP',
                          ),
                          _buildProductCard(
                            id: 'sug_lumina_fold',
                            title: 'Lumina Fold OLED',
                            specs: '144Hz folding display...',
                            rating: '4.9 (480)',
                            price: '₹99,999',
                            image: 'asset/sug_lumina_fold.jpg',
                            tag: 'PRE-ORDER',
                          ),
                          _buildProductCard(
                            id: 'chronos_ultra_2',
                            title: 'Chronos Ultra X',
                            specs: 'Titanium case with LTE...',
                            rating: '4.9 (2.1k)',
                            price: '₹28,999',
                            image: 'asset/chronos_ultra_2.jpg',
                            tag: 'AEROSPACE',
                          ),
                          _buildProductCard(
                            id: 'carousel_fast_gan_charger',
                            title: 'Volta 65W GaN',
                            specs: 'Dual Type-C ports, travel...',
                            rating: '4.8 (3.4k)',
                            price: '₹3,499',
                            image: 'asset/carousel_fast_gan_charger.jpg',
                            tag: 'FAST CHARGE',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // -----------------------------------------------------
                      // SECTION 2: FLAGSHIP DEALS
                      // -----------------------------------------------------
                      _buildSectionHeader(
                        'Flagship Deals',
                        'Verified Hardware with Direct Warranty',
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: gridChildAspectRatio,
                        children: [
                          _buildProductCard(
                            id: 'apex_fold_hero',
                            title: 'Apex Fold',
                            specs: 'Pure titanium dual-screen...',
                            rating: '4.9 (840)',
                            price: '₹1,24,999',
                            image: 'asset/apex_fold_buds_pro.jpg',
                            tag: 'ALL-IN-ONE',
                          ),
                          _buildProductCard(
                            id: 'desk_bundle_clean',
                            title: 'Omni Dock Station',
                            specs: 'Triple 4K display output...',
                            rating: '4.8 (920)',
                            price: '₹12,999',
                            image: 'asset/desk_bundle_card_clean.png',
                            tag: 'COMPACT',
                          ),
                          _buildProductCard(
                            id: 'hyperdrive_gan',
                            title: 'HyperDrive GaN',
                            specs: 'High-efficiency thermal...',
                            rating: '4.9 (1.8k)',
                            price: '₹18,999',
                            image: 'asset/carousel_fast_gan_charger.jpg',
                            tag: 'GaN',
                          ),
                          _buildProductCard(
                            id: 'nova_buds_air',
                            title: 'Nova Buds Case',
                            specs: '40h total battery backup...',
                            rating: '4.7 (1.5k)',
                            price: '₹15,999',
                            image: 'asset/category_earbuds.jpg',
                            tag: 'AUDIO',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // -----------------------------------------------------
                      // SECTION 3: TRENDING AUDIO & WEARABLES
                      // -----------------------------------------------------
                      _buildSectionHeader(
                        'Trending Audio & Wearables',
                        'High demand tech curated for performance',
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: gridChildAspectRatio,
                        children: [
                          _buildProductCard(
                            id: 'aura_anc_4_pro',
                            title: 'Aura Pro ANC 4',
                            specs: 'Active ANC • 38h Battery',
                            rating: '4.9 (1.9k)',
                            price: '₹12,499',
                            image: 'asset/aura_anc_4_pro.jpg',
                          ),
                          _buildProductCard(
                            id: 'chronos_watch_x',
                            title: 'Chronos Light',
                            specs: 'Ceramic bezel • Sapphire',
                            rating: '4.8 (890)',
                            price: '₹15,999',
                            image: 'asset/chronos_watch_x.jpg',
                          ),
                          _buildProductCard(
                            id: 'aura_studio_anc_4',
                            title: 'Revel Ear ANC',
                            specs: 'Studio acoustics, zero-loss',
                            rating: '4.9 (1.4k)',
                            price: '₹18,999',
                            image: 'asset/aura_studio_anc_4.jpg',
                          ),
                          _buildProductCard(
                            id: 'deal_watch',
                            title: 'Orbit Band Track',
                            specs: 'Full-day biometric sensors',
                            rating: '4.7 (760)',
                            price: '₹24,999',
                            image: 'asset/deal_watch.jpg',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // -----------------------------------------------------
                      // SECTION 4: WORKSPACE & DESK SETUP
                      // -----------------------------------------------------
                      _buildSectionHeader(
                        'Workspace & Desk Setup',
                        'Ergonomic accessories crafted for peak productivity',
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: gridChildAspectRatio,
                        children: [
                          _buildProductCard(
                            id: 'desk_mat_pad',
                            title: 'SilentDesk Mat Pad',
                            specs: 'Spill-resistant vegan hide...',
                            rating: '4.8 (1.1k)',
                            price: '₹4,499',
                            image: 'asset/desk_bundle_card_clean.png',
                            tag: 'SUPPLE',
                          ),
                          _buildProductCard(
                            id: 'neo_monitor_hub',
                            title: 'NeoMonitor Hub',
                            specs: '10-in-1 desktop hub...',
                            rating: '4.9 (610)',
                            price: '₹9,499',
                            image: 'asset/carousel_fast_gan_charger.jpg',
                            tag: 'COPPER',
                          ),
                          _buildProductCard(
                            id: 'tether_magpad',
                            title: 'TetherDesk Magpad',
                            specs: 'Magnetic attachment rail...',
                            rating: '4.7 (420)',
                            price: '₹4,999',
                            image: 'asset/desk_bundle_card_clean.png',
                            tag: 'SLATE',
                          ),
                          _buildProductCard(
                            id: 'aurabar_max3',
                            title: 'AuraBar Max3',
                            specs: 'Asymmetric screen illumination...',
                            rating: '4.8 (730)',
                            price: '₹6,499',
                            image: 'asset/carousel_fast_gan_charger.jpg',
                            tag: 'ALUMINUM',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // -----------------------------------------------------
                      // SECTION 5: ACCESSORIES & FAST POWER
                      // -----------------------------------------------------
                      _buildSectionHeader(
                        'Accessories & Fast Power',
                        'Travel chargers, GaN blocks and battery reserves',
                      ),
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 12,
                        mainAxisSpacing: 12,
                        childAspectRatio: gridChildAspectRatio,
                        children: [
                          _buildProductCard(
                            id: 'ampvolt_gan',
                            title: 'AmpVolt GaN',
                            specs: 'Triple port pocket GaN...',
                            rating: '4.8 (2.4k)',
                            price: '₹4,299',
                            image: 'asset/carousel_fast_gan_charger.jpg',
                            tag: '65W POWER',
                          ),
                          _buildProductCard(
                            id: 'ambient_screen',
                            title: 'Ambient Screen',
                            specs: 'Secondary display companion...',
                            rating: '4.7 (890)',
                            price: '₹7,999',
                            image: 'asset/sug_lumina_fold.jpg',
                            tag: 'SCREEN',
                          ),
                          _buildProductCard(
                            id: 'terra_carbon_band',
                            title: 'Terra Carbon Band',
                            specs: 'Ultra-light carbon weave...',
                            rating: '4.9 (610)',
                            price: '₹8,499',
                            image: 'asset/chronos_watch_x.jpg',
                            tag: '49MM',
                          ),
                          _buildProductCard(
                            id: 'voltfast_140w',
                            title: 'VoltFast 140W Pro',
                            specs: 'Full laptop fast delivery...',
                            rating: '4.9 (1.3k)',
                            price: '₹7,499',
                            image: 'asset/carousel_fast_gan_charger.jpg',
                            tag: '140W OUTPUT',
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // -----------------------------------------------------
                      // GUARANTEE FOOTER CARD
                      // -----------------------------------------------------
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EEE4),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  'G',
                                  style: GoogleFonts.domine(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF8B6B2B),
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
                                      color: const Color(0xFF8B6B2B),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Direct replacement warranty, zero-question returns on verified hardware units.',
                                    style: GoogleFonts.literata(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF4A5568),
                                      height: 1.35,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    'Explore Return Policy →',
                                    style: GoogleFonts.literata(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF00344B),
                                      decoration: TextDecoration.underline,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),
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
                      AppNavigator.toAiVisualSearchCamera(context);
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
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        AppNavigator.toCategories(context);
      },
      child: Column(
        children: [
          Container(
            width: 52,
            height: 52,
            decoration: BoxDecoration(
              color: isSelected
                  ? const Color(0xFFCCE4F5)
                  : const Color(0xFFEAF5FF),
              shape: BoxShape.circle,
            ),
            child: Center(
              child: Icon(
                icon,
                size: 24,
                color: const Color(0xFF00344B),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: GoogleFonts.literata(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.w600 : FontWeight.w400,
              color: const Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }
}
