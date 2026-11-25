import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_routes/app_navigator.dart';
import '../system/currency_service.dart';

/// TechKart Admin - Product Catalog Management Screen
///
/// A high-fidelity pixel-perfect recreation of the Product Catalog screen:
/// - Top Navigation Bar: Back button, TechKart brand glyph, 'Notifica...', '✓ Mark all read', User Avatar
/// - Catalog Header: 'Product Catalog •', '48 Products Active', Barcode/QR Scanner button, 'AD' Avatar
/// - Search Bar: 'Search name, SKU, barcode...', with clear button
/// - Filter Chips: 'All (48)', '🔴 Low Stock (6)', 'Out of Stock (2)', etc.
/// - Inventory Health Banner: 'Health: 94% In-Stock • 6 Require Restock', 'Q2 Audited' tag
/// - Primary Action Button: '+ + Add New Product' (navigates to EditProductScreen)
/// - Product List Cards:
///   1. Chronos Ultra 2 (49mm GPS) - $429.00 ($499.00), Low Stock: 3 units left, active switch, stepper (- 3 +), edit, delete
///   2. VoltFast 65W GaN Dual Port - $49.00, In Stock (142 units), Top Seller, edit, delete
///   3. QuietComfort Max Wireless - $289.00 ($349.00), In Stock (38 units), 18 sold this week, edit, delete
///   4. Apex Pro Mechanical Wireless - $169.00, Out of Stock (0 units), Restock PO #883 In Transit, 'Restock Now' button
///   5. Titanium Fold 5G Dual Display - $1,299.00, Low Stock: 4 units left, Flagship, edit, delete
/// - Pagination Row: 'Showing 5 of 48 products', [<] [1] [2] [3] [...] [10] [>]
/// - Sticky Bottom Bar: '• Batch Select:', 'Select All', 'Bulk Actions'
class ProductManagementScreen extends StatefulWidget {
  final String? initialFilter;

  const ProductManagementScreen({
    super.key,
    this.initialFilter,
  });

  @override
  State<ProductManagementScreen> createState() => _ProductManagementScreenState();
}

class _ProductItemModel {
  final String id;
  final String title;
  final String sku;
  final String category;
  final double price;
  final double? originalPrice;
  int stock;
  final String badgeText;
  final Color badgeBg;
  final Color badgeTextColor;
  final bool hasRedDot;
  final String subtext;
  final Color? subtextColor;
  final String imagePath;
  bool isEnabled;
  bool hasStepper;
  bool hasRestockButton;

  _ProductItemModel({
    required this.id,
    required this.title,
    required this.sku,
    required this.category,
    required this.price,
    this.originalPrice,
    required this.stock,
    required this.badgeText,
    required this.badgeBg,
    required this.badgeTextColor,
    this.hasRedDot = false,
    required this.subtext,
    this.subtextColor,
    required this.imagePath,
    this.isEnabled = true,
    this.hasStepper = false,
    this.hasRestockButton = false,
  });
}

class _ProductManagementScreenState extends State<ProductManagementScreen> {
  late String _selectedFilter;
  final TextEditingController _searchController = TextEditingController();
  int _selectedPage = 1;
  bool _isAllSelected = false;

  late List<_ProductItemModel> _products;

  @override
  void initState() {
    super.initState();
    _selectedFilter = widget.initialFilter ?? 'All';

    _products = [
      _ProductItemModel(
        id: 'TK-W9842',
        title: 'Chronos Ultra 2 (49mm ...',
        sku: 'TK-W9842',
        category: 'Wearables',
        price: CurrencyService.convertUsdToInr(429.00),
        originalPrice: CurrencyService.convertUsdToInr(499.00),
        stock: 3,
        badgeText: 'Low Stock: 3 units left',
        badgeBg: const Color(0xFFFEF2F2),
        badgeTextColor: const Color(0xFFB91C1C),
        hasRedDot: true,
        subtext: 'Active • 24 sold this week',
        imagePath: 'asset/chronos_ultra_2.jpg',
        isEnabled: true,
        hasStepper: true,
      ),
      _ProductItemModel(
        id: 'TK-C4410',
        title: 'VoltFast 65W GaN Dual ...',
        sku: 'TK-C4410',
        category: 'Chargers & Power',
        price: CurrencyService.convertUsdToInr(49.00),
        stock: 142,
        badgeText: 'In Stock (142 units)',
        badgeBg: const Color(0xFFE6C17A),
        badgeTextColor: const Color(0xFFB8860B),
        hasRedDot: false,
        subtext: 'Active • Top Seller',
        imagePath: 'asset/category_chargers.jpg',
        isEnabled: true,
      ),
      _ProductItemModel(
        id: 'TK-A7720',
        title: 'QuietComfort Max Wire...',
        sku: 'TK-A7720',
        category: 'Audio',
        price: CurrencyService.convertUsdToInr(289.00),
        originalPrice: CurrencyService.convertUsdToInr(349.00),
        stock: 38,
        badgeText: 'In Stock (38 units)',
        badgeBg: const Color(0xFFE6C17A),
        badgeTextColor: const Color(0xFFB8860B),
        hasRedDot: false,
        subtext: 'Active • 18 sold this week',
        imagePath: 'asset/aura_pro_headphones.jpg',
        isEnabled: true,
      ),
      _ProductItemModel(
        id: 'TK-K1102',
        title: 'Apex Pro Mechanical Wi...',
        sku: 'TK-K1102',
        category: 'Accessories & Peripherals',
        price: CurrencyService.convertUsdToInr(169.00),
        stock: 0,
        badgeText: 'Out of Stock (0 units)',
        badgeBg: const Color(0xFFFEE2E2),
        badgeTextColor: const Color(0xFFB91C1C),
        hasRedDot: false,
        subtext: 'Restock PO #883 In Transit',
        subtextColor: const Color(0xFF1B365D),
        imagePath: 'asset/apex_titanium_link.jpg',
        isEnabled: false,
        hasRestockButton: true,
      ),
      _ProductItemModel(
        id: 'TK-P9001',
        title: 'Titanium Fold 5G Dual D...',
        sku: 'TK-P9001',
        category: 'Smartphones',
        price: CurrencyService.convertUsdToInr(1299.00),
        stock: 4,
        badgeText: 'Low Stock: 4 units left',
        badgeBg: const Color(0xFFFEF2F2),
        badgeTextColor: const Color(0xFFB91C1C),
        hasRedDot: true,
        subtext: 'Active • Flagship',
        imagePath: 'asset/apex_fold_buds_pro.jpg',
        isEnabled: true,
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<_ProductItemModel> get _filteredProducts {
    final query = _searchController.text.trim().toLowerCase();
    return _products.where((p) {
      if (query.isNotEmpty) {
        final matchesQuery = p.title.toLowerCase().contains(query) ||
            p.sku.toLowerCase().contains(query) ||
            p.category.toLowerCase().contains(query);
        if (!matchesQuery) return false;
      }
      if (_selectedFilter == 'Low Stock') {
        return p.stock > 0 && p.stock <= 5;
      } else if (_selectedFilter == 'Out of Stock') {
        return p.stock == 0;
      }
      return true;
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    final displayedProducts = _filteredProducts;

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
                    // Header: Product Catalog & Action Buttons
                    _buildCatalogHeader(context),

                    const SizedBox(height: 14),

                    // Search Field
                    _buildSearchBar(),

                    const SizedBox(height: 12),

                    // Filter Chips Row
                    _buildFilterChipsRow(),

                    const SizedBox(height: 14),

                    // Health / Restock Banner
                    _buildHealthBanner(context),

                    const SizedBox(height: 14),

                    // + Add New Product Button
                    _buildAddNewProductButton(context),

                    const SizedBox(height: 14),

                    // Product Cards
                    ...displayedProducts.map((product) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _buildProductCard(context, product),
                        )),

                    const SizedBox(height: 16),

                    // Pagination Row
                    _buildPaginationRow(),

                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar: Batch Select
            _buildBatchSelectBottomBar(context),
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
            'Notifica...',
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
        // Mark all read button
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Notifications marked as read'),
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, size: 16, color: Color(0xFF1B365D)),
                SizedBox(width: 4),
                Text(
                  'Mark all read',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1B365D),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),

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
  // Catalog Header (Product Catalog • & Scanner / Avatar)
  // ---------------------------------------------------------------------------
  Widget _buildCatalogHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: const [
                Text(
                  'Product Catalog',
                  style: TextStyle(
                    fontFamily: 'serif',
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF0D1B2A),
                    letterSpacing: -0.3,
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  '•',
                  style: TextStyle(
                    color: Color(0xFFB8860B),
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            const Text(
              '48 Products Active',
              style: TextStyle(
                color: Color(0xFF1B365D),
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        // Action Buttons: Barcode / QR Scanner & AD Avatar
        Row(
          children: [
            // Barcode Scanner button
            InkWell(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Barcode scanner active: Scan product label'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFFE6C17A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.qr_code_scanner,
                  color: Color(0xFFB8860B),
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),

            // AD Dark Avatar
            Container(
              width: 38,
              height: 38,
              decoration: const BoxDecoration(
                color: Color(0xFF0D1B2A),
                shape: BoxShape.circle,
              ),
              alignment: Alignment.center,
              child: const Text(
                'AD',
                style: TextStyle(
                  color: Color(0xFFF5EBDD),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
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
          hintText: 'Search name, SKU, barcode...',
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
  // Horizontal Filter Chips
  // ---------------------------------------------------------------------------
  Widget _buildFilterChipsRow() {
    final filters = [
      {'label': 'All (48)', 'key': 'All', 'hasDot': false},
      {'label': 'Low Stock (6)', 'key': 'Low Stock', 'hasDot': true},
      {'label': 'Out of Stock (2)', 'key': 'Out of Stock', 'hasDot': false},
      {'label': 'Wearables', 'key': 'Wearables', 'hasDot': false},
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: const BouncingScrollPhysics(),
      child: Row(
        children: filters.map((f) {
          final isSelected = _selectedFilter == f['key'];
          final hasDot = f['hasDot'] as bool;
          final label = f['label'] as String;

          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: InkWell(
              onTap: () {
                setState(() {
                  _selectedFilter = f['key'] as String;
                });
              },
              borderRadius: BorderRadius.circular(20),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
                decoration: BoxDecoration(
                  color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFE6C17A),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (hasDot) ...[
                      Container(
                        width: 7,
                        height: 7,
                        decoration: const BoxDecoration(
                          color: Color(0xFFDC2626),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      label,
                      style: TextStyle(
                        color: isSelected ? const Color(0xFFF5EBDD) : const Color(0xFF0D1B2A),
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
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Inventory Health Banner
  // ---------------------------------------------------------------------------
  Widget _buildHealthBanner(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
      decoration: BoxDecoration(
        color: const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6C17A), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(Icons.inventory_2_outlined, size: 16, color: Color(0xFFB8860B)),
              SizedBox(width: 8),
              Text(
                'Health: ',
                style: TextStyle(color: Color(0xFF0D1B2A), fontSize: 11.5, fontWeight: FontWeight.bold),
              ),
              Text(
                '94% In-Stock • 6 Require Restock',
                style: TextStyle(color: Color(0xFF1B365D), fontSize: 11.5, fontWeight: FontWeight.w500),
              ),
            ],
          ),
          InkWell(
            onTap: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Q2 Audit Report: Audited on Oct 18, 2026'),
                  duration: Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text(
              'Q2 Audited',
              style: TextStyle(
                color: Color(0xFF1B365D),
                fontSize: 11,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Add New Product Button
  // ---------------------------------------------------------------------------
  Widget _buildAddNewProductButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: () => AppNavigator.toEditProduct(context),
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
          children: const [
            Icon(Icons.add, size: 20),
            SizedBox(width: 6),
            Text(
              '+ Add New Product',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.bold,
                letterSpacing: 0.2,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Product Card Item
  // ---------------------------------------------------------------------------
  Widget _buildProductCard(BuildContext context, _ProductItemModel product) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDD),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE6C17A), width: 1),
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
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  color: const Color(0xFFE6C17A),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE6C17A)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Image.asset(
                  product.imagePath,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => const Center(
                    child: Icon(Icons.image_outlined, color: Color(0xFF1B365D), size: 30),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Middle Column (Title, SKU, Price, Badges)
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Title and Switch toggle
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Text(
                            product.title,
                            style: const TextStyle(
                              fontFamily: 'serif',
                              fontSize: 14.5,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF0D1B2A),
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Transform.scale(
                          scale: 0.75,
                          child: Switch(
                            value: product.isEnabled,
                            onChanged: (val) {
                              setState(() {
                                product.isEnabled = val;
                              });
                            },
                            activeTrackColor: const Color(0xFF0D1B2A),
                            activeThumbColor: const Color(0xFFF5EBDD),
                            inactiveThumbColor: const Color(0xFFF5EBDD),
                            inactiveTrackColor: const Color(0xFFE6C17A),
                          ),
                        ),
                      ],
                    ),

                    // SKU & Category
                    Text(
                      '${product.sku} • ${product.category}',
                      style: const TextStyle(
                        color: Color(0xFF1B365D),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),

                    // Price Row
                    Row(
                      children: [
                        Text(
                          CurrencyService.formatInr(product.price),
                          style: const TextStyle(
                            fontFamily: 'serif',
                            fontSize: 15.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF0D1B2A),
                          ),
                        ),
                        if (product.originalPrice != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            CurrencyService.formatInr(product.originalPrice!),
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: Color(0xFF1B365D),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 6),

                    // Badge and Subtext Row
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
                          decoration: BoxDecoration(
                            color: product.badgeBg,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              if (product.hasRedDot) ...[
                                Container(
                                  width: 5,
                                  height: 5,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFDC2626),
                                    shape: BoxShape.circle,
                                  ),
                                ),
                                const SizedBox(width: 4),
                              ],
                              Text(
                                product.badgeText,
                                style: TextStyle(
                                  color: product.badgeTextColor,
                                  fontSize: 10,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Spacer(),
                        Text(
                          product.subtext,
                          style: TextStyle(
                            color: product.subtextColor ?? const Color(0xFF1B365D),
                            fontSize: 10,
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

          const SizedBox(height: 10),

          // Action Row (Stepper / Restock Now / Edit / Delete)
          Row(
            children: [
              // Stepper for stock count
              if (product.hasStepper)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6C17A),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      InkWell(
                        onTap: () {
                          if (product.stock > 0) {
                            setState(() {
                              product.stock--;
                            });
                          }
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text('-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Text(
                          '${product.stock}',
                          style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            product.stock++;
                          });
                        },
                        child: const Padding(
                          padding: EdgeInsets.symmetric(horizontal: 4),
                          child: Text('+', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14)),
                        ),
                      ),
                    ],
                  ),
                ),

              // Restock Now Pill Button
              if (product.hasRestockButton)
                InkWell(
                  onTap: () => AppNavigator.toEditProduct(
                    context,
                    productName: product.title,
                    sku: product.sku,
                  ),
                  borderRadius: BorderRadius.circular(16),
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE6C17A),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: const [
                        Icon(Icons.local_shipping_outlined, size: 14, color: Color(0xFFB8860B)),
                        SizedBox(width: 4),
                        Text(
                          'Restock Now',
                          style: TextStyle(
                            color: Color(0xFFB8860B),
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

              const Spacer(),

              // Edit Pencil Button
              InkWell(
                onTap: () => AppNavigator.toEditProduct(
                  context,
                  productName: product.title.startsWith('Chronos')
                      ? 'Chronos Ultra 2 (49mm GPS)'
                      : product.title,
                  sku: product.sku,
                  price: product.price,
                  compareAtPrice: product.originalPrice ?? (product.price + 50),
                  stock: product.stock,
                ),
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6C17A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.edit_outlined,
                    size: 16,
                    color: Color(0xFF0D1B2A),
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // Delete Trash Button
              InkWell(
                onTap: () {
                  _showDeleteConfirmDialog(context, product);
                },
                borderRadius: BorderRadius.circular(10),
                child: Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6C17A),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 16,
                    color: Color(0xFF1B365D),
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
  // Pagination Row
  // ---------------------------------------------------------------------------
  Widget _buildPaginationRow() {
    return Column(
      children: [
        const Text(
          'Showing 5 of 48 products',
          style: TextStyle(
            color: Color(0xFF1B365D),
            fontSize: 11.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Left Chevron
            _buildPaginationButton(
              icon: Icons.chevron_left,
              onTap: () {
                if (_selectedPage > 1) {
                  setState(() => _selectedPage--);
                }
              },
            ),
            const SizedBox(width: 6),

            // Page 1 (Active)
            _buildPaginationNumber(1),
            const SizedBox(width: 6),

            // Page 2
            _buildPaginationNumber(2),
            const SizedBox(width: 6),

            // Page 3
            _buildPaginationNumber(3),
            const SizedBox(width: 6),

            // Dots ...
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 4),
              child: Text('•••', style: TextStyle(color: Color(0xFF1B365D), fontSize: 10)),
            ),
            const SizedBox(width: 6),

            // Page 10
            _buildPaginationNumber(10),
            const SizedBox(width: 6),

            // Right Chevron
            _buildPaginationButton(
              icon: Icons.chevron_right,
              onTap: () {
                if (_selectedPage < 10) {
                  setState(() => _selectedPage++);
                }
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildPaginationButton({required IconData icon, required VoidCallback onTap}) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        decoration: const BoxDecoration(
          color: Color(0xFFE6C17A),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: 16, color: const Color(0xFF0D1B2A)),
      ),
    );
  }

  Widget _buildPaginationNumber(int page) {
    final isActive = _selectedPage == page;
    return InkWell(
      onTap: () {
        setState(() => _selectedPage = page);
      },
      borderRadius: BorderRadius.circular(16),
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          color: isActive ? const Color(0xFF0D1B2A) : const Color(0xFFF5EBDD),
          shape: BoxShape.circle,
          border: isActive ? null : Border.all(color: const Color(0xFFE6C17A)),
        ),
        alignment: Alignment.center,
        child: Text(
          '$page',
          style: TextStyle(
            color: isActive ? const Color(0xFFF5EBDD) : const Color(0xFF0D1B2A),
            fontSize: 12,
            fontWeight: isActive ? FontWeight.bold : FontWeight.w600,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Batch Select Sticky Bottom Bar
  // ---------------------------------------------------------------------------
  Widget _buildBatchSelectBottomBar(BuildContext context) {
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
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFFB8860B),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          const Text(
            'Batch Select:',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF0D1B2A),
            ),
          ),
          const Spacer(),

          // Select All Button
          InkWell(
            onTap: () {
              setState(() {
                _isAllSelected = !_isAllSelected;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(_isAllSelected ? 'Selected all 48 products' : 'Deselected all products'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            borderRadius: BorderRadius.circular(18),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFE6C17A),
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                _isAllSelected ? 'Deselect All' : 'Select All',
                style: const TextStyle(
                  color: Color(0xFFB8860B),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
          const SizedBox(width: 8),

          // Bulk Actions Button
          ElevatedButton(
            onPressed: () {
              _showBulkActionsMenu(context);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D1B2A),
              foregroundColor: const Color(0xFFF5EBDD),
              elevation: 0,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              minimumSize: const Size(90, 36),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(18),
              ),
            ),
            child: const Text(
              'Bulk Actions',
              style: TextStyle(
                fontSize: 11.5,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDeleteConfirmDialog(BuildContext context, _ProductItemModel product) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Remove Product?'),
        content: Text('Are you sure you want to remove "${product.title}" from the catalog?'),
        actions: [
          TextButton(
            onPressed: () => AppNavigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                _products.removeWhere((p) => p.id == product.id);
              });
              AppNavigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Removed ${product.title}'),
                  duration: const Duration(seconds: 1),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Delete'),
          ),
        ],
      ),
    );
  }

  void _showBulkActionsMenu(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: const Color(0xFFF5EBDD),
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
              'Bulk Operations',
              style: TextStyle(fontFamily: 'serif', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 12),
            ListTile(
              leading: const Icon(Icons.archive_outlined, color: Color(0xFFB8860B)),
              title: const Text('Export Selected as CSV / Excel'),
              onTap: () => AppNavigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.price_change_outlined, color: Color(0xFFB8860B)),
              title: const Text('Apply Percentage Discount (% Off)'),
              onTap: () => AppNavigator.pop(ctx),
            ),
            ListTile(
              leading: const Icon(Icons.update_outlined, color: Color(0xFFB8860B)),
              title: const Text('Update Restock Alert Threshold'),
              onTap: () => AppNavigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}
