import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';

/// TechKart Search Overlay Screen
///
/// 100% visual fidelity reproduction of the Search Overlay reference screen:
/// - Light airy background (#F5FAFF)
/// - Top Search Bar with rounded pill container (#EAF5FF):
///   - Back button on the far left.
///   - Search icon with input prefilled `Titanium watch|` (cursor indicator).
///   - Clear "×" circle icon, microphone icon, and camera lens visual search icon.
/// - Filter Category Tabs:
///   - "All Tech" (Active dark navy #00344B pill)
///   - "Gadgets" (#EAF5FF pill)
///   - "Audio" (#EAF5FF pill)
///   - "Accessories" (#EAF5FF pill)
/// - Top Live Match Dropdown Result Card:
///   - Watch icon in circular blue badge (#EAF5FF).
///   - "Chronos Titanium Watc..." with soft gold "IN STOCK" pill tag and arrow diagonal ↗.
///   - Subtitle: "Hardware category • 49mm Cellular Case".
/// - Section: "RECENT SEARCHES" with right-aligned "Clear All":
///   - Pill tags with history clock icon and trailing "×":
///     - `Chronos Ultra 2 ×`
///     - `GaN 65W Fast Charger ×`
///     - `ANC Headphones ×`
///     - `Foldable OLED ×`
/// - Section: "TRENDING SEARCHES" (with flame icon):
///   - White rounded card containing 5 trending items with numbers (1 to 5) and arrow diagonal ↗:
///     1. "Apex Fold & Buds Pro" + soft beige "Hot Drop" pill badge
///     2. "Mechanical Tactile Keyboard"
///     3. "MagSafe Duo Charging Station"
///     4. "Titanium Cellular Watch 49mm"
///     5. "Spatial Acoustics Earbuds"
/// - Bottom AI Intelligence Card:
///   - Sparkles badge, "TechKart Intelligence",
///     "Ask our assistant about pinouts, display latency, or hardware compatibility."
///   - Pill button: "Compare Chronos vs Aura Studio →".
/// - Bottom home indicator capsule.
class SearchOverlayScreen extends StatefulWidget {
  final String initialQuery;

  const SearchOverlayScreen({
    super.key,
    this.initialQuery = 'Titanium watch',
  });

  @override
  State<SearchOverlayScreen> createState() => _SearchOverlayScreenState();
}

class _SearchOverlayScreenState extends State<SearchOverlayScreen> {
  late final TextEditingController _searchController;
  late final FocusNode _searchFocusNode;

  int _selectedCategoryIndex = 0;
  final List<String> _categories = [
    'All Tech',
    'Gadgets',
    'Audio',
    'Accessories',
  ];

  final List<String> _recentSearches = [
    'Chronos Ultra 2',
    'GaN 65W Fast Charger',
    'ANC Headphones',
    'Foldable OLED',
  ];

  final List<Map<String, dynamic>> _trendingSearches = [
    {
      'title': 'Apex Fold & Buds Pro',
      'hasBadge': true,
      'badge': 'Hot Drop',
    },
    {
      'title': 'Mechanical Tactile Keyboard',
      'hasBadge': false,
    },
    {
      'title': 'MagSafe Duo Charging Station',
      'hasBadge': false,
    },
    {
      'title': 'Titanium Cellular Watch 49mm',
      'hasBadge': false,
    },
    {
      'title': 'Spatial Acoustics Earbuds',
      'hasBadge': false,
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.initialQuery);
    _searchFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchSubmitted(String query) {
    if (query.trim().isEmpty) return;
    HapticFeedback.lightImpact();
    AppNavigator.toSearchResult(context, query: query.trim());
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
            SizedBox(height: topPadding > 0 ? topPadding + 8 : 28),

            // ---------------------------------------------------------------
            // TOP BAR: Back Button + Rounded Search Input Box
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
                    constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  const SizedBox(width: 8),

                  Expanded(
                    child: Container(
                      height: 48,
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5FF),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 14),
                      child: Row(
                        children: [
                          const Icon(
                            Icons.search_rounded,
                            size: 20,
                            color: Color(0xFF4A5568),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: TextField(
                              controller: _searchController,
                              focusNode: _searchFocusNode,
                              onSubmitted: _onSearchSubmitted,
                              style: GoogleFonts.literata(
                                fontSize: 14.5,
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
                            onTap: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            child: Container(
                              width: 18,
                              height: 18,
                              decoration: const BoxDecoration(
                                color: Color(0xFFCCE4F5),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.close_rounded,
                                  size: 13,
                                  color: Color(0xFF00344B),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.mic_none_rounded,
                            size: 20,
                            color: Color(0xFF4A5568),
                          ),
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              AppNavigator.toAiVisualSearchCamera(context);
                            },
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 20,
                              color: Color(0xFF4A5568),
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
            // HORIZONTAL CATEGORY CHIPS RAIL
            // ---------------------------------------------------------------
            SizedBox(
              height: 38,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _categories.length,
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
                          vertical: 8,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00344B)
                              : const Color(0xFFEAF5FF),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Center(
                          child: Text(
                            _categories[index],
                            style: GoogleFonts.literata(
                              fontSize: 13,
                              fontWeight:
                                  isSelected ? FontWeight.w600 : FontWeight.w500,
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF00344B),
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
                      // TOP LIVE MATCH RESULT CARD
                      // -----------------------------------------------------
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          AppNavigator.toProductDetails(
                            context,
                            productId: 'chronos_ultra_2',
                          );
                        },
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(18),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00344B).withValues(alpha: 0.04),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Row(
                            children: [
                              // Watch circle icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEAF5FF),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.watch_outlined,
                                    size: 22,
                                    color: Color(0xFF00344B),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            'Chronos Titanium Watc...',
                                            style: GoogleFonts.domine(
                                              fontSize: 14.5,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF00344B),
                                            ),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF3EEE4),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            'IN\nSTOCK',
                                            textAlign: TextAlign.center,
                                            style: GoogleFonts.literata(
                                              fontSize: 8.5,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF8B6B2B),
                                              height: 1.1,
                                              letterSpacing: 0.6,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(width: 8),
                                        const Icon(
                                          Icons.north_east_rounded,
                                          size: 18,
                                          color: Color(0xFF4A5568),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 4),
                                    Text(
                                      'Hardware category • 49mm Cellular Case',
                                      style: GoogleFonts.literata(
                                        fontSize: 12,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF718096),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // -----------------------------------------------------
                      // SECTION: RECENT SEARCHES
                      // -----------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'RECENT SEARCHES',
                            style: GoogleFonts.domine(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00344B),
                              letterSpacing: 0.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _recentSearches.clear();
                              });
                            },
                            child: Text(
                              'Clear All',
                              style: GoogleFonts.literata(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4A5568),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      Wrap(
                        spacing: 8,
                        runSpacing: 8,
                        children: _recentSearches.map((item) {
                          return GestureDetector(
                            onTap: () => _onSearchSubmitted(item),
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFFEAF5FF),
                                borderRadius: BorderRadius.circular(18),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Icon(
                                    Icons.history_rounded,
                                    size: 16,
                                    color: Color(0xFF4A5568),
                                  ),
                                  const SizedBox(width: 6),
                                  Text(
                                    item,
                                    style: GoogleFonts.literata(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w500,
                                      color: const Color(0xFF00344B),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _recentSearches.remove(item);
                                      });
                                    },
                                    child: const Icon(
                                      Icons.close_rounded,
                                      size: 14,
                                      color: Color(0xFF718096),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        }).toList(),
                      ),

                      const SizedBox(height: 28),

                      // -----------------------------------------------------
                      // SECTION: TRENDING SEARCHES
                      // -----------------------------------------------------
                      Row(
                        children: [
                          const Icon(
                            Icons.local_fire_department_rounded,
                            size: 18,
                            color: Color(0xFF00344B),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'TRENDING SEARCHES',
                            style: GoogleFonts.domine(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00344B),
                              letterSpacing: 0.5,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 12),

                      // Trending list card
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF00344B).withValues(alpha: 0.04),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: Column(
                          children: List.generate(_trendingSearches.length, (index) {
                            final item = _trendingSearches[index];
                            return InkWell(
                              onTap: () =>
                                  _onSearchSubmitted(item['title'] as String),
                              borderRadius: BorderRadius.circular(20),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 18,
                                  vertical: 14,
                                ),
                                child: Row(
                                  children: [
                                    // Number index
                                    SizedBox(
                                      width: 20,
                                      child: Text(
                                        '${index + 1}',
                                        style: GoogleFonts.literata(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF00344B),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),

                                    Expanded(
                                      child: Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              item['title'] as String,
                                              style: GoogleFonts.literata(
                                                fontSize: 13.5,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF2D3748),
                                              ),
                                              maxLines: 1,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                          if (item['hasBadge'] == true) ...[
                                            const SizedBox(width: 8),
                                            Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 3,
                                              ),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFFF3EEE4),
                                                borderRadius:
                                                    BorderRadius.circular(10),
                                              ),
                                              child: Text(
                                                item['badge'] as String,
                                                style: GoogleFonts.literata(
                                                  fontSize: 10,
                                                  fontWeight: FontWeight.w600,
                                                  color:
                                                      const Color(0xFF8B6B2B),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ],
                                      ),
                                    ),

                                    const Icon(
                                      Icons.north_east_rounded,
                                      size: 17,
                                      color: Color(0xFF718096),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // -----------------------------------------------------
                      // TECHKART INTELLIGENCE CARD
                      // -----------------------------------------------------
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF5FF),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 18,
                                      color: Color(0xFF00344B),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  'TechKart Intelligence',
                                  style: GoogleFonts.domine(
                                    fontSize: 15,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF00344B),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),
                            Text(
                              'Ask our assistant about pinouts, display latency, or hardware compatibility.',
                              style: GoogleFonts.literata(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF4A5568),
                                height: 1.4,
                              ),
                            ),
                            const SizedBox(height: 16),
                            SizedBox(
                              width: double.infinity,
                              height: 44,
                              child: ElevatedButton(
                                onPressed: () {
                                  HapticFeedback.selectionClick();
                                  AppNavigator
                                      .toConversationalShoppingAssistant(
                                          context);
                                },
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white,
                                  foregroundColor: const Color(0xFF00344B),
                                  elevation: 0,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(22),
                                    side: const BorderSide(
                                      color: Color(0xFFCBD5E1),
                                      width: 1,
                                    ),
                                  ),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Compare Chronos vs Aura Studio',
                                      style: GoogleFonts.literata(
                                        fontSize: 13,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF00344B),
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 16,
                                      color: Color(0xFF00344B),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Home indicator
                      Center(
                        child: Container(
                          width: 134,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFCBD5E1),
                            borderRadius: BorderRadius.circular(2),
                          ),
                        ),
                      ),

                      SizedBox(height: bottomPadding > 0 ? bottomPadding + 4 : 16),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
