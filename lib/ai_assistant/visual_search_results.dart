import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/bottom_navbar.dart';
import '../theme/profile_avatar.dart';

/// TechKart Visual Search Results Screen
///
/// 100% visual fidelity reproduction of the Visual Search Results reference:
/// - Light airy background (#F5FAFF)
/// - Top Bar: Back button, "Visual Search Results", notification bell with red dot, user profile avatar.
/// - Top Visual Query Card:
///   - Square thumbnail of detected item (`asset/chronos_ultra_2.jpg`) with crop target icon.
///   - Tag: "VISUAL QUERY DETECTED"
///   - Title: "Titanium Smartwatch" in Domine bold.
///   - Sub-badges: "• 98% Exact Match" (Beige), "📷 Retake" (Link).
/// - Filter Category Tabs:
///   - "Exact Match (3)" (Active dark navy #00344B pill)
///   - "Compatible Bands (12)"
///   - "Wireless Chargers"
/// - Featured Top Match Card:
///   - Tag: "99% Match • Best Price"
///   - Heart wishlist button on top-right.
///   - Square image stage (`asset/chronos_ultra_2.jpg`).
///   - Title: "Chronos Ultra 2", "49mm Cellular • Grade 5 Titanium".
///   - Price: "₹35,499.00" ($429.00 in INR) with strikethrough "₹39,999.00".
///   - Button: "View Details →" (Full width dark navy).
/// - Section: "MATCHED DEVICES & GEAR (4 results) • ⚡ Real-Time Catalog"
/// - 2x2 Grid of Matched Products:
///   1. "Chronos Active Pro" | Tag: "94% Match" | 45mm GPS • Aluminum | ₹24,999 | Image: `asset/chronos_watch_x.jpg`
///   2. "Aura Fold Pro & Pods" | Tag: "Paired Device" | Titanium Slate • 256GB | ₹74,999 | Image: `asset/apex_fold_buds_pro.jpg`
///   3. "GaN 65W Fast Charger" | Tag: "OEM Accessory" | Dual USB-C • Compact | ₹3,999 | Image: `asset/carousel_fast_gan_charger.jpg`
///   4. "AeroPulse ANC Studio" | Tag: "Eco Match" | Spatial Audio • 40h Battery | ₹20,699 | Image: `asset/aura_anc_4_pro.jpg`
/// - Bottom Refine Strip:
///   - "Not the right match? Refine with text query or adjust crop box"
///   - "Refine" button (Dark navy).
/// - Bottom Navigation Bar (AI Search active).
class VisualSearchResultsScreen extends StatefulWidget {
  const VisualSearchResultsScreen({super.key});

  @override
  State<VisualSearchResultsScreen> createState() =>
      _VisualSearchResultsScreenState();
}

class _VisualSearchResultsScreenState extends State<VisualSearchResultsScreen> {
  int _selectedTabIndex = 0;
  final List<String> _tabs = [
    'Exact Match (3)',
    'Compatible Bands (12)',
    'Wireless Chargers',
  ];

  final List<Map<String, dynamic>> _matchedProducts = [
    {
      'id': 'chronos_active_pro',
      'title': 'Chronos Active Pro',
      'specs': '45mm GPS • Aluminum',
      'price': '₹24,999.00',
      'tag': '94% Match',
      'tagBg': const Color(0xFFE6C17A),
      'tagColor': const Color(0xFF0D1B2A),
      'image': 'asset/chronos_watch_x.jpg',
    },
    {
      'id': 'aura_fold_pro',
      'title': 'Aura Fold Pro & Pods',
      'specs': 'Titanium Slate • 256GB',
      'price': '₹74,999.00',
      'tag': 'Paired Device',
      'tagBg': const Color(0xFFE6C17A),
      'tagColor': const Color(0xFFB8860B),
      'image': 'asset/apex_fold_buds_pro.jpg',
    },
    {
      'id': 'gan_65w_charger',
      'title': 'GaN 65W Fast Charger',
      'specs': 'Dual USB-C • Compact',
      'price': '₹3,999.00',
      'tag': 'OEM Accessory',
      'tagBg': const Color(0xFFE6C17A),
      'tagColor': const Color(0xFF0D1B2A),
      'image': 'asset/carousel_fast_gan_charger.jpg',
    },
    {
      'id': 'aeropulse_anc_studio',
      'title': 'AeroPulse ANC Studio',
      'specs': 'Spatial Audio • 40h Battery',
      'price': '₹20,699.00',
      'tag': 'Eco Match',
      'tagBg': const Color(0xFFE6C17A),
      'tagColor': const Color(0xFF0D1B2A),
      'image': 'asset/aura_anc_4_pro.jpg',
    },
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

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
            // TOP BAR
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF0D1B2A),
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      'Visual Search Results',
                      style: GoogleFonts.domine(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D1B2A),
                      ),
                    ),
                  ),

                  // Bell
                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => AppNavigator.toNotifications(context),
                        icon: const Icon(
                          Icons.notifications_none_rounded,
                          size: 23,
                          color: Color(0xFF1B365D),
                        ),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 34, minHeight: 34),
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

                  const ProfileAvatar(size: 30),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------------
            // TOP VISUAL QUERY CARD
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EBDD),
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF0D1B2A).withValues(alpha: 0.04),
                      blurRadius: 10,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Cropped Image with Reticle Overlay
                    Stack(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(14),
                          child: Container(
                            width: 62,
                            height: 62,
                            color: const Color(0xFFE6C17A),
                            child: Image.asset(
                              'asset/chronos_ultra_2.jpg',
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) => Container(
                                color: const Color(0xFFE6C17A),
                                child: const Icon(
                                  Icons.watch_outlined,
                                  color: Color(0xFF0D1B2A),
                                  size: 24,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 4,
                          right: 4,
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: const BoxDecoration(
                              color: Color(0xFF0D1B2A),
                              shape: BoxShape.circle,
                            ),
                            child: const Center(
                              child: Icon(
                                Icons.crop_free_rounded,
                                size: 12,
                                color: Color(0xFFF5EBDD),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(width: 14),

                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'VISUAL QUERY DETECTED',
                            style: GoogleFonts.literata(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.8,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Titanium Smartwatch',
                            style: GoogleFonts.domine(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D1B2A),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 3,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFE6C17A),
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Text(
                                  '• 98% Exact Match',
                                  style: GoogleFonts.literata(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFFB8860B),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 10),
                              GestureDetector(
                                onTap: () => Navigator.of(context).pop(),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.camera_alt_outlined,
                                      size: 13,
                                      color: Color(0xFF1B365D),
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      'Retake',
                                      style: GoogleFonts.literata(
                                        fontSize: 11,
                                        fontWeight: FontWeight.w500,
                                        color: const Color(0xFF1B365D),
                                      ),
                                    ),
                                  ],
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
            ),

            const SizedBox(height: 12),

            // ---------------------------------------------------------------
            // FILTER TABS RAIL
            // ---------------------------------------------------------------
            SizedBox(
              height: 34,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _tabs.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedTabIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedTabIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0D1B2A)
                              : const Color(0xFFE6C17A),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(
                            _tabs[index],
                            style: GoogleFonts.literata(
                              fontSize: 12,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFFF5EBDD)
                                  : const Color(0xFF0D1B2A),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // SCROLLABLE RESULTS BODY
            // ---------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // FEATURED TOP MATCH CARD
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EBDD),
                          borderRadius: BorderRadius.circular(22),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF0D1B2A).withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 4,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFE6C17A),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Text(
                                    '99% Match • Best Price',
                                    style: GoogleFonts.literata(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0D1B2A),
                                    ),
                                  ),
                                ),
                                const Spacer(),
                                const Icon(
                                  Icons.favorite_border_rounded,
                                  size: 18,
                                  color: Color(0xFF1B365D),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                ClipRRect(
                                  borderRadius: BorderRadius.circular(16),
                                  child: Container(
                                    width: 100,
                                    height: 100,
                                    color: const Color(0xFFE6C17A),
                                    child: Image.asset(
                                      'asset/chronos_ultra_2.jpg',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error, stackTrace) => Container(
                                        color: const Color(0xFFE6C17A),
                                        child: const Icon(
                                          Icons.watch_outlined,
                                          color: Color(0xFF0D1B2A),
                                          size: 36,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 14),

                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Chronos Ultra 2',
                                        style: GoogleFonts.domine(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF0D1B2A),
                                        ),
                                      ),
                                      const SizedBox(height: 3),
                                      Text(
                                        '49mm Cellular • Grade 5 Titanium',
                                        style: GoogleFonts.literata(
                                          fontSize: 11.5,
                                          color: const Color(0xFF1B365D),
                                        ),
                                      ),
                                      const SizedBox(height: 8),
                                      Row(
                                        children: [
                                          Text(
                                            '₹35,499.00',
                                            style: GoogleFonts.domine(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0D1B2A),
                                            ),
                                          ),
                                          const SizedBox(width: 6),
                                          Text(
                                            '₹39,999.00',
                                            style: GoogleFonts.literata(
                                              fontSize: 11.5,
                                              decoration:
                                                  TextDecoration.lineThrough,
                                              color: const Color(0xFF1B365D),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),

                            const SizedBox(height: 14),

                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  HapticFeedback.lightImpact();
                                  AppNavigator.toProductDetails(context,
                                      productId: 'chronos_ultra_2');
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D1B2A),
                                  foregroundColor: const Color(0xFFF5EBDD),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'View Details',
                                      style: GoogleFonts.literata(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    const Icon(Icons.arrow_forward_rounded,
                                        size: 15),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Section Title
                      Row(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Flexible(
                                  child: Text(
                                    'MATCHED DEVICES & GEAR',
                                    style: GoogleFonts.domine(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0D1B2A),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  '(4 results)',
                                  style: GoogleFonts.literata(
                                    fontSize: 11,
                                    color: const Color(0xFF1B365D),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 6),
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.bolt_rounded,
                                  size: 14, color: Color(0xFF0D1B2A)),
                              const SizedBox(width: 2),
                              Text(
                                'Real-Time Catalog',
                                style: GoogleFonts.literata(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w500,
                                  color: const Color(0xFF0D1B2A),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // 2x2 Grid of Matched Products
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 14,
                          childAspectRatio: ((mediaQuery.size.width - 32 - 12) / 2) /
                              (((mediaQuery.size.width - 32 - 12) / 2 / 1.15) + 98.0),
                        ),
                        itemCount: _matchedProducts.length,
                        itemBuilder: (context, index) {
                          final p = _matchedProducts[index];
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.lightImpact();
                              AppNavigator.toProductDetails(context,
                                  productId: p['id'] as String);
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5EBDD),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF0D1B2A)
                                        .withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 3),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  ClipRRect(
                                    borderRadius: const BorderRadius.vertical(
                                      top: Radius.circular(20),
                                    ),
                                    child: AspectRatio(
                                      aspectRatio: 1.15,
                                      child: Stack(
                                        fit: StackFit.expand,
                                        children: [
                                          Image.asset(
                                            p['image'] as String,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              color: const Color(0xFFE6C17A),
                                            ),
                                          ),
                                          Positioned(
                                            top: 8,
                                            left: 8,
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: p['tagBg'] as Color,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                p['tag'] as String,
                                                style: GoogleFonts.literata(
                                                  fontSize: 8.5,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      p['tagColor'] as Color,
                                                ),
                                              ),
                                            ),
                                          ),
                                          const Positioned(
                                            top: 6,
                                            right: 6,
                                            child: Icon(
                                              Icons.favorite_border_rounded,
                                              size: 16,
                                              color: Color(0xFF1B365D),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),

                                  Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          p['title'] as String,
                                          style: GoogleFonts.domine(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF0D1B2A),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          p['specs'] as String,
                                          style: GoogleFonts.literata(
                                            fontSize: 10.5,
                                            color: const Color(0xFF1B365D),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 8),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              p['price'] as String,
                                              style: GoogleFonts.domine(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF0D1B2A),
                                              ),
                                            ),
                                            Container(
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
                                          ],
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

                      const SizedBox(height: 18),

                      // Bottom Refine Strip
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6C17A),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.manage_search_rounded,
                              size: 19,
                              color: Color(0xFF0D1B2A),
                            ),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Not the right match?',
                                    style: GoogleFonts.domine(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0D1B2A),
                                    ),
                                  ),
                                  Text(
                                    'Refine with text query or adjust crop box',
                                    style: GoogleFonts.literata(
                                      fontSize: 10.5,
                                      color: const Color(0xFF1B365D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 32,
                              child: ElevatedButton(
                                onPressed: () {
                                  AppNavigator.toSearchOverlay(context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0D1B2A),
                                  foregroundColor: const Color(0xFFF5EBDD),
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 14),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: Text(
                                  'Refine',
                                  style: GoogleFonts.literata(
                                    fontSize: 11.5,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // ---------------------------------------------------------------
            // BOTTOM NAVIGATION BAR
            // ---------------------------------------------------------------
            TechKartBottomNavBar(
              currentIndex: 2, // AI Search active
              onTabSelected: (index) {
                if (index == 0) {
                  AppNavigator.toHome(context);
                } else if (index == 1) {
                  AppNavigator.toCategories(context);
                } else if (index == 3) {
                  AppNavigator.toCart(context);
                } else if (index == 4) {
                  AppNavigator.toCustomerProfileHub(context);
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
