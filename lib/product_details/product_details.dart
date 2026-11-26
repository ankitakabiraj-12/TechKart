import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/api_client.dart';
import '../core/network/catalog_models.dart';
import '../core/network/product_resolver.dart';
import '../core/session_manager.dart';
import '../core/widgets/techkart_product_image.dart';
import '../theme/profile_avatar.dart';

/// TechKart Product Details Screen (Chronos Ultra 2)
///
/// 100% visual fidelity reproduction of the Product Details reference screen:
/// - Light airy background (#F5FAFF)
/// - Top Bar:
///   - Back button, TechKart logo mark + "Product ...", share button, heart wishlist button, user profile avatar.
/// - Hero Gallery Container:
///   - White curved stage with `asset/chronos_ultra_2.jpg`.
///   - Top badges: "• Titanium Grade 5", "49mm Cellular", 360 viewer icon.
///   - 2-dot carousel indicator.
/// - Breadcrumb: "Wearables > Watches > Chronos Series"
/// - Title & Rating:
///   - "Chronos Ultra 2" in bold Domine serif font.
///   - "☆ 4.9 (420 reviews) • 98% recommendation"
/// - Pricing & Offer Card (#EAF5FF rounded container):
///   - Price: "₹35,499.00" with strike-through "₹39,999.00", soft gold pill badge "SAVE ₹4,500".
///   - EMI option: "or ₹2,958/mo with 0% APR across 12 months ⓘ"
///   - Stock indicator: "⚡ In Stock — Mumbai 400001 2-hr delivery available"
/// - Case Finish Selector:
///   - "Case Finish" on left, "Natural Titanium" on right.
///   - 3 rounded pill swatches:
///     - "● Natural" (Selected soft blue border)
///     - "● Space Black"
///     - "● Starlight"
/// - Band Style & Fit:
///   - "Band Style & Fit" on left, "Size Guide" on right.
///   - 3 band selection cards:
///     1. "Midnight Ocean Band — 49mm" (Selected, high-performance elastomer, checked radio)
///     2. "Alpine Loop — Orange 49mm" (Seamless dual-layer weave with titanium G-hook, radio)
///     3. "Trail Loop — Grey 49mm" (Ultra-thin lightweight textile tab for runners, radio)
/// - SPECIFICATIONS MATRIX (2x2 rounded light blue grid cards):
///   - BATTERY: "Up to 72 hrs Low Power"
///   - WATER DEPTH: "100m ISO 22810 Rated"
///   - RETINA DISPLAY: "3,000 Nits Always-On"
///   - DIAGNOSTICS: "Dual-Freq GPS & ECG"
/// - TechKart AI Fitment Advisor Card:
///   - Bot icon, "Unsure about wrist drape or band swapping? Our AI assistant verifies lug compatibility & circumference instantly."
///   - "Check Wrist Size →" link.
/// - Assurance badges:
///   - Free Priority Shipping (Arrives tomorrow to Mumbai 400001)
///   - 2-Year Titanium Care Guarantee (Hassle-free coverage & 30-day trial returns)
/// - Bottom Sticky Bar:
///   - "TOTAL PRICE / ₹74,999.00" (or item price)
///   - Dark charcoal button: "👜 Add to Cart"
class ProductDetailsScreen extends StatefulWidget {
  final String productId;

  const ProductDetailsScreen({
    super.key,
    this.productId = 'chronos_ultra_2',
  });

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  ProductModel? _product;
  int _selectedFinishIndex = 0;
  final List<Map<String, dynamic>> _finishes = [
    {'name': 'Natural', 'color': Color(0xFF6B655C)},
    {'name': 'Space Black', 'color': const Color(0xFF0D1B2A)},
    {'name': 'Starlight', 'color': Color(0xFFE2D9C8)},
  ];

  int _selectedBandIndex = 0;
  final List<Map<String, dynamic>> _bands = [
    {
      'title': 'Midnight Ocean Band — 49mm',
      'subtitle': 'High-performance elastomer for water sports',
      'icon': Icons.watch_outlined,
      'color': const Color(0xFF0D1B2A),
    },
    {
      'title': 'Alpine Loop — Orange 49mm',
      'subtitle': 'Seamless dual-layer weave with titanium G-hook',
      'icon': Icons.hiking_rounded,
      'color': Color(0xFFE28743),
    },
    {
      'title': 'Trail Loop — Grey 49mm',
      'subtitle': 'Ultra-thin lightweight textile tab for runners',
      'icon': Icons.directions_run_rounded,
      'color': const Color(0xFF1B365D),
    },
  ];

  bool _isWishlisted = false;
  bool _isWishlistLoading = false;
  int _selectedVariantIndex = 0;
  bool _isAddingToCart = false;
  final ApiClient _apiClient = ApiClient();

  ProductVariantModel? get _currentVariant =>
      (_product != null && _product!.variants.isNotEmpty && _selectedVariantIndex < _product!.variants.length)
          ? _product!.variants[_selectedVariantIndex]
          : null;

  double get _effectivePrice =>
      _currentVariant?.sellingPrice ?? _product?.price ?? 35499.0;

  double? get _effectiveMrp =>
      _currentVariant?.mrp ?? _product?.mrp ?? 39999.0;

  int get _effectiveStock =>
      _currentVariant?.stockQuantity ?? _product?.stockQuantity ?? 10;

  String get _effectiveSku =>
      _currentVariant?.sku ?? 'TK-CAT-STD';

  @override
  void initState() {
    super.initState();
    _checkWishlistStatus();
    _loadProductDetails();
  }

  @override
  void dispose() {
    _apiClient.close();
    super.dispose();
  }

  Future<void> _loadProductDetails() async {
    try {
      final res = await _apiClient.getProduct(widget.productId);
      if (res.isSuccess && res.data != null && mounted) {
        setState(() {
          _product = res.data;
          if (_product!.variants.isNotEmpty) {
            _selectedVariantIndex = 0;
          }
        });
      }
    } catch (_) {
      // Graceful fallback to default in offline/test mode
    }
  }

  Future<void> _handleAddToCart({bool navigateToCheckout = false}) async {
    HapticFeedback.mediumImpact();
    setState(() => _isAddingToCart = true);

    final resolvedProductId = _product?.id ?? ProductResolver.toProductId(widget.productId);
    final variantId = _currentVariant?.id;
    final listingId = _currentVariant?.listingId;

    try {
      final res = await _apiClient.addToCart(
        productId: resolvedProductId,
        variantId: variantId,
        listingId: listingId,
        quantity: 1,
      );

      if (!mounted) return;
      setState(() => _isAddingToCart = false);

      final variantText = _currentVariant != null ? ' (${_currentVariant!.variantName})' : '';
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            res.isSuccess
                ? 'Added ${_product?.title ?? "Product"}$variantText to cart!'
                : (res.message.isNotEmpty ? res.message : 'Added to cart!'),
            style: GoogleFonts.literata(fontSize: 13),
          ),
          backgroundColor: const Color(0xFF0D1B2A),
          duration: const Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );

      if (navigateToCheckout) {
        AppNavigator.toDeliveryAddress(context);
      } else {
        AppNavigator.toCart(context);
      }
    } catch (_) {
      if (mounted) {
        setState(() => _isAddingToCart = false);
        if (navigateToCheckout) {
          AppNavigator.toDeliveryAddress(context);
        } else {
          AppNavigator.toCart(context);
        }
      }
    }
  }

  Future<void> _checkWishlistStatus() async {
    final token = await _apiClient.tokenStorage.getToken();
    if (token == null || token.isEmpty) return;

    try {
      final res = await _apiClient.getWishlist();
      if (res.success && res.data != null && mounted) {
        final targetId = ProductResolver.toProductId(widget.productId);
        final found = res.data!.items.any((item) => item.productId == targetId);
        setState(() {
          _isWishlisted = found;
        });
      }
    } catch (_) {
      // Graceful fallback to default in offline/test mode
    }
  }

  Future<void> _toggleWishlist() async {
    HapticFeedback.selectionClick();
    final targetId = ProductResolver.toProductId(widget.productId);
    final previousState = _isWishlisted;

    setState(() {
      _isWishlisted = !previousState;
      _isWishlistLoading = true;
    });

    try {
      if (!previousState) {
        final res = await _apiClient.addToWishlist(targetId);
        if (res.success && res.data != null) {
          SessionManager().updateWishlistCount(res.data!.summary.totalItems);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Added to your saved wishlist.',
                  style: GoogleFonts.literata(fontSize: 13),
                ),
                backgroundColor: const Color(0xFF0D1B2A),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      } else {
        final res = await _apiClient.removeFromWishlist(targetId);
        if (res.success && res.data != null) {
          SessionManager().updateWishlistCount(res.data!.summary.totalItems);
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  'Removed from your saved wishlist.',
                  style: GoogleFonts.literata(fontSize: 13),
                ),
                backgroundColor: const Color(0xFF0D1B2A),
                duration: const Duration(seconds: 2),
                behavior: SnackBarBehavior.floating,
              ),
            );
          }
        }
      }
    } catch (e) {
      // Revert if API failed
      if (mounted) {
        setState(() {
          _isWishlisted = previousState;
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isWishlistLoading = false;
        });
      }
    }
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
        systemNavigationBarColor: Color(0xFFF5EBDD),
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
                  const Spacer(),
                  IconButton(
                    onPressed: () {
                      HapticFeedback.selectionClick();
                    },
                    icon: const Icon(
                      Icons.share_outlined,
                      size: 20,
                      color: Color(0xFF1B365D),
                    ),
                    padding: EdgeInsets.zero,
                    constraints:
                        const BoxConstraints(minWidth: 34, minHeight: 34),
                  ),
                  IconButton(
                    onPressed: _isWishlistLoading ? null : _toggleWishlist,
                    icon: _isWishlistLoading
                        ? const SizedBox(
                            width: 16,
                            height: 16,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              color: Color(0xFF0D1B2A),
                            ),
                          )
                        : Icon(
                            _isWishlisted
                                ? Icons.favorite_rounded
                                : Icons.favorite_border_rounded,
                            size: 20,
                            color: _isWishlisted
                                ? const Color(0xFFE53E3E)
                                : const Color(0xFF1B365D),
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

            // ---------------------------------------------------------------
            // SCROLLABLE CONTENT
            // ---------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Hero Stage Container
                      GestureDetector(
                        onTap: () {
                          HapticFeedback.lightImpact();
                          AppNavigator.toProductGallery(context,
                              productId: widget.productId);
                        },
                        child: Container(
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF5EBDD),
                            borderRadius: BorderRadius.circular(24),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF0D1B2A)
                                    .withValues(alpha: 0.04),
                                blurRadius: 14,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(24),
                            child: AspectRatio(
                              aspectRatio: 1.15,
                              child: Stack(
                                fit: StackFit.expand,
                                children: [
                                  TechKartProductImage(
                                    imageUrl: _product?.primaryImageUrl,
                                    fit: BoxFit.cover,
                                    productTitle: _product?.title,
                                    categoryName: _product?.categoryName,
                                  ),
                                  Positioned(
                                    top: 12,
                                    left: 12,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF5EBDD)
                                                .withValues(alpha: 0.9),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '• Titanium Grade 5',
                                            style: GoogleFonts.literata(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF0D1B2A),
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE6C17A)
                                                .withValues(alpha: 0.9),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                          ),
                                          child: Text(
                                            '49mm Cellular',
                                            style: GoogleFonts.literata(
                                              fontSize: 10,
                                              fontWeight: FontWeight.w600,
                                              color: const Color(0xFF0D1B2A),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    top: 12,
                                    right: 12,
                                    child: Container(
                                      width: 32,
                                      height: 32,
                                      decoration: const BoxDecoration(
                                        color: Color(0xFFF5EBDD),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Center(
                                        child: Icon(
                                          Icons.rotate_right_rounded,
                                          size: 18,
                                          color: Color(0xFF0D1B2A),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    bottom: 12,
                                    left: 0,
                                    right: 0,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Container(
                                          width: 18,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFF0D1B2A),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                        const SizedBox(width: 4),
                                        Container(
                                          width: 5,
                                          height: 4,
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFE6C17A),
                                            borderRadius:
                                                BorderRadius.circular(2),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Breadcrumbs
                      Text(
                        _product != null
                            ? '${_product!.categoryName ?? 'Electronics'}  >  ${_product!.subcategoryName ?? 'Catalog'}'
                            : 'Wearables  >  Watches  >  Chronos Series',
                        style: GoogleFonts.literata(
                          fontSize: 11,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1B365D),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // Title
                      Text(
                        _product?.title ?? 'Chronos Ultra 2',
                        style: GoogleFonts.domine(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                      const SizedBox(height: 4),

                      // Rating
                      Row(
                        children: [
                          const Icon(Icons.star_border_rounded,
                              size: 14, color: Color(0xFF1B365D)),
                          const SizedBox(width: 3),
                          Text(
                            '4.9 (420 reviews)  •  98% recommendation',
                            style: GoogleFonts.literata(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 14),

                      // Pricing & EMI Card
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
                                Text(
                                  '₹${_effectivePrice.toStringAsFixed(0)}',
                                  style: GoogleFonts.domine(
                                    fontSize: 22,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0D1B2A),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                if (_effectiveMrp != null)
                                  Text(
                                    '₹${_effectiveMrp!.toStringAsFixed(0)}',
                                    style: GoogleFonts.literata(
                                      fontSize: 13,
                                      decoration: TextDecoration.lineThrough,
                                      color: const Color(0xFF1B365D),
                                    ),
                                  ),
                                const Spacer(),
                                if (_effectiveMrp != null && _effectiveMrp! > _effectivePrice)
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFFE6C17A),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Text(
                                      'SAVE ₹${(_effectiveMrp! - _effectivePrice).toStringAsFixed(0)}',
                                      style: GoogleFonts.literata(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFFB8860B),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'or ₹${(_effectivePrice / 12).toStringAsFixed(0)}/mo with 0% APR across 12 months ⓘ',
                              style: GoogleFonts.literata(
                                fontSize: 11.5,
                                color: const Color(0xFF1B365D),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Row(
                              children: [
                                Icon(
                                  _effectiveStock > 0 ? Icons.bolt_rounded : Icons.info_outline,
                                  size: 15,
                                  color: _effectiveStock > 0 ? const Color(0xFF0D1B2A) : const Color(0xFFD32F2F),
                                ),
                                const SizedBox(width: 4),
                                Expanded(
                                  child: Text(
                                    _effectiveStock > 0
                                        ? 'In Stock ($_effectiveStock units) — Mumbai 400001 2-hr delivery available'
                                        : 'Currently Out of Stock',
                                    style: GoogleFonts.literata(
                                      fontSize: 11.5,
                                      fontWeight: FontWeight.w500,
                                      color: _effectiveStock > 0 ? const Color(0xFF0D1B2A) : const Color(0xFFD32F2F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            if (_effectiveSku.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(
                                'SKU: $_effectiveSku',
                                style: GoogleFonts.literata(
                                  fontSize: 10,
                                  color: const Color(0xFF1B365D),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),

                      const SizedBox(height: 20),

                      if (_product != null && _product!.variants.isNotEmpty) ...[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Select Variant',
                              style: GoogleFonts.domine(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0D1B2A),
                              ),
                            ),
                            Text(
                              _currentVariant?.variantName ?? 'Standard',
                              style: GoogleFonts.literata(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF1B365D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),

                        SizedBox(
                          height: 38,
                          child: ListView.builder(
                            scrollDirection: Axis.horizontal,
                            itemCount: _product!.variants.length,
                            itemBuilder: (context, index) {
                              final v = _product!.variants[index];
                              final isSelected = _selectedVariantIndex == index;
                              return Padding(
                                padding: const EdgeInsets.only(right: 8),
                                child: GestureDetector(
                                  onTap: () {
                                    HapticFeedback.selectionClick();
                                    setState(() {
                                      _selectedVariantIndex = index;
                                    });
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 14,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? const Color(0xFF0D1B2A)
                                          : const Color(0xFFF5EBDD),
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                        color: isSelected
                                            ? const Color(0xFF0D1B2A)
                                            : const Color(0xFFE6C17A),
                                        width: 1,
                                      ),
                                    ),
                                    child: Center(
                                      child: Text(
                                        v.variantName,
                                        style: GoogleFonts.literata(
                                          fontSize: 12,
                                          fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
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
                        const SizedBox(height: 16),
                      ],

                      // Case Finish Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Case Finish',
                            style: GoogleFonts.domine(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D1B2A),
                            ),
                          ),
                          Text(
                            'Natural Titanium',
                            style: GoogleFonts.literata(
                              fontSize: 12,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Row(
                        children: List.generate(_finishes.length, (index) {
                          final f = _finishes[index];
                          final isSelected = _selectedFinishIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(right: 8),
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _selectedFinishIndex = index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFE6C17A)
                                      : const Color(0xFFF5EBDD),
                                  borderRadius: BorderRadius.circular(20),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF0D1B2A)
                                        : const Color(0xFFE6C17A),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 12,
                                      height: 12,
                                      decoration: BoxDecoration(
                                        color: f['color'] as Color,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                    const SizedBox(width: 6),
                                    Text(
                                      f['name'] as String,
                                      style: GoogleFonts.literata(
                                        fontSize: 12,
                                        fontWeight: isSelected
                                            ? FontWeight.w600
                                            : FontWeight.w400,
                                        color: const Color(0xFF0D1B2A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // Band Style & Fit
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Band Style & Fit',
                            style: GoogleFonts.domine(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D1B2A),
                            ),
                          ),
                          Text(
                            'Size Guide',
                            style: GoogleFonts.literata(
                              fontSize: 12,
                              color: const Color(0xFF1B365D),
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 10),

                      Column(
                        children: List.generate(_bands.length, (index) {
                          final b = _bands[index];
                          final isSelected = _selectedBandIndex == index;
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                setState(() {
                                  _selectedBandIndex = index;
                                });
                              },
                              child: Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  color: isSelected
                                      ? const Color(0xFFE6C17A)
                                      : const Color(0xFFF5EBDD),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected
                                        ? const Color(0xFF0D1B2A)
                                        : const Color(0xFFE6C17A),
                                    width: 1,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      width: 36,
                                      height: 36,
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? const Color(0xFF0D1B2A)
                                            : const Color(0xFFE6C17A),
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          b['icon'] as IconData,
                                          size: 18,
                                          color: isSelected
                                              ? const Color(0xFFF5EBDD)
                                              : const Color(0xFF1B365D),
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: 12),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            b['title'] as String,
                                            style: GoogleFonts.domine(
                                              fontSize: 13,
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF0D1B2A),
                                            ),
                                          ),
                                          const SizedBox(height: 2),
                                          Text(
                                            b['subtitle'] as String,
                                            style: GoogleFonts.literata(
                                              fontSize: 11,
                                              color: const Color(0xFF1B365D),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Icon(
                                      isSelected
                                          ? Icons.check_circle_rounded
                                          : Icons.radio_button_unchecked_rounded,
                                      size: 18,
                                      color: isSelected
                                          ? const Color(0xFF0D1B2A)
                                          : const Color(0xFFE6C17A),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 20),

                      // SPECIFICATIONS MATRIX
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'SPECIFICATIONS MATRIX',
                            style: GoogleFonts.domine(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D1B2A),
                              letterSpacing: 0.5,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              AppNavigator.toProductSpecifications(context,
                                  productId: widget.productId);
                            },
                            child: const Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: Color(0xFF0D1B2A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 1.8,
                        children: [
                          _buildSpecMatrixCard(
                            icon: Icons.battery_charging_full_rounded,
                            title: 'BATTERY',
                            value: 'Up to 72 hrs Low Power',
                          ),
                          _buildSpecMatrixCard(
                            icon: Icons.scuba_diving_rounded,
                            title: 'WATER DEPTH',
                            value: '100m ISO 22810 Rated',
                          ),
                          _buildSpecMatrixCard(
                            icon: Icons.wb_sunny_outlined,
                            title: 'RETINA DISPLAY',
                            value: '3,000 Nits Always-On',
                          ),
                          _buildSpecMatrixCard(
                            icon: Icons.monitor_heart_outlined,
                            title: 'DIAGNOSTICS',
                            value: 'Dual-Freq GPS & ECG',
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      // TechKart AI Fitment Advisor
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
                                      size: 18,
                                      color: Color(0xFF0D1B2A),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Text(
                                  'TechKart AI Fitment Advisor',
                                  style: GoogleFonts.domine(
                                    fontSize: 13.5,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF0D1B2A),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Unsure about wrist drape or band swapping? Our AI assistant verifies lug compatibility & circumference instantly.',
                              style: GoogleFonts.literata(
                                fontSize: 12,
                                color: const Color(0xFF1B365D),
                                height: 1.35,
                              ),
                            ),
                            const SizedBox(height: 8),
                            GestureDetector(
                              onTap: () {
                                AppNavigator.toConversationalShoppingAssistant(
                                    context);
                              },
                              child: Text(
                                'Check Wrist Size →',
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

                      const SizedBox(height: 14),

                      // Assurance Cards
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EBDD),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.local_shipping_outlined,
                                size: 18, color: Color(0xFF0D1B2A)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Free Priority Shipping',
                                    style: GoogleFonts.domine(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0D1B2A),
                                    ),
                                  ),
                                  Text(
                                    'Arrives tomorrow, 2:00 PM to Mumbai 400001',
                                    style: GoogleFonts.literata(
                                      fontSize: 10.5,
                                      color: const Color(0xFF1B365D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 8),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 12),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF5EBDD),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.verified_user_outlined,
                                size: 18, color: Color(0xFF0D1B2A)),
                            const SizedBox(width: 10),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    '2-Year Titanium Care Guarantee',
                                    style: GoogleFonts.domine(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0D1B2A),
                                    ),
                                  ),
                                  Text(
                                    'Hassle-free coverage & 30-day trial returns',
                                    style: GoogleFonts.literata(
                                      fontSize: 10.5,
                                      color: const Color(0xFF1B365D),
                                    ),
                                  ),
                                ],
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
            // BOTTOM STICKY BAR: TOTAL PRICE + ADD TO CART
            // ---------------------------------------------------------------
            Container(
              padding: EdgeInsets.fromLTRB(
                  20, 12, 20, bottomPadding > 0 ? bottomPadding + 8 : 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF5EBDD),
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
                          color: const Color(0xFF1B365D),
                        ),
                      ),
                      Text(
                        '₹${_effectivePrice.toStringAsFixed(0)}',
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
                      // Add to Cart Button
                      OutlinedButton(
                        onPressed: _isAddingToCart ? null : () => _handleAddToCart(),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: const Color(0xFF0D1B2A),
                          side: const BorderSide(color: Color(0xFF0D1B2A)),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                        ),
                        child: Row(
                          children: [
                            if (_isAddingToCart)
                              const SizedBox(
                                width: 14,
                                height: 14,
                                child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF0D1B2A)),
                              )
                            else ...[
                              const Icon(Icons.shopping_bag_outlined, size: 15),
                              const SizedBox(width: 6),
                              Text(
                                'Add to Cart',
                                style: GoogleFonts.literata(
                                  fontSize: 12.5,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                      const SizedBox(width: 8),
                      // Buy Now Button
                      ElevatedButton(
                        onPressed: _isAddingToCart ? null : () => _handleAddToCart(navigateToCheckout: true),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0D1B2A),
                          foregroundColor: const Color(0xFFF5EBDD),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(24),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                        ),
                        child: Row(
                          children: [
                            const Icon(Icons.flash_on_rounded, size: 15, color: Color(0xFFFFD700)),
                            const SizedBox(width: 4),
                            Text(
                              'Buy Now',
                              style: GoogleFonts.literata(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
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
    );
  }

  Widget _buildSpecMatrixCard({
    required IconData icon,
    required String title,
    required String value,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 17, color: const Color(0xFF0D1B2A)),
          const SizedBox(height: 4),
          Text(
            title,
            style: GoogleFonts.literata(
              fontSize: 9.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1B365D),
            ),
          ),
          Text(
            value,
            style: GoogleFonts.literata(
              fontSize: 11,
              fontWeight: FontWeight.w500,
              color: const Color(0xFF0D1B2A),
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}
