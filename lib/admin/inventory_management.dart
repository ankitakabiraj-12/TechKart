import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_routes/app_navigator.dart';
import '../system/currency_service.dart';

/// TechKart Admin - Inventory Control & Warehouse Management Screen
///
/// A high-fidelity pixel-perfect recreation of the TechKart Inventory Control screen:
/// - Top App Bar: Back arrow, TechKart brand glyph, 'TechKart Inventory Co...', Checklist icon, User avatar
/// - Live Inventory Status Banner:
///   - 'LIVE INVENTORY STATUS', '• Synced 2m ago'
///   - 2x2 Stats:
///     1. Total Stock Value ($142,850, 48 Total SKUs)
///     2. Units on Hand (1,842 pcs, Across 3 Hubs)
///     3. Low Stock Alert (6 Items, ⚠️, Below min safety buffer - warm sand bg)
///     4. Inbound Transit (1 Purchase Order, 🚚, 50 units expected soon - soft blue bg)
///   - Action row: 'Reorder All Low Stock' button & sync/refresh button
/// - Search Bar: 'Search SKU, product or bin location...' with clear button
/// - Filter Chips: 'All Items (48)', '• Critical Low (6)', 'Out of Stock (2)'
/// - Inventory Item Cards:
///   1. Chronos Ultra 2 (49mm GPS) - Bin A3-14, $290 cost • $429 retail, Low Stock (3 left), Min safety: 10, Stepper, [PO Restock]
///   2. VoltFast 65W GaN Dual Port - Bin B1-08, $18 cost • $49 retail, Optimal Stock (142 units), Min safety: 30, Stepper, Count Verified
///   3. QuietComfort Max Wireless - Bin A1-02, $175 cost • $289 retail, Healthy (38 units), Min safety: 15, Stepper, Auto-saved
///   4. Apex Pro Mechanical Keyboard - Bin C2-21, $95 cost • $169 retail, Out of Stock (0 units), PO #883 arriving Oct 26, [Receive PO #883]
///   5. Titanium Fold 5G Dual Display - Bin Vault V-04, $890 cost • $1,299 retail, Low Stock (4 left), Min safety: 8, Stepper, [PO Restock]
/// - Bottom Sticky Floating Bar: 'Audit Mode Active • 5 / 48 Verified', [Adjust] pill button, [Export/Download] button
class InventoryManagementScreen extends StatefulWidget {
  final String? initialFilter;

  const InventoryManagementScreen({
    super.key,
    this.initialFilter,
  });

  @override
  State<InventoryManagementScreen> createState() => _InventoryManagementScreenState();
}

class _InventoryProductModel {
  final String id;
  final String title;
  final String sku;
  final String binLocation;
  final double cost;
  final double retail;
  int stock;
  final int minSafety;
  final String statusText;
  final Color statusBg;
  final Color statusTextColor;
  final IconData? statusIcon;
  final bool isWarning;
  final bool isOutOfStock;
  final String? actionText;
  final bool isRestockAction;
  final bool isReceiveAction;
  final String? rightFooterText;
  final IconData? rightFooterIcon;
  final String imagePath;
  final String? arrivalNote;

  _InventoryProductModel({
    required this.id,
    required this.title,
    required this.sku,
    required this.binLocation,
    required this.cost,
    required this.retail,
    required this.stock,
    required this.minSafety,
    required this.statusText,
    required this.statusBg,
    required this.statusTextColor,
    this.statusIcon,
    this.isWarning = false,
    this.isOutOfStock = false,
    this.actionText,
    this.isRestockAction = false,
    this.isReceiveAction = false,
    this.rightFooterText,
    this.rightFooterIcon,
    required this.imagePath,
    this.arrivalNote,
  });
}

class _InventoryManagementScreenState extends State<InventoryManagementScreen> {
  late String _selectedFilter;
  final TextEditingController _searchController = TextEditingController();
  late List<_InventoryProductModel> _items;

  int _verifiedCount = 5;
  final int _totalAuditCount = 48;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter ?? 'All Items';

    _items = [
      _InventoryProductModel(
        id: 'TK-W9842',
        title: 'Chronos Ultra 2 (49mm G...',
        sku: 'TK-W9842',
        binLocation: 'A3-14',
        cost: CurrencyService.convertUsdToInr(290.0),
        retail: CurrencyService.convertUsdToInr(429.0),
        stock: 3,
        minSafety: 10,
        statusText: 'Low Stock (3 left)',
        statusBg: const Color(0xFFFBF0E4),
        statusTextColor: const Color(0xFF9A3412),
        statusIcon: Icons.warning_amber_rounded,
        isWarning: true,
        actionText: 'PO Restock',
        isRestockAction: true,
        imagePath: 'asset/chronos_ultra_2.jpg',
      ),
      _InventoryProductModel(
        id: 'TK-C4410',
        title: 'VoltFast 65W GaN Dual U...',
        sku: 'TK-C4410',
        binLocation: 'B1-08',
        cost: CurrencyService.convertUsdToInr(18.0),
        retail: CurrencyService.convertUsdToInr(49.0),
        stock: 142,
        minSafety: 30,
        statusText: 'Optimal Stock (142 units)',
        statusBg: const Color(0xFF142D4E),
        statusTextColor: const Color(0xFF142D4E),
        statusIcon: Icons.check_circle_outline,
        rightFooterText: 'Count Verified',
        rightFooterIcon: Icons.verified_outlined,
        imagePath: 'asset/category_chargers.jpg',
      ),
      _InventoryProductModel(
        id: 'TK-A7720',
        title: 'QuietComfort Max Wireless',
        sku: 'TK-A7720',
        binLocation: 'A1-02',
        cost: CurrencyService.convertUsdToInr(175.0),
        retail: CurrencyService.convertUsdToInr(289.0),
        stock: 38,
        minSafety: 15,
        statusText: 'Healthy (38 units)',
        statusBg: const Color(0xFF142D4E),
        statusTextColor: const Color(0xFF142D4E),
        statusIcon: Icons.inventory_2_outlined,
        rightFooterText: 'Auto-saved',
        imagePath: 'asset/aura_pro_headphones.jpg',
      ),
      _InventoryProductModel(
        id: 'TK-K1102',
        title: 'Apex Pro Mechanical Key...',
        sku: 'TK-K1102',
        binLocation: 'C2-21',
        cost: CurrencyService.convertUsdToInr(95.0),
        retail: CurrencyService.convertUsdToInr(169.0),
        stock: 0,
        minSafety: 20,
        statusText: 'Out of Stock (0 units)',
        statusBg: const Color(0xFFFDE8E4),
        statusTextColor: const Color(0xFF991B1B),
        statusIcon: Icons.block,
        isOutOfStock: true,
        arrivalNote: 'PO #883 arriving Oct 26 (50 units)',
        actionText: 'Receive PO #883',
        isReceiveAction: true,
        imagePath: 'asset/apex_titanium_link.jpg',
      ),
      _InventoryProductModel(
        id: 'TK-P9001',
        title: 'Titanium Fold 5G Dual Di...',
        sku: 'TK-P9001',
        binLocation: 'Vault V-04',
        cost: CurrencyService.convertUsdToInr(890.0),
        retail: CurrencyService.convertUsdToInr(1299.0),
        stock: 4,
        minSafety: 8,
        statusText: 'Low Stock (4 left)',
        statusBg: const Color(0xFFFBF0E4),
        statusTextColor: const Color(0xFF9A3412),
        statusIcon: Icons.warning_amber_rounded,
        isWarning: true,
        actionText: 'PO Restock',
        isRestockAction: true,
        imagePath: 'asset/apex_fold_buds_pro.jpg',
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_InventoryProductModel> get _filteredItems {
    final query = _searchController.text.trim().toLowerCase();
    return _items.where((item) {
      if (query.isNotEmpty) {
        final matches = item.title.toLowerCase().contains(query) ||
            item.sku.toLowerCase().contains(query) ||
            item.binLocation.toLowerCase().contains(query);
        if (!matches) return false;
      }
      if (_selectedFilter == 'Critical Low') {
        return item.stock > 0 && item.stock <= item.minSafety;
      } else if (_selectedFilter == 'Out of Stock') {
        return item.stock == 0;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedItems = _filteredItems;

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: _buildTopAppBar(context),
      body: SafeArea(
        top: false,
        child: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(left: 16, right: 16, top: 8, bottom: 84),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Live Inventory Status Card (Overview)
                  _buildLiveInventoryStatusCard(context),

                  const SizedBox(height: 14),

                  // Search Bar
                  _buildSearchBar(),

                  const SizedBox(height: 12),

                  // Filter Chips
                  _buildFilterChipsRow(),

                  const SizedBox(height: 14),

                  // Item Cards List
                  ...displayedItems.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: _buildInventoryCard(context, item),
                      )),

                  const SizedBox(height: 20),
                ],
              ),
            ),

            // Bottom Sticky Audit Floating Bar
            Positioned(
              left: 16,
              right: 16,
              bottom: 14,
              child: _buildAuditFloatingBar(context),
            ),
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
      backgroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      automaticallyImplyLeading: false,
      titleSpacing: 8,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Color(0xFF000000), size: 20),
            onPressed: () => AppNavigator.pop(context),
            tooltip: 'Back',
          ),
          const SizedBox(width: 2),

          // TechKart Icon Glyph
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
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
                child: Icon(Icons.shopping_cart_rounded, color: Color(0xFF142D4E), size: 18),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // TechKart Brand text + Title
          Row(
            children: const [
              Text(
                'TechKart ',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.2,
                ),
              ),
              Text(
                'Inventory Co...',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Literata',
                ),
              ),
            ],
          ),
        ],
      ),
      actions: [
        // Audit Checklist Icon Button in rounded container
        InkWell(
          onTap: () {
            _showAuditChecklistSheet(context);
          },
          borderRadius: BorderRadius.circular(10),
          child: Container(
            width: 34,
            height: 34,
            decoration: BoxDecoration(
              color: const Color(0xFF142D4E),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(
              Icons.assignment_turned_in_outlined,
              size: 18,
              color: Color(0xFF142D4E),
            ),
          ),
        ),
        const SizedBox(width: 8),

        // User Avatar Circle
        Container(
          width: 34,
          height: 34,
          margin: const EdgeInsets.only(right: 14),
          decoration: const BoxDecoration(
            color: Color(0xFF000000),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: Color(0xFFF8FAFC),
            size: 20,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Live Inventory Status Card
  // ---------------------------------------------------------------------------
  Widget _buildLiveInventoryStatusCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF4FD),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF142D4E), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row: Warehouse Icon + LIVE INVENTORY STATUS + Synced 2m ago
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(Icons.warehouse_outlined, size: 16, color: Color(0xFF000000)),
                  SizedBox(width: 6),
                  Text(
                    'LIVE INVENTORY STATUS',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 11.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF000000),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 5),
                  const Text(
                    'Synced 2m ago',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // 2x2 Inner Stat Boxes
          Row(
            children: [
              // Box 1: Total Stock Value
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Total Stock Value',
                        style: TextStyle(color: Color(0xFF000000), fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        CurrencyService.formatUsdToInr(142850, showDecimals: false),
                        style: const TextStyle(
                          fontFamily: 'Literata',
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFFF7ED),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          '48 Total SKUs',
                          style: TextStyle(color: Color(0xFFB45309), fontSize: 9.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Box 2: Units on Hand
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF8FAFC),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Units on Hand',
                        style: TextStyle(color: Color(0xFF000000), fontSize: 11, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 4),
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.baseline,
                        textBaseline: TextBaseline.alphabetic,
                        children: const [
                          Text(
                            '1,842',
                            style: TextStyle(
                              fontFamily: 'Literata',
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF000000),
                            ),
                          ),
                          SizedBox(width: 3),
                          Text(
                            'pcs',
                            style: TextStyle(color: Color(0xFF000000), fontSize: 12, fontWeight: FontWeight.w500),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFF142D4E),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: const Text(
                          'Across 3 Hubs',
                          style: TextStyle(color: Color(0xFF142D4E), fontSize: 9.5, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          Row(
            children: [
              // Box 3: Low Stock Alert (Warm beige)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF7F1E8),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFEFE5D8)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Low Stock Alert',
                            style: TextStyle(color: Color(0xFF000000), fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.warning_amber_rounded, size: 14, color: Color(0xFF9A3412)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '6 Items',
                        style: TextStyle(
                          fontFamily: 'Literata',
                          fontSize: 16.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF000000),
                        ),
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        'Below min safety buffer',
                        style: TextStyle(color: Color(0xFF000000), fontSize: 9.5, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Box 4: Inbound Transit (Soft sky blue)
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF142D4E),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF142D4E)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'Inbound Transit',
                            style: TextStyle(color: Color(0xFF142D4E), fontSize: 11, fontWeight: FontWeight.w500),
                          ),
                          Icon(Icons.local_shipping_outlined, size: 14, color: Color(0xFF142D4E)),
                        ],
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        '1 Purchase Order',
                        style: TextStyle(
                          fontFamily: 'Literata',
                          fontSize: 14.5,
                          fontWeight: FontWeight.w800,
                          color: Color(0xFF0C4A6E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      const Text(
                        '50 units expected soon',
                        style: TextStyle(color: Color(0xFF142D4E), fontSize: 9.5, fontWeight: FontWeight.w500),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Bottom Action Row: Reorder All Low Stock & Refresh
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 44,
                  child: ElevatedButton(
                    onPressed: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Bulk Purchase Order created for 6 Low Stock items'),
                          duration: Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF142D4E),
                      foregroundColor: const Color(0xFFF8FAFC),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.shopping_cart_outlined, size: 16),
                        SizedBox(width: 8),
                        Text(
                          'Reorder All Low Stock',
                          style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Sync / Refresh Button
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Syncing latest warehouse stock telemetry...'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(16),
                child: Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: const Color(0xFF142D4E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(
                    Icons.sync_rounded,
                    color: Color(0xFF000000),
                    size: 20,
                  ),
                ),
              ),
            ],
          ),
        ],
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
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFF142D4E)),
      ),
      child: TextField(
        controller: _searchController,
        onChanged: (_) => setState(() {}),
        style: const TextStyle(fontSize: 13, color: Color(0xFF000000)),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(vertical: 12),
          hintText: 'Search SKU, product or bin location...',
          hintStyle: const TextStyle(color: Color(0xFF000000), fontSize: 13),
          prefixIcon: const Icon(Icons.search, color: Color(0xFF000000), size: 20),
          suffixIcon: _searchController.text.isNotEmpty
              ? IconButton(
                  icon: const Icon(Icons.cancel_outlined, color: Color(0xFF000000), size: 18),
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
    final filters = [
      {'label': 'All Items (48)', 'key': 'All Items', 'hasDot': false, 'isWarn': false, 'isOut': false},
      {'label': 'Critical Low (6)', 'key': 'Critical Low', 'hasDot': true, 'isWarn': true, 'isOut': false},
      {'label': 'Out of Stock (2)', 'key': 'Out of Stock', 'hasDot': false, 'isWarn': false, 'isOut': true},
    ];

    return Row(
      children: filters.map((f) {
        final key = f['key'] as String;
        final isSelected = _selectedFilter == key;
        final hasDot = f['hasDot'] as bool;
        final isWarn = f['isWarn'] as bool;
        final isOut = f['isOut'] as bool;
        final label = f['label'] as String;

        Color bgColor;
        Color textColor;

        if (isSelected) {
          bgColor = const Color(0xFF142D4E);
          textColor = const Color(0xFFF8FAFC);
        } else if (isWarn) {
          bgColor = const Color(0xFFF7ECE0);
          textColor = const Color(0xFF9A3412);
        } else if (isOut) {
          bgColor = const Color(0xFFFEE2E2);
          textColor = const Color(0xFFDC2626);
        } else {
          bgColor = const Color(0xFF142D4E);
          textColor = const Color(0xFF142D4E);
        }

        return Padding(
          padding: const EdgeInsets.only(right: 8),
          child: InkWell(
            onTap: () {
              setState(() => _selectedFilter = key);
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (hasDot && !isSelected) ...[
                    Container(
                      width: 6,
                      height: 6,
                      decoration: const BoxDecoration(
                        color: Color(0xFFDC2626),
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    label,
                    style: TextStyle(
                      color: textColor,
                      fontSize: 12,
                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  // ---------------------------------------------------------------------------
  // Inventory Product Card Item
  // ---------------------------------------------------------------------------
  Widget _buildInventoryCard(BuildContext context, _InventoryProductModel item) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF142D4E), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Part: Product Image, Title, 3-dots, SKU, Bin Location, Cost & Retail
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Product Thumbnail
                Container(
                  width: 70,
                  height: 70,
                  decoration: BoxDecoration(
                    color: const Color(0xFF142D4E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF142D4E)),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: Image.asset(
                    item.imagePath,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) => const Center(
                      child: Icon(Icons.inventory_2_outlined, color: Color(0xFF000000), size: 26),
                    ),
                  ),
                ),
                const SizedBox(width: 12),

                // Middle Info
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              item.title,
                              style: const TextStyle(
                                fontFamily: 'Literata',
                                fontSize: 14.5,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF000000),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          InkWell(
                            onTap: () => _showItemActionsMenu(context, item),
                            child: const Icon(Icons.more_vert, size: 18, color: Color(0xFF000000)),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),

                      // SKU & Bin Location (Bin in blue)
                      Row(
                        children: [
                          Text(
                            'SKU: ${item.sku} • Bin: ',
                            style: const TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            item.binLocation,
                            style: const TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),

                      // Cost & Retail
                      Row(
                        children: [
                          Text(
                            '${CurrencyService.formatInr(item.cost)} cost • ',
                            style: const TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '${CurrencyService.formatInr(item.retail)} ',
                            style: const TextStyle(
                              fontFamily: 'Literata',
                              color: Color(0xFF000000),
                              fontSize: 12.5,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const Text(
                            'retail',
                            style: TextStyle(
                              color: Color(0xFF000000),
                              fontSize: 11.5,
                              fontWeight: FontWeight.w500,
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

          // Bottom Section with Status Pill, Safety Buffer, Stepper & Action Buttons
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: item.isOutOfStock ? const Color(0xFFFFF7F5) : const Color(0xFFF9FBFE),
              borderRadius: const BorderRadius.vertical(bottom: Radius.circular(20)),
            ),
            child: Column(
              children: [
                // Status Badge & Min safety threshold
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: item.statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          if (item.statusIcon != null) ...[
                            Icon(item.statusIcon, size: 12, color: item.statusTextColor),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            item.statusText,
                            style: TextStyle(
                              color: item.statusTextColor,
                              fontSize: 10.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (item.arrivalNote != null)
                      Expanded(
                        child: Text(
                          item.arrivalNote!,
                          style: const TextStyle(
                            color: Color(0xFF4338CA),
                            fontSize: 10,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.end,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    else
                      Text(
                        'Min safety threshold: ${item.minSafety}',
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontSize: 10.5,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                  ],
                ),

                const SizedBox(height: 10),

                // Stepper & Restock Button Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Stepper (- Stock +)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8FAFC),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF142D4E)),
                      ),
                      child: Row(
                        children: [
                          InkWell(
                            onTap: () {
                              if (item.stock > 0) {
                                setState(() {
                                  item.stock--;
                                });
                              }
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text('-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 12),
                            child: Text(
                              '${item.stock}',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 13),
                            ),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() {
                                item.stock++;
                              });
                            },
                            child: const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 6),
                              child: Text('+', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),

                    // Action Button or Footer status
                    if (item.isRestockAction)
                      ElevatedButton(
                        onPressed: () => AppNavigator.toEditProduct(
                          context,
                          productName: item.title,
                          sku: item.sku,
                          stock: item.stock,
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF142D4E),
                          foregroundColor: const Color(0xFF142D4E),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                          minimumSize: const Size(80, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.shopping_cart_outlined, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'PO Restock',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    else if (item.isReceiveAction)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            item.stock += 50;
                          });
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Received 50 units for Apex Pro (PO #883)'),
                              duration: Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF142D4E),
                          foregroundColor: const Color(0xFFF8FAFC),
                          elevation: 0,
                          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                          minimumSize: const Size(100, 32),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: Row(
                          children: const [
                            Icon(Icons.download_for_offline_outlined, size: 14),
                            SizedBox(width: 4),
                            Text(
                              'Receive PO #883',
                              style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      )
                    else if (item.rightFooterText != null)
                      Row(
                        children: [
                          if (item.rightFooterIcon != null) ...[
                            Icon(item.rightFooterIcon, size: 14, color: const Color(0xFF142D4E)),
                            const SizedBox(width: 4),
                          ],
                          Text(
                            item.rightFooterText!,
                            style: TextStyle(
                              color: item.rightFooterIcon != null
                                  ? const Color(0xFF142D4E)
                                  : const Color(0xFF142D4E),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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
  // Bottom Sticky Floating Audit Bar
  // ---------------------------------------------------------------------------
  Widget _buildAuditFloatingBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFF0F263E),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.15),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Glowing cyan dot
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: Color(0xFF000000),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),

          // Audit status texts
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                'Audit Mode Active',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 10,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$_verifiedCount / $_totalAuditCount Verified',
                style: const TextStyle(
                  color: Color(0xFFF8FAFC),
                  fontSize: 12.5,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const Spacer(),

          // Adjust Button (white pill)
          ElevatedButton(
            onPressed: () {
              _showAdjustModal(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFF8FAFC),
              foregroundColor: const Color(0xFF142D4E),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(60, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            child: Row(
              children: const [
                Icon(Icons.tune, size: 15, color: Color(0xFF000000)),
                SizedBox(width: 5),
                Text(
                  'Adjust',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),

          // Download / Export Icon Button
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Exporting Inventory Audit Report (PDF / XLSX)...'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            borderRadius: BorderRadius.circular(20),
            child: Container(
              width: 36,
              height: 36,
              decoration: const BoxDecoration(
                color: Color(0xFF1E3A5F),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.file_download_outlined,
                color: Color(0xFFF8FAFC),
                size: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showItemActionsMenu(BuildContext context, _InventoryProductModel item) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF8FAFC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              item.title,
              style: const TextStyle(fontFamily: 'Literata', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text('SKU: ${item.sku} • Bin: ${item.binLocation}', style: const TextStyle(color: Color(0xFF000000))),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.qr_code, color: Color(0xFF142D4E)),
              title: const Text('Print Bin Label / Barcode'),
              onTap: () => AppNavigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.swap_horiz, color: Color(0xFF142D4E)),
              title: const Text('Relocate Stock to Another Bin'),
              onTap: () => AppNavigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.edit_note, color: Color(0xFF142D4E)),
              title: const Text('Manual Inventory Adjustment / Write-Off'),
              onTap: () => AppNavigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }

  void _showAdjustModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF8FAFC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Stock Cycle Count & Audit',
              style: TextStyle(fontFamily: 'Literata', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Select an action to verify or correct on-hand bin quantities across warehouses:',
              style: TextStyle(color: Color(0xFF000000), fontSize: 12.5),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.checklist_rtl, color: Color(0xFF142D4E)),
              title: const Text('Mark Remaining 43 Items as Verified'),
              onTap: () {
                setState(() => _verifiedCount = _totalAuditCount);
                AppNavigator.pop(ctx);
              },
            ),
            ListTile(
              leading: const Icon(Icons.restart_alt, color: Color(0xFF9A3412)),
              title: const Text('Reset Cycle Count Verification'),
              onTap: () {
                setState(() => _verifiedCount = 0);
                AppNavigator.pop(ctx);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showAuditChecklistSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF8FAFC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) => Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Warehouse Audit Checklist',
              style: TextStyle(fontFamily: 'Literata', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Text('• Central Mumbai Hub: 1,240 units verified\n• Bandra Hub: 420 units verified\n• Andheri Hub: 182 units verified',
                style: TextStyle(height: 1.6, color: Color(0xFF000000))),
          ],
        ),
      ),
    );
  }
}
