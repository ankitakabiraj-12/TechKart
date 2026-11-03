import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/profile_avatar.dart';

/// TechKart Orders - Order History Screen
/// Recreated to match original reference UI with 100% visual fidelity.
class OrderHistoryScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onLockPressed;
  final VoidCallback? onProfilePressed;
  final ValueChanged<String>? onOrderSelected;
  final ValueChanged<String>? onTrackOrder;
  final ValueChanged<String>? onReorder;
  final ValueChanged<String>? onWriteReview;
  final ValueChanged<String>? onDownloadReceipt;
  final VoidCallback? onContactConcierge;

  const OrderHistoryScreen({
    super.key,
    this.onBack,
    this.onLockPressed,
    this.onProfilePressed,
    this.onOrderSelected,
    this.onTrackOrder,
    this.onReorder,
    this.onWriteReview,
    this.onDownloadReceipt,
    this.onContactConcierge,
  });

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  String _selectedTab = 'all'; // 'all', 'in_progress', 'delivered'
  final TextEditingController _searchController = TextEditingController();

  final List<Map<String, dynamic>> _orders = [
    {
      'orderId': 'TK-89421',
      'date': 'Today, Oct 26, 2024',
      'status': 'Preparing Dispatch',
      'statusType': 'in_progress',
      'statusBg': const Color(0xFFF3EEE4),
      'statusColor': const Color(0xFF8B6B2B),
      'hasDot': true,
      'title': 'Chronos Ultra 2 (49...',
      'subtitle': '+ 1 other item (VoltFast 6...)',
      'price': '₹40,273.95',
      'itemsCount': '2 items',
      'expectedDelivery': 'Tomorrow, Oct 27',
      'thumbnails': [
        'asset/chronos_ultra_2.jpg',
        'asset/carousel_fast_gan_charger.jpg',
      ],
      'primaryAction': 'Track Order',
      'secondaryAction': 'View Details',
    },
    {
      'orderId': 'TK-78210',
      'date': 'Oct 14, 2024',
      'status': 'Delivered',
      'statusType': 'delivered',
      'statusBg': const Color(0xFFDCEEFB),
      'statusColor': const Color(0xFF00344B),
      'hasCheck': true,
      'title': 'KeyPro Wireless Mechani...',
      'subtitle': 'Tactile Brown Switch • Midnight Slate',
      'price': '₹15,649.00',
      'itemsCount': '1 item',
      'thumbnails': [
        'asset/keychron_pro_keyboard.jpg',
      ],
      'primaryAction': 'Reorder',
      'secondaryAction': 'Write Review',
      'hasReceiptIcon': true,
    },
    {
      'orderId': 'TK-65934',
      'date': 'Sep 28, 2024',
      'status': 'Delivered',
      'statusType': 'delivered',
      'statusBg': const Color(0xFFDCEEFB),
      'statusColor': const Color(0xFF00344B),
      'hasCheck': true,
      'title': 'Aura Pro ANC Headphones',
      'subtitle': 'Ivory White • Spatial Audio',
      'price': '₹28,897.00',
      'itemsCount': '1 item',
      'thumbnails': [
        'asset/aura_anc_4_pro.jpg',
      ],
      'primaryAction': 'Reorder',
      'secondaryAction': 'View Details',
    },
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _filteredOrders {
    if (_selectedTab == 'in_progress') {
      return _orders.where((o) => o['statusType'] == 'in_progress').toList();
    }
    if (_selectedTab == 'delivered') {
      return _orders.where((o) => o['statusType'] == 'delivered').toList();
    }
    return _orders;
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
                  _buildSearchBar(),
                  const SizedBox(height: 14),
                  _buildFilterTabs(),
                  const SizedBox(height: 16),
                  ..._filteredOrders.map(_buildOrderCard),
                  const SizedBox(height: 16),
                  _buildNeedAssistanceCard(),
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
              'Order History',
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
  // SEARCH BAR
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2EDF3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.literata(
                fontSize: 13,
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search orders, items or serials...',
                hintStyle: GoogleFonts.literata(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
                ),
              ),
            ),
          ),
          const Icon(Icons.tune, size: 18, color: Color(0xFF00344B)),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // FILTER TABS
  // ---------------------------------------------------------------------------
  Widget _buildFilterTabs() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip(id: 'all', label: 'All Orders (14)', icon: Icons.receipt_long),
          const SizedBox(width: 8),
          _buildFilterChip(id: 'in_progress', label: 'In Progress (2)', hasDot: true),
          const SizedBox(width: 8),
          _buildFilterChip(id: 'delivered', label: 'Delivered (12)'),
        ],
      ),
    );
  }

  Widget _buildFilterChip({
    required String id,
    required String label,
    IconData? icon,
    bool hasDot = false,
  }) {
    final isSelected = _selectedTab == id;

    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedTab = id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF00344B) : const Color(0xFFEAF5FF),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? Colors.white : const Color(0xFF00344B)),
              const SizedBox(width: 6),
            ],
            if (hasDot) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : const Color(0xFF00344B),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: GoogleFonts.literata(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: isSelected ? Colors.white : const Color(0xFF00344B),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ORDER CARD
  // ---------------------------------------------------------------------------
  Widget _buildOrderCard(Map<String, dynamic> order) {
    final orderId = order['orderId'] as String;
    final thumbnails = order['thumbnails'] as List<String>;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
          // Order Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Order #$orderId',
                    style: GoogleFonts.domine(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  Text(
                    order['date'] as String,
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: order['statusBg'] as Color,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (order['hasDot'] == true) ...[
                      Container(
                        width: 5,
                        height: 5,
                        decoration: BoxDecoration(
                          color: order['statusColor'] as Color,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 5),
                    ],
                    if (order['hasCheck'] == true) ...[
                      Icon(Icons.check, size: 12, color: order['statusColor'] as Color),
                      const SizedBox(width: 4),
                    ],
                    Text(
                      order['status'] as String,
                      style: TextStyle(
                        fontFamily: 'Literata',
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        color: order['statusColor'] as Color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Product details & thumbnail row
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Row(
                  children: thumbnails.map((thumb) {
                    return Container(
                      margin: const EdgeInsets.only(right: 6),
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: const Color(0xFFE2EDF3)),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.asset(
                          thumb,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) =>
                              const Icon(Icons.devices, size: 20, color: Colors.grey),
                        ),
                      ),
                    );
                  }).toList(),
                ),
                const SizedBox(width: 6),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        order['title'] as String,
                        style: GoogleFonts.domine(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        order['subtitle'] as String,
                        style: GoogleFonts.literata(
                          fontSize: 10.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${order['price']} (${order['itemsCount']})',
                        style: GoogleFonts.domine(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (order['expectedDelivery'] != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 13, color: Color(0xFF00344B)),
                  const SizedBox(width: 6),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF0F172A),
                      ),
                      children: [
                        const TextSpan(text: 'Expected Delivery: '),
                        TextSpan(
                          text: order['expectedDelivery'] as String,
                          style: const TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          // Action Buttons
          Row(
            children: [
              if (order['primaryAction'] == 'Track Order')
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => AppNavigator.toOrderDetails(context, orderId: orderId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00344B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.local_shipping_outlined, size: 14),
                    label: Text(
                      'Track Order',
                      style: GoogleFonts.literata(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Items added to cart', style: GoogleFonts.literata()),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEAF5FF),
                      foregroundColor: const Color(0xFF00344B),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.refresh, size: 14),
                    label: Text(
                      'Reorder',
                      style: GoogleFonts.literata(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              const SizedBox(width: 8),
              if (order['secondaryAction'] == 'Write Review')
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () => AppNavigator.toWriteReviews(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEAF5FF),
                      foregroundColor: const Color(0xFF00344B),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    icon: const Icon(Icons.rate_review_outlined, size: 14),
                    label: Text(
                      'Write Review',
                      style: GoogleFonts.literata(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                )
              else
                Expanded(
                  child: ElevatedButton(
                    onPressed: () => AppNavigator.toOrderDetails(context, orderId: orderId),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEAF5FF),
                      foregroundColor: const Color(0xFF00344B),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 10),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View Details',
                          style: GoogleFonts.literata(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(Icons.arrow_forward_ios, size: 10),
                      ],
                    ),
                  ),
                ),
              if (order['hasReceiptIcon'] == true) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF5FF),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.receipt_outlined,
                      size: 16, color: Color(0xFF00344B)),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NEED ASSISTANCE CARD
  // ---------------------------------------------------------------------------
  Widget _buildNeedAssistanceCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5FF),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFD3E7F8)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.headset_mic_outlined,
                size: 18, color: Color(0xFF00344B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need assistance?',
                  style: GoogleFonts.domine(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00344B),
                  ),
                ),
                Text(
                  'TechKart 24/7 concierge is here',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Text(
              'Contact',
              style: GoogleFonts.literata(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
