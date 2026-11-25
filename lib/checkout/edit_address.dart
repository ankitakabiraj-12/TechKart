import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:techkart/checkout/delivery_address.dart';
import '../theme/profile_avatar.dart';

/// TechKart Checkout - Add / Edit Delivery Address Screen (SCR-27)
/// Recreated to match original UI reference with 100% visual fidelity.
class EditAddressScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onLockPressed;
  final VoidCallback? onProfilePressed;
  final ValueChanged<DeliveryAddress>? onSaveAddress;
  final DeliveryAddress? initialAddress;

  const EditAddressScreen({
    super.key,
    this.onBack,
    this.onLockPressed,
    this.onProfilePressed,
    this.onSaveAddress,
    this.initialAddress,
  });

  @override
  State<EditAddressScreen> createState() => _EditAddressScreenState();
}

class _EditAddressScreenState extends State<EditAddressScreen> {
  final _formKey = GlobalKey<FormState>();

  late TextEditingController _nameController;
  late TextEditingController _phoneController;
  late TextEditingController _streetController;
  late TextEditingController _landmarkController;
  late TextEditingController _cityController;
  late TextEditingController _divisionController;
  late TextEditingController _pinController;
  late TextEditingController _instructionsController;

  final String _country = 'India';
  String _addressType = 'Home'; // 'Home', 'Office', 'Other'
  bool _isDefault = false;

  @override
  void initState() {
    super.initState();
    final a = widget.initialAddress;
    _nameController = TextEditingController(text: a?.name ?? 'Tanvir Ahmed');
    _phoneController = TextEditingController(
      text: a != null ? a.phone.replaceAll(RegExp(r'^\+91\s*'), '') : '98765-43210',
    );
    _streetController = TextEditingController(
      text: a?.addressLine ?? 'Flat 402, Lotus Grandeur, 14th Road',
    );
    _landmarkController = TextEditingController(text: 'Opposite National College, Bandra West');
    _cityController = TextEditingController(text: 'Mumbai');
    _divisionController = TextEditingController(text: 'Maharashtra');
    _pinController = TextEditingController(text: '400050');
    _instructionsController = TextEditingController(
      text: 'Call before arrival, ring bell at Flat 4B directly.',
    );
    _addressType = a?.label ?? 'Home';
    _isDefault = a?.isDefault ?? false;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _streetController.dispose();
    _landmarkController.dispose();
    _cityController.dispose();
    _divisionController.dispose();
    _pinController.dispose();
    _instructionsController.dispose();
    super.dispose();
  }

  void _handleSave() {
    if (_formKey.currentState?.validate() ?? false) {
      HapticFeedback.mediumImpact();
      final newAddr = DeliveryAddress(
        id: widget.initialAddress?.id ?? 'addr_${DateTime.now().millisecondsSinceEpoch}',
        name: _nameController.text.trim(),
        label: _addressType,
        phone: '+91 ${_phoneController.text.trim()}',
        addressLine:
            '${_streetController.text.trim()}, ${_landmarkController.text.trim()}, ${_cityController.text.trim()}, ${_divisionController.text.trim()} - ${_pinController.text.trim()}',
        shortLocation: '$_addressType (${_cityController.text.trim()})',
        isDefault: _isDefault,
        deliveryEstimate: 'Tomorrow, Oct 27 (Express)',
        isExpress: true,
        labelIcon: _addressType == 'Office'
            ? Icons.business_rounded
            : (_addressType == 'Other'
                ? Icons.people_alt_rounded
                : Icons.home_rounded),
      );

      widget.onSaveAddress?.call(newAddr);
      Navigator.of(context).pop(newAddr);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBCF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  children: [
                    _buildStepPillHeader(),
                    const SizedBox(height: 12),
                    Text(
                      'Enter your delivery location details to ensure fast and accurate shipment of your order.',
                      style: GoogleFonts.literata(
                        fontSize: 12,
                        color: const Color(0xFF1B365D),
                        height: 1.35,
                      ),
                    ),
                    const SizedBox(height: 14),
                    _buildGpsAutofillBanner(),
                    const SizedBox(height: 20),
                    _buildSectionHeader('CONTACT INFORMATION'),
                    const SizedBox(height: 10),
                    _buildRecipientNameField(),
                    const SizedBox(height: 12),
                    _buildPhoneField(),
                    const SizedBox(height: 20),
                    _buildSectionHeader('ADDRESS DETAILS'),
                    const SizedBox(height: 10),
                    _buildStreetAddressField(),
                    const SizedBox(height: 12),
                    _buildLandmarkField(),
                    const SizedBox(height: 12),
                    _buildCityAndDivisionRow(),
                    const SizedBox(height: 12),
                    _buildPinAndCountryRow(),
                    const SizedBox(height: 20),
                    _buildSectionHeader('SAVE ADDRESS AS'),
                    const SizedBox(height: 10),
                    _buildAddressTypeSelector(),
                    const SizedBox(height: 16),
                    _buildDeliveryInstructionsField(),
                    const SizedBox(height: 16),
                    _buildDefaultAddressSwitch(),
                    const SizedBox(height: 20),
                    _buildSaveButton(),
                    const SizedBox(height: 12),
                    _buildSecurityNote(),
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
        color: Color(0xFFFDFBCF),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE6C17A),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF0D1B2A)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              widget.initialAddress != null ? 'Edit Address' : 'Add New Address',
              style: GoogleFonts.domine(
                fontSize: 19,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline, size: 22, color: Color(0xFF0D1B2A)),
            onPressed: widget.onLockPressed ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Secure address configuration protected.',
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
  // STEP PILL HEADER
  // ---------------------------------------------------------------------------
  Widget _buildStepPillHeader() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
          decoration: BoxDecoration(
            color: const Color(0xFFE6C17A),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFFB8860B),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                'CHECKOUT STEP 1 OF 3',
                style: GoogleFonts.literata(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: const Color(0xFFB8860B),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Delivery Details',
          style: GoogleFonts.literata(
            fontSize: 11.5,
            color: const Color(0xFF1B365D),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // GPS AUTOFILL BANNER
  // ---------------------------------------------------------------------------
  Widget _buildGpsAutofillBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6C17A)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF5EBDD),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.my_location, size: 16, color: Color(0xFF0D1B2A)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Use Current GPS Location',
                  style: GoogleFonts.literata(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
                Text(
                  'Pinpoint your current location instantly',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    color: const Color(0xFF1B365D),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            decoration: BoxDecoration(
              color: const Color(0xFFE6C17A),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Instant Fill',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.arrow_forward_ios, size: 10, color: Color(0xFF0D1B2A)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION HEADER
  // ---------------------------------------------------------------------------
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.literata(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: const Color(0xFF1B365D),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // RECIPIENT NAME FIELD
  // ---------------------------------------------------------------------------
  Widget _buildRecipientNameField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Recipient Full Name',
              style: GoogleFonts.literata(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
            const Text(' *', style: TextStyle(color: Color(0xFFEF4444))),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EBDD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6C17A)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _nameController,
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF0D1B2A),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'e.g. Tanvir Ahmed',
                    hintStyle: GoogleFonts.literata(
                      fontSize: 13,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                ),
              ),
              const Icon(Icons.check_circle, size: 18, color: Color(0xFF10B981)),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PHONE FIELD (+91)
  // ---------------------------------------------------------------------------
  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Phone Number',
              style: GoogleFonts.literata(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
            const Text(' *', style: TextStyle(color: Color(0xFFEF4444))),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            // Country Code Pill
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
              decoration: BoxDecoration(
                color: const Color(0xFFE6C17A),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: const Color(0xFFE6C17A)),
              ),
              child: Row(
                children: [
                  Text(
                    'IN +91',
                    style: GoogleFonts.literata(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.arrow_drop_down,
                      size: 16, color: Color(0xFF0D1B2A)),
                ],
              ),
            ),
            const SizedBox(width: 8),
            // Phone Number Input
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EBDD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6C17A)),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: TextFormField(
                        controller: _phoneController,
                        keyboardType: TextInputType.phone,
                        style: GoogleFonts.literata(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF0D1B2A),
                        ),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText: '98765-43210',
                          hintStyle: GoogleFonts.literata(
                            fontSize: 13,
                            color: const Color(0xFF1B365D),
                          ),
                        ),
                      ),
                    ),
                    const Icon(Icons.phone_outlined,
                        size: 18, color: Color(0xFF1B365D)),
                  ],
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(Icons.info_outline, size: 12, color: Color(0xFF1B365D)),
            const SizedBox(width: 4),
            Text(
              'Used for delivery updates & SMS courier tracking',
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF1B365D),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STREET ADDRESS FIELD
  // ---------------------------------------------------------------------------
  Widget _buildStreetAddressField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              'Street Address & House / Flat No.',
              style: GoogleFonts.literata(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
            const Text(' *', style: TextStyle(color: Color(0xFFEF4444))),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EBDD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6C17A)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _streetController,
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    color: const Color(0xFF0D1B2A),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'House, road, flat, or building details',
                    hintStyle: GoogleFonts.literata(
                      fontSize: 13,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                ),
              ),
              const Icon(Icons.apartment_rounded,
                  size: 18, color: Color(0xFF1B365D)),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // LANDMARK FIELD
  // ---------------------------------------------------------------------------
  Widget _buildLandmarkField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Locality / Landmark',
              style: GoogleFonts.literata(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
            Text(
              'Optional',
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF1B365D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EBDD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6C17A)),
          ),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  controller: _landmarkController,
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    color: const Color(0xFF0D1B2A),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Nearby prominent structure, road or park',
                    hintStyle: GoogleFonts.literata(
                      fontSize: 13,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                ),
              ),
              const Icon(Icons.place_outlined,
                  size: 18, color: Color(0xFF1B365D)),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // CITY & STATE ROW
  // ---------------------------------------------------------------------------
  Widget _buildCityAndDivisionRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'City',
                    style: GoogleFonts.literata(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                  const Text(' *', style: TextStyle(color: Color(0xFFEF4444))),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EBDD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6C17A)),
                ),
                child: TextFormField(
                  controller: _cityController,
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    color: const Color(0xFF0D1B2A),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'City',
                    hintStyle: GoogleFonts.literata(
                      fontSize: 13,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
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
              Row(
                children: [
                  Text(
                    'State / Division',
                    style: GoogleFonts.literata(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                  const Text(' *', style: TextStyle(color: Color(0xFFEF4444))),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EBDD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6C17A)),
                ),
                child: TextFormField(
                  controller: _divisionController,
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    color: const Color(0xFF0D1B2A),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Division',
                    hintStyle: GoogleFonts.literata(
                      fontSize: 13,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PIN CODE & COUNTRY ROW
  // ---------------------------------------------------------------------------
  Widget _buildPinAndCountryRow() {
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    'Postal Code',
                    style: GoogleFonts.literata(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                  const Text(' *', style: TextStyle(color: Color(0xFFEF4444))),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EBDD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6C17A)),
                ),
                child: TextFormField(
                  controller: _pinController,
                  keyboardType: TextInputType.number,
                  style: GoogleFonts.literata(
                    fontSize: 13,
                    color: const Color(0xFF0D1B2A),
                  ),
                  decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'PIN / ZIP',
                    hintStyle: GoogleFonts.literata(
                      fontSize: 13,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
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
              Row(
                children: [
                  Text(
                    'Country',
                    style: GoogleFonts.literata(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                  const Text(' *', style: TextStyle(color: Color(0xFFEF4444))),
                ],
              ),
              const SizedBox(height: 6),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF5EBDD),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFE6C17A)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _country,
                      style: GoogleFonts.literata(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF0D1B2A),
                      ),
                    ),
                    const Icon(Icons.keyboard_arrow_down,
                        size: 16, color: Color(0xFF1B365D)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ADDRESS TYPE SELECTOR (HOME, OFFICE, OTHER)
  // ---------------------------------------------------------------------------
  Widget _buildAddressTypeSelector() {
    return Row(
      children: [
        _buildTypeOption(title: 'Home', icon: Icons.home_rounded),
        const SizedBox(width: 10),
        _buildTypeOption(title: 'Office', icon: Icons.apartment_rounded),
        const SizedBox(width: 10),
        _buildTypeOption(title: 'Other', icon: Icons.place_outlined),
      ],
    );
  }

  Widget _buildTypeOption({required String title, required IconData icon}) {
    final isSelected = _addressType == title;

    return Expanded(
      child: GestureDetector(
        onTap: () {
          HapticFeedback.selectionClick();
          setState(() => _addressType = title);
        },
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? const Color(0xFFE6C17A) : const Color(0xFFF5EBDD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: isSelected
                  ? const Color(0xFFB8860B)
                  : const Color(0xFFE6C17A),
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                size: 20,
                color: isSelected
                    ? const Color(0xFFB8860B)
                    : const Color(0xFF1B365D),
              ),
              const SizedBox(height: 6),
              Text(
                title,
                style: GoogleFonts.literata(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected
                      ? const Color(0xFF0D1B2A)
                      : const Color(0xFF1B365D),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DELIVERY INSTRUCTIONS FIELD
  // ---------------------------------------------------------------------------
  Widget _buildDeliveryInstructionsField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Delivery Instructions',
              style: GoogleFonts.literata(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
            Text(
              'Optional',
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF1B365D),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: const Color(0xFFF5EBDD),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: const Color(0xFFE6C17A)),
          ),
          child: TextFormField(
            controller: _instructionsController,
            maxLines: 2,
            style: GoogleFonts.literata(
              fontSize: 12.5,
              height: 1.35,
              color: const Color(0xFF0D1B2A),
            ),
            decoration: InputDecoration(
              border: InputBorder.none,
              hintText: 'Call before arrival, ring bell at Flat 4B directly.',
              hintStyle: GoogleFonts.literata(
                fontSize: 12,
                color: const Color(0xFF1B365D),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // DEFAULT ADDRESS SWITCH
  // ---------------------------------------------------------------------------
  Widget _buildDefaultAddressSwitch() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6C17A)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Set as default delivery address',
                  style: GoogleFonts.literata(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Use this address as primary for upcoming TechKart purchases',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    height: 1.3,
                    color: const Color(0xFF1B365D),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _isDefault,
            onChanged: (val) => setState(() => _isDefault = val),
            activeThumbColor: const Color(0xFF0D1B2A),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SAVE BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildSaveButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _handleSave,
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
              'Save & Use Address',
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
    );
  }

  // ---------------------------------------------------------------------------
  // SECURITY NOTE
  // ---------------------------------------------------------------------------
  Widget _buildSecurityNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.shield_outlined, size: 14, color: Color(0xFF1B365D)),
        const SizedBox(width: 6),
        Flexible(
          child: Text(
            'SSL Encrypted • 100% Secure Checkout & Data Privacy',
            style: GoogleFonts.literata(
              fontSize: 11,
              color: const Color(0xFF1B365D),
            ),
          ),
        ),
      ],
    );
  }
}
