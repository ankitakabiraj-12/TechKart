import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';

/// TechKart Product Gallery Screen (Chronos Ultra 2)
///
/// 100% visual fidelity reproduction of the Product Gallery reference screen:
/// - Light airy background (#F5FAFF)
/// - Top Bar:
///   - Circular back button on the left (#EAF5FF)
///   - Title "Chronos Ultra 2" in bold Domine serif, with page pill "1 / 4" (#D9ECFE)
///   - Action buttons on the right: Share button (#EAF5FF), Fullscreen expand icon (#EAF5FF)
/// - Material & Feature Tags:
///   - "Grade 5 Titanium • 49mm" (Soft sky blue pill)
///   - "• Sapphire Crystal" (Soft beige pill)
/// - Central High-Resolution Macro Viewport:
///   - Large white card showcasing product macro angle (`asset/chronos_ultra_2.jpg`)
///   - Floating zoom controls on the right: [+] [1x] [-]
///   - Floating bottom status bar: "🔍 Pinch or double-tap to inspect finish", "1.0x"
/// - Perspective Info Row:
///   - "Perspective: Isometric bezel & crown profile" in Literata italic/serif font.
///   - "MACRO 4K" badge with verified checkmark.
/// - 4 Interactive Thumbnail Circles:
///   - Thumb 1: Selected (Circle with dark border ring & active dot), isometric view
///   - Thumb 2: Side crown & button angle (`asset/chronos_side_angle.jpg`)
///   - Thumb 3: Lug curvature profile (`asset/chronos_lug_angle.jpg`)
///   - Thumb 4: Clasp & strap finish (`asset/chronos_clasp_angle.jpg`)
/// - Highlight Feature Card:
///   - Search icon, "3000 Nit OLED Display", "Edge-to-edge sapphire crystal shield", "100M DIVE"
/// - Bottom Sticky Purchase Bar:
///   - "• In Stock • Ships Tomorrow"
///   - "₹35,499.00" with strike-through "₹39,999.00"
///   - Primary button: "👜 Add to Bag" (Dark navy)
class ProductGalleryScreen extends StatefulWidget {
  final String productId;

  const ProductGalleryScreen({
    super.key,
    this.productId = 'chronos_ultra_2',
  });

  @override
  State<ProductGalleryScreen> createState() => _ProductGalleryScreenState();
}

class _ProductGalleryScreenState extends State<ProductGalleryScreen> {
  int _selectedThumbIndex = 0;

  final List<String> _galleryImages = [
    'asset/chronos_ultra_2.jpg',
    'asset/chronos_side_angle.jpg',
    'asset/chronos_lug_angle.jpg',
    'asset/chronos_clasp_angle.jpg',
  ];

  final List<String> _perspectives = [
    'Perspective: Isometric bezel & crown profile',
    'Perspective: Digital crown & action button profile',
    'Perspective: Lug curvature & strap attachment',
    'Perspective: Titanium clasp & elastomer buckle',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Colors.white,
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
            // TOP BAR
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      width: 40,
                      height: 40,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF5FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.arrow_back_ios_new_rounded,
                          size: 16,
                          color: Color(0xFF00344B),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Text(
                          'Chronos Ultra 2',
                          style: GoogleFonts.domine(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00344B),
                          ),
                        ),
                        const SizedBox(height: 2),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFD9ECFE),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '${_selectedThumbIndex + 1} / ${_galleryImages.length}',
                            style: GoogleFonts.literata(
                              fontSize: 10,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF00344B),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF5FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.share_outlined,
                        size: 17,
                        color: Color(0xFF00344B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF5FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.fullscreen_rounded,
                        size: 20,
                        color: Color(0xFF00344B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // TAGS ROW: Titanium + Sapphire
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFD9ECFE),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Grade 5 Titanium • 49mm',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF00344B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3EEE4),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      '• Sapphire Crystal',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF8B6B2B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // MAIN MACRO VIEWPORT
            // ---------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: double.infinity,
                        height: 320,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(24),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00344B).withValues(alpha: 0.05),
                              blurRadius: 16,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(24),
                              child: Image.asset(
                                _galleryImages[_selectedThumbIndex],
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: const Color(0xFFF1F5F9),
                                  child: const Center(
                                    child: Icon(Icons.image_outlined, size: 40),
                                  ),
                                ),
                              ),
                            ),

                            // Floating zoom buttons on right
                            Positioned(
                              top: 20,
                              right: 14,
                              child: Container(
                                decoration: BoxDecoration(
                                  color: Colors.white.withValues(alpha: 0.9),
                                  borderRadius: BorderRadius.circular(20),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(alpha: 0.08),
                                      blurRadius: 10,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.add, size: 18),
                                      constraints: const BoxConstraints(
                                          minWidth: 36, minHeight: 36),
                                      padding: EdgeInsets.zero,
                                    ),
                                    Text(
                                      '1x',
                                      style: GoogleFonts.literata(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF00344B),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {},
                                      icon: const Icon(Icons.remove, size: 18),
                                      constraints: const BoxConstraints(
                                          minWidth: 36, minHeight: 36),
                                      padding: EdgeInsets.zero,
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            // Floating bottom inspection strip
                            Positioned(
                              bottom: 12,
                              left: 12,
                              right: 12,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 5,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFEAF5FF)
                                          .withValues(alpha: 0.95),
                                      borderRadius: BorderRadius.circular(16),
                                    ),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.pinch_rounded,
                                          size: 14,
                                          color: Color(0xFF00344B),
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Pinch or double-tap to inspect finish',
                                          style: GoogleFonts.literata(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF00344B),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFD9ECFE)
                                          .withValues(alpha: 0.95),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      '1.0x',
                                      style: GoogleFonts.literata(
                                        fontSize: 10.5,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF00344B),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Perspective Info Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              _perspectives[_selectedThumbIndex],
                              style: GoogleFonts.literata(
                                fontSize: 12,
                                fontStyle: FontStyle.italic,
                                color: const Color(0xFF4A5568),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.verified_outlined,
                                size: 14,
                                color: Color(0xFF48587E),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'MACRO\n4K',
                                style: GoogleFonts.literata(
                                  fontSize: 8.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF48587E),
                                  height: 1.1,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // 4 Interactive Thumbnail Circles
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: List.generate(_galleryImages.length, (index) {
                          final isSelected = _selectedThumbIndex == index;
                          return GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              setState(() {
                                _selectedThumbIndex = index;
                              });
                            },
                            child: Container(
                              width: 68,
                              height: 68,
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: isSelected
                                    ? Border.all(
                                        color: const Color(0xFF00344B),
                                        width: 2,
                                      )
                                    : Border.all(
                                        color: const Color(0xFFE2E8F0),
                                        width: 1,
                                      ),
                              ),
                              padding: const EdgeInsets.all(3),
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(32),
                                child: Image.asset(
                                  _galleryImages[index],
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Container(
                                    color: const Color(0xFFF1F5F9),
                                  ),
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // Highlight Feature Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF5FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.search_rounded,
                              size: 18,
                              color: Color(0xFF00344B),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '3000 Nit OLED Display',
                                    style: GoogleFonts.domine(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF00344B),
                                    ),
                                  ),
                                  Text(
                                    'Edge-to-edge sapphire crystal shield',
                                    style: GoogleFonts.literata(
                                      fontSize: 11,
                                      color: const Color(0xFF718096),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Text(
                              '100M DIVE',
                              style: GoogleFonts.literata(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF48587E),
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
            // BOTTOM STICKY PURCHASE BAR
            // ---------------------------------------------------------------
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20, bottomPadding > 0 ? bottomPadding + 8 : 16),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 10,
                    offset: const Offset(0, -4),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Row(
                        children: [
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF8B6B2B),
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 5),
                          Text(
                            'In Stock • Ships Tomorrow',
                            style: GoogleFonts.literata(
                              fontSize: 10,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Row(
                        children: [
                          Text(
                            '₹35,499.00',
                            style: GoogleFonts.domine(
                              fontSize: 19,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00344B),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            '₹39,999.00',
                            style: GoogleFonts.literata(
                              fontSize: 11.5,
                              decoration: TextDecoration.lineThrough,
                              color: const Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),

                  SizedBox(
                    height: 46,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        AppNavigator.toCart(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF00344B),
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 24),
                      ),
                      child: Row(
                        children: [
                          const Icon(Icons.shopping_bag_outlined, size: 16),
                          const SizedBox(width: 8),
                          Text(
                            'Add to Bag',
                            style: GoogleFonts.literata(
                              fontSize: 13.5,
                              fontWeight: FontWeight.w600,
                            ),
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
  }
}
