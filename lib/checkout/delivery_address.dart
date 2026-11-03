import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/network.dart';
import '../theme/profile_avatar.dart';

/// TechKart Checkout - Select Delivery Address Screen (SCR-26)
/// Recreated to match original UI reference with 100% visual fidelity.
class DeliveryAddressScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onLockPressed;
  final VoidCallback? onProfilePressed;
  final ValueChanged<DeliveryAddress>? onAddressSelected;
  final VoidCallback? onContinueToPayment;
  final VoidCallback? onAddNewAddress;

  const DeliveryAddressScreen({
    super.key,
    this.onBack,
    this.onLockPressed,
    this.onProfilePressed,
    this.onAddressSelected,
    this.onContinueToPayment,
    this.onAddNewAddress,
  });

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  String _selectedAddressId = 'addr_1';
  bool _isLoadingAddresses = false;
  bool _leaveAtDoor = true;
  final ApiClient _apiClient = ApiClient();

  late List<DeliveryAddress> _addresses;

  @override
  void initState() {
    super.initState();
    _loadInitialFallback();
    _fetchAddresses();
  }

  void _loadInitialFallback() {
    _addresses = [
      const DeliveryAddress(
        id: 'addr_1',
        name: 'Tanvir Ahmed',
        label: 'Home',
        phone: '+91 98765-43210',
        addressLine:
            'Flat 402, Lotus Grandeur, 14th Road, Bandra West, Mumbai, Maharashtra - 400050, India',
        shortLocation: 'Home (Bandra West, Mumbai)',
        isDefault: true,
        deliveryEstimate: 'Tomorrow, Oct 27 (Express)',
        isExpress: true,
        labelIcon: Icons.home_rounded,
      ),
      const DeliveryAddress(
        id: 'addr_2',
        name: 'Tanvir Ahmed',
        companyTag: '(TechKart HQ)',
        label: 'Office',
        phone: '+91 98201-98765',
        addressLine:
            'Level 8, Crystal Tower, Bandra Kurla Complex (BKC), Mumbai, Maharashtra - 400051, India',
        shortLocation: 'Office (BKC, Mumbai)',
        isDefault: false,
        deliveryEstimate: 'Standard Delivery (2-3 business days)',
        isExpress: false,
        labelIcon: Icons.business_rounded,
      ),
      const DeliveryAddress(
        id: 'addr_3',
        name: 'Nasreen Sultana',
        label: 'Other',
        phone: '+91 94330-12345',
        addressLine:
            'Apartment 5B, Green Valley, Hiranandani Gardens, Powai, Mumbai, Maharashtra - 400076',
        shortLocation: 'Other (Powai, Mumbai)',
        isDefault: false,
        deliveryEstimate: 'Standard Delivery (2-3 business days)',
        isExpress: false,
        labelIcon: Icons.people_alt_rounded,
      ),
    ];
  }

  DeliveryAddress get _selectedAddress {
    return _addresses.firstWhere(
      (a) => a.id == _selectedAddressId,
      orElse: () => _addresses.first,
    );
  }

  @override
  void dispose() {
    _apiClient.close();
    super.dispose();
  }

  Future<void> _fetchAddresses() async {
    final token = await TokenStorage().getToken();
    if (token == null || token.isEmpty) return;
    if (_isLoadingAddresses) return;
    _isLoadingAddresses = true;
    try {
      final response = await _apiClient.get<List<AddressModel>>(
        '/customer/addresses',
        requiresAuth: true,
        fromJsonData: (data) {
          if (data is List) {
            return data
                .map((e) => AddressModel.fromJson(e as Map<String, dynamic>))
                .toList();
          }
          return <AddressModel>[];
        },
      );
      if (response.success && response.data != null && mounted) {
        final list = response.data!;
        if (list.isNotEmpty) {
          final loaded = list.map((addr) {
            final isOffice = addr.label.toLowerCase() == 'office' ||
                addr.label.toLowerCase() == 'work';
            return DeliveryAddress(
              id: addr.id.toString(),
              name: addr.recipientName,
              companyTag: isOffice ? '(Work)' : null,
              label: addr.label,
              phone: addr.phone,
              addressLine: addr.fullAddressString,
              shortLocation: '${addr.label} (${addr.city})',
              isDefault: addr.isDefault,
              deliveryEstimate: 'Tomorrow, Oct 27 (Express)',
              isExpress: true,
              labelIcon: isOffice ? Icons.business_rounded : Icons.home_rounded,
            );
          }).toList();
          setState(() {
            _addresses = loaded;
            final def = loaded.firstWhere((a) => a.isDefault, orElse: () => loaded.first);
            _selectedAddressId = def.id;
          });
        }
      }
    } catch (_) {
    } finally {
      if (mounted) setState(() => _isLoadingAddresses = false);
    }
  }

  void _handleAddressSelect(DeliveryAddress addr) {
    HapticFeedback.selectionClick();
    setState(() => _selectedAddressId = addr.id);
    widget.onAddressSelected?.call(addr);
  }

  void _handleProceed() {
    HapticFeedback.mediumImpact();
    if (widget.onContinueToPayment != null) {
      widget.onContinueToPayment!();
    } else {
      AppNavigator.toOrderReview(context, selectedAddress: _selectedAddress);
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
                  _buildStepperIndicator(),
                  const SizedBox(height: 18),
                  _buildStepTitleHeader(),
                  const SizedBox(height: 16),
                  ..._addresses.map(_buildAddressCard),
                  const SizedBox(height: 12),
                  _buildAddNewAddressCard(),
                  const SizedBox(height: 12),
                  _buildDeliveryPreferenceCard(),
                  const SizedBox(height: 16),
                ],
              ),
            ),
            _buildStickyBottomBar(),
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
  // 3-STEPPER INDICATOR (ADDRESS - PAYMENT - REVIEW)
  // ---------------------------------------------------------------------------
  Widget _buildStepperIndicator() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildStepItem(icon: Icons.location_on, label: 'ADDRESS', isActive: true, isDone: false),
            _buildStepConnector(),
            _buildStepItem(icon: Icons.credit_card_outlined, label: 'PAYMENT', isActive: false, isDone: false),
            _buildStepConnector(),
            _buildStepItem(icon: Icons.verified_outlined, label: 'REVIEW', isActive: false, isDone: false),
          ],
        ),
        const SizedBox(height: 12),
        const Divider(color: Color(0xFFE2EDF3), height: 1),
      ],
    );
  }

  Widget _buildStepItem({
    required IconData icon,
    required String label,
    required bool isActive,
    required bool isDone,
  }) {
    return Column(
      children: [
        Container(
          width: 32,
          height: 32,
          decoration: BoxDecoration(
            color: isActive
                ? const Color(0xFF00344B)
                : const Color(0xFFDCEEFB),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            size: 16,
            color: isActive ? Colors.white : const Color(0xFF64748B),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.literata(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: isActive ? const Color(0xFF00344B) : const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }

  Widget _buildStepConnector() {
    return Container(
      width: 44,
      height: 2,
      color: const Color(0xFFE2EDF3),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP TITLE HEADER
  // ---------------------------------------------------------------------------
  Widget _buildStepTitleHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
          decoration: BoxDecoration(
            color: const Color(0xFFEAF5FF),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF00344B),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'STEP 1 OF 3',
                style: GoogleFonts.literata(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: const Color(0xFF00344B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Select Delivery Address',
          style: GoogleFonts.domine(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0F172A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Choose where you would like your TechKart order delivered.',
          style: GoogleFonts.literata(
            fontSize: 12,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ADDRESS CARD
  // ---------------------------------------------------------------------------
  Widget _buildAddressCard(DeliveryAddress address) {
    final isSelected = address.id == _selectedAddressId;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF00344B) : const Color(0xFFE2EDF3),
          width: isSelected ? 1.5 : 1,
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: IntrinsicHeight(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Selected left vertical accent bar
            if (isSelected)
              Container(
                width: 4,
                decoration: const BoxDecoration(
                  color: Color(0xFF00344B),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16),
                    bottomLeft: Radius.circular(16),
                  ),
                ),
              ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Top Row: Selection Radio + Tag + Actions
                    Row(
                      children: [
                        GestureDetector(
                          onTap: () => _handleAddressSelect(address),
                          child: Container(
                            width: 20,
                            height: 20,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF00344B)
                                  : Colors.white,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSelected
                                    ? const Color(0xFF00344B)
                                    : const Color(0xFFCBD5E1),
                                width: 1.5,
                              ),
                            ),
                            child: isSelected
                                ? const Icon(Icons.check,
                                    size: 13, color: Colors.white)
                                : null,
                          ),
                        ),
                        const SizedBox(width: 8),
                        // Label Pill (Home, Office, Other)
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF5FF),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(address.labelIcon,
                                  size: 13, color: const Color(0xFF00344B)),
                              const SizedBox(width: 4),
                              Text(
                                address.label,
                                style: GoogleFonts.literata(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF00344B),
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFFF3EEE4),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              'DEFAULT',
                              style: TextStyle(
                                fontFamily: 'Literata',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF8B6B2B),
                              ),
                            ),
                          ),
                        ],
                        const Spacer(),
                        // Edit & Delete Icons
                        GestureDetector(
                          onTap: () {
                            AppNavigator.toEditAddress(
                              context,
                              initialAddress: address,
                            );
                          },
                          child: const Icon(Icons.edit_outlined,
                              size: 16, color: Color(0xFF64748B)),
                        ),
                        if (address.isDefault) ...[
                          const SizedBox(width: 10),
                          GestureDetector(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Cannot delete default address',
                                    style: GoogleFonts.literata(),
                                  ),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            child: const Icon(Icons.delete_outline,
                                size: 16, color: Color(0xFF64748B)),
                          ),
                        ],
                      ],
                    ),
                    const SizedBox(height: 10),
                    // Recipient Name & Phone
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          address.name +
                              (address.companyTag != null
                                  ? ' ${address.companyTag}'
                                  : ''),
                          style: GoogleFonts.domine(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        Text(
                          address.phone,
                          style: GoogleFonts.literata(
                            fontSize: 11.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 4),
                    // Address Line
                    Text(
                      address.addressLine,
                      style: GoogleFonts.literata(
                        fontSize: 12,
                        height: 1.35,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    if (address.deliveryEstimate != null) ...[
                      const SizedBox(height: 10),
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEAF5FF),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              address.isExpress
                                  ? Icons.bolt
                                  : Icons.access_time_rounded,
                              size: 14,
                              color: const Color(0xFF00344B),
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                'Estimated Delivery: ${address.deliveryEstimate}',
                                style: GoogleFonts.literata(
                                  fontSize: 11,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF00344B),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
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
  // ADD NEW ADDRESS CARD
  // ---------------------------------------------------------------------------
  Widget _buildAddNewAddressCard() {
    return GestureDetector(
      onTap: widget.onAddNewAddress ?? () => AppNavigator.toEditAddress(context),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF5FF),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFD3E7F8)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFDCEEFB),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.add_location_alt_outlined,
                  size: 18, color: Color(0xFF00344B)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Add New Delivery Address',
                    style: GoogleFonts.literata(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF00344B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Add a home, office, or pickup location',
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.arrow_forward_ios, size: 14, color: Color(0xFF00344B)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DELIVERY PREFERENCE CARD
  // ---------------------------------------------------------------------------
  Widget _buildDeliveryPreferenceCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE2EDF3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF1F5F9),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.door_front_door_outlined,
                size: 18, color: Color(0xFF00344B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Delivery Preference',
                  style: GoogleFonts.literata(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Leave package at front door with building guard if unavailable',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    height: 1.3,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          GestureDetector(
            onTap: () => setState(() => _leaveAtDoor = !_leaveAtDoor),
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: _leaveAtDoor ? const Color(0xFF00344B) : Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(
                  color: _leaveAtDoor
                      ? const Color(0xFF00344B)
                      : const Color(0xFFCBD5E1),
                ),
              ),
              child: _leaveAtDoor
                  ? const Icon(Icons.check, size: 14, color: Colors.white)
                  : null,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STICKY BOTTOM BAR
  // ---------------------------------------------------------------------------
  Widget _buildStickyBottomBar() {
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
              const Icon(Icons.near_me_outlined,
                  size: 14, color: Color(0xFF00344B)),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Delivering to: ${_selectedAddress.shortLocation}',
                  style: GoogleFonts.literata(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0F172A),
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5FF),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'FREE SHIPPING',
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
          const SizedBox(height: 10),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton(
              onPressed: _handleProceed,
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
                      fontSize: 14.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Icon(Icons.arrow_forward, size: 16, color: Colors.white),
                ],
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.lock_outline, size: 12, color: Color(0xFF64748B)),
              const SizedBox(width: 4),
              Text(
                'Secure SSL 256-bit Encrypted Checkout',
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

class DeliveryAddress {
  final String id;
  final String name;
  final String? companyTag;
  final String label;
  final String phone;
  final String addressLine;
  final String shortLocation;
  final bool isDefault;
  final String? deliveryEstimate;
  final bool isExpress;
  final IconData labelIcon;

  const DeliveryAddress({
    required this.id,
    required this.name,
    this.companyTag,
    required this.label,
    required this.phone,
    required this.addressLine,
    required this.shortLocation,
    required this.isDefault,
    this.deliveryEstimate,
    required this.isExpress,
    required this.labelIcon,
  });
}

