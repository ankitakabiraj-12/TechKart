import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/api_client.dart';
import '../core/network/catalog_models.dart';
import '../theme/bottom_navbar.dart';
import '../theme/profile_avatar.dart';

/// TechKart Subcategories Browsing Screen
///
/// Displays the subcategories of a selected main category in a 2-column card grid
/// matching the exact visual design language and reference layout:
/// - Light airy background (#F5FAFF)
/// - Top bar: Back arrow, Category Title in Domine bold serif, Notification Bell, User Avatar
/// - Controls row: "Sort: Popular v" dropdown, "Filters" pill, Verified Shield icon
/// - Search & Filter Chips rail
/// - 2-Column Subcategory Cards Grid (rounded 20px, genuine local Unsplash images, tag pill, title, subtitle, count/explore icon)
/// - Information Card & Delivery Status Strip
/// - TechKart Bottom Navigation Bar (Categories tab active)
/// - Zero bottom overflow, resilient loading & error states
class SubcategoryProductsScreen extends StatefulWidget {
  final int initialTabIndex;
  final CategoryModel? category;
  final String? categoryName;

  const SubcategoryProductsScreen({
    super.key,
    this.initialTabIndex = 1,
    this.category,
    this.categoryName,
  });

  @override
  State<SubcategoryProductsScreen> createState() =>
      _SubcategoryProductsScreenState();
}

class _SubcategoryProductsScreenState extends State<SubcategoryProductsScreen> {
  final ApiClient _apiClient = ApiClient();
  final TextEditingController _searchController = TextEditingController();

  List<CategoryModel> _subcategories = [];
  bool _isLoading = true;
  String? _errorMessage;
  int _selectedFilterIndex = 0;
  String _searchQuery = '';

  late final CategoryModel _effectiveCategory;

  final List<String> _filters = [
    'All',
    'Flagship & Pro',
    'Accessories',
    'Components',
  ];

  @override
  void initState() {
    super.initState();
    _effectiveCategory = widget.category ??
        CategoryModel(
          id: 1,
          name: widget.categoryName ?? 'Mobiles & Smartphones',
          slug: 'mobiles-smartphones',
        );
    _loadSubcategories();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _apiClient.close();
    super.dispose();
  }

  Future<void> _loadSubcategories() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final res = await _apiClient.getSubcategories(_effectiveCategory.id);
      if (!mounted) return;

      if (res.success && res.data != null) {
        setState(() {
          _subcategories = res.data!;
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = res.message.isNotEmpty
              ? res.message
              : 'Failed to load subcategories';
          _isLoading = false;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _errorMessage = 'Network error. Please try again.';
        _isLoading = false;
      });
    }
  }

  List<CategoryModel> _getFilteredSubcategories() {
    return _subcategories.where((sub) {
      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final matches = sub.name.toLowerCase().contains(q) ||
            sub.slug.toLowerCase().contains(q);
        if (!matches) return false;
      }

      if (_selectedFilterIndex == 0) return true;
      final f = _filters[_selectedFilterIndex].toLowerCase();
      if (f.contains('flagship')) {
        return sub.name.toLowerCase().contains('pro') ||
            sub.name.toLowerCase().contains('smart') ||
            sub.name.toLowerCase().contains('5g') ||
            sub.name.toLowerCase().contains('gaming') ||
            sub.name.toLowerCase().contains('4k');
      } else if (f.contains('accessories')) {
        return sub.name.toLowerCase().contains('access') ||
            sub.name.toLowerCase().contains('case') ||
            sub.name.toLowerCase().contains('cable') ||
            sub.name.toLowerCase().contains('stand') ||
            sub.name.toLowerCase().contains('holder');
      } else if (f.contains('components')) {
        return sub.name.toLowerCase().contains('part') ||
            sub.name.toLowerCase().contains('fan') ||
            sub.name.toLowerCase().contains('mount') ||
            sub.name.toLowerCase().contains('board') ||
            sub.name.toLowerCase().contains('motor');
      }
      return true;
    }).toList();
  }

  String _formatParentId(int parentId) {
    return parentId.toString().padLeft(2, '0');
  }

  Widget _buildSubcategoryImage(CategoryModel sub) {
    final parentPrefix = _formatParentId(_effectiveCategory.id);
    final assetPath = 'asset/subcategories/${parentPrefix}_${sub.slug}.jpg';

    return Image.asset(
      assetPath,
      fit: BoxFit.cover,
      errorBuilder: (context, error, stackTrace) {
        // Fallback to parent category image if available, else placeholder icon
        final parentAsset = 'asset/categories/${_effectiveCategory.slug}.jpg';
        return Image.asset(
          parentAsset,
          fit: BoxFit.cover,
          errorBuilder: (context, error2, stackTrace2) {
            return Container(
              color: const Color(0xFFE2E8F0),
              child: const Center(
                child: Icon(
                  Icons.devices_other_rounded,
                  size: 28,
                  color: Color(0xFF00344B),
                ),
              ),
            );
          },
        );
      },
    );
  }

  void _onSubcategoryTap(CategoryModel sub) {
    HapticFeedback.lightImpact();
    // Navigate to SearchResult / Products filtered by this subcategory
    AppNavigator.toSearchResult(context, query: sub.name);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final screenWidth = mediaQuery.size.width;

    // Responsive aspect ratio to guarantee zero bottom overflow
    final double gridChildAspectRatio = screenWidth < 360 ? 0.70 : 0.75;

    final filteredList = _getFilteredSubcategories();

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Column(
          children: [
            SizedBox(height: topPadding > 0 ? topPadding + 8 : 28),

            // ---------------------------------------------------------------
            // TOP BAR: Back Arrow + Category Title + Notification Bell + Avatar
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      if (Navigator.of(context).canPop()) {
                        Navigator.of(context).pop();
                      } else {
                        AppNavigator.toCategories(context);
                      }
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
                  const SizedBox(width: 8),

                  Expanded(
                    child: Text(
                      _effectiveCategory.name,
                      style: GoogleFonts.domine(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00344B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),

                  // Notification Bell with Badge
                  IconButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      AppNavigator.toNotifications(context);
                    },
                    icon: Stack(
                      clipBehavior: Clip.none,
                      children: [
                        const Icon(
                          Icons.notifications_outlined,
                          color: Color(0xFF00344B),
                          size: 24,
                        ),
                        Positioned(
                          top: 1,
                          right: 1,
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
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 36, minHeight: 36),
                  ),
                  const SizedBox(width: 8),

                  // Profile Avatar
                  ProfileAvatar(
                    size: 34,
                    onTap: () {
                      HapticFeedback.selectionClick();
                      AppNavigator.toCustomerProfileHub(context);
                    },
                  ),
                ],
              ),
            ),

            const SizedBox(height: 12),

            // ---------------------------------------------------------------
            // SECONDARY CONTROLS ROW: Sort Pill + Filters Pill + Verified Badge
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  // Sort: Popular
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5FF),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(
                            Icons.swap_vert_rounded,
                            size: 16,
                            color: Color(0xFF48587E),
                          ),
                          const SizedBox(width: 4),
                          Flexible(
                            child: Text(
                              'Sort: Popular',
                              style: GoogleFonts.literata(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF00344B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const SizedBox(width: 2),
                          const Icon(
                            Icons.keyboard_arrow_down_rounded,
                            size: 16,
                            color: Color(0xFF48587E),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Filters Pill
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
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.tune_rounded,
                          size: 15,
                          color: Color(0xFF48587E),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          'Subcategories',
                          style: GoogleFonts.literata(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF00344B),
                          ),
                        ),
                        const SizedBox(width: 5),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 5,
                            vertical: 1,
                          ),
                          decoration: const BoxDecoration(
                            color: Color(0xFF48587E),
                            borderRadius: BorderRadius.all(Radius.circular(10)),
                          ),
                          child: Text(
                            '${_subcategories.length}',
                            style: GoogleFonts.literata(
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  // Verified Shield
                  Container(
                    width: 32,
                    height: 32,
                    decoration: const BoxDecoration(
                      color: Color(0xFFEAF5FF),
                      shape: BoxShape.circle,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.verified_outlined,
                        size: 16,
                        color: Color(0xFF48587E),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------------
            // SEARCH FIELD (Optional quick filtering)
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                height: 38,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: const Color(0xFF00344B).withValues(alpha: 0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (val) {
                    setState(() {
                      _searchQuery = val.trim();
                    });
                  },
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    color: const Color(0xFF00344B),
                  ),
                  decoration: InputDecoration(
                    hintText: 'Search within ${_effectiveCategory.name}...',
                    hintStyle: GoogleFonts.literata(
                      fontSize: 12.5,
                      color: const Color(0xFFA0AEC0),
                    ),
                    prefixIcon: const Icon(
                      Icons.search_rounded,
                      size: 18,
                      color: Color(0xFF48587E),
                    ),
                    suffixIcon: _searchQuery.isNotEmpty
                        ? IconButton(
                            icon: const Icon(
                              Icons.clear_rounded,
                              size: 16,
                              color: Color(0xFF718096),
                            ),
                            onPressed: () {
                              _searchController.clear();
                              setState(() {
                                _searchQuery = '';
                              });
                            },
                          )
                        : null,
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(vertical: 9),
                  ),
                ),
              ),
            ),

            const SizedBox(height: 10),

            // ---------------------------------------------------------------
            // HORIZONTAL FILTER CHIPS RAIL
            // ---------------------------------------------------------------
            SizedBox(
              height: 32,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilterIndex == index;
                  final label = index == 0
                      ? 'All (${_subcategories.length})'
                      : _filters[index];

                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.selectionClick();
                        setState(() {
                          _selectedFilterIndex = index;
                        });
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 5,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF00344B)
                              : const Color(0xFFEAF5FF),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Center(
                          child: Text(
                            label,
                            style: GoogleFonts.literata(
                              fontSize: 11.5,
                              fontWeight: isSelected
                                  ? FontWeight.w600
                                  : FontWeight.w500,
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

            const SizedBox(height: 12),

            // ---------------------------------------------------------------
            // 2-COLUMN SUBCATEGORY GRID & CONTENT
            // ---------------------------------------------------------------
            Expanded(
              child: _isLoading
                  ? const Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xFF00344B)),
                      ),
                    )
                  : _errorMessage != null
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.cloud_off_rounded,
                                size: 48,
                                color: Color(0xFFA0AEC0),
                              ),
                              const SizedBox(height: 12),
                              Text(
                                _errorMessage!,
                                style: GoogleFonts.literata(
                                  fontSize: 13,
                                  color: const Color(0xFF718096),
                                ),
                              ),
                              const SizedBox(height: 16),
                              ElevatedButton(
                                onPressed: _loadSubcategories,
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF00344B),
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(16),
                                  ),
                                ),
                                child: const Text('Retry'),
                              ),
                            ],
                          ),
                        )
                      : filteredList.isEmpty
                          ? Center(
                              child: Text(
                                'No subcategories match "$_searchQuery"',
                                style: GoogleFonts.literata(
                                  fontSize: 13,
                                  color: const Color(0xFF718096),
                                ),
                              ),
                            )
                          : RefreshIndicator(
                              onRefresh: _loadSubcategories,
                              color: const Color(0xFF00344B),
                              child: SingleChildScrollView(
                                physics: const AlwaysScrollableScrollPhysics(
                                  parent: BouncingScrollPhysics(),
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                  ),
                                  child: Column(
                                    children: [
                                      // Grid
                                      GridView.builder(
                                        shrinkWrap: true,
                                        physics:
                                            const NeverScrollableScrollPhysics(),
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 2,
                                          crossAxisSpacing: 12,
                                          mainAxisSpacing: 14,
                                          childAspectRatio:
                                              gridChildAspectRatio,
                                        ),
                                        itemCount: filteredList.length,
                                        itemBuilder: (context, index) {
                                          final sub = filteredList[index];

                                          return GestureDetector(
                                            onTap: () => _onSubcategoryTap(sub),
                                            child: Container(
                                              decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color:
                                                        const Color(0xFF00344B)
                                                            .withValues(
                                                                alpha: 0.04),
                                                    blurRadius: 10,
                                                    offset: const Offset(0, 4),
                                                  ),
                                                ],
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  // Image Container with Tag
                                                  ClipRRect(
                                                    borderRadius:
                                                        const BorderRadius
                                                            .vertical(
                                                      top: Radius.circular(20),
                                                    ),
                                                    child: AspectRatio(
                                                      aspectRatio: 1.25,
                                                      child: Stack(
                                                        fit: StackFit.expand,
                                                        children: [
                                                          _buildSubcategoryImage(
                                                              sub),

                                                          // Tag Pill
                                                          Positioned(
                                                            top: 8,
                                                            left: 8,
                                                            child: Container(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .symmetric(
                                                                horizontal: 7,
                                                                vertical: 3,
                                                              ),
                                                              decoration:
                                                                  BoxDecoration(
                                                                color: Colors
                                                                    .white
                                                                    .withValues(
                                                                        alpha:
                                                                            0.92),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            10),
                                                              ),
                                                              child: Text(
                                                                'CAT #${sub.displayOrder ?? (index + 1)}',
                                                                style:
                                                                    GoogleFonts
                                                                        .literata(
                                                                  fontSize: 8.5,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w700,
                                                                  color:
                                                                      const Color(
                                                                    0xFF00344B,
                                                                  ),
                                                                  letterSpacing:
                                                                      0.4,
                                                                ),
                                                              ),
                                                            ),
                                                          ),

                                                          // Verified Icon top-right
                                                          Positioned(
                                                            top: 6,
                                                            right: 6,
                                                            child: Container(
                                                              width: 24,
                                                              height: 24,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color:
                                                                    Colors.white,
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child: const Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_forward_ios_rounded,
                                                                  size: 11,
                                                                  color: Color(
                                                                    0xFF00344B,
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ),
                                                  ),

                                                  // Details Section
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            10),
                                                    child: Column(
                                                      crossAxisAlignment:
                                                          CrossAxisAlignment
                                                              .start,
                                                      children: [
                                                        // Subcategory Name
                                                        Text(
                                                          sub.name,
                                                          style: GoogleFonts
                                                              .domine(
                                                            fontSize: 13,
                                                            fontWeight:
                                                                FontWeight.w700,
                                                            color: const Color(
                                                              0xFF00344B,
                                                            ),
                                                          ),
                                                          maxLines: 2,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            height: 3),

                                                        // Subtitle / Parent info
                                                        Text(
                                                          'In ${_effectiveCategory.name}',
                                                          style: GoogleFonts
                                                              .literata(
                                                            fontSize: 10,
                                                            fontWeight:
                                                                FontWeight.w400,
                                                            color: const Color(
                                                              0xFF718096,
                                                            ),
                                                          ),
                                                          maxLines: 1,
                                                          overflow: TextOverflow
                                                              .ellipsis,
                                                        ),
                                                        const SizedBox(
                                                            height: 6),

                                                        // Explore button / pill
                                                        Row(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .spaceBetween,
                                                          children: [
                                                            Text(
                                                              'Explore',
                                                              style: GoogleFonts
                                                                  .literata(
                                                                fontSize: 11,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                                color:
                                                                    const Color(
                                                                  0xFF48587E,
                                                                ),
                                                              ),
                                                            ),
                                                            Container(
                                                              width: 24,
                                                              height: 24,
                                                              decoration:
                                                                  const BoxDecoration(
                                                                color: Color(
                                                                    0xFF00344B),
                                                                shape: BoxShape
                                                                    .circle,
                                                              ),
                                                              child:
                                                                  const Center(
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_forward_rounded,
                                                                  size: 13,
                                                                  color: Colors
                                                                      .white,
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

                                      // Information Guarantee Card
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.all(16),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFEAF5FF),
                                          borderRadius:
                                              BorderRadius.circular(20),
                                        ),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          children: [
                                            Container(
                                              width: 40,
                                              height: 40,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFD9ECFE),
                                                shape: BoxShape.circle,
                                              ),
                                              child: const Center(
                                                child: Icon(
                                                  Icons
                                                      .verified_user_outlined,
                                                  size: 20,
                                                  color: Color(0xFF00344B),
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
                                                    'Genuine Hardware Guarantee',
                                                    style: GoogleFonts.literata(
                                                      fontSize: 12.5,
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      color: const Color(
                                                          0xFF00344B),
                                                    ),
                                                  ),
                                                  const SizedBox(height: 3),
                                                  Text(
                                                    'All products in ${_effectiveCategory.name} are 100% genuine and verified with brand warranty.',
                                                    style: GoogleFonts.literata(
                                                      fontSize: 11.5,
                                                      fontWeight:
                                                          FontWeight.w400,
                                                      color: const Color(
                                                          0xFF4A5568),
                                                      height: 1.35,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),

                                      const SizedBox(height: 14),

                                      // Delivery Status Strip
                                      Container(
                                        width: double.infinity,
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 14,
                                          vertical: 10,
                                        ),
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFD9ECFE)
                                              .withValues(alpha: 0.5),
                                          borderRadius:
                                              BorderRadius.circular(16),
                                        ),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Expanded(
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    width: 6,
                                                    height: 6,
                                                    decoration:
                                                        const BoxDecoration(
                                                      color: Color(0xFF00344B),
                                                      shape: BoxShape.circle,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 8),
                                                  Flexible(
                                                    child: Text(
                                                      'Showing ${filteredList.length} subcategories',
                                                      style:
                                                          GoogleFonts.literata(
                                                        fontSize: 11.5,
                                                        fontWeight:
                                                            FontWeight.w500,
                                                        color: const Color(
                                                            0xFF4A5568),
                                                      ),
                                                      maxLines: 1,
                                                      overflow:
                                                          TextOverflow.ellipsis,
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
                                                const SizedBox(width: 4),
                                                Text(
                                                  'Verified Direct',
                                                  style: GoogleFonts.literata(
                                                    fontSize: 11.5,
                                                    fontWeight: FontWeight.w600,
                                                    color:
                                                        const Color(0xFF00344B),
                                                  ),
                                                ),
                                              ],
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
            ),

            // ---------------------------------------------------------------
            // BOTTOM NAVIGATION BAR
            // ---------------------------------------------------------------
            TechKartBottomNavBar(
              currentIndex: 1, // Categories tab active
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
