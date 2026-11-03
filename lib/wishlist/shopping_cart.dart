import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/network.dart';
import '../theme/bottom_navbar.dart';
import '../theme/profile_avatar.dart';

/// TechKart Shopping Cart Screen
/// Recreated to match original reference UI with 100% visual fidelity.
class ShoppingCartScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onCheckout;
  final int initialTabIndex;

  const ShoppingCartScreen({
    super.key,
    this.onBack,
    this.onCheckout,
    this.initialTabIndex = 3,
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
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFC),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
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
                  const SizedBox(height: 20),
                ],
              ),
            ),
            TechKartBottomNavBar(
              currentIndex: 3,
              onTabSelected: (index) {
                if (index == 0) AppNavigator.toHome(context);
                if (index == 1) AppNavigator.toCategories(context);
                if (index == 2) AppNavigator.toAiChatSessions(context);
                if (index == 4) AppNavigator.toProfile(context);
              },
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // APP BAR
  // ---------------------------------------------------------------------------
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF6FAFC),
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2EDF3), width: 1),
        ),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF5FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF00344B)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Cart',
              style: GoogleFonts.domine(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search, size: 22, color: Color(0xFF0F172A)),
            onPressed: () => AppNavigator.toSearchOverlay(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 14),
          Stack(
            clipBehavior: Clip.none,
            children: [
              const Icon(Icons.shopping_bag_outlined,
                  color: Color(0xFF0F172A), size: 22),
              Positioned(
                right: -6,
                top: -6,
                child: Container(
                  padding: const EdgeInsets.all(3.5),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEF4444),
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '${_items.length}',
                    style: const TextStyle(
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 14),
          const ProfileAvatar(size: 32),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // HEADER ROW ("My Cart" + "Clear")
  // ---------------------------------------------------------------------------
  Widget _buildHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'My Cart',
              style: GoogleFonts.domine(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
            const SizedBox(height: 2),
            Text(
              '${_items.length} items selected for checkout',
              style: GoogleFonts.literata(
                fontSize: 12,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: _clearCart,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.delete_outline, size: 14, color: Color(0xFF00344B)),
                const SizedBox(width: 4),
                Text(
                  'Clear',
                  style: GoogleFonts.literata(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00344B),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2EDF3)),
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
                  color: const Color(0xFFF3EEE4),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.local_shipping_outlined,
                    size: 16, color: Color(0xFF8B6B2B)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Free Express Shipping Unlocked!',
                  style: GoogleFonts.domine(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
              Text(
                '100% QUALIFIED',
                style: GoogleFonts.literata(
                  fontSize: 10.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: const Color(0xFF64748B),
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
              backgroundColor: Color(0xFFE2EDF3),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B4875)),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Next-day priority dispatch guaranteed for your order.',
            style: GoogleFonts.literata(
              fontSize: 11.5,
              color: const Color(0xFF64748B),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EDF3)),
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
                        ? const Color(0xFFDCEEFB)
                        : const Color(0xFFF3EEE4),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    item['badge'] as String,
                    style: TextStyle(
                      fontFamily: 'Literata',
                      fontSize: 9,
                      fontWeight: FontWeight.w700,
                      color: item['badge'] == 'SALE'
                          ? const Color(0xFF0284C7)
                          : const Color(0xFF8B6B2B),
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
                        style: GoogleFonts.domine(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => _removeItem(index),
                      child: const Padding(
                        padding: EdgeInsets.only(left: 4),
                        child: Icon(Icons.delete_outline,
                            size: 18, color: Color(0xFF64748B)),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  item['subtitle'] as String,
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '₹${(item['price'] as double).toStringAsFixed(2)}',
                          style: GoogleFonts.domine(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        if (item['originalPrice'] != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            '₹${(item['originalPrice'] as double).toStringAsFixed(2)}',
                            style: GoogleFonts.literata(
                              fontSize: 11,
                              color: const Color(0xFF94A3B8),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    // Stepper (- qty +)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5FF),
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
                                  color: Color(0xFF00344B),
                                ),
                              ),
                            ),
                          ),
                          Text(
                            '${item['quantity']}',
                            style: GoogleFonts.literata(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0F172A),
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
                                  color: Color(0xFF00344B),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2EDF3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_offer_outlined,
              size: 20, color: Color(0xFF0F172A)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              _couponController.text,
              style: GoogleFonts.literata(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: const Color(0xFF0F172A),
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
                    ? const Color(0xFFDCEEFB)
                    : const Color(0xFF00344B),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                _couponApplied ? 'Applied' : 'Apply',
                style: GoogleFonts.literata(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: _couponApplied
                      ? const Color(0xFF00344B)
                      : Colors.white,
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EDF3)),
      ),
      child: Column(
        children: [
          _buildPriceRow(
            'Subtotal (${_items.length} items)',
            '₹${_subtotal.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Bundle Promotion',
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EEE4),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '-10%',
                  style: TextStyle(
                    fontFamily: 'Literata',
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8B6B2B),
                  ),
                ),
              ),
              const Spacer(),
              Text(
                '-₹${_discount.toStringAsFixed(2)}',
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _buildPriceRow(
            'Estimated Tax & Duty',
            '₹${_tax.toStringAsFixed(2)}',
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(
                'Express Delivery',
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.bolt, size: 14, color: Color(0xFF8B6B2B)),
              const Spacer(),
              Text(
                'FREE',
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 14),
            child: Divider(color: Color(0xFFE2EDF3), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Total',
                    style: GoogleFonts.domine(
                      fontSize: 17,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Including GST & duties',
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Text(
                '₹${_total.toStringAsFixed(2)}',
                style: GoogleFonts.domine(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
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
        Text(
          label,
          style: GoogleFonts.literata(
            fontSize: 12.5,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.literata(
            fontSize: 12.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
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
          backgroundColor: const Color(0xFF00344B),
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Row(
          children: [
            const Icon(Icons.lock_outline, size: 16, color: Colors.white),
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
              '₹${_total.toStringAsFixed(2)}',
              style: GoogleFonts.literata(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
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
            size: 14, color: Color(0xFF64748B)),
        const SizedBox(width: 6),
        Text(
          'Guaranteed Safe & 256-Bit Encrypted Checkout',
          style: GoogleFonts.literata(
            fontSize: 11,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }
}
