import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:techkart/checkout/delivery_address.dart';
import '../core/network/network.dart';
import '../theme/profile_avatar.dart';

/// TechKart Checkout - Order Review Screen (SCR-28)
/// Recreated to match original UI reference with 100% visual fidelity.
class OrderReviewScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onLockPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onChangeAddress;
  final VoidCallback? onEditCart;
  final VoidCallback? onContinueToPayment;
  final DeliveryAddress? selectedAddress;

  const OrderReviewScreen({
    super.key,
    this.onBack,
    this.onLockPressed,
    this.onProfilePressed,
    this.onChangeAddress,
    this.onEditCart,
    this.onContinueToPayment,
    this.selectedAddress,
  });

  @override
  State<OrderReviewScreen> createState() => _OrderReviewScreenState();
}

class _OrderReviewScreenState extends State<OrderReviewScreen> {
  late DeliveryAddress _currentAddress;
  final ApiClient _apiClient = ApiClient();

  final List<OrderItemReview> _items = const [
    OrderItemReview(
      id: 'chronos_ultra_2',
      title: 'Chronos Ultra 2 (49mm GPS)',
      subtitle: 'Grade 5 Titanium • Qty: 1',
      price: 35499.00,
      originalPrice: 41499.00,
      discountTag: '-₹6,000',
      image: 'asset/chronos_ultra_2.jpg',
    ),
    OrderItemReview(
      id: 'voltfast_65w_gan',
      title: 'VoltFast 65W GaN Dual USB-C',
      subtitle: 'Space Grey • Qty: 1',
      price: 3999.00,
      originalPrice: 4999.00,
      isBundle: true,
      image: 'asset/carousel_fast_gan_charger.jpg',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _currentAddress = widget.selectedAddress ??
        const DeliveryAddress(
          id: 'addr_1',
          name: 'Tanvir Ahmed',
          label: 'HOME',
          phone: '+91 98765-43210',
          addressLine:
              'House 42, Road 11, Block D, Bandra West, Mumbai - 400050, India',
          shortLocation: 'Home (Bandra West, Mumbai)',
          isDefault: true,
          deliveryEstimate: 'Tomorrow, Oct 27 (by 6:00 PM)',
          isExpress: true,
          labelIcon: Icons.home_rounded,
        );
  }

  @override
  void dispose() {
    _apiClient.close();
    super.dispose();
  }

  double get _subtotal => _items.fold(0.0, (sum, i) => sum + i.price);
  double get _bundleDiscount => 800.00;
  double get _tax => (_subtotal - _bundleDiscount) * 0.05;
  double get _total => _subtotal - _bundleDiscount + _tax;

  void _handlePlaceOrder() {
    HapticFeedback.heavyImpact();
    if (widget.onContinueToPayment != null) {
      widget.onContinueToPayment!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Order placed successfully! Order #TK-89421 confirmed.',
            style: GoogleFonts.literata(),
          ),
          backgroundColor: const Color(0xFF00344B),
          behavior: SnackBarBehavior.floating,
        ),
      );
      Navigator.of(context).popUntil((route) => route.isFirst);
    }
  }

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
                  _buildStepPillHeader(),
                  const SizedBox(height: 14),
                  _buildReviewTitleHeader(),
                  const SizedBox(height: 16),
                  _buildDeliveryDestinationCard(),
                  const SizedBox(height: 14),
                  _buildExpressPriorityBanner(),
                  const SizedBox(height: 18),
                  _buildItemsInShipmentHeader(),
                  const SizedBox(height: 10),
                  ..._items.map(_buildItemReviewCard),
                  const SizedBox(height: 16),
                  _buildPriceBreakdownCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            _buildStickyPaymentBar(),
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
              'Checkout',
              style: GoogleFonts.domine(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline, size: 22, color: Color(0xFF0F172A)),
            onPressed: widget.onLockPressed ?? () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 14),
          const ProfileAvatar(size: 32),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP PILL HEADER (STEP 2 OF 3)
  // ---------------------------------------------------------------------------
  Widget _buildStepPillHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFF3EEE4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Step 2 of 3 • Delivery & Order Review',
                style: GoogleFonts.literata(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF8B6B2B),
                ),
              ),
            ),
            Text(
              'Order #TK-89421',
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        // 3-step timeline (Address [Done check], Review [Truck active], Payment [Card])
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTimelineStep(
              icon: Icons.check,
              label: 'Address',
              isCompleted: true,
              isActive: false,
            ),
            _buildTimelineConnector(isDone: true),
            _buildTimelineStep(
              icon: Icons.local_shipping,
              label: 'Review',
              isCompleted: false,
              isActive: true,
            ),
            _buildTimelineConnector(isDone: false),
            _buildTimelineStep(
              icon: Icons.credit_card,
              label: 'Payment',
              isCompleted: false,
              isActive: false,
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required String label,
    required bool isCompleted,
    required bool isActive,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive || isCompleted
                ? const Color(0xFF00344B)
                : const Color(0xFFDCEEFB),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: isActive || isCompleted ? Colors.white : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.literata(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: isActive || isCompleted
                ? const Color(0xFF00344B)
                : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineConnector({required bool isDone}) {
    return Container(
      width: 48,
      height: 2,
      color: isDone ? const Color(0xFF00344B) : const Color(0xFFE2EDF3),
    );
  }

  // ---------------------------------------------------------------------------
  // REVIEW TITLE HEADER
  // ---------------------------------------------------------------------------
  Widget _buildReviewTitleHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Review Your Order',
          style: GoogleFonts.domine(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Verify your delivery destination and item breakdown before proceeding to secure payment.',
          style: GoogleFonts.literata(
            fontSize: 12,
            height: 1.35,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DELIVERING TO CARD
  // ---------------------------------------------------------------------------
  Widget _buildDeliveryDestinationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.location_on, size: 16, color: Color(0xFF00344B)),
              const SizedBox(width: 6),
              Text(
                'Delivering to',
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EEE4),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  _currentAddress.label,
                  style: TextStyle(
                    fontFamily: 'Literata',
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8B6B2B),
                  ),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onChangeAddress ?? () => Navigator.of(context).pop(),
                child: Text(
                  'Change',
                  style: GoogleFonts.literata(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00344B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                _currentAddress.name,
                style: GoogleFonts.domine(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                _currentAddress.phone,
                style: GoogleFonts.literata(
                  fontSize: 11.5,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            _currentAddress.addressLine,
            style: GoogleFonts.literata(
              fontSize: 12,
              height: 1.35,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.verified_user_outlined,
                    size: 14, color: Color(0xFF00344B)),
                const SizedBox(width: 8),
                Expanded(
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF0F172A),
                      ),
                      children: const [
                        TextSpan(
                          text: 'Delivery Note: ',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                        TextSpan(
                          text: 'Leave package at front door with building concierge if unavailable.',
                          style: TextStyle(color: Color(0xFF64748B)),
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
    );
  }

  // ---------------------------------------------------------------------------
  // EXPRESS PRIORITY BANNER
  // ---------------------------------------------------------------------------
  Widget _buildExpressPriorityBanner() {
    return Container(
      padding: const EdgeInsets.all(14),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFDCEEFB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.bolt, size: 16, color: Color(0xFF00344B)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  'TechKart Express Priority',
                  style: GoogleFonts.domine(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'FREE',
                  style: TextStyle(
                    fontFamily: 'Literata',
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00344B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 32),
            child: Text(
              'Dispatched from Mumbai Central Fulfillment Hub',
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF64748B),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              children: [
                const Icon(Icons.access_time_rounded,
                    size: 14, color: Color(0xFF00344B)),
                const SizedBox(width: 6),
                RichText(
                  text: TextSpan(
                    style: GoogleFonts.literata(
                      fontSize: 11.5,
                      color: const Color(0xFF0F172A),
                    ),
                    children: const [
                      TextSpan(text: 'Estimated Delivery: '),
                      TextSpan(
                        text: 'Tomorrow, Oct 27 (by 6:00 PM)',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ITEMS IN SHIPMENT HEADER
  // ---------------------------------------------------------------------------
  Widget _buildItemsInShipmentHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          'Items in Shipment (${_items.length})',
          style: GoogleFonts.domine(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        GestureDetector(
          onTap: widget.onEditCart ?? () => Navigator.of(context).pop(),
          child: Text(
            'Edit Cart',
            style: GoogleFonts.literata(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF00344B),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ITEM REVIEW CARD
  // ---------------------------------------------------------------------------
  Widget _buildItemReviewCard(OrderItemReview item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(12),
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
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              width: 58,
              height: 58,
              color: const Color(0xFFF1F5F9),
              child: Image.asset(
                item.image,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    const Icon(Icons.devices, color: Colors.grey),
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.title,
                  style: GoogleFonts.domine(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      item.subtitle,
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    if (item.isBundle) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF3EEE4),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Bundle Deal',
                          style: TextStyle(
                            fontFamily: 'Literata',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF8B6B2B),
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Text(
                      '₹${item.price.toStringAsFixed(2)}',
                      style: GoogleFonts.domine(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      '₹${item.originalPrice.toStringAsFixed(2)}',
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF94A3B8),
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                    if (item.discountTag != null) ...[
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF5FF),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          item.discountTag!,
                          style: TextStyle(
                            fontFamily: 'Literata',
                            fontSize: 9,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00344B),
                          ),
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
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'PRICE BREAKDOWN',
            style: GoogleFonts.literata(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 12),
          _buildPriceRow('Items Subtotal (${_items.length} products)', '₹${_subtotal.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Bundle Promotion',
                style: GoogleFonts.literata(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
              const SizedBox(width: 6),
              const Icon(Icons.local_offer_outlined, size: 13, color: Color(0xFF00344B)),
              const Spacer(),
              Text(
                '-₹${_bundleDiscount.toStringAsFixed(2)}',
                style: GoogleFonts.literata(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          _buildPriceRow('Estimated Tax & VAT (5%)', '₹${_tax.toStringAsFixed(2)}'),
          const SizedBox(height: 8),
          Row(
            children: [
              Text(
                'Express Priority Dispatch',
                style: GoogleFonts.literata(
                  fontSize: 12,
                  color: const Color(0xFF64748B),
                ),
              ),
              const Spacer(),
              Text(
                'FREE',
                style: GoogleFonts.literata(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 12),
            child: Divider(color: Color(0xFFE2EDF3), height: 1),
          ),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Total Amount',
                      style: GoogleFonts.domine(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Includes taxes and courier insurance',
                      style: GoogleFonts.literata(
                        fontSize: 10.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Text(
                  '₹${_total.toStringAsFixed(2)}',
                  style: GoogleFonts.domine(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
              ],
            ),
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
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.literata(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF0F172A),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STICKY PAYMENT BAR
  // ---------------------------------------------------------------------------
  Widget _buildStickyPaymentBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2EDF3), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TO PAY',
                    style: GoogleFonts.literata(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: const Color(0xFF64748B),
                    ),
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
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handlePlaceOrder,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00344B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'Continue to Payment',
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
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 12, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                '256-Bit SSL Encrypted Checkout • 100% Genuine Guarantee',
                style: GoogleFonts.literata(
                  fontSize: 10.5,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class OrderItemReview {
  final String id;
  final String title;
  final String subtitle;
  final double price;
  final double originalPrice;
  final String? discountTag;
  final bool isBundle;
  final String image;

  const OrderItemReview({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.originalPrice,
    this.discountTag,
    this.isBundle = false,
    required this.image,
  });
}
