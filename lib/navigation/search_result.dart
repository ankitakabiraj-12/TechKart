import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/bottom_navbar.dart';
import '../theme/profile_avatar.dart';

/// TechKart Search Results Screen (Titanium watch)
///
/// 100% visual fidelity reproduction of the Search Results reference screen:
/// - Light airy background (#F5FAFF)
/// - Top Bar:
///   - TechKart logo mark + "TechKart"
///   - Indian postal code location: "• 400001 • Mumbai"
///   - Notification bell with red dot, user profile avatar.
/// - Search Input Pill:
///   - Back arrow, search icon, "Titanium watch" text, clear "×", mic, and camera lens visual search icons.
/// - Results Header:
///   - "Titanium watch" in bold Domine serif font, "14 items" soft sky blue pill tag (#D9ECFE).
///   - "Sort: Best Match v" soft pill dropdown.
/// - Filter Chips Rail:
///   - "✔ In Stock" (Active dark navy #00344B pill)
///   - "Filters 2" (pill with circular count badge)
///   - "Titanium Case" (pill)
///   - "Cellular 4G/LTE" (pill)
/// - 2-Column Product Grid (Clean white cards, 20px radius, heart icon, photo, badges, title, specs, INR ₹ prices, plus button):
///   1. "Chronos Ultra 2"
///      - Badge: "BEST MATCH" (Dark navy)
///      - Rating: "☆ 4.9 (420)"
///      - Specs: "Titanium 49mm • Cellul..."
///      - Price: ₹35,499
///      - Image: `asset/chronos_titanium_chrono.jpg`
///   2. "Aura Watch Studio"
///      - Badge: "SAPPHIRE" (Purple/Navy)
///      - Rating: "☆ 4.8 (312)"
///      - Specs: "Ceramic Bezel • Sapphire"
///      - Price: ₹32,199
///      - Image: `asset/onboarding_hero_1.png`
///   3. "Volta Dual GaN Do..."
///      - Badge: "COMPANION" (Beige)
///      - Rating: "☆ 4.9 (890)"
///      - Specs: "65W Fast Charge • Puck"
///      - Price: ₹7,399
///      - Image: `asset/carousel_fast_gan_charger.jpg`
///   4. "Apex Titanium Link"
///      - Badge: "ECOSYSTEM" (Soft sky blue)
///      - Rating: "☆ 4.9 (1.1k)"
///      - Specs: "Dual Biometrics • 7-day"
///      - Price: ₹45,499
///      - Image: `asset/apex_titanium_link.jpg`
/// - Specs Assistance Card:
///   - Sparkles badge, "Didn't find the exact specs?",
///     "TechKart AI can match watch lugs, titanium grades (Grade 2 vs Grade 5), battery endurance, and cellular band coverage."
///   - Pill button: "💬 Compare Chronos battery vs Garmin Epix →".
/// - Floating Bottom Navigation Bar.
class SearchResultScreen extends StatefulWidget {
  final String query;

  const SearchResultScreen({
    super.key,
    this.query = 'Titanium watch',
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  late final TextEditingController _searchController;
  final Set<String> _wishlisted = {'chronos_ultra_2'};

  final List<Map<String, dynamic>> _results = [
    {
      'id': 'chronos_ultra_2',
      'title': 'Chronos Ultra 2',
      'specs': 'Titanium 49mm • Cellul...',
      'rating': '4.9 (420)',
      'price': '₹35,499',
      'tag': 'BEST MATCH',
      'tagBg': const Color(0xFF00344B),
      'tagColor': Colors.white,
      'image': 'asset/chronos_titanium_chrono.jpg',
    },
    {
      'id': 'aura_watch_studio',
      'title': 'Aura Watch Studio',
      'specs': 'Ceramic Bezel • Sapphire',
      'rating': '4.8 (312)',
      'price': '₹32,199',
      'tag': 'SAPPHIRE',
      'tagBg': const Color(0xFF48587E),
      'tagColor': Colors.white,
      'image': 'asset/onboarding_hero_1.png',
    },
    {
      'id': 'volta_dual_dock',
      'title': 'Volta Dual GaN Do...',
      'specs': '65W Fast Charge • Puck',
      'rating': '4.9 (890)',
      'price': '₹7,399',
      'tag': 'COMPANION',
      'tagBg': const Color(0xFFF3EEE4),
      'tagColor': const Color(0xFF8B6B2B),
      'image': 'asset/carousel_fast_gan_charger.jpg',
    },
    {
      'id': 'apex_titanium_link',
      'title': 'Apex Titanium Link',
      'specs': 'Dual Biometrics • 7-day',
      'rating': '4.9 (1.1k)',
      'price': '₹45,499',
      'tag': 'ECOSYSTEM',
      'tagBg': const Color(0xFFD9ECFE),
      'tagColor': const Color(0xFF00344B),
      'image': 'asset/apex_titanium_link.jpg',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onProductTap(Map<String, dynamic> item) {
    HapticFeedback.lightImpact();
    AppNavigator.toProductDetails(context, productId: item['id'] as String);
  }

  void _onAddToCart(Map<String, dynamic> item) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item['title']} added to your cart.',
          style: GoogleFonts.literata(fontSize: 13.5),
        ),
        backgroundColor: const Color(0xFF00344B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;

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
            // TOP BAR: Brand Logo + Location + Bell + Avatar
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Image.asset(
                    'asset/app_logo.png',
                    height: 32,
                    fit: BoxFit.contain,
                    errorBuilder: (context, error, stackTrace) => Image.asset(
                      'asset/app_launcher_icon.png',
                      height: 32,
                      fit: BoxFit.contain,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'TechKart',
                        style: GoogleFonts.domine(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00344B),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(
                            Icons.location_on_outlined,
                            size: 11,
                            color: Color(0xFF718096),
                          ),
                          const SizedBox(width: 2),
                          Text(
                            '400001 • Mumbai',
                            style: GoogleFonts.literata(
                              fontSize: 10.5,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF718096),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),

                  // Bell
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

                  // Avatar
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
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------------
            // SEARCH INPUT PILL
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF00344B),
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  const SizedBox(width: 6),

                  Expanded(
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
                            child: TextField(
                              controller: _searchController,
                              style: GoogleFonts.literata(
                                fontSize: 13.5,
                                color: const Color(0xFF00344B),
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                contentPadding: EdgeInsets.zero,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _searchController.clear(),
                            child: const Icon(
                              Icons.close_rounded,
                              size: 17,
                              color: Color(0xFF718096),
                            ),
                          ),
                          const SizedBox(width: 10),
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
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // RESULTS COUNT & SORT DROPDOWN
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Text(
                        widget.query,
                        style: GoogleFonts.domine(
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00344B),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFD9ECFE),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Text(
                          '14 items',
                          style: GoogleFonts.literata(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFF00344B),
                          ),
                        ),
                      ),
                    ],
                  ),

                  // Sort dropdown pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sort: Best Match',
                          style: GoogleFonts.literata(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF00344B),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: Color(0xFF00344B),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------------------------------------
            // FILTER CHIPS ROW
            // ---------------------------------------------------------------
            SizedBox(
              height: 32,
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                children: [
                  // In Stock (Active)
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF00344B),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_rounded,
                            size: 14, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'In Stock',
                          style: GoogleFonts.literata(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Filters 2
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Filters',
                          style: GoogleFonts.literata(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF00344B),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Color(0xFF48587E),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: GoogleFonts.literata(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Titanium Case
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Titanium Case',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF00344B),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Cellular 4G/LTE
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5FF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Cellular 4G/LTE',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF00344B),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // 2-COLUMN RESULTS GRID & SPEC ASSISTANT CARD
            // ---------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    children: [
                      GridView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                          crossAxisSpacing: 12,
                          mainAxisSpacing: 14,
                          childAspectRatio: 0.68,
                        ),
                        itemCount: _results.length,
                        itemBuilder: (context, index) {
                          final item = _results[index];
                          final id = item['id'] as String;
                          final isFavorite = _wishlisted.contains(id);

                          return GestureDetector(
                            onTap: () => _onProductTap(item),
                            child: Container(
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF00344B)
                                        .withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
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
                                            item['image'] as String,
                                            fit: BoxFit.cover,
                                            errorBuilder:
                                                (context, error, stackTrace) =>
                                                    Container(
                                              color: const Color(0xFFF1F5F9),
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
                                                color: item['tagBg'] as Color,
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                item['tag'] as String,
                                                style: GoogleFonts.literata(
                                                  fontSize: 8.5,
                                                  fontWeight: FontWeight.w700,
                                                  color:
                                                      item['tagColor'] as Color,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                          Positioned(
                                            top: 6,
                                            right: 6,
                                            child: GestureDetector(
                                              onTap: () {
                                                HapticFeedback.selectionClick();
                                                setState(() {
                                                  if (isFavorite) {
                                                    _wishlisted.remove(id);
                                                  } else {
                                                    _wishlisted.add(id);
                                                  }
                                                });
                                              },
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: const BoxDecoration(
                                                  color: Colors.white,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Center(
                                                  child: Icon(
                                                    isFavorite
                                                        ? Icons.favorite_rounded
                                                        : Icons
                                                            .favorite_border_rounded,
                                                    size: 15,
                                                    color: isFavorite
                                                        ? const Color(
                                                            0xFFE53E3E)
                                                        : const Color(
                                                            0xFF718096),
                                                  ),
                                                ),
                                              ),
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
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star_border_rounded,
                                              size: 14,
                                              color: Color(0xFF4A5568),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              item['rating'] as String,
                                              style: GoogleFonts.literata(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF4A5568),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['title'] as String,
                                          style: GoogleFonts.domine(
                                            fontSize: 13.5,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF00344B),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item['specs'] as String,
                                          style: GoogleFonts.literata(
                                            fontSize: 10.5,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF718096),
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
                                              item['price'] as String,
                                              style: GoogleFonts.domine(
                                                fontSize: 14.5,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF00344B),
                                              ),
                                            ),
                                            GestureDetector(
                                              onTap: () => _onAddToCart(item),
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF00344B),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.add_rounded,
                                                    size: 17,
                                                    color: Colors.white,
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
                        },
                      ),

                      const SizedBox(height: 18),

                      // -----------------------------------------------------
                      // SPECS ASSISTANCE CARD
                      // -----------------------------------------------------
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFFEAF5FF), Color(0xFFD9ECFE)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 32,
                                  height: 32,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFF48587E),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Didn\'t find the exact specs?',
                                  style: GoogleFonts.domine(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF00344B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'TechKart AI can match watch lugs, titanium grades (Grade 2 vs Grade 5), battery endurance, and cellular band coverage.',
                              style: GoogleFonts.literata(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4A5568),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 14),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                AppNavigator.toConversationalShoppingAssistant(
                                    context);
                              },
                              child: Container(
                                width: double.infinity,
                                height: 42,
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 15,
                                      color: Color(0xFF4A5568),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Compare Chronos battery vs Garmin Epix',
                                        style: GoogleFonts.literata(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF00344B),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 15,
                                      color: Color(0xFF00344B),
                                    ),
                                  ],
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
              currentIndex: 1, // Categories/Search
              onTabSelected: (index) {
                if (index == 0) {
                  AppNavigator.toHome(context);
                } else if (index == 1) {
                  AppNavigator.toCategories(context);
                } else if (index == 2) {
                  AppNavigator.toAiVisualSearchCamera(context);
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
