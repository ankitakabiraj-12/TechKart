import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';

/// TechKart Checkout - Order Confirmation Screen (SCR-31)
/// Recreated to match original reference UI with 100% visual fidelity.
class OrderConfirmationScreen extends StatefulWidget {
  final String orderId;
  final String customerName;
  final String customerFullName;
  final String customerEmail;
  final String deliveryAddress;
  final String estimatedDelivery;
  final String guaranteedTime;
  final String cardLast4;
  final String cardBrand;
  final String authCode;
  final double totalAmount;
  final String dateTimeText;
  final VoidCallback? onTrackOrder;
  final VoidCallback? onContinueShopping;
  final VoidCallback? onContactConcierge;
  final VoidCallback? onCopyOrderId;

  const OrderConfirmationScreen({
    super.key,
    this.orderId = 'TK-89421',
    this.customerName = 'Tanvir',
    this.customerFullName = 'Tanvir Ahmed',
    this.customerEmail = 'tanvir.ahmed@example.com',
    this.deliveryAddress =
        'House 42, Road 11, Block D, Bandra West, Mumbai - 400050, India',
    this.estimatedDelivery = 'Tomorrow, Oct 27',
    this.guaranteedTime = 'Guaranteed delivery by 6:00 PM',
    this.cardLast4 = '4829',
    this.cardBrand = 'Mastercard',
    this.authCode = '920831',
    this.totalAmount = 40273.95,
    this.dateTimeText = 'Oct 26, 2024 • 10:28 AM',
    this.onTrackOrder,
    this.onContinueShopping,
    this.onContactConcierge,
    this.onCopyOrderId,
  });

  @override
  State<OrderConfirmationScreen> createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {
  final List<Map<String, dynamic>> _items = [
    {
      'title': 'Chronos Ultra 2 (49mm GPS)',
      'subtitle': 'Titanium Case • Qty: 1',
      'price': '₹35,499.00',
      'image': 'asset/chronos_ultra_2.jpg',
    },
    {
      'title': 'VoltFast 65W GaN Dual USB-C',
      'subtitle': 'Matte Off-White • Qty: 1',
      'price': '₹4,774.95',
      'image': 'asset/carousel_fast_gan_charger.jpg',
    },
  ];

  void _copyOrderId() {
    Clipboard.setData(ClipboardData(text: '#${widget.orderId}'));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Order ID copied to clipboard',
          style: GoogleFonts.literata(),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBCF),
      body: SafeArea(
        child: ListView(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
          children: [
            // Top Success Badge
            Center(
              child: Container(
                width: 64,
                height: 64,
                decoration: const BoxDecoration(
                  color: Color(0xFF0D1B2A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.check, size: 34, color: Color(0xFFF5EBDD)),
              ),
            ),
            const SizedBox(height: 14),
            // Payment Successful Pill
            Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6C17A),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFF0D1B2A),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      'Payment Successful',
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D1B2A),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Order Confirmed Headline
            Center(
              child: Text(
                'Order Confirmed!',
                style: GoogleFonts.domine(
                  fontSize: 24,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1B2A),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Text(
                  'Thank you, ${widget.customerName}! Your order #${widget.orderId} has been placed and is being prepared for dispatch.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.literata(
                    fontSize: 12.5,
                    height: 1.4,
                    color: const Color(0xFF1B365D),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            // Reference & Payment Card
            _buildReferenceCard(),
            const SizedBox(height: 14),
            // Estimated Delivery Card
            _buildDeliveryCard(),
            const SizedBox(height: 18),
            // Items in Package
            _buildItemsCard(),
            const SizedBox(height: 14),
            // Email Confirmation Note
            _buildEmailConfirmationNote(),
            const SizedBox(height: 20),
            // Track Order Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: widget.onTrackOrder ??
                    () => AppNavigator.toOrderDetails(context, orderId: widget.orderId),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1B2A),
                  foregroundColor: const Color(0xFFF5EBDD),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Track Order',
                      style: GoogleFonts.literata(
                        fontSize: 14.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Icon(Icons.arrow_forward, size: 16, color: Color(0xFFF5EBDD)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 10),
            // Continue Shopping Button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: widget.onContinueShopping ??
                    () => AppNavigator.toHome(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFE6C17A),
                  foregroundColor: const Color(0xFF0D1B2A),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Text(
                  'Continue Shopping',
                  style: GoogleFonts.literata(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // REFERENCE & PAYMENT CARD
  // ---------------------------------------------------------------------------
  Widget _buildReferenceCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6C17A)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'REFERENCE',
                    style: GoogleFonts.literata(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Row(
                    children: [
                      Text(
                        '#${widget.orderId}',
                        style: GoogleFonts.domine(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                      const SizedBox(width: 4),
                      GestureDetector(
                        onTap: _copyOrderId,
                        child: const Icon(Icons.copy_rounded,
                            size: 13, color: Color(0xFF1B365D)),
                      ),
                    ],
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    'DATE & TIME',
                    style: GoogleFonts.literata(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.dateTimeText,
                    style: GoogleFonts.literata(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Color(0xFFE6C17A), height: 1),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFE6C17A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.credit_card, size: 16, color: Color(0xFF0D1B2A)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.cardBrand} ending in ${widget.cardLast4}',
                      style: GoogleFonts.literata(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D1B2A),
                      ),
                    ),
                    Text(
                      'Auth Code • ${widget.authCode}',
                      style: GoogleFonts.literata(
                        fontSize: 10.5,
                        color: const Color(0xFF1B365D),
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    '₹${widget.totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.domine(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6C17A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      'Paid',
                      style: TextStyle(
                        fontFamily: 'Literata',
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D1B2A),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ESTIMATED DELIVERY CARD
  // ---------------------------------------------------------------------------
  Widget _buildDeliveryCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6C17A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFE6C17A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_shipping, size: 16, color: Color(0xFF0D1B2A)),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'ESTIMATED DELIVERY',
                      style: GoogleFonts.literata(
                        fontSize: 9.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF1B365D),
                      ),
                    ),
                    Text(
                      widget.estimatedDelivery,
                      style: GoogleFonts.domine(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0D1B2A),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6C17A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'EXPRESS PRIORITY',
                  style: TextStyle(
                    fontFamily: 'Literata',
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.only(left: 36),
            child: Text(
              widget.guaranteedTime,
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF1B365D),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE6C17A),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.location_on_outlined,
                    size: 14, color: Color(0xFF0D1B2A)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.customerFullName,
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                      Text(
                        widget.deliveryAddress,
                        style: GoogleFonts.literata(
                          fontSize: 11,
                          color: const Color(0xFF1B365D),
                        ),
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
  // ITEMS IN PACKAGE
  // ---------------------------------------------------------------------------
  Widget _buildItemsCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Items in this Package',
              style: GoogleFonts.domine(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
            Text(
              '${_items.length} items',
              style: GoogleFonts.literata(
                fontSize: 11.5,
                color: const Color(0xFF1B365D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        ..._items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 10),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EBDD),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: const Color(0xFFE6C17A)),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 50,
                    height: 50,
                    color: const Color(0xFFE6C17A),
                    child: Image.asset(
                      item['image'] as String,
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
                        item['title'] as String,
                        style: GoogleFonts.domine(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                      Text(
                        item['subtitle'] as String,
                        style: GoogleFonts.literata(
                          fontSize: 11,
                          color: const Color(0xFF1B365D),
                        ),
                      ),
                    ],
                  ),
                ),
                Text(
                  item['price'] as String,
                  style: GoogleFonts.domine(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // EMAIL CONFIRMATION NOTE
  // ---------------------------------------------------------------------------
  Widget _buildEmailConfirmationNote() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          const Icon(Icons.mail_outline, size: 16, color: Color(0xFF0D1B2A)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: GoogleFonts.literata(
                  fontSize: 11,
                  color: const Color(0xFF0D1B2A),
                ),
                children: [
                  const TextSpan(text: 'Receipt & live courier tracking link sent to '),
                  TextSpan(
                    text: widget.customerEmail,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
