import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/profile_avatar.dart';

/// TechKart Product Specifications Screen (Chronos Ultra 2)
///
/// 100% visual fidelity reproduction of the Product Specifications reference screen:
/// - Light airy background (#F5FAFF)
/// - Top Bar: Back arrow, TechKart logo mark + "Product ...", share, heart wishlist, profile avatar.
/// - Filter Search Bar: Rounded input field (#EAF5FF) with search icon and placeholder "Filter specs (e.g., nits, GPS, battery)..."
/// - Horizontal Spec Categories Rail:
///   - "Overview" (Active dark navy #00344B pill)
///   - "Display & Case"
///   - "Sensors & Health"
///   - "Power & Battery"
/// - Compact Product Header Card:
///   - Thumbnail image (`asset/chronos_ultra_2.jpg`), "Chronos Ultra 2", "Grade 5 Titanium • 49mm Cellular", "₹35,499.00 • In Stock • Model #CU2-5G", "SPECS" pill tag.
/// - Metric Hero Cards (2 columns):
///   1. PEAK BRIGHTNESS: "3,000 nits", "1 nit minimum in dark mode"
///   2. WATER RATING: "100m ISO 22810", "40m dive certified EN13319"
/// - Detailed Section Blocks (Rounded cards with blue category icons):
///   1. CASE & DIMENSIONS:
///      - Case Dimensions: 49mm Ã— 44mm Ã— 14.4mm
///      - Case Weight: 61.4g (Titanium Chassis)
///      - Wrist Fit Range: Accommodates 130-210 mm wrists
///      - Bezel & Edge: Grade 5 aerospace titanium with raised protection lip
///   2. DISPLAY & OPTICS:
///      - Panel Technology: Always-On Retina LTPO OLED
///      - Luminance: 3,000 nits peak / 1 nit ultra-low
///      - Resolution & Density: 410 Ã— 502 pixels (338 ppi)
///      - Lens Protection: Flat sapphire front crystal with AR coating
///   3. HEALTH & BIO-TELEMETRY:
///      - Cardiac Telemetry: Electrical heart sensor (ECG) & 3rd-Gen Optical PPG
///      - Thermal Sensing: Dual-sensor wrist temp (0.01Â°C precision)
///      - Blood Oxygenation: Optical SpO2 with ambient light filter
///      - Crash & Fall Kinematics: High-g dual accelerometer (up to 256 Gs)
///   4. POWER & ENDURANCE:
///      - Battery Autonomy: 36 hrs normal / up to 72 hrs Low Power Mode
///      - Fast Charging Profile: 0% to 80% in 45 minutes
///      - Chemistry: Rechargeable Lithium-Ion smart pack
///   5. CONNECTIVITY & AUDIO:
///      - Cellular & eSIM: LTE, UMTS (Worldwide eSIM support)
///      - GNSS Satellite: Precision dual-frequency GPS (L1 + L5), GLONASS, BeiDou
///      - Wireless: Wi-Fi 4 (802.11n) + Bluetooth 5.3 LE
///      - Audio Array: Dual speakers (86dB siren) + 3-beam mic
///   6. MATERIALS & RESISTANCE:
///      - Water Resistance: 100m water resistant (ISO 22810:2010)
///      - Dive Rating: EN13319 certified to 40m depth
///      - Ingress & MIL-STD: IP6X Dustproof & MIL-STD 810H tested
/// - "What's in the Box" Card:
///   - "4 ITEMS INCLUDED"
///   - ✔ Chronos Ultra 2 Grade 5 Titanium Case
///   - ✔ Midnight Ocean Band (49mm matching titanium buckle)
///   - ✔ Magnetic Fast Charging USB-C Cable (1m braided)
///   - ✔ Quick Start Guide & 2-Year International Warranty
/// - Bottom disclaimer & Sticky Purchase Bar ("TOTAL PRICE / ₹35,499.00", "👜 Add to Cart").
class ProductSpecificationsScreen extends StatefulWidget {
  final String productId;

  const ProductSpecificationsScreen({
    super.key,
    this.productId = 'chronos_ultra_2',
  });

  @override
  State<ProductSpecificationsScreen> createState() =>
      _ProductSpecificationsScreenState();
}

class _ProductSpecificationsScreenState
    extends State<ProductSpecificationsScreen> {
  final TextEditingController _searchFilter = TextEditingController();
  int _selectedCategoryIndex = 0;

  final List<String> _specCategories = [
    'Overview',
    'Display & Case',
    'Sensors & Health',
    'Power & Battery',
  ];

  @override
  void dispose() {
    _searchFilter.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF8FAFC),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
                      color: Color(0xFF000000),
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  const SizedBox(width: 6),
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                    ),
                    child: ClipOval(
                      child: Image.asset(
                        'asset/app_logo.png',
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) => Image.asset(
                          'asset/app_launcher_icon.png',
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Product ...',
                    style: GoogleFonts.literata(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      Clipboard.setData(ClipboardData(text: 'Full Specifications for ${widget.productId} on TechKart'));
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            'Specifications copied to clipboard.',
                            style: GoogleFonts.literata(),
                          ),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 20,
                      color: Color(0xFF000000),
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 34, minHeight: 34),
                  ),
                  IconButton(
                    onPressed: () => AppNavigator.toWishlist(context),
                    icon: const Icon(
                      Icons.favorite_border_rounded,
                      size: 20,
                      color: Color(0xFF000000),
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 34, minHeight: 34),
                  ),
                  const SizedBox(width: 4),
                  const ProfileAvatar(size: 30),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // Search filter field
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFF142D4E),
                  borderRadius: BorderRadius.circular(22),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: [
                    const Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: Color(0xFF000000),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _searchFilter,
                        style: GoogleFonts.literata(
                          fontSize: 13,
                          color: const Color(0xFF000000),
                        ),
                        decoration: InputDecoration(
                          filled: false,
                          fillColor: Colors.transparent,
                          hintText:
                              'Filter specs (e.g., nits, GPS, battery)...',
                          hintStyle: GoogleFonts.literata(
                            fontSize: 12.5,
                            color: const Color(0xFF000000),
                          ),
                          border: InputBorder.none,
                          isDense: true,
                          contentPadding: EdgeInsets.zero,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 12),

            // Horizontal Spec Categories Rail
            SizedBox(
              height: 34,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _specCategories.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedCategoryIndex == index;
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedCategoryIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF142D4E)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(18),
                        ),
                        child: Center(
                          child: Text(
                            _specCategories[index],
                            style: GoogleFonts.literata(
                              fontSize: 12,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? const Color(0xFFF8FAFC)
                                  : const Color(0xFF142D4E),
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------------------------------------
            // SCROLLABLE SPECIFICATIONS BODY
            // ---------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Compact Header Card
                      Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(18),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withValues(alpha: 0.04),
                              blurRadius: 10,
                              offset: const Offset(0, 3),
                            ),
                          ],
                        ),
                        child: Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Container(
                                width: 54,
                                height: 54,
                                color: const Color(0xFF142D4E),
                                child: Image.asset(
                                  'asset/chronos_ultra_2.jpg',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) => Container(
                                    color: const Color(0xFF142D4E),
                                    child: const Icon(
                                      Icons.watch_outlined,
                                      color: Color(0xFF000000),
                                      size: 24,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Chronos Ultra 2',
                                        style: GoogleFonts.literata(
                                          fontSize: 14.5,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF000000),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 6,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFF142D4E),
                                          borderRadius:
                                              BorderRadius.circular(6),
                                        ),
                                        child: Text(
                                          'SPECS',
                                          style: GoogleFonts.literata(
                                            fontSize: 9,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF000000),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    'Grade 5 Titanium • 49mm Cellular',
                                    style: GoogleFonts.literata(
                                      fontSize: 11,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '₹35,499.00 • In Stock • Model #CU2-5G',
                                    style: GoogleFonts.literata(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 12),

                      // Metric Hero Cards
                      Row(
                        children: [
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF142D4E),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'PEAK BRIGHTNESS',
                                        style: GoogleFonts.literata(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF000000),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.wb_sunny_outlined,
                                        size: 13,
                                        color: Color(0xFF000000),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '3,000 nits',
                                    style: GoogleFonts.literata(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '1 nit minimum in dark mode',
                                    style: GoogleFonts.literata(
                                      fontSize: 10,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: const Color(0xFF142D4E),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'WATER RATING',
                                        style: GoogleFonts.literata(
                                          fontSize: 9,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF000000),
                                        ),
                                      ),
                                      const Icon(
                                        Icons.scuba_diving_rounded,
                                        size: 14,
                                        color: Color(0xFF000000),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '100m ISO 22810',
                                    style: GoogleFonts.literata(
                                      fontSize: 17,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '40m dive certified EN13319',
                                    style: GoogleFonts.literata(
                                      fontSize: 10,
                                      color: const Color(0xFF000000),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Section 1: CASE & DIMENSIONS
                      _buildSpecSection(
                        icon: Icons.calendar_view_week_rounded,
                        title: 'CASE & DIMENSIONS',
                        specs: [
                          {'label': 'Case Dimensions', 'val': '49mm Ã— 44mm Ã— 14.4mm'},
                          {'label': 'Case Weight', 'val': '61.4g (Titanium Chassis)'},
                          {'label': 'Wrist Fit Range', 'val': 'Accommodates 130-210 mm wrists'},
                          {'label': 'Bezel & Edge', 'val': 'Grade 5 aerospace titanium with raised protection lip'},
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Section 2: DISPLAY & OPTICS
                      _buildSpecSection(
                        icon: Icons.filter_none_rounded,
                        title: 'DISPLAY & OPTICS',
                        specs: [
                          {'label': 'Panel Technology', 'val': 'Always-On Retina LTPO OLED'},
                          {'label': 'Luminance', 'val': '3,000 nits peak / 1 nit ultra-low'},
                          {'label': 'Resolution & Density', 'val': '410 Ã— 502 pixels (338 ppi)'},
                          {'label': 'Lens Protection', 'val': 'Flat sapphire front crystal with AR coating'},
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Section 3: HEALTH & BIO-TELEMETRY
                      _buildSpecSection(
                        icon: Icons.monitor_heart_outlined,
                        title: 'HEALTH & BIO-TELEMETRY',
                        specs: [
                          {'label': 'Cardiac Telemetry', 'val': 'Electrical heart sensor (ECG) & 3rd-Gen Optical PPG'},
                          {'label': 'Thermal Sensing', 'val': 'Dual-sensor wrist temp (0.01Â°C precision)'},
                          {'label': 'Blood Oxygenation', 'val': 'Optical SpO2 with ambient light filter'},
                          {'label': 'Crash & Fall Kinematics', 'val': 'High-g dual accelerometer (up to 256 Gs)'},
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Section 4: POWER & ENDURANCE
                      _buildSpecSection(
                        icon: Icons.battery_charging_full_rounded,
                        title: 'POWER & ENDURANCE',
                        specs: [
                          {'label': 'Battery Autonomy', 'val': '36 hrs normal / up to 72 hrs Low Power Mode'},
                          {'label': 'Fast Charging Profile', 'val': '0% to 80% in 45 minutes'},
                          {'label': 'Chemistry', 'val': 'Rechargeable Lithium-Ion smart pack'},
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Section 5: CONNECTIVITY & AUDIO
                      _buildSpecSection(
                        icon: Icons.podcasts_rounded,
                        title: 'CONNECTIVITY & AUDIO',
                        specs: [
                          {'label': 'Cellular & eSIM', 'val': 'LTE, UMTS (Worldwide eSIM support)'},
                          {'label': 'GNSS Satellite', 'val': 'Precision dual-frequency GPS (L1 + L5), GLONASS, BeiDou'},
                          {'label': 'Wireless', 'val': 'Wi-Fi 4 (802.11n) + Bluetooth 5.3 LE'},
                          {'label': 'Audio Array', 'val': 'Dual speakers (86dB siren) + 3-beam mic'},
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Section 6: MATERIALS & RESISTANCE
                      _buildSpecSection(
                        icon: Icons.shield_outlined,
                        title: 'MATERIALS & RESISTANCE',
                        specs: [
                          {'label': 'Water Resistance', 'val': '100m water resistant (ISO 22810:2010)'},
                          {'label': 'Dive Rating', 'val': 'EN13319 certified to 40m depth'},
                          {'label': 'Ingress & MIL-STD', 'val': 'IP6X Dustproof & MIL-STD 810H tested'},
                        ],
                      ),

                      const SizedBox(height: 16),

                      // What's in the Box Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF142D4E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                              children: [
                                Row(
                                  children: [
                                    const Icon(
                                      Icons.inventory_2_outlined,
                                      size: 16,
                                      color: Color(0xFF142D4E),
                                    ),
                                    const SizedBox(width: 8),
                                    Text(
                                      'What\'s in the Box',
                                      style: GoogleFonts.literata(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF142D4E),
                                      ),
                                    ),
                                  ],
                                ),
                                Text(
                                  '4 ITEMS INCLUDED',
                                  style: GoogleFonts.literata(
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.w700,
                                    letterSpacing: 0.8,
                                    color: const Color(0xFF142D4E),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),

                            _buildBoxItem('Chronos Ultra 2 Grade 5 Titanium Case'),
                            _buildBoxItem('Midnight Ocean Band (49mm matching titanium buckle)'),
                            _buildBoxItem('Magnetic Fast Charging USB-C Cable (1m braided)'),
                            _buildBoxItem('Quick Start Guide & 2-Year International Warranty'),
                          ],
                        ),
                      ),

                      const SizedBox(height: 14),

                      // Disclaimer
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Icon(
                            Icons.help_outline_rounded,
                            size: 14,
                            color: Color(0xFF000000),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Chronos Ultra 2 is tested under controlled laboratory conditions with ratings compliant with ISO 22810:2010 and EN13319 standards for recreational diving up to 40 meters. Battery endurance derived from typical daily usage metrics.',
                              style: GoogleFonts.literata(
                                fontSize: 10,
                                color: const Color(0xFF000000),
                                height: 1.35,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // ---------------------------------------------------------------
            // BOTTOM STICKY BAR: TOTAL PRICE + ADD TO CART
            // ---------------------------------------------------------------
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20, bottomPadding > 0 ? bottomPadding + 8 : 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
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
                      Text(
                        'TOTAL PRICE',
                        style: GoogleFonts.literata(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF000000),
                        ),
                      ),
                      Text(
                        '₹35,499.00',
                        style: GoogleFonts.literata(
                          fontSize: 20,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        HapticFeedback.lightImpact();
                        AppNavigator.toCart(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF142D4E),
                        foregroundColor: const Color(0xFFF8FAFC),
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
                            'Add to Cart',
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

  Widget _buildSpecSection({
    required IconData icon,
    required String title,
    required List<Map<String, String>> specs,
  }) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF000000).withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                child: Center(
                  child: Icon(icon, size: 13, color: const Color(0xFF000000)),
                ),
              ),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.literata(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),

          ...specs.map((s) {
            return Container(
              margin: const EdgeInsets.only(bottom: 6),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFFFFFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    s['label']!,
                    style: GoogleFonts.literata(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w400,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    s['val']!,
                    style: GoogleFonts.literata(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildBoxItem(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.check_rounded,
              size: 15,
              color: Color(0xFF142D4E),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                text,
                style: GoogleFonts.literata(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
