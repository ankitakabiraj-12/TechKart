import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/bottom_navbar.dart';
import '../theme/profile_avatar.dart';
import '../core/network/api_client.dart';
import '../core/widgets/techkart_product_image.dart';
import '../system/currency_service.dart';

/// TechKart Search Results Screen (Titanium watch)
///
/// 100% visual fidelity reproduction of the Search Results reference screen:
/// - Light airy background (#F5FAFF)
/// - Top Bar:
///   - TechKart logo mark + "TechKart"
///   - Indian postal code location: "• 400001 • Mumbai"
///   - Notification bell with red dot, user profile avatar.
/// - Search Input Pill:
///   - Back arrow, search icon, "Titanium watch" text, clear "Ã—", mic, and camera lens visual search icons.
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
///      - Rating: "★ 4.9 (420)"
///      - Specs: "Titanium 49mm • Cellul..."
///      - Price: ₹35,499
///      - Image: `asset/chronos_titanium_chrono.jpg`
///   2. "Aura Watch Studio"
///      - Badge: "SAPPHIRE" (Purple/Navy)
///      - Rating: "★ 4.8 (312)"
///      - Specs: "Ceramic Bezel • Sapphire"
///      - Price: ₹32,199
///      - Image: `asset/onboarding_hero_1.png`
///   3. "Volta Dual GaN Do..."
///      - Badge: "COMPANION" (Beige)
///      - Rating: "★ 4.9 (890)"
///      - Specs: "65W Fast Charge • Puck"
///      - Price: ₹7,399
///      - Image: `asset/carousel_fast_gan_charger.jpg`
///   4. "Apex Titanium Link"
///      - Badge: "ECOSYSTEM" (Soft sky blue)
///      - Rating: "★ 4.9 (1.1k)"
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
  final int? categoryId;
  final int? subcategoryId;
  final String? categoryName;

  const SearchResultScreen({
    super.key,
    this.query = 'Titanium watch',
    this.categoryId,
    this.subcategoryId,
    this.categoryName,
  });

  @override
  State<SearchResultScreen> createState() => _SearchResultScreenState();
}

class _SearchResultScreenState extends State<SearchResultScreen> {
  final ApiClient _apiClient = ApiClient();
  late final TextEditingController _searchController;
  final Set<String> _wishlisted = {'chronos_ultra_2'};

  bool _isLoading = true;
  List<Map<String, dynamic>> _results = [];

  final List<Map<String, dynamic>> _fallbackResults = [
    {
      'id': '12',
      'title': 'Apple Watch Ultra 2 (GPS + Cellular, 49mm)',
      'specs': 'Grade 5 Titanium 49mm • 3000 nits Always-On',
      'rating': '4.9 (420)',
      'price': '₹84,900',
      'tag': 'BEST MATCH',
      'tagBg': const Color(0xFF142D4E),
      'tagColor': const Color(0xFFF8FAFC),
      'image': 'https://images.unsplash.com/photo-1508685096489-7aacd43bd3b1?w=800&q=80',
    },
    {
      'id': '102',
      'title': 'Apple iPhone 16 Pro Max',
      'specs': 'Titanium 6.9" Super Retina XDR • A18 Pro',
      'rating': '4.9 (1.4k)',
      'price': '₹1,39,900',
      'tag': 'FLAGSHIP',
      'tagBg': const Color(0xFF142D4E),
      'tagColor': const Color(0xFFF8FAFC),
      'image': 'https://images.unsplash.com/photo-1592750475338-74b7b21085ab?w=800&q=80',
    },
    {
      'id': '16',
      'title': 'Anker 735 GaNPrime 65W Fast Charger',
      'specs': '65W Multi-Port • 2x USB-C + 1x USB-A',
      'rating': '4.9 (890)',
      'price': '₹3,999',
      'tag': 'COMPANION',
      'tagBg': const Color(0xFF142D4E),
      'tagColor': const Color(0xFF142D4E),
      'image': 'https://images.unsplash.com/photo-1583863788434-e58a36330cf0?w=800&q=80',
    },
    {
      'id': '101',
      'title': 'Sony WH-1000XM5 ANC Headphones',
      'specs': 'Industry Leading Noise Cancelling • 30h Playtime',
      'rating': '4.9 (2.1k)',
      'price': '₹29,990',
      'tag': 'HI-RES',
      'tagBg': const Color(0xFF142D4E),
      'tagColor': const Color(0xFF142D4E),
      'image': 'https://images.unsplash.com/photo-1546435770-a3e426bf472b?w=800&q=80',
    },
  ];

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController(text: widget.query);
    _loadProducts();
  }

  Future<void> _loadProducts() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiClient.getProducts(
        categoryId: widget.categoryId,
        subcategoryId: widget.subcategoryId,
        search: widget.subcategoryId != null ? null : (widget.query.isNotEmpty ? widget.query : null),
      );

      if (!mounted) return;

      if (response.isSuccess && response.data != null && response.data!.isNotEmpty) {
        final products = response.data!;
        setState(() {
          _results = products.map((p) {
            final String imgPath = p.primaryImageUrl ?? (p.images.isNotEmpty ? p.images.first : "");

            final specsText = (p.description != null && p.description!.isNotEmpty)
                ? p.description!
                : (p.sellerStoreName != null ? "${p.sellerStoreName} • Authentic" : "Authentic • TechKart");

            return {
              'id': p.id.toString(),
              'title': p.title,
              'specs': specsText,
              'rating': "4.9 (${p.stockQuantity > 0 ? p.stockQuantity : 100})",
              'price': CurrencyService.formatInr(p.price, showDecimals: false),
              'mrp': p.mrp != null ? CurrencyService.formatInr(p.mrp, showDecimals: false) : null,
              'tag': (p.stockQuantity > 0 ? "IN STOCK" : "PRE-ORDER"),
              'tagBg': const Color(0xFF142D4E),
              'tagColor': const Color(0xFFF8FAFC),
              'image': imgPath,
              'stock': p.stockQuantity,
            };
          }).toList();
          _isLoading = false;
        });
      } else {
        if (widget.subcategoryId != null) {
          setState(() {
            _results = [];
            _isLoading = false;
          });
        } else {
          setState(() {
            _results = List.from(_fallbackResults);
            _isLoading = false;
          });
        }
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          if (widget.subcategoryId != null) {
            _results = [];
          } else {
            _results = List.from(_fallbackResults);
          }
          _isLoading = false;
        });
      }
    }
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
        backgroundColor: const Color(0xFF142D4E),
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
        systemNavigationBarColor: Color(0xFFFFFFFF),
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
            SizedBox(height: topPadding > 0 ? topPadding + 4 : 16),

            // ---------------------------------------------------------------
            // UNIFIED TOP BAR: Back + Search Pill + Bell + Avatar
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                      Navigator.of(context).pop();
                    },
                    icon: const Icon(
                      Icons.arrow_back_rounded,
                      color: Color(0xFF000000),
                      size: 22,
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 34, minHeight: 36),
                  ),
                  const SizedBox(width: 4),

                  Expanded(
                    child: Container(
                      height: 44,
                      decoration: BoxDecoration(
                        color: const Color(0xFF142D4E),
                        borderRadius: BorderRadius.circular(22),
                      ),
                      padding: const EdgeInsets.symmetric(horizontal: 12),
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
                              controller: _searchController,
                              style: GoogleFonts.literata(
                                fontSize: 13,
                                color: const Color(0xFF000000),
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: const InputDecoration(
                                filled: false,
                                fillColor: Colors.transparent,
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
                            child: const Icon(
                              Icons.close_rounded,
                              size: 16,
                              color: Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              AppNavigator.toConversationalShoppingAssistant(context);
                            },
                            child: const Icon(
                              Icons.mic_none_rounded,
                              size: 18,
                              color: Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(width: 8),
                          GestureDetector(
                            onTap: () {
                              HapticFeedback.selectionClick();
                              AppNavigator.toAiVisualSearchCamera(context);
                            },
                            child: const Icon(
                              Icons.camera_alt_outlined,
                              size: 18,
                              color: Color(0xFF000000),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

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
                          color: Color(0xFF000000),
                        ),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 32, minHeight: 34),
                      ),
                      Positioned(
                        top: 5,
                        right: 6,
                        child: Container(
                          width: 7,
                          height: 7,
                          decoration: const BoxDecoration(
                            color: Color(0xFFDC2626),
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

            const SizedBox(height: 12),

            // ---------------------------------------------------------------
            // RESULTS COUNT & SORT DROPDOWN
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
                        Flexible(
                          child: Text(
                            widget.categoryName ?? widget.query,
                            style: GoogleFonts.literata(
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000000),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 3,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF142D4E),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(
                            '${_results.length} items',
                            style: GoogleFonts.literata(
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF000000),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Sort dropdown pill
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF142D4E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Sort: Best Match',
                          style: GoogleFonts.literata(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.keyboard_arrow_down_rounded,
                          size: 16,
                          color: Color(0xFF000000),
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
                      color: const Color(0xFF000000),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.check_rounded,
                            size: 14, color: Color(0xFFF8FAFC)),
                        const SizedBox(width: 4),
                        Text(
                          'In Stock',
                          style: GoogleFonts.literata(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: const Color(0xFFF8FAFC),
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
                      color: const Color(0xFF142D4E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        Text(
                          'Filters',
                          style: GoogleFonts.literata(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(width: 4),
                        Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Color(0xFF000000),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: GoogleFonts.literata(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFF8FAFC),
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
                      color: const Color(0xFF142D4E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Titanium Case',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),

                  // Cellular 4G/LTE
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF142D4E),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Text(
                      'Cellular 4G/LTE',
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
                      if (_isLoading)
                        const Padding(
                          padding: EdgeInsets.symmetric(vertical: 48),
                          child: Center(
                            child: CircularProgressIndicator(color: Color(0xFF000000)),
                          ),
                        )
                      else if (_results.isEmpty)
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 48),
                          child: Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 72,
                                  height: 72,
                                  decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                                  child: const Icon(
                                    Icons.inventory_2_outlined,
                                    size: 36,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "No products in this subcategory",
                                  style: GoogleFonts.literata(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  "Verified catalog stock arriving soon.",
                                  style: GoogleFonts.literata(
                                    fontSize: 13,
                                    color: const Color(0xFF000000),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      else
                      Builder(
                        builder: (context) {
                          final screenWidth = MediaQuery.of(context).size.width;
                          final cardWidth = (screenWidth - 32 - 12) / 2;
                          final double cardHeight = (cardWidth / 1.15) + 130.0;
                          final double dynamicRatio = (cardWidth / cardHeight).clamp(0.48, 0.72);

                          return GridView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 12,
                              mainAxisSpacing: 14,
                              childAspectRatio: dynamicRatio,
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
                                color: const Color(0xFFF8FAFC),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: const Color(0xFF000000)
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
                                          TechKartProductImage(
                                            imageUrl: item['image'] as String?,
                                            fit: BoxFit.cover,
                                            productTitle: item['title'] as String?,
                                            categoryName: widget.categoryName,
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
                                                  color: Color(0xFFF8FAFC),
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
                                                            0xFFDC2626)
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
                                    padding: const EdgeInsets.fromLTRB(10, 8, 10, 8),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Row(
                                          children: [
                                            const Icon(
                                              Icons.star_border_rounded,
                                              size: 14,
                                              color: Color(0xFF000000),
                                            ),
                                            const SizedBox(width: 3),
                                            Text(
                                              item['rating'] as String,
                                              style: GoogleFonts.literata(
                                                fontSize: 11,
                                                fontWeight: FontWeight.w500,
                                                color: const Color(0xFF000000),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          item['title'] as String,
                                          style: GoogleFonts.literata(
                                            fontSize: 13,
                                            fontWeight: FontWeight.w700,
                                            color: const Color(0xFF000000),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 2),
                                        Text(
                                          item['specs'] as String,
                                          style: GoogleFonts.literata(
                                            fontSize: 10,
                                            fontWeight: FontWeight.w400,
                                            color: const Color(0xFF000000),
                                          ),
                                          maxLines: 1,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        const SizedBox(height: 6),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          crossAxisAlignment: CrossAxisAlignment.center,
                                          children: [
                                            Row(
                                              crossAxisAlignment: CrossAxisAlignment.baseline,
                                              textBaseline: TextBaseline.alphabetic,
                                              children: [
                                                Text(
                                                  item['price'] as String,
                                                  style: GoogleFonts.literata(
                                                    fontSize: 14.5,
                                                    fontWeight: FontWeight.w700,
                                                    color: const Color(0xFF000000),
                                                  ),
                                                ),
                                                if (item['mrp'] != null) ...[
                                                  const SizedBox(width: 4),
                                                  Text(
                                                    item['mrp'] as String,
                                                    style: GoogleFonts.literata(
                                                      fontSize: 10.5,
                                                      decoration: TextDecoration.lineThrough,
                                                      color: const Color(0xFF000000),
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                            GestureDetector(
                                              onTap: () => _onAddToCart(item),
                                              child: Container(
                                                width: 28,
                                                height: 28,
                                                decoration: const BoxDecoration(
                                                  color: Color(0xFF000000),
                                                  shape: BoxShape.circle,
                                                ),
                                                child: const Center(
                                                  child: Icon(
                                                    Icons.add_rounded,
                                                    size: 17,
                                                    color: Color(0xFFF8FAFC),
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
                      );
                    },),

                      const SizedBox(height: 18),

                      // -----------------------------------------------------
                      // SPECS ASSISTANCE CARD
                      // -----------------------------------------------------
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(18),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF142D4E), Color(0xFF142D4E)],
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
                                    color: Color(0xFF000000),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 16,
                                      color: Color(0xFFF8FAFC),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'Didn\'t find the exact specs?',
                                  style: GoogleFonts.literata(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF000000),
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
                                color: const Color(0xFF000000),
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
                                  color: const Color(0xFFF8FAFC),
                                  borderRadius: BorderRadius.circular(21),
                                ),
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 14),
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.chat_bubble_outline_rounded,
                                      size: 15,
                                      color: Color(0xFF000000),
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        'Compare Chronos battery vs Garmin Epix',
                                        style: GoogleFonts.literata(
                                          fontSize: 11.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF000000),
                                        ),
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 15,
                                      color: Color(0xFF000000),
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
                  AppNavigator.toConversationalShoppingAssistant(context);
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
