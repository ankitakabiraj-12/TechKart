import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_routes/app_navigator.dart';

/// TechKart Admin - Edit Product / Product Details Screen
///
/// A high-fidelity pixel-perfect recreation of the Edit Product screen:
/// - Top App Bar: Back button, TechKart logo glyph, 'Notifica...', '✓ Mark all read', User Avatar
/// - Live Status Capsule: '🟢 Live & Active', '⇄' sync, '🕒 Oct 24, 2:15 PM'
/// - Section 1: Product Media
///   - 'Product Media' with '1 / 5 uploaded' badge
///   - '1 primary photo • up to 5 gallery shots'
///   - Slot 1: Primary Photo with 'PRIMARY' badge, rotate & delete buttons
///   - Slot 2: '+ Add Photo'
///   - Slot 3: 'Slot 3' placeholder
///   - Validation hint: 'JPG, PNG or WebP • Max 5MB • 1:1 square ratio recommended'
/// - Section 2: Basic Information
///   - 'Basic Information' with '* Mandatory fields'
///   - Product Name *: 'Chronos Ultra 2 (49mm GPS)' with clear icon
///   - Category *: 'Wearables & Smartwatches' dropdown
///   - Brand / Manufacturer: 'TechKart Originals / Chronos' with store icon
///   - Short Description: 240 / 500 characters with aerospace-grade titanium description
/// - Section 3: Pricing & Inventory
///   - 'Pricing & Inventory' with dollar icon
///   - Regular Price ($) * ($429.00) & Compare-at ($) ($499.00)
///   - Stock * (Low Stock) with stepper (- 3 +) & SKU Identifier * (TK-W9842)
///   - Restock Alert Threshold card: 'Notify team when below: 5 units' with switch toggle
/// - Section 4: Variants & Logistics
///   - 'Variants & Logistics' with '+ Add'
///   - 'Configured Finishes:'
///     - '⚫ Titanium Black (Default) ✓'
///     - '🟡 Titanium Starlight ✕'
///   - Logistics Card: '0.28 kg • Express Parcel', 'Eligible for Next-Day Dispatch', tune icon
/// - Sticky Bottom Bar:
///   - 'Save Draft' (light blue button)
///   - 'Publish Changes' (dark navy button)
class EditProductScreen extends StatefulWidget {
  final String productName;
  final String sku;
  final double price;
  final double compareAtPrice;
  final int stock;

  const EditProductScreen({
    super.key,
    this.productName = 'Chronos Ultra 2 (49mm GPS)',
    this.sku = 'TK-W9842',
    this.price = 40506.18,
    this.compareAtPrice = 47115.58,
    this.stock = 3,
  });

  @override
  State<EditProductScreen> createState() => _EditProductScreenState();
}

class _EditProductScreenState extends State<EditProductScreen> {
  late TextEditingController _nameController;
  late TextEditingController _brandController;
  late TextEditingController _descController;
  late TextEditingController _priceController;
  late TextEditingController _compareAtController;
  late TextEditingController _skuController;

  late int _stockCount;
  String _selectedCategory = 'Wearables';
  bool _restockAlertEnabled = true;

  final List<String> _categories = [
    'Mobiles & Smartphones',
    'Laptops & Notebooks',
    'Computers & Desktops',
    'Monitors & Displays',
    'Computer Accessories',
    'Audio & Headphones',
    'Wearables',
    'TV & Home Entertainment',
    'Gaming',
    'Cameras & Photography',
    'Drones',
    'Chargers & Power',
    'Power Banks & Batteries',
    'Electrical & Power Equipment',
    'Networking',
    'Smart Home',
    'Security & Surveillance',
    'Home Appliances',
    'Kitchen Appliances',
    'Automotive Electronics',
    'Printers & Office Electronics',
    'Storage & Memory',
    'Electronics Tools & Repair',
    'Electronic Components',
    'Robotics & Development',
    'Scientific & Measurement Electronics',
    'Solar & Renewable Energy',
    'Lighting',
    '3D Printing & Fabrication',
    'VR, AR & Metaverse',
    'GPS & Navigation',
    'Communication Equipment',
    'Industrial Electronics',
    'Medical & Healthcare Electronics',
    'Office & Business Technology',
    'Professional Audio & Studio',
    'Musical Electronics',
    'Servers & Data Center',
    'Cables, Connectors & Adapters',
    'Refurbished & Used Electronics',
    'Smart Devices & IoT',
    'Electronic Accessories',
    'Gaming Accessories',
    'Photo & Video Accessories',
    'Other Electronics',
  ];

  final List<Map<String, dynamic>> _finishes = [
    {'name': 'Titanium Black (Default)', 'color': const Color(0xFF142D4E), 'isSelected': true},
    {'name': 'Titanium Starlight', 'color': const Color(0xFFFACC15), 'isSelected': false},
  ];

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.productName);
    _brandController = TextEditingController(text: 'TechKart Originals / Chronos');
    _descController = TextEditingController(
      text:
          'Aerospace-grade Grade 5 titanium case with sapphire crystal glass and 3000-nit LTPO display. Features dual-frequency GPS and 72-hour battery...',
    );
    _priceController = TextEditingController(text: widget.price.toStringAsFixed(2));
    _compareAtController = TextEditingController(text: widget.compareAtPrice.toStringAsFixed(2));
    _skuController = TextEditingController(text: widget.sku);
    _stockCount = widget.stock;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _descController.dispose();
    _priceController.dispose();
    _compareAtController.dispose();
    _skuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
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
                    // Live & Active status pill card
                    _buildLiveStatusPill(),

                    const SizedBox(height: 14),

                    // Section 1: Product Media
                    _buildProductMediaSection(),

                    const SizedBox(height: 14),

                    // Section 2: Basic Information
                    _buildBasicInformationSection(),

                    const SizedBox(height: 14),

                    // Section 3: Pricing & Inventory
                    _buildPricingInventorySection(),

                    const SizedBox(height: 14),

                    // Section 4: Variants & Logistics
                    _buildVariantsLogisticsSection(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // Sticky Bottom Bar
            _buildBottomActionBar(context),
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
            icon: const Icon(Icons.arrow_back, color: Color(0xFF000000), size: 22),
            onPressed: () => AppNavigator.pop(context),
            tooltip: 'Back',
          ),
          const SizedBox(width: 4),

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
          const SizedBox(width: 10),

          // Title
          const Text(
            'Notifica...',
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 19,
              fontWeight: FontWeight.w700,
              fontFamily: 'Literata',
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
                Icon(Icons.check, size: 16, color: Color(0xFF000000)),
                SizedBox(width: 4),
                Text(
                  'Mark all read',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
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
  // Live Status Pill (Live & Active • ⇄ • Oct 24, 2:15 PM)
  // ---------------------------------------------------------------------------
  Widget _buildLiveStatusPill() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF142D4E),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF142D4E), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: const BoxDecoration(
                  color: Color(0xFF107C41),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'Live & Active',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 11.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const Icon(Icons.sync_alt_rounded, size: 16, color: Color(0xFF142D4E)),
          Row(
            children: const [
              Icon(Icons.access_time, size: 13, color: Color(0xFF000000)),
              SizedBox(width: 4),
              Text(
                'Oct 24, 2:15 PM',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section 1: Product Media
  // ---------------------------------------------------------------------------
  Widget _buildProductMediaSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF142D4E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Product Media',
                style: TextStyle(
                  fontFamily: 'Literata',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF142D4E),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  '1 / 5 uploaded',
                  style: TextStyle(
                    color: Color(0xFF142D4E),
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            '1 primary photo • up to 5 gallery shots',
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),

          // Photos Row
          Row(
            children: [
              // Photo 1: Primary Photo
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF142D4E)),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      'asset/chronos_ultra_2.jpg',
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) => Container(
                        color: const Color(0xFF142D4E),
                        child: const Icon(Icons.image, color: Color(0xFF000000)),
                      ),
                    ),
                    // PRIMARY pill badge
                    Positioned(
                      top: 4,
                      left: 4,
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC).withValues(alpha: 0.9),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: const Text(
                          'PRIMARY',
                          style: TextStyle(
                            fontSize: 7.5,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF000000),
                          ),
                        ),
                      ),
                    ),
                    // Bottom Controls: Refresh and Delete
                    Positioned(
                      bottom: 4,
                      right: 4,
                      child: Row(
                        children: [
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.sync, size: 13, color: Color(0xFF000000)),
                          ),
                          const SizedBox(width: 4),
                          Container(
                            width: 22,
                            height: 22,
                            decoration: const BoxDecoration(
                              color: Color(0xFFDC2626),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(Icons.delete_outline, size: 13, color: Color(0xFFF8FAFC)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),

              // Photo 2: + Add Photo
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Select image from Gallery or Camera'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  width: 86,
                  height: 86,
                  decoration: BoxDecoration(
                    color: const Color(0xFF142D4E),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFF142D4E)),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Icon(Icons.add_photo_alternate_outlined, color: Color(0xFF142D4E), size: 22),
                      SizedBox(height: 4),
                      Text(
                        '+ Add Photo',
                        style: TextStyle(
                          color: Color(0xFF142D4E),
                          fontSize: 10.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 10),

              // Photo 3: Slot 3 Placeholder
              Container(
                width: 86,
                height: 86,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFFFFF),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF142D4E)),
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.image_outlined, color: Color(0xFF000000), size: 20),
                    SizedBox(height: 4),
                    Text(
                      'Slot 3',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 9.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Caption Validation Hint
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(Icons.check_circle_outline, size: 13, color: Color(0xFF142D4E)),
              SizedBox(width: 5),
              Expanded(
                child: Text(
                  'JPG, PNG or WebP • Max 5MB • 1:1 square ratio recommended',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 10,
                    fontWeight: FontWeight.w500,
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
  // Section 2: Basic Information
  // ---------------------------------------------------------------------------
  Widget _buildBasicInformationSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF142D4E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Basic Information',
                style: TextStyle(
                  fontFamily: 'Literata',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              Text(
                '* Mandatory fields',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 10.5,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Field 1: Product Name *
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Product Name *',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                ),
              ),
              Text(
                'Shown on storefront',
                style: TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _buildInputBox(
            controller: _nameController,
            suffixIcon: IconButton(
              icon: const Icon(Icons.cancel_outlined, size: 18, color: Color(0xFF000000)),
              onPressed: () => _nameController.clear(),
            ),
          ),

          const SizedBox(height: 14),

          // Field 2: Category *
          const Text(
            'Category *',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFF142D4E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: _selectedCategory,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down, color: Color(0xFF000000)),
                style: const TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
                items: _categories.map((c) {
                  return DropdownMenuItem(value: c, child: Text(c));
                }).toList(),
                onChanged: (val) {
                  if (val != null) {
                    setState(() => _selectedCategory = val);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: 14),

          // Field 3: Brand / Manufacturer
          const Text(
            'Brand / Manufacturer',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: Color(0xFF000000),
            ),
          ),
          const SizedBox(height: 6),
          _buildInputBox(
            controller: _brandController,
            prefixIcon: const Icon(Icons.store_mall_directory_outlined, size: 18, color: Color(0xFF142D4E)),
          ),

          const SizedBox(height: 14),

          // Field 4: Short Description
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Short Description',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF000000),
                ),
              ),
              Text(
                '240 / 500',
                style: TextStyle(
                  fontSize: 10.5,
                  color: Color(0xFF000000),
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          _buildInputBox(
            controller: _descController,
            maxLines: 4,
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Section 3: Pricing & Inventory
  // ---------------------------------------------------------------------------
  Widget _buildPricingInventorySection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF142D4E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text(
                'Pricing & Inventory',
                style: TextStyle(
                  fontFamily: 'Literata',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              Icon(Icons.monetization_on_outlined, size: 20, color: Color(0xFF142D4E)),
            ],
          ),
          const SizedBox(height: 14),

          // Row 1: Regular Price & Compare-at Price
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Regular Price (₹) *',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF000000)),
                    ),
                    const SizedBox(height: 6),
                    _buildInputBox(
                      controller: _priceController,
                      prefixText: '₹  ',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Compare-at (₹)',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF000000)),
                    ),
                    const SizedBox(height: 6),
                    _buildInputBox(
                      controller: _compareAtController,
                      prefixText: '₹  ',
                      keyboardType: const TextInputType.numberWithOptions(decimal: true),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Row 2: Stock * (with Low Stock badge) & SKU Identifier *
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        const Text(
                          'Stock *',
                          style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF000000)),
                        ),
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFEE2E2),
                            shape: BoxShape.circle,
                          ),
                          child: const Text(
                            'Low Stock',
                            style: TextStyle(color: Color(0xFFDC2626), fontSize: 8.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    Container(
                      height: 44,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      decoration: BoxDecoration(
                        color: const Color(0xFF142D4E),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          InkWell(
                            onTap: () {
                              if (_stockCount > 0) {
                                setState(() => _stockCount--);
                              }
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Text('-', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                          Text(
                            '$_stockCount',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                          ),
                          InkWell(
                            onTap: () {
                              setState(() => _stockCount++);
                            },
                            child: Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF8FAFC),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: const Text('+', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'SKU Identifier *',
                      style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w700, color: Color(0xFF000000)),
                    ),
                    const SizedBox(height: 6),
                    _buildInputBox(
                      controller: _skuController,
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 14),

          // Restock Alert Threshold Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF142D4E),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                const Icon(Icons.notifications_active_outlined, color: Color(0xFF142D4E), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Restock Alert Threshold',
                        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Color(0xFF000000)),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Notify team when below: 5 units',
                        style: TextStyle(fontSize: 10.5, color: Color(0xFF000000), fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                Transform.scale(
                  scale: 0.8,
                  child: Switch(
                    value: _restockAlertEnabled,
                    onChanged: (val) {
                      setState(() => _restockAlertEnabled = val);
                    },
                    activeTrackColor: const Color(0xFF142D4E),
                    activeThumbColor: const Color(0xFFF8FAFC),
                    inactiveThumbColor: const Color(0xFFF8FAFC),
                    inactiveTrackColor: const Color(0xFF142D4E),
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
  // Section 4: Variants & Logistics
  // ---------------------------------------------------------------------------
  Widget _buildVariantsLogisticsSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFF142D4E)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Variants & Logistics',
                style: TextStyle(
                  fontFamily: 'Literata',
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                ),
              ),
              InkWell(
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Add finish/variant dialog'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text(
                  '+ Add',
                  style: TextStyle(
                    color: Color(0xFF142D4E),
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 2),
          const Text(
            'Options, SKUs, and packaging specs',
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 11,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 14),

          // Configured Finishes Subheading
          const Text(
            'Configured Finishes:',
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 8),

          // Chips Row
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _finishes.map((finish) {
              final isDefault = finish['name'].toString().contains('Default');
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
                decoration: BoxDecoration(
                  color: isDefault ? const Color(0xFF142D4E) : const Color(0xFF142D4E),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF142D4E)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: finish['color'] as Color,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      finish['name'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(width: 6),
                    if (isDefault)
                      const Icon(Icons.check_circle, size: 14, color: Color(0xFF142D4E))
                    else
                      const Icon(Icons.close, size: 14, color: Color(0xFF000000)),
                  ],
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 14),

          // Logistics Card
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFF142D4E),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                // Truck in white circle
                Container(
                  width: 34,
                  height: 34,
                  decoration: const BoxDecoration(
                    color: Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.local_shipping_outlined,
                    color: Color(0xFF142D4E),
                    size: 18,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        '0.28 kg • Express Parcel',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF000000),
                        ),
                      ),
                      SizedBox(height: 1),
                      Text(
                        'Eligible for Next-Day Dispatch',
                        style: TextStyle(
                          fontSize: 10.5,
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.tune, color: Color(0xFF142D4E), size: 18),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Sticky Bottom Action Bar
  // ---------------------------------------------------------------------------
  Widget _buildBottomActionBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        border: const Border(top: BorderSide(color: Color(0xFF142D4E))),
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
          // Save Draft Button
          Expanded(
            flex: 4,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Draft saved successfully!'),
                      duration: Duration(seconds: 1),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF142D4E),
                  foregroundColor: const Color(0xFF142D4E),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.bookmark_border_rounded, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Save Draft',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Publish Changes Button
          Expanded(
            flex: 6,
            child: SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Changes published to TechKart storefront!'),
                      duration: Duration(seconds: 2),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                  AppNavigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF142D4E),
                  foregroundColor: const Color(0xFFF8FAFC),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(Icons.check_circle_outline, size: 18),
                    SizedBox(width: 6),
                    Text(
                      'Publish Changes',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInputBox({
    required TextEditingController controller,
    Widget? prefixIcon,
    String? prefixText,
    Widget? suffixIcon,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF142D4E),
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: const TextStyle(
          color: Color(0xFF000000),
          fontSize: 13,
          fontWeight: FontWeight.w600,
        ),
        decoration: InputDecoration(
          isDense: true,
          contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          border: InputBorder.none,
          prefixIcon: prefixIcon,
          prefixText: prefixText,
          prefixStyle: const TextStyle(
            color: Color(0xFF000000),
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
          suffixIcon: suffixIcon,
        ),
      ),
    );
  }
}
