import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/profile_avatar.dart';

/// TechKart Orders - Order Details Screen (SCR-33)
/// Recreated to match original reference UI with 100% visual fidelity.
class OrderDetailsScreen extends StatefulWidget {
  final String orderId;
  final String orderDate;
  final String orderTime;
  final String estimatedDelivery;
  final String guaranteedTime;
  final String recipientName;
  final String recipientPhone;
  final String recipientAddress;
  final String shippingMethod;
  final String courierPartner;
  final String trackingId;
  final String cardLast4;
  final String? authCode;
  final double? subtotal;
  final double? discount;
  final double? tax;
  final double? totalAmount;
  final VoidCallback? onBack;
  final VoidCallback? onLockPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onTrackShipment;
  final ValueChanged<String>? onBuyAgain;
  final ValueChanged<String>? onViewProduct;
  final VoidCallback? onDownloadInvoice;
  final VoidCallback? onCancelOrder;
  final VoidCallback? onNeedHelp;

  const OrderDetailsScreen({
    super.key,
    this.orderId = 'TK-89421',
    this.orderDate = 'Oct 26, 2024',
    this.orderTime = '10:28 AM',
    this.estimatedDelivery = 'Tomorrow, Oct 27',
    this.guaranteedTime = 'Guaranteed delivery before 6:00 PM',
    this.recipientName = 'Tanvir Ahmed',
    this.recipientPhone = '+91 98765-43210',
    this.recipientAddress =
        'House 42, Road 11, Block D, Bandra West, Mumbai - 400050, India',
    this.shippingMethod = 'TechKart Express Priority',
    this.courierPartner = 'Apex Courier Express',
    this.trackingId = 'APX-982140',
    this.cardLast4 = '4829',
    this.authCode,
    this.subtotal,
    this.discount,
    this.tax,
    this.totalAmount,
    this.onBack,
    this.onLockPressed,
    this.onProfilePressed,
    this.onTrackShipment,
    this.onBuyAgain,
    this.onViewProduct,
    this.onDownloadInvoice,
    this.onCancelOrder,
    this.onNeedHelp,
  });

  @override
  State<OrderDetailsScreen> createState() => _OrderDetailsScreenState();
}

class _OrderDetailsScreenState extends State<OrderDetailsScreen> {
  final List<Map<String, dynamic>> _items = [
    {
      'title': 'Chronos Ultra 2 (49mm GPS)',
      'subtitle': 'Grade 5 Titanium • Midnight Ocean Band • Qty: 1',
      'price': '₹35,499.00',
      'originalPrice': '₹41,499.00',
      'image': 'asset/chronos_ultra_2.jpg',
    },
    {
      'title': 'VoltFast 65W GaN Dual USB-C',
      'subtitle': 'Matte Off-White • 65W Ultra Compact • Qty: 1',
      'price': '₹3,999.00',
      'originalPrice': '₹4,999.00',
      'image': 'asset/carousel_fast_gan_charger.jpg',
    },
  ];

  void _copyTrackingId() {
    Clipboard.setData(ClipboardData(text: widget.trackingId));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tracking ID copied to clipboard', style: GoogleFonts.literata()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _copyOrderId() {
    Clipboard.setData(ClipboardData(text: '#${widget.orderId}'));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Order ID copied to clipboard', style: GoogleFonts.literata()),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  _buildOrderOverviewCard(),
                  const SizedBox(height: 16),
                  _buildItemsInOrderCard(),
                  const SizedBox(height: 16),
                  _buildShippingDetailsCard(),
                  const SizedBox(height: 16),
                  _buildPaymentInformationCard(),
                  const SizedBox(height: 16),
                  _buildDownloadInvoiceButton(),
                  const SizedBox(height: 12),
                  _buildCancelOrderRow(),
                  const SizedBox(height: 14),
                  _buildNeedHelpRow(),
                  const SizedBox(height: 24),
                ],
              ),
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
        color: Color(0xFFFFFFFF),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF142D4E),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF000000)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Order Details',
              style: GoogleFonts.literata(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          IconButton(
            key: const Key('order_details_lock_button'),
            icon: const Icon(Icons.lock_outline, size: 22, color: Color(0xFF000000)),
            onPressed: widget.onLockPressed ?? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    '256-bit TLS encrypted order session is active.',
                    style: GoogleFonts.literata(),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 14),
          GestureDetector(
            key: const Key('order_details_profile_button'),
            onTap: widget.onProfilePressed,
            child: const ProfileAvatar(size: 32),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ORDER OVERVIEW CARD
  // ---------------------------------------------------------------------------
  Widget _buildOrderOverviewCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF142D4E)),
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
              Text(
                'Order #${widget.orderId}',
                style: GoogleFonts.literata(
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
              const SizedBox(width: 6),
              GestureDetector(
                key: const Key('copy_order_id_button'),
                onTap: _copyOrderId,
                child: const Icon(Icons.copy_rounded, size: 14, color: Color(0xFF000000)),
              ),
            ],
          ),
          const SizedBox(height: 2),
          Text(
            'Placed on ${widget.orderDate} • ${widget.orderTime}',
            style: GoogleFonts.literata(
              fontSize: 11,
              color: const Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFF142D4E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 5,
                  height: 5,
                  decoration: const BoxDecoration(
                    color: Color(0xFF142D4E),
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 5),
                Text(
                  'Preparing Dispatch',
                  style: TextStyle(
                    fontFamily: 'Literata',
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF142D4E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF142D4E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                const Icon(Icons.local_shipping_outlined,
                    size: 16, color: Color(0xFF000000)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.literata(
                            fontSize: 11.5,
                            color: const Color(0xFF000000),
                          ),
                          children: [
                            const TextSpan(text: 'Expected Delivery: '),
                            TextSpan(
                              text: widget.estimatedDelivery,
                              style: const TextStyle(fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                      Text(
                        widget.guaranteedTime,
                        style: GoogleFonts.literata(
                          fontSize: 10.5,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 42,
            child: ElevatedButton.icon(
              onPressed: widget.onTrackShipment ?? () => AppNavigator.toShipmentTracking(
                context,
                trackingId: widget.trackingId,
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF142D4E),
                foregroundColor: const Color(0xFFF8FAFC),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              icon: const Icon(Icons.show_chart, size: 16),
              label: Text(
                'Track Shipment',
                style: GoogleFonts.literata(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ITEMS IN THIS ORDER
  // ---------------------------------------------------------------------------
  Widget _buildItemsInOrderCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF142D4E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Items in this Order (${_items.length})',
                style: GoogleFonts.literata(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
              Text(
                '2 packages',
                style: GoogleFonts.literata(
                  fontSize: 11,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          ..._items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      width: 52,
                      height: 52,
                      color: const Color(0xFF142D4E),
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
                          style: GoogleFonts.literata(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        Text(
                          item['subtitle'] as String,
                          style: GoogleFonts.literata(
                            fontSize: 10.5,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Text(
                              item['price'] as String,
                              style: GoogleFonts.literata(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF000000),
                              ),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              item['originalPrice'] as String,
                              style: GoogleFonts.literata(
                                fontSize: 10.5,
                                color: const Color(0xFF000000),
                                decoration: TextDecoration.lineThrough,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                widget.onBuyAgain?.call(item['title'] as String);
                              },
                              child: Text(
                                'Buy Again ›',
                                style: GoogleFonts.literata(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            GestureDetector(
                              onTap: () {
                                widget.onViewProduct?.call(item['title'] as String);
                              },
                              child: Text(
                                'View Product',
                                style: GoogleFonts.literata(
                                  fontSize: 11,
                                  color: const Color(0xFF000000),
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
            );
          }),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SHIPPING DETAILS CARD
  // ---------------------------------------------------------------------------
  Widget _buildShippingDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF142D4E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF142D4E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.local_shipping_outlined,
                    size: 14, color: Color(0xFF000000)),
              ),
              const SizedBox(width: 8),
              Text(
                'Shipping Details',
                style: GoogleFonts.literata(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF142D4E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.person_outline, size: 14, color: Color(0xFF000000)),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.recipientName} • ${widget.recipientPhone}',
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        widget.recipientAddress,
                        style: GoogleFonts.literata(
                          fontSize: 11,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          _buildDetailRow('Shipping Method', widget.shippingMethod, isBold: true),
          const SizedBox(height: 6),
          _buildDetailRow('Courier Partner', widget.courierPartner),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tracking ID',
                style: GoogleFonts.literata(
                  fontSize: 11.5,
                  color: const Color(0xFF000000),
                ),
              ),
              Row(
                children: [
                  Text(
                    widget.trackingId,
                    style: GoogleFonts.literata(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  const SizedBox(width: 4),
                  GestureDetector(
                    onTap: _copyTrackingId,
                    child: const Icon(Icons.copy_rounded,
                        size: 13, color: Color(0xFF000000)),
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
  // PAYMENT INFORMATION CARD
  // ---------------------------------------------------------------------------
  Widget _buildPaymentInformationCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF142D4E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF142D4E),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.credit_card, size: 14, color: Color(0xFF000000)),
              ),
              const SizedBox(width: 8),
              Text(
                'Payment Information',
                style: GoogleFonts.literata(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF142D4E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF142D4E),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: const Text(
                    'MC',
                    style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Mastercard ending in •••• ${widget.cardLast4}',
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                      ),
                      Text(
                        'Auth #${widget.authCode ?? '920831'}',
                        style: GoogleFonts.literata(
                          fontSize: 10.5,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF142D4E),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Text(
                    'Paid',
                    style: TextStyle(
                      fontFamily: 'Literata',
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF142D4E),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          _buildDetailRow('Items Subtotal', '₹39,498.00'),
          const SizedBox(height: 6),
          Row(
            children: [
              const Icon(Icons.local_offer_outlined, size: 12, color: Color(0xFF000000)),
              const SizedBox(width: 4),
              Text(
                'Bundle Promotion',
                style: GoogleFonts.literata(
                  fontSize: 11.5,
                  color: const Color(0xFF000000),
                ),
              ),
              const Spacer(),
              Text(
                '-₹800.00',
                style: GoogleFonts.literata(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _buildDetailRow('Estimated Tax & VAT (5%)', '₹1,575.95'),
          const SizedBox(height: 6),
          _buildDetailRow('Express Delivery', 'FREE', isBold: true),
          const Padding(
            padding: EdgeInsets.symmetric(vertical: 10),
            child: Divider(color: Color(0xFF142D4E), height: 1),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Total Amount Paid',
                style: GoogleFonts.literata(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
              Text(
                '₹40,273.95',
                style: GoogleFonts.literata(
                  fontSize: 15.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.literata(
            fontSize: 11.5,
            color: const Color(0xFF000000),
          ),
        ),
        Text(
          value,
          style: GoogleFonts.literata(
            fontSize: 11.5,
            fontWeight: isBold ? FontWeight.w700 : FontWeight.w600,
            color: const Color(0xFF000000),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DOWNLOAD INVOICE BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildDownloadInvoiceButton() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: widget.onDownloadInvoice ?? () {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                'Downloading Tax Invoice PDF (#TK-89421)...',
                style: GoogleFonts.literata(),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF142D4E),
          foregroundColor: const Color(0xFF142D4E),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        icon: const Icon(Icons.download_rounded, size: 16),
        label: Text(
          'Download Invoice (PDF)',
          style: GoogleFonts.literata(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CANCEL ORDER ROW
  // ---------------------------------------------------------------------------
  Widget _buildCancelOrderRow() {
    return GestureDetector(
      onTap: widget.onCancelOrder,
      child: Row(
        children: [
          const Icon(Icons.cancel_outlined, size: 14, color: Color(0xFF000000)),
          const SizedBox(width: 6),
          Text(
            'Cancel Order',
            style: GoogleFonts.literata(
              fontSize: 11.5,
              color: const Color(0xFF000000),
            ),
          ),
          const Spacer(),
          Text(
            'Eligible until 12:28 PM',
            style: GoogleFonts.literata(
              fontSize: 10.5,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NEED HELP ROW
  // ---------------------------------------------------------------------------
  Widget _buildNeedHelpRow() {
    return GestureDetector(
      onTap: widget.onNeedHelp,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.headset_mic_outlined, size: 14, color: Color(0xFF000000)),
          const SizedBox(width: 6),
          Text(
            'Need Help with this Order?',
            style: GoogleFonts.literata(
              fontSize: 11.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
            ),
          ),
        ],
      ),
    );
  }
}
