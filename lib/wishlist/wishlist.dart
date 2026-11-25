import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/api_client.dart';
import '../core/network/product_resolver.dart';
import '../core/network/wishlist_models.dart';
import '../core/session_manager.dart';
import '../theme/bottom_navbar.dart';
import '../theme/profile_avatar.dart';

/// TechKart Saved Items / Wishlist Screen
///
/// 100% visual fidelity reproduction of the Cart/Wishlist reference:
/// - Light airy background (#F5FAFF)
/// - Top Bar: Back arrow, "Cart" title, search icon, bag badge 2, profile avatar.
/// - Headline: "My Saved Items" in bold Domine serif, "4 items saved" soft sky blue pill tag.
/// - Dual Action Bar:
///   - "🛒 Add All to Cart" (Dark navy button #00344B)
///   - "🎛 Sort & Filter" (Light blue container #EAF5FF)
/// - Horizontal Filter Tags Rail:
///   - "All (4)" (Active dark navy #00344B pill)
///   - "In Stock (3)"
///   - "↘ Price Drop (2)"
///   - "Wearables"
/// - Saved Item Cards (White rounded 20px cards with heart icon, tag, square thumbnail, details, INR ₹ pricing, "Move to Cart" button):
///   1. "Chronos Ultra 2 (49mm GPS)"
///      - Top Tag: "↓ Price dropped by ₹5,800 since saved" (Beige)
///      - Subtitle: "Titanium Smartwatch • LTPO"
///      - Status: "• In Stock (3 units left)"
///      - Price: ₹35,499.00 (was ₹39,999.00)
///      - Footer: "Grade 5 Titanium • 3000 Nit LTPO"
///      - Action: "Move" button
///      - Image: `asset/chronos_ultra_2.jpg`
///   2. "VoltFast 65W GaN Dual USB-C"
///      - Top Tag: "🚚 Next-day dispatch" (Soft blue)
///      - Subtitle: "Ultra-compact • 45W+20W split"
///      - Status: "• In Stock"
///      - Price: ₹3,999.00
///      - Footer: "Dual charging • Foldable pins"
///      - Action: "Move to Cart" button
///      - Image: `asset/carousel_fast_gan_charger.jpg`
///   3. "KeyChron Pro Wireless..."
///      - Top Tags: "↓ Price drop (₹1,650 saved)" (Beige) + "Only 2 left" (Soft red)
///      - Subtitle: "Hot-swappable tactile • Mac/Win"
///      - Status: "• Low Stock" (Red)
///      - Price: ₹9,899.00 (was ₹11,499.00)
///      - Footer: "RGB Backlit • Bluetooth 5.1"
///      - Action: "Move to Cart" button
///      - Image: `asset/desk_bundle_card_clean.png`
///   4. "Aura Fold Pro Smartphone"
///      - Top Tag: "✔ TechKart Verified Care Included" (Soft blue)
///      - Subtitle: "7.9\" Foldable OLED • 512GB"
///      - Status: "• In Stock"
///      - Price: ₹1,24,999.00
///      - Footer: "Titanium Grey • 120Hz LTPO"
///      - Action: "Move to Cart" button
///      - Image: `asset/apex_fold_buds_pro.jpg`
/// - "Looking for more?" AI Recommendation Card:
///   - Bot icon, "Ask TechKart AI to find matching accessories, cables, or bundled offers for your saved gear."
///   - "Consult TechKart AI ↗" link.
/// - Bottom Navigation Bar (Cart tab active).
class WishlistScreen extends StatefulWidget {
  final int initialTabIndex;
  final bool showBottomNav;
  final ValueChanged<int>? onNavTabSelected;
  final VoidCallback? onBack;

  const WishlistScreen({
    super.key,
    this.initialTabIndex = 3,
    this.showBottomNav = true,
    this.onNavTabSelected,
    this.onBack,
  });

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'All (4)',
    'In Stock (3)',
    'Price Drop (2)',
    'Wearables',
  ];

  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;

  final List<Map<String, dynamic>> _savedItems = [
    {
      'id': 'chronos_ultra_2',
      'productId': 12,
      'title': 'Chronos Ultra 2 (49mm GPS)',
      'subtitle': 'Titanium Smartwatch • LTPO',
      'status': '• In Stock (3 units left)',
      'statusColor': const Color(0xFF1B365D),
      'price': '₹35,499.00',
      'cutPrice': '₹39,999.00',
      'badge': '↓ Price dropped by ₹5,800 since saved',
      'badgeBg': const Color(0xFFE6C17A),
      'badgeColor': const Color(0xFFB8860B),
      'footer': 'Grade 5 Titanium • 3000 Nit LTPO',
      'image': 'asset/chronos_ultra_2.jpg',
      'btnText': 'Move',
    },
    {
      'id': 'voltfast_65w_gan',
      'productId': 16,
      'title': 'VoltFast 65W GaN Dual USB-C',
      'subtitle': 'Ultra-compact • 45W+20W split',
      'status': '• In Stock',
      'statusColor': const Color(0xFF1B365D),
      'price': '₹3,999.00',
      'cutPrice': null,
      'badge': 'Next-day dispatch',
      'badgeBg': const Color(0xFFE6C17A),
      'badgeColor': const Color(0xFF0D1B2A),
      'badgeIcon': Icons.local_shipping_outlined,
      'footer': 'Dual charging • Foldable pins',
      'image': 'asset/carousel_fast_gan_charger.jpg',
      'btnText': 'Move to Cart',
    },
    {
      'id': 'keychron_pro_wireless',
      'productId': 17,
      'title': 'KeyChron Pro Wireless...',
      'subtitle': 'Hot-swappable tactile • Mac/Win',
      'status': '• Low Stock',
      'statusColor': const Color(0xFFE53E3E),
      'price': '₹9,899.00',
      'cutPrice': '₹11,499.00',
      'badge': '↓ Price drop (₹1,650 saved)',
      'badgeBg': const Color(0xFFE6C17A),
      'badgeColor': const Color(0xFFB8860B),
      'badge2': 'Only 2 left',
      'badge2Bg': const Color(0xFFFFECEC),
      'badge2Color': const Color(0xFFE53E3E),
      'footer': 'RGB Backlit • Bluetooth 5.1',
      'image': 'asset/keychron_pro_keyboard.jpg',
      'btnText': 'Move to Cart',
    },
    {
      'id': 'aura_fold_pro',
      'productId': 19,
      'title': 'Aura Fold Pro Smartphone',
      'subtitle': '7.9" Foldable OLED • 512GB',
      'status': '• In Stock',
      'statusColor': const Color(0xFF1B365D),
      'price': '₹1,24,999.00',
      'cutPrice': null,
      'badge': 'TechKart Verified Care Included',
      'badgeBg': const Color(0xFFE6C17A),
      'badgeColor': const Color(0xFF0D1B2A),
      'badgeIcon': Icons.verified_user_outlined,
      'footer': 'Titanium Grey • 120Hz LTPO',
      'image': 'asset/apex_fold_buds_pro.jpg',
      'btnText': 'Move to Cart',
    },
  ];

  @override
  void initState() {
    super.initState();
    _fetchWishlist();
  }

  @override
  void dispose() {
    _apiClient.close();
    super.dispose();
  }

  Future<void> _fetchWishlist() async {
    final token = await _apiClient.tokenStorage.getToken();
    if (token == null || token.isEmpty) {
      _syncFiltersAndStats();
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final res = await _apiClient.getWishlist();
      if (res.success && res.data != null && mounted) {
        _populateSavedItems(res.data!);
        SessionManager().updateWishlistCount(res.data!.summary.totalItems);
      }
    } catch (_) {
      // Graceful fallback to default seed items if network is offline
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
        _syncFiltersAndStats();
      }
    }
  }

  void _populateSavedItems(WishlistDataModel data) {
    if (data.items.isEmpty) {
      _savedItems.clear();
      return;
    }

    _savedItems.clear();
    for (final item in data.items) {
      final priceDrop = item.hasPriceDrop && item.mrp != null;
      final priceDiff = priceDrop ? (item.mrp! - item.price).toInt() : 0;

      String badgeText = '';
      Color badgeBg = const Color(0xFFE6C17A);
      Color badgeColor = const Color(0xFF0D1B2A);
      IconData? badgeIcon;

      if (priceDrop) {
        badgeText = '↓ Price dropped by ₹$priceDiff since saved';
        badgeBg = const Color(0xFFE6C17A);
        badgeColor = const Color(0xFFB8860B);
      } else {
        badgeText = 'Next-day dispatch';
        badgeIcon = Icons.local_shipping_outlined;
      }

      String statusText = item.isInStock
          ? (item.stockQuantity <= 3
              ? '• In Stock (${item.stockQuantity} units left)'
              : '• In Stock')
          : '• Out of Stock';
      Color statusColor = item.isInStock
          ? const Color(0xFF1B365D)
          : const Color(0xFFE53E3E);

      _savedItems.add({
        'id': item.slug.isNotEmpty ? item.slug : '${item.productId}',
        'productId': item.productId,
        'wishlistItemId': item.wishlistItemId,
        'title': item.title,
        'subtitle': item.description.isNotEmpty
            ? item.description
            : '${item.categoryName} • ${item.sellerStoreName}',
        'status': statusText,
        'statusColor': statusColor,
        'price': '₹${item.price.toStringAsFixed(2)}',
        'cutPrice': item.mrp != null ? '₹${item.mrp!.toStringAsFixed(2)}' : null,
        'badge': badgeText,
        'badgeBg': badgeBg,
        'badgeColor': badgeColor,
        'badgeIcon': badgeIcon,
        'badge2': item.isLowStock ? 'Only ${item.stockQuantity} left' : null,
        'badge2Bg': const Color(0xFFFFECEC),
        'badge2Color': const Color(0xFFE53E3E),
        'footer': item.sellerStoreName,
        'image': item.primaryImageUrl != null && item.primaryImageUrl!.isNotEmpty
            ? item.primaryImageUrl!
            : 'asset/chronos_ultra_2.jpg',
        'btnText': 'Move to Cart',
        'isInStock': item.isInStock,
        'hasPriceDrop': item.hasPriceDrop,
        'category': item.categoryName,
      });
    }
  }

  void _syncFiltersAndStats() {
    final total = _savedItems.length;
    int inStock = 0;
    int priceDrop = 0;

    for (final item in _savedItems) {
      if (item['isInStock'] != false && !item['status'].toString().contains('Out of Stock')) {
        inStock++;
      }
      if (item['hasPriceDrop'] == true || item['badge'].toString().contains('dropped')) {
        priceDrop++;
      }
    }

    _filters[0] = 'All ($total)';
    _filters[1] = 'In Stock ($inStock)';
    _filters[2] = 'Price Drop ($priceDrop)';
    _filters[3] = 'Wearables';
  }

  List<Map<String, dynamic>> get _displayedItems {
    if (_selectedFilterIndex == 1) {
      // In Stock
      return _savedItems.where((i) {
        return i['isInStock'] != false && !i['status'].toString().contains('Out of Stock');
      }).toList();
    } else if (_selectedFilterIndex == 2) {
      // Price Drop
      return _savedItems.where((i) {
        return i['hasPriceDrop'] == true || i['badge'].toString().contains('dropped');
      }).toList();
    } else if (_selectedFilterIndex == 3) {
      // Wearables
      return _savedItems.where((i) {
        final cat = (i['category'] ?? '').toString().toLowerCase();
        final title = (i['title'] ?? '').toString().toLowerCase();
        return cat.contains('wearable') || title.contains('chronos') || title.contains('watch');
      }).toList();
    }
    return _savedItems;
  }

  Future<void> _removeItem(Map<String, dynamic> item) async {
    HapticFeedback.mediumImpact();
    final int prodId = ProductResolver.toProductId(item['productId'] ?? item['id']);
    final int wishId = item['wishlistItemId'] is int ? item['wishlistItemId'] : prodId;

    final removed = Map<String, dynamic>.from(item);
    setState(() {
      _savedItems.removeWhere((i) => i['productId'] == prodId || i['id'] == item['id']);
      _syncFiltersAndStats();
    });

    try {
      final res = await _apiClient.removeFromWishlist(wishId);
      if (res.success && res.data != null) {
        SessionManager().updateWishlistCount(res.data!.summary.totalItems);
      }
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              '${removed['title']} removed from wishlist.',
              style: GoogleFonts.literata(fontSize: 13),
            ),
            backgroundColor: const Color(0xFF0D1B2A),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    } catch (_) {
      // Revert if API failed
      if (mounted) {
        setState(() {
          _savedItems.add(removed);
          _syncFiltersAndStats();
        });
      }
    }
  }

  Future<void> _clearAll() async {
    HapticFeedback.mediumImpact();
    final backup = List<Map<String, dynamic>>.from(_savedItems);
    setState(() {
      _savedItems.clear();
      _syncFiltersAndStats();
    });

    try {
      final res = await _apiClient.clearWishlist();
      if (res.success && res.data != null) {
        SessionManager().updateWishlistCount(0);
      }
    } catch (_) {
      if (mounted) {
        setState(() {
          _savedItems.addAll(backup);
          _syncFiltersAndStats();
        });
      }
    }
  }

  void _onMoveToCart(Map<String, dynamic> item) {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          '${item['title']} moved to your cart.',
          style: GoogleFonts.literata(fontSize: 13.5),
        ),
        backgroundColor: const Color(0xFF0D1B2A),
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

                  Text(
                    'Wishlist',
                    style: GoogleFonts.domine(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                  const Spacer(),

                  IconButton(
                    onPressed: () => AppNavigator.toSearchOverlay(context),
                    icon: const Icon(
                      Icons.search_rounded,
                      size: 21,
                      color: Color(0xFF1B365D),
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 34, minHeight: 34),
                  ),
                  const SizedBox(width: 6),

                  Stack(
                    children: [
                      IconButton(
                        onPressed: () => AppNavigator.toCart(context),
                        icon: const Icon(
                          Icons.shopping_bag_outlined,
                          size: 22,
                          color: Color(0xFF1B365D),
                        ),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 34, minHeight: 34),
                      ),
                      Positioned(
                        top: 4,
                        right: 4,
                        child: Container(
                          width: 15,
                          height: 15,
                          decoration: const BoxDecoration(
                            color: Color(0xFFE53E3E),
                            shape: BoxShape.circle,
                          ),
                          child: Center(
                            child: Text(
                              '2',
                              style: GoogleFonts.literata(
                                fontSize: 9,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFFF5EBDD),
                              ),
                            ),
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

            const SizedBox(height: 12),

            // ---------------------------------------------------------------
            // HEADLINE & ITEMS COUNT
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Flexible(
                    child: Text(
                      'My Saved Items',
                      style: GoogleFonts.domine(
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D1B2A),
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6C17A),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      '${_savedItems.length} items saved',
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D1B2A),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // DUAL ACTION ROW: Add All to Cart & Sort & Filter
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  Expanded(
                    flex: 6,
                    child: SizedBox(
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          HapticFeedback.lightImpact();
                          AppNavigator.toCart(context);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D1B2A),
                          foregroundColor: const Color(0xFFF5EBDD),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(22),
                          ),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.add_shopping_cart_rounded,
                                size: 15),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Add All to Cart',
                                style: GoogleFonts.literata(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),

                  Expanded(
                    flex: 4,
                    child: GestureDetector(
                      onTap: () {
                        if (_savedItems.isNotEmpty) {
                          _clearAll();
                        }
                      },
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6C17A),
                          borderRadius: BorderRadius.circular(22),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(Icons.tune_rounded,
                                size: 15, color: Color(0xFF0D1B2A)),
                            const SizedBox(width: 5),
                            Flexible(
                              child: Text(
                                'Sort & Filter',
                                style: GoogleFonts.literata(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0D1B2A),
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // FILTER CHIPS RAIL
            // ---------------------------------------------------------------
            SizedBox(
              height: 32,
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                scrollDirection: Axis.horizontal,
                itemCount: _filters.length,
                itemBuilder: (context, index) {
                  final isSelected = _selectedFilterIndex == index;
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
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF0D1B2A)
                              : const Color(0xFFE6C17A),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            if (index == 2) ...[
                              Icon(Icons.trending_down_rounded,
                                  size: 14,
                                  color: isSelected
                                      ? const Color(0xFFF5EBDD)
                                      : const Color(0xFF0D1B2A)),
                              const SizedBox(width: 4),
                            ],
                            Text(
                              _filters[index],
                              style: GoogleFonts.literata(
                                fontSize: 11.5,
                                fontWeight: isSelected
                                    ? FontWeight.w600
                                    : FontWeight.w500,
                                color: isSelected
                                    ? const Color(0xFFF5EBDD)
                                    : const Color(0xFF0D1B2A),
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

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // SAVED ITEMS LIST
            // ---------------------------------------------------------------
            Expanded(
              child: RefreshIndicator(
                color: const Color(0xFF0D1B2A),
                backgroundColor: const Color(0xFFF5EBDD),
                onRefresh: _fetchWishlist,
                child: SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        if (_isLoading && _savedItems.isEmpty)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 40),
                            child: Center(
                              child: CircularProgressIndicator(
                                strokeWidth: 2.5,
                                color: Color(0xFF0D1B2A),
                              ),
                            ),
                          )
                        else if (_displayedItems.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 48),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFE6C17A),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.favorite_border_rounded,
                                      size: 30,
                                      color: Color(0xFF0D1B2A),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 14),
                                Text(
                                  'Your saved wishlist is empty',
                                  style: GoogleFonts.domine(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0D1B2A),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  'Tap the heart on any product to save it for later.',
                                  style: GoogleFonts.literata(
                                    fontSize: 12,
                                    color: const Color(0xFF1B365D),
                                  ),
                                ),
                              ],
                            ),
                          )
                        else
                          ..._displayedItems.map((item) {
                            return Padding(
                              padding: const EdgeInsets.only(bottom: 14),
                              child: Container(
                                width: double.infinity,
                                padding: const EdgeInsets.all(14),
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
                                // Top Badge Row with Heart
                                Row(
                                  children: [
                                    Expanded(
                                      child: Wrap(
                                        spacing: 6,
                                        runSpacing: 4,
                                        crossAxisAlignment: WrapCrossAlignment.center,
                                        children: [
                                          if (item['badge'] != null)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: item['badgeBg'] as Color,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  if (item['badgeIcon'] != null) ...[
                                                    Icon(
                                                      item['badgeIcon'] as IconData,
                                                      size: 11,
                                                      color: item['badgeColor']
                                                          as Color,
                                                    ),
                                                    const SizedBox(width: 4),
                                                  ],
                                                  Flexible(
                                                    child: Text(
                                                      item['badge'] as String,
                                                      style: GoogleFonts.literata(
                                                        fontSize: 9.5,
                                                        fontWeight: FontWeight.w600,
                                                        color: item['badgeColor']
                                                            as Color,
                                                      ),
                                                      overflow: TextOverflow.ellipsis,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          if (item['badge2'] != null)
                                            Container(
                                              padding: const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                              decoration: BoxDecoration(
                                                color: item['badge2Bg'] as Color,
                                                borderRadius:
                                                    BorderRadius.circular(8),
                                              ),
                                              child: Text(
                                                item['badge2'] as String,
                                                style: GoogleFonts.literata(
                                                  fontSize: 9.5,
                                                  fontWeight: FontWeight.w600,
                                                  color: item['badge2Color'] as Color,
                                                ),
                                              ),
                                            ),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    GestureDetector(
                                      onTap: () => _removeItem(item),
                                      child: const Padding(
                                        padding: EdgeInsets.all(4),
                                        child: Icon(
                                          Icons.favorite_rounded,
                                          size: 20,
                                          color: Color(0xFFE53E3E),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 12),

                                // Thumbnail + Details Row
                                Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.circular(14),
                                      child: Container(
                                        width: 78,
                                        height: 78,
                                        color: const Color(0xFFE6C17A),
                                        child: (item['image'] as String).startsWith('http')
                                            ? Image.network(
                                                item['image'] as String,
                                                cacheWidth: 350,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    const Icon(Icons.devices_rounded, color: Color(0xFF0D1B2A)),
                                              )
                                            : Image.asset(
                                                item['image'] as String,
                                                cacheWidth: 350,
                                                fit: BoxFit.cover,
                                                errorBuilder: (context, error, stackTrace) =>
                                                    const Icon(Icons.devices_rounded, color: Color(0xFF0D1B2A)),
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
                                            item['title'] as String,
                                            style: GoogleFonts.domine(
                                              fontSize: 13.5,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0D1B2A),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            item['subtitle'] as String,
                                            style: GoogleFonts.literata(
                                              fontSize: 11,
                                              color: const Color(0xFF1B365D),
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            item['status'] as String,
                                            style: GoogleFonts.literata(
                                              fontSize: 11,
                                              fontWeight: FontWeight.w500,
                                              color: item['statusColor']
                                                  as Color,
                                            ),
                                          ),
                                          const SizedBox(height: 6),
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Flexible(
                                                child: Text(
                                                  item['price'] as String,
                                                  style: GoogleFonts.domine(
                                                    fontSize: 14,
                                                    fontWeight: FontWeight.w700,
                                                    color:
                                                        const Color(0xFF0D1B2A),
                                                  ),
                                                  overflow: TextOverflow.ellipsis,
                                                ),
                                              ),
                                              if (item['cutPrice'] != null) ...[
                                                const SizedBox(width: 6),
                                                Flexible(
                                                  child: Text(
                                                    item['cutPrice'] as String,
                                                    style: GoogleFonts.literata(
                                                      fontSize: 11,
                                                      decoration: TextDecoration
                                                          .lineThrough,
                                                      color:
                                                          const Color(0xFF1B365D),
                                                    ),
                                                    overflow: TextOverflow.ellipsis,
                                                  ),
                                                ),
                                              ],
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),

                                const SizedBox(height: 12),

                                // Footer Spec + Action Button
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Text(
                                        item['footer'] as String,
                                        style: GoogleFonts.literata(
                                          fontSize: 10.5,
                                          color: const Color(0xFF1B365D),
                                        ),
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    SizedBox(
                                      height: 34,
                                      child: ElevatedButton(
                                        onPressed: () => _onMoveToCart(item),
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:
                                              const Color(0xFF0D1B2A),
                                          foregroundColor: const Color(0xFFF5EBDD),
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 14),
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(17),
                                          ),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(
                                                Icons.shopping_bag_outlined,
                                                size: 13),
                                            const SizedBox(width: 5),
                                            Text(
                                              item['btnText'] as String,
                                              style: GoogleFonts.literata(
                                                fontSize: 11.5,
                                                fontWeight: FontWeight.w600,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      }),

                      const SizedBox(height: 10),

                      // Looking for more? Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6C17A),
                          borderRadius: BorderRadius.circular(20),
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
                                    color: Color(0xFFF5EBDD),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.smart_toy_outlined,
                                      size: 17,
                                      color: Color(0xFF0D1B2A),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Flexible(
                                  child: Text(
                                    'Looking for more?',
                                    style: GoogleFonts.domine(
                                      fontSize: 13.5,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0D1B2A),
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Ask TechKart AI to find matching accessories, cables, or bundled offers for your saved gear.',
                              style: GoogleFonts.literata(
                                fontSize: 11.5,
                                color: const Color(0xFF1B365D),
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                AppNavigator
                                    .toConversationalShoppingAssistant(context);
                              },
                              child: Text(
                                'Consult TechKart AI ↗',
                                style: GoogleFonts.literata(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF0D1B2A),
                                  decoration: TextDecoration.underline,
                                ),
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
          ),

          // ---------------------------------------------------------------
            // BOTTOM NAVIGATION BAR
            // ---------------------------------------------------------------
            if (widget.showBottomNav)
              TechKartBottomNavBar(
                currentIndex: 3, // Cart active
                onTabSelected: (index) {
                  if (widget.onNavTabSelected != null) {
                    widget.onNavTabSelected!(index);
                  } else {
                    if (index == 0) {
                      AppNavigator.toHome(context);
                    } else if (index == 1) {
                      AppNavigator.toCategories(context);
                    } else if (index == 2) {
                      AppNavigator.toAiVisualSearchCamera(context);
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
}
