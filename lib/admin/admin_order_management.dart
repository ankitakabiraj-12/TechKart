import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_routes/app_navigator.dart';
import '../system/currency_service.dart';

/// TechKart Admin - Dedicated Order Management Screen
///
/// A rich, high-fidelity screen for warehouse dispatchers and store managers:
/// - Order status metrics (All, Pending Dispatch, In Transit, Delivered)
/// - Search by Order ID, customer, or phone number
/// - Filter chips with real-time status counts
/// - Detailed order cards with customer address, delivery method, payment status, and dispatch action buttons
/// - Bottom batch action bar for printing airway bills and packing slips
class AdminOrderManagementScreen extends StatefulWidget {
  const AdminOrderManagementScreen({super.key});

  @override
  State<AdminOrderManagementScreen> createState() => _AdminOrderManagementScreenState();
}

class _AdminOrderModel {
  final String orderId;
  final String customerName;
  final String customerLocation;
  final String itemTitle;
  final String sku;
  final double amount;
  final String paymentMethod;
  final bool isPaid;
  String status;
  final Color statusBg;
  final Color statusTextColor;
  final String timestamp;
  final String imagePath;

  _AdminOrderModel({
    required this.orderId,
    required this.customerName,
    required this.customerLocation,
    required this.itemTitle,
    required this.sku,
    required this.amount,
    required this.paymentMethod,
    required this.isPaid,
    required this.status,
    required this.statusBg,
    required this.statusTextColor,
    required this.timestamp,
    required this.imagePath,
  });
}

class _AdminOrderManagementScreenState extends State<AdminOrderManagementScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _selectedFilter = 'All';

  late List<_AdminOrderModel> _orders;

  @override
  void initState() {
    super.initState();
    _orders = [
      _AdminOrderModel(
        orderId: '#TK-98241',
        customerName: 'Mohammad Rahat',
        customerLocation: 'House 14, Rd 11, Banani, Dhaka',
        itemTitle: 'Chronos Ultra 2 • Titanium (49mm GPS)',
        sku: 'TK-W9842',
        amount: CurrencyService.convertUsdToInr(429.00),
        paymentMethod: 'Paid Online (Mastercard)',
        isPaid: true,
        status: 'Packed',
        statusBg: const Color(0xFFE6C17A),
        statusTextColor: const Color(0xFF1B365D),
        timestamp: '2 mins ago',
        imagePath: 'asset/chronos_ultra_2.jpg',
      ),
      _AdminOrderModel(
        orderId: '#TK-98240',
        customerName: 'Farhan Kabir',
        customerLocation: 'Flat 402, Bandra West, Mumbai',
        itemTitle: 'VoltFast 65W GaN Dual USB-C Charger',
        sku: 'TK-C4410',
        amount: CurrencyService.convertUsdToInr(49.00),
        paymentMethod: 'Cash on Delivery (Confirmed)',
        isPaid: false,
        status: 'In Transit',
        statusBg: const Color(0xFFFEF3C7),
        statusTextColor: const Color(0xFFB45309),
        timestamp: '14 mins ago',
        imagePath: 'asset/category_chargers.jpg',
      ),
      _AdminOrderModel(
        orderId: '#TK-98239',
        customerName: 'Tanvir Ahmed',
        customerLocation: 'Flat 12B, Andheri West, Mumbai',
        itemTitle: 'QuietComfort Max Wireless Headphones',
        sku: 'TK-A7720',
        amount: CurrencyService.convertUsdToInr(289.00),
        paymentMethod: 'Paid Online (Visa)',
        isPaid: true,
        status: 'Processing',
        statusBg: const Color(0xFFE6C17A),
        statusTextColor: const Color(0xFFB8860B),
        timestamp: '28 mins ago',
        imagePath: 'asset/aura_pro_headphones.jpg',
      ),
      _AdminOrderModel(
        orderId: '#TK-98238',
        customerName: 'Anisur Rahman',
        customerLocation: 'Hiranandani Gardens, Powai, Mumbai',
        itemTitle: 'Titanium Fold 5G Dual Display Smartphone',
        sku: 'TK-P9001',
        amount: CurrencyService.convertUsdToInr(1299.00),
        paymentMethod: 'Paid Online (Amex)',
        isPaid: true,
        status: 'Delivered',
        statusBg: const Color(0xFFDCFCE7),
        statusTextColor: const Color(0xFF15803D),
        timestamp: '1 hour ago',
        imagePath: 'asset/apex_fold_buds_pro.jpg',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_AdminOrderModel> get _filteredOrders {
    final query = _searchController.text.trim().toLowerCase();
    return _orders.where((order) {
      if (query.isNotEmpty) {
        final matches = order.orderId.toLowerCase().contains(query) ||
            order.customerName.toLowerCase().contains(query) ||
            order.itemTitle.toLowerCase().contains(query);
        if (!matches) return false;
      }
      if (_selectedFilter == 'Packed') {
        return order.status == 'Packed';
      } else if (_selectedFilter == 'In Transit') {
        return order.status == 'In Transit';
      } else if (_selectedFilter == 'Processing') {
        return order.status == 'Processing';
      } else if (_selectedFilter == 'Delivered') {
        return order.status == 'Delivered';
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedOrders = _filteredOrders;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBCF),
      appBar: _buildTopAppBar(context),
      body: SafeArea(
        top: false,
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Header & Metrics
                    _buildOrdersOverviewHeader(),

                    const SizedBox(height: 14),

                    // Search Bar
                    _buildSearchBar(),

                    const SizedBox(height: 12),

                    // Filter Chips Row
                    _buildFilterChipsRow(),

                    const SizedBox(height: 14),

                    // Order List Cards
                    ...displayedOrders.map((order) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildOrderCard(context, order),
                        )),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),

            // Bottom Batch Action Bar
            _buildBottomBatchBar(context),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top App Bar
  // ---------------------------------------------------------------------------
  PreferredSizeWidget _buildTopAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFDFBCF),
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      automaticallyImplyLeading: false,
      titleSpacing: 8,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF0D1B2A), size: 22),
            onPressed: () => AppNavigator.pop(context),
            tooltip: 'Back',
          ),
          const SizedBox(width: 4),

          // TechKart Icon Glyph
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF5EBDD),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: Image.asset(
              'asset/app_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.shopping_cart_rounded, color: Color(0xFFB8860B), size: 18),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Title
          const Text(
            'Order Dispatch',
            style: TextStyle(
              color: Color(0xFF0D1B2A),
              fontSize: 19,
              fontWeight: FontWeight.w700,
              fontFamily: 'serif',
            ),
          ),
        ],
      ),
      actions: [
        // Filter Icon
        IconButton(
          icon: const Icon(Icons.tune, color: Color(0xFF1B365D), size: 20),
          onPressed: () {},
        ),
        // User Avatar Circle
        Container(
          width: 34,
          height: 34,
          margin: const EdgeInsets.only(right: 14),
          decoration: const BoxDecoration(
            color: Color(0xFF1B365D),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: Color(0xFFF5EBDD),
            size: 20,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Orders Overview Header
  // ---------------------------------------------------------------------------
  Widget _buildOrdersOverviewHeader() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6C17A), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Live Dispatch Pipeline',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B2A),
                ),
              ),
              Text(
                '148 Orders Today',
                style: TextStyle(
                  color: Color(0xFF0D1B2A),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              _buildMiniStatusPill('12 Packed', const Color(0xFFE6C17A), const Color(0xFF1B365D)),
              const SizedBox(width: 8),
              _buildMiniStatusPill('8 In Transit', const Color(0xFFFEF3C7), const Color(0xFFB45309)),
              const SizedBox(width: 8),
              _buildMiniStatusPill('128 Delivered', const Color(0xFFDCFCE7), const Color(0xFF15803D)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMiniStatusPill(String text, Color bg, Color textCol) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        text,
        style: TextStyle(color: textCol, fontSize: 11, fontWeight: FontWeight.bold),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Search Bar
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      height: 44,
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDD),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE6C17A)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 13, color: Color(0xFF0D1B2A)),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintText: 'Search Order #, customer name...',
          hintStyle: const TextStyle(color: Color(0xFF1B365D), fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF1B365D), size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.close, color: Color(0xFF1B365D), size: 18),
                  onPressed: () {
                    _searchController.clear();
                    setState(() {});
                  },
                )
              : null,
          border: InputBorder.none,
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Filter Chips Row
  // ---------------------------------------------------------------------------
  Widget _buildFilterChipsRow() {
    final filters = ['All', 'Packed', 'In Transit', 'Processing', 'Delivered'];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() => _selectedFilter = f);
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFE6C17A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: isSelected ? const Color(0xFFF5EBDD) : const Color(0xFF0D1B2A),
                    fontSize: 12,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Order Card Item
  // ---------------------------------------------------------------------------
  Widget _buildOrderCard(BuildContext context, _AdminOrderModel order) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6C17A)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID, Status, Timestamp
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    order.orderId,
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0D1B2A)),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                    decoration: BoxDecoration(
                      color: order.statusBg,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      order.status,
                      style: TextStyle(color: order.statusTextColor, fontSize: 10, fontWeight: FontWeight.bold),
                    ),
                  ),
                ],
              ),
              Text(
                order.timestamp,
                style: const TextStyle(color: Color(0xFF1B365D), fontSize: 11),
              ),
            ],
          ),

          const Divider(height: 16, color: Color(0xFFE6C17A)),

          // Product item + Image
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFE6C17A)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  order.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Icon(Icons.shopping_bag_outlined, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      order.itemTitle,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Color(0xFF0D1B2A)),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${order.customerName} • ${order.customerLocation}',
                      style: const TextStyle(color: Color(0xFF1B365D), fontSize: 11),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              Text(
                CurrencyService.formatInr(order.amount),
                style: const TextStyle(fontFamily: 'serif', fontSize: 15, fontWeight: FontWeight.w800),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Action row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                order.paymentMethod,
                style: TextStyle(
                  color: order.isPaid ? const Color(0xFF1B365D) : const Color(0xFFD97706),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w600,
                ),
              ),
              ElevatedButton(
                onPressed: () {
                  if (order.status == 'Packed') {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Updated ${order.orderId} dispatch status'),
                        duration: const Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  } else {
                    AppNavigator.toOrderDetails(context, orderId: order.orderId);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0D1B2A),
                  foregroundColor: const Color(0xFFF5EBDD),
                  elevation: 0,
                  minimumSize: const Size(80, 30),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                child: Text(
                  order.status == 'Packed' ? 'Dispatch Courier' : 'View Details',
                  style: const TextStyle(fontSize: 10.5, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Bottom Batch Action Bar
  // ---------------------------------------------------------------------------
  Widget _buildBottomBatchBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDD),
        border: const Border(top: BorderSide(color: Color(0xFFE6C17A))),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Generating packing slips PDF...'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.print_outlined, size: 16),
              label: const Text('Print Slips', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              style: OutlinedButton.styleFrom(
                foregroundColor: const Color(0xFF0D1B2A),
                side: const BorderSide(color: Color(0xFFE6C17A)),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Dispatched all 12 packed parcels to courier hubs'),
                    duration: Duration(seconds: 2),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              icon: const Icon(Icons.local_shipping_outlined, size: 16),
              label: const Text('Dispatch All (12)', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12)),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF0D1B2A),
                foregroundColor: const Color(0xFFF5EBDD),
                elevation: 0,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
