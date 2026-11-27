import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/network.dart';
import '../theme/bottom_navbar.dart';
import '../theme/profile_avatar.dart';
import '../theme/app_theme.dart';
import '../system/currency_service.dart';

/// TechKart Shopping Cart Screen
/// Recreated to match original reference UI with 100% visual fidelity.
class ShoppingCartScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onCheckout;
  final int initialTabIndex;
  final bool showBottomNav;
  final ValueChanged<int>? onNavTabSelected;
  final List<Map<String, dynamic>>? initialItems;
  final VoidCallback? onSearch;
  final VoidCallback? onCartPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onClearCart;
  final ValueChanged<String>? onProductSelected;

  const ShoppingCartScreen({
    super.key,
    this.onBack,
    this.onCheckout,
    this.initialTabIndex = 3,
    this.showBottomNav = true,
    this.onNavTabSelected,
    this.initialItems,
    this.onSearch,
    this.onCartPressed,
    this.onProfilePressed,
    this.onClearCart,
    this.onProductSelected,
  });

  @override
  State<ShoppingCartScreen> createState() => _ShoppingCartScreenState();
}

class _ShoppingCartScreenState extends State<ShoppingCartScreen> {
  final ApiClient _apiClient = ApiClient();
  final TextEditingController _couponController =
      TextEditingController(text: 'TECO10');
  bool _couponApplied = true;

  // Cart items state
  late List<Map<String, dynamic>> _items;

  @override
  void initState() {
    super.initState();
    if (widget.initialItems != null) {
      _items = List.from(widget.initialItems!);
    } else {
      _items = [
        {
          'id': 'chronos_ultra_2',
          'badge': 'SALE',
          'title': 'Chronos Ultra 2 (49mm GPS)',
          'subtitle': 'Grade 5 Titanium • Midnight Band',
          'price': 35499.00,
          'originalPrice': 41499.00,
          'quantity': 1,
          'image': 'asset/chronos_ultra_2.jpg',
        },
        {
          'id': 'voltfast_65w_gan',
          'badge': 'BUNDLE',
          'title': 'VoltFast 65W GaN Charger',
          'subtitle': 'Space Grey • Dual USB-C',
          'price': 3999.00,
          'originalPrice': 4999.00,
          'quantity': 1,
          'image': 'asset/carousel_fast_gan_charger.jpg',
        },
      ];
    }
  }

  @override
  void dispose() {
    _couponController.dispose();
    _apiClient.close();
    super.dispose();
  }

  void _updateQuantity(int index, int delta) {
    HapticFeedback.selectionClick();
    setState(() {
      final newQty = (_items[index]['quantity'] as int) + delta;
      if (newQty > 0) {
        _items[index]['quantity'] = newQty;
      }
    });
  }

  void _removeItem(int index) {
    HapticFeedback.mediumImpact();
    setState(() {
      _items.removeAt(index);
    });
  }

  void _clearCart() {
    HapticFeedback.mediumImpact();
    setState(() {
      _items.clear();
    });
  }

  double get _subtotal {
    return _items.fold(
      0.0,
      (sum, item) => sum + (item['price'] as double) * (item['quantity'] as int),
    );
  }

  double get _discount => _couponApplied ? 800.00 : 0.00;
  double get _tax => _subtotal * 0.05; // 5% GST
  double get _total => _subtotal - _discount + _tax;

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: AppTheme.pureWhite,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: _items.isEmpty
                  ? _buildEmptyState()
                  : ListView(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                      children: [
                        _buildHeaderRow(),
                        const SizedBox(height: 14),
                        _buildFreeExpressBanner(),
                        const SizedBox(height: 16),
                        ..._items.asMap().entries.map((entry) {
                          return _buildCartItemCard(entry.value, entry.key);
                        }),
                        const SizedBox(height: 14),
                        _buildCouponSection(),
                        const SizedBox(height: 16),
                        _buildPriceBreakdownCard(),
                        const SizedBox(height: 20),
                        _buildCheckoutButton(),
                        const SizedBox(height: 12),
                        _buildTrustSafetyNote(),
                        const SizedBox(height: 70),
                      ],
                    ),
            ),
            if (widget.showBottomNav)
              TechKartBottomNavBar(
                currentIndex: 3,
                onTabSelected: (index) {
                  if (widget.onNavTabSelected != null) {
                    widget.onNavTabSelected!(index);
                  } else {
                    if (index == 0) AppNavigator.toHome(context);
                    if (index == 1) AppNavigator.toCategories(context);
                    if (index == 2) AppNavigator.toAiChatSessions(context);
                    if (index == 4) AppNavigator.toProfile(context);
                  }
                },
              ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CLEAN MINIMAL APP BAR
  // ---------------------------------------------------------------------------
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFFFFFF),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
            child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle), child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF000000))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Cart',
              style: GoogleFonts.literata(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, size: 22, color: Color(0xFF000000)),
            onPressed: () => AppNavigator.toSearchOverlay(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 14),
          Stack(
            clipBehavior: Clip.none,
            children: [
              IconButton(
                icon: const Icon(Icons.shopping_bag_outlined,
                    size: 22, color: Color(0xFF000000)),
                onPressed: () {},
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Positioned(
                right: -4,
                top: -4,
                child: Container(
                  padding: const EdgeInsets.all(3.5),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDC2626),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${_items.length}',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFFF8FAFC),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          GestureDetector(
            onTap: () => AppNavigator.toCustomerProfileHub(context),
            child: const ProfileAvatar(size: 32),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'My Cart',
                style: GoogleFonts.literata(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                '${_items.length} items selected for checkout',
                style: GoogleFonts.literata(
                  fontSize: 12,
                  color: const Color(0xFF000000),
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        GestureDetector(
          onTap: _clearCart,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete_outline, size: 14, color: Color(0xFF000000)),
                const SizedBox(width: 4),
                Text(
                  'Clear',
                  style: GoogleFonts.literata(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // FREE EXPRESS SHIPPING BANNER
  // ---------------------------------------------------------------------------
  Widget _buildFreeExpressBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F2FD),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_shipping_outlined,
                    size: 16, color: Color(0xFF142D4E)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Free Express Shipping Unlocked!',
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
              Text(
                '100% QUALIFIED',
                style: GoogleFonts.literata(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 1.0,
              minHeight: 5,
              backgroundColor: Color(0xFFE2E8F0),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF142D4E)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Next-day priority dispatch guaranteed for your order.',
            style: GoogleFonts.literata(
              fontSize: 11.5,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CART ITEM CARD
  // ---------------------------------------------------------------------------
  Widget _buildCartItemCard(Map<String, dynamic> item, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Thumbnail with Pill Badge
          Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 84,
                  height: 84,
                  color: const Color(0xFFF1F5F9),
                  child: Image.asset(
                    item['image'] as String,
                    cacheWidth: 350,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Center(child: Icon(Icons.devices, color: Colors.grey)),
                  ),
                ),
              ),
              Positioned(
                top: 4,
                left: 4,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: item['badge'] == 'SALE'
                        ? const Color(0xFF142D4E)
                        : const Color(0xFFE2E8F0),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item['badge'] as String,
                    style: TextStyle(
                      fontFamily: 'Literata',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: item['badge'] == 'SALE'
                          ? const Color(0xFF142D4E)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        item['title'] as String,
                        style: GoogleFonts.literata(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _removeItem(index),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.delete_outline,
                            size: 18, color: Color(0xFF000000)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item['subtitle'] as String,
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    color: const Color(0xFF000000),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Wrap(
                        crossAxisAlignment: WrapCrossAlignment.center,
                        children: [
                          Text(
                            CurrencyService.formatInr(item['price'] as double, showDecimals: true),
                            style: GoogleFonts.literata(
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          if (item['originalPrice'] != null) ...[
                            const SizedBox(width: 4),
                            Text(
                              CurrencyService.formatInr(item['originalPrice'] as double, showDecimals: true),
                              style: GoogleFonts.literata(
                                fontSize: 11,
                                color: const Color(0xFF000000),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ],
                      ),
                    ),
                    const SizedBox(width: 6),
                    // Stepper (- qty +)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF1F5F9),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          GestureDetector(
                            onTap: () => _updateQuantity(index, -1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                '−',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '${item['quantity']}',
                            style: GoogleFonts.literata(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          GestureDetector(
                            onTap: () => _updateQuantity(index, 1),
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text(
                                '+',
                                style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),
                                ),
                              ),
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
    );
  }

  // ---------------------------------------------------------------------------
  // COUPON SECTION
  // ---------------------------------------------------------------------------
  Widget _buildCouponSection() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined,
              size: 20, color: Color(0xFF000000)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _couponController.text,
              style: GoogleFonts.literata(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          GestureDetector(
            onTap: () {
              setState(() {
                _couponApplied = !_couponApplied;
              });
            },
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: _couponApplied
                    ? const Color(0xFF142D4E)
                    : const Color(0xFFE2E8F0),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                _couponApplied ? 'Applied' : 'Apply',
                style: GoogleFonts.literata(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFFFFFFFF),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PRICE BREAKDOWN CARD
  // ---------------------------------------------------------------------------
  Widget _buildPriceBreakdownCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        children: [
          _buildPriceRow(
            'Subtotal (${_items.length} items)',
            CurrencyService.formatInr(_subtotal, showDecimals: true),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      child: Text(
                        'Bundle Promotion',
                        style: GoogleFonts.literata(
                          fontSize: 12.5,
                          color: const Color(0xFF000000),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFF142D4E),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '-10%',
                        style: TextStyle(
                          fontFamily: 'Literata',
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFFFFFFF),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '-${CurrencyService.formatInr(_discount, showDecimals: true)}',
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildPriceRow(
            'Estimated Tax & Duty',
            CurrencyService.formatInr(_tax, showDecimals: true),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Express Delivery',
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  color: const Color(0xFF000000),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.bolt, size: 14, color: Color(0xFF142D4E)),
              const Spacer(),
              Text(
                'FREE',
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: const Color(0xFFE2E8F0), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total',
                      style: GoogleFonts.literata(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Including GST & duties',
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  CurrencyService.formatInr(_total, showDecimals: true),
                  style: GoogleFonts.literata(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPriceRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: GoogleFonts.literata(
              fontSize: 12.5,
              color: const Color(0xFF000000),
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: GoogleFonts.literata(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000000),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // CHECKOUT BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildCheckoutButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: widget.onCheckout ?? () => AppNavigator.toDeliveryAddress(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF142D4E),
          foregroundColor: const Color(0xFFFFFFFF),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.lock_outline, size: 16, color: Color(0xFFF8FAFC)),
            const SizedBox(width: 8),
            Text(
              'Checkout',
              style: GoogleFonts.literata(
                fontSize: 15,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Spacer(),
            Text(
              CurrencyService.formatInr(_total, showDecimals: true),
              style: GoogleFonts.literata(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 16, color: Color(0xFFF8FAFC)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TRUST SAFETY NOTE
  // ---------------------------------------------------------------------------
  Widget _buildTrustSafetyNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.verified_user_outlined,
            size: 14, color: Color(0xFF000000)),
        const SizedBox(width: 6),
        Text(
          'Guaranteed Safe & 256-Bit Encrypted Checkout',
          style: GoogleFonts.literata(
            fontSize: 11,
            color: const Color(0xFF000000),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // EMPTY CART STATE
  // ---------------------------------------------------------------------------
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: const BoxDecoration(
                color: Color(0xFF142D4E),
                shape: BoxShape.circle,
              ),
              child: const Center(
                child: Icon(
                  Icons.shopping_cart_outlined,
                  size: 38,
                  color: Color(0xFF000000),
                ),
              ),
            ),
            const SizedBox(height: 18),
            Text(
              'Your shopping cart is empty',
              style: GoogleFonts.literata(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              'Explore our curated collection of tech and gadgets.',
              style: GoogleFonts.literata(
                fontSize: 13,
                color: const Color(0xFF000000),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: () {
                HapticFeedback.lightImpact();
                AppNavigator.toHome(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF142D4E),
                foregroundColor: const Color(0xFFFFFFFF),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.symmetric(
                  horizontal: 28,
                  vertical: 14,
                ),
              ),
              child: Text(
                'Start Shopping',
                style: GoogleFonts.literata(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
