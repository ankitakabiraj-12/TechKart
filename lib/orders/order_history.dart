import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/network.dart';
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
  final ApiClient _apiClient = ApiClient();
  bool _isLoading = false;
  List<Map<String, dynamic>> _liveOrders = [];

  final List<Map<String, dynamic>> _fallbackOrders = [
    {
      'orderId': 'TK-89421',
      'date': 'Today, Oct 26, 2024',
      'status': 'Preparing Dispatch',
      'statusType': 'in_progress',
      'statusBg': const Color(0xFF142D4E),
      'statusColor': const Color(0xFF142D4E),
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
      'statusBg': const Color(0xFF142D4E),
      'statusColor': const Color(0xFF142D4E),
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
      'statusBg': const Color(0xFF142D4E),
      'statusColor': const Color(0xFF142D4E),
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
  void initState() {
    super.initState();
    _fetchLiveOrders();
  }

  Future<void> _fetchLiveOrders() async {
    setState(() => _isLoading = true);
    try {
      final response = await _apiClient.get('/customer/orders');
      if (response.isSuccess && response.data is List) {
        final list = (response.data as List).map<Map<String, dynamic>>((raw) {
          final m = Map<String, dynamic>.from(raw as Map);
          final ordNum = m['order_number']?.toString() ?? 'TK-ORD';
          final orderStatus = (m['order_status']?.toString() ?? 'placed').toLowerCase();
          final isDelivered = orderStatus == 'delivered';
          final isCancelled = orderStatus == 'cancelled';
          final isProcessing = orderStatus == 'processing' || orderStatus == 'placed' || orderStatus == 'shipped';

          final statusLabel = isDelivered
              ? 'Delivered'
              : (isCancelled
                  ? 'Cancelled'
                  : (orderStatus == 'shipped'
                      ? 'In Transit'
                      : (orderStatus == 'processing' ? 'Processing Hub' : 'Order Placed')));

          final statusType = isDelivered ? 'delivered' : (isCancelled ? 'cancelled' : 'in_progress');
          final statusBg = isDelivered
              ? const Color(0xFF142D4E)
              : (isCancelled ? const Color(0xFFFDE8E5) : const Color(0xFF142D4E));
          final statusColor = isDelivered
              ? const Color(0xFF142D4E)
              : (isCancelled ? const Color(0xFFDC2626) : const Color(0xFF142D4E));

          final previewItems = (m['preview_items'] as List?) ?? [];
          final firstTitle = previewItems.isNotEmpty ? previewItems.first['title']?.toString() ?? 'Tech Hardware' : 'Tech Hardware';
          final otherCount = previewItems.length > 1 ? previewItems.length - 1 : 0;
          final subtitle = otherCount > 0 ? '+ $otherCount other item${otherCount > 1 ? "s" : ""}' : 'Verified Certified Unit';

          final total = double.tryParse(m['total_amount']?.toString() ?? '0') ?? 0.0;
          final itemsCount = '${m['items_count'] ?? previewItems.length} item${(m['items_count'] ?? 1) == 1 ? "" : "s"}';

          final thumbs = <String>[];
          for (final item in previewItems) {
            final img = item['image_url']?.toString();
            if (img != null && img.isNotEmpty) {
              thumbs.add(img);
            }
          }
          if (thumbs.isEmpty) {
            thumbs.add('asset/chronos_ultra_2.jpg');
          }

          return {
            'orderId': ordNum,
            'dbId': m['id'],
            'date': m['created_at'] != null ? m['created_at'].toString().split(' ').first : 'Today',
            'status': statusLabel,
            'statusType': statusType,
            'statusBg': statusBg,
            'statusColor': statusColor,
            'hasDot': isProcessing,
            'hasCheck': isDelivered,
            'title': firstTitle,
            'subtitle': subtitle,
            'price': '₹${total.toStringAsFixed(2)}',
            'itemsCount': itemsCount,
            'expectedDelivery': m['estimated_delivery']?.toString() ?? 'Standard Transit',
            'thumbnails': thumbs,
            'primaryAction': isDelivered ? 'Reorder' : 'Track Order',
            'secondaryAction': 'View Details',
          };
        }).toList();

        if (mounted) {
          setState(() {
            _liveOrders = list;
            _isLoading = false;
          });
        }
      } else {
        if (mounted) setState(() => _isLoading = false);
      }
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _apiClient.close();
    _searchController.dispose();
    super.dispose();
  }

  List<Map<String, dynamic>> get _orders => _liveOrders.isNotEmpty ? _liveOrders : _fallbackOrders;

  List<Map<String, dynamic>> get _filteredOrders {
    final query = _searchController.text.trim().toLowerCase();
    var list = _orders;

    if (_selectedTab == 'in_progress') {
      list = list.where((o) => o['statusType'] == 'in_progress').toList();
    } else if (_selectedTab == 'delivered') {
      list = list.where((o) => o['statusType'] == 'delivered').toList();
    }

    if (query.isNotEmpty) {
      list = list.where((o) {
        final id = (o['orderId'] ?? '').toString().toLowerCase();
        final title = (o['title'] ?? '').toString().toLowerCase();
        return id.contains(query) || title.contains(query);
      }).toList();
    }

    return list;
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
              child: RefreshIndicator(
                onRefresh: _fetchLiveOrders,
                color: const Color(0xFF000000),
                child: ListView(
                  physics: const AlwaysScrollableScrollPhysics(
                    parent: BouncingScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    _buildSearchBar(),
                    const SizedBox(height: 14),
                    _buildFilterTabs(),
                    const SizedBox(height: 16),
                    if (_isLoading)
                      const Padding(
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF000000),
                          ),
                        ),
                      )
                    else if (_filteredOrders.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 36),
                        child: Center(
                          child: Column(
                            children: [
                              const Icon(Icons.shopping_bag_outlined, size: 48, color: Color(0xFF000000)),
                              const SizedBox(height: 12),
                              Text(
                                'No orders found',
                                style: GoogleFonts.literata(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'Items you purchase will appear here in real time.',
                                style: GoogleFonts.literata(
                                  fontSize: 12,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )
                    else
                      ..._filteredOrders.map(_buildOrderCard),
                    const SizedBox(height: 16),
                    _buildNeedAssistanceCard(),
                    const SizedBox(height: 24),
                  ],
                ),
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
            child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle), child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF000000))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Order History',
              style: GoogleFonts.literata(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline, size: 22, color: Color(0xFF000000)),
            onPressed: widget.onLockPressed ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Secure order vault active with end-to-end encryption.',
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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF000000)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              style: GoogleFonts.literata(
                fontSize: 13,
                color: const Color(0xFF000000),
              ),
              decoration: InputDecoration(
                filled: false,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                hintText: 'Search orders, items or serials...',
                hintStyle: GoogleFonts.literata(
                  fontSize: 13,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ),
          const Icon(Icons.tune, size: 18, color: Color(0xFF000000)),
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
          color: isSelected ? const Color(0xFF142D4E) : const Color(0xFFE2E8F0),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 14, color: isSelected ? const Color(0xFFF8FAFC) : const Color(0xFF142D4E)),
              const SizedBox(width: 6),
            ],
            if (hasDot) ...[
              Container(
                width: 6,
                height: 6,
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFFF8FAFC) : const Color(0xFF142D4E),
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
                color: isSelected ? const Color(0xFFF8FAFC) : const Color(0xFF142D4E),
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
                    style: GoogleFonts.literata(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                  Text(
                    order['date'] as String,
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF000000),
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
              color: const Color(0xFFFFFFFF),
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
                        border: Border.all(color: const Color(0xFFE2E8F0)),
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
                        style: GoogleFonts.literata(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                      ),
                      Text(
                        order['subtitle'] as String,
                        style: GoogleFonts.literata(
                          fontSize: 10.5,
                          color: const Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${order['price']} (${order['itemsCount']})',
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
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
                color: const Color(0xFF142D4E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 13, color: Color(0xFF000000)),
                  const SizedBox(width: 6),
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF000000),
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
                      backgroundColor: const Color(0xFF142D4E),
                      foregroundColor: const Color(0xFFF8FAFC),
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
                      backgroundColor: const Color(0xFF142D4E),
                      foregroundColor: const Color(0xFFFFFFFF),
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
                      backgroundColor: const Color(0xFF142D4E),
                      foregroundColor: const Color(0xFFFFFFFF),
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
                      backgroundColor: const Color(0xFF142D4E),
                      foregroundColor: const Color(0xFFFFFFFF),
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
                    color: const Color(0xFF142D4E),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(Icons.receipt_outlined,
                      size: 16, color: Color(0xFF000000)),
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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF8FAFC),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.headset_mic_outlined,
                size: 18, color: Color(0xFF000000)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Need assistance?',
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                  ),
                ),
                Text(
                  'TechKart 24/7 concierge is here',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2E8F0)),
            ),
            child: Text(
              'Contact',
              style: GoogleFonts.literata(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
