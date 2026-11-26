import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/profile_avatar.dart';
import '../checkout/delivery_address.dart';

/// TechKart Profile & Settings - Address Book Screen
/// Recreated to match original reference UI with 100% visual fidelity.
typedef SavedLocation = DeliveryAddress;

class AddressBookScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onLockPressed;
  final VoidCallback? onProfilePressed;
  final ValueChanged<DeliveryAddress>? onSetDefault;
  final ValueChanged<DeliveryAddress>? onEditAddress;
  final ValueChanged<DeliveryAddress>? onDeleteAddress;
  final VoidCallback? onAddNewAddress;
  final ValueChanged<DeliveryAddress>? onSelectAddress;

  const AddressBookScreen({
    super.key,
    this.onBack,
    this.onLockPressed,
    this.onProfilePressed,
    this.onSetDefault,
    this.onEditAddress,
    this.onDeleteAddress,
    this.onAddNewAddress,
    this.onSelectAddress,
  });

  @override
  State<AddressBookScreen> createState() => _AddressBookScreenState();
}

class _AddressBookScreenState extends State<AddressBookScreen> {
  String _defaultAddressId = 'addr_1';

  final List<DeliveryAddress> _addresses = [
    const DeliveryAddress(
      id: 'addr_1',
      name: 'Tanvir Ahmed',
      label: 'Home',
      phone: '+91 98765-43210',
      addressLine:
          'House 42, Road 11, Block D, Bandra West, Mumbai - 400050, India',
      shortLocation: 'Home (Bandra West, Mumbai)',
      isDefault: true,
      deliveryEstimate: 'Hand to reception if unavailable',
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
          'Level 8, Silicon Tower, Bandra Kurla Complex (BKC), Mumbai - 400051, India',
      shortLocation: 'Office (BKC, Mumbai)',
      isDefault: false,
      deliveryEstimate: 'Mon–Fri: 9:00 AM – 6:00 PM',
      isExpress: false,
      labelIcon: Icons.business_rounded,
    ),
    const DeliveryAddress(
      id: 'addr_3',
      name: 'Nusrat Jahan',
      label: 'Family Residence',
      phone: '+91 94330-12345',
      addressLine:
          'Apartment 4B, Green Lake Enclave, Sector 4, Powai, Mumbai - 400076, India',
      shortLocation: 'Family Residence (Powai, Mumbai)',
      isDefault: false,
      deliveryEstimate: 'Weekend deliveries preferred',
      isExpress: false,
      labelIcon: Icons.location_on_outlined,
    ),
  ];

  void _setDefault(String id) {
    HapticFeedback.selectionClick();
    setState(() => _defaultAddressId = id);
    final match = _addresses.firstWhere((a) => a.id == id, orElse: () => _addresses.first);
    widget.onSetDefault?.call(match);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Default address updated', style: GoogleFonts.literata()),
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
                  _buildSubHeader(),
                  const SizedBox(height: 14),
                  ..._addresses.map(_buildAddressCard),
                  const SizedBox(height: 12),
                  _buildCityZoneAssurance(),
                  const SizedBox(height: 20),
                  _buildAddNewAddressButton(),
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
              'Address Book',
              style: GoogleFonts.literata(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          IconButton(
            key: const Key('address_book_lock_button'),
            icon: const Icon(Icons.lock_outline, size: 22, color: Color(0xFF000000)),
            onPressed: widget.onLockPressed ?? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Address data stored securely with 256-bit encryption.',
                    style: GoogleFonts.literata(),
                  ),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            key: const Key('address_book_profile_button'),
            onTap: widget.onProfilePressed,
            child: const ProfileAvatar(size: 32),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUB HEADER
  // ---------------------------------------------------------------------------
  Widget _buildSubHeader() {
    return Row(
      children: [
        Text(
          'Saved Locations',
          style: GoogleFonts.literata(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(width: 6),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2.5),
          decoration: BoxDecoration(
            color: const Color(0xFF142D4E),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Text(
            '${_addresses.length} Addresses',
            style: GoogleFonts.literata(
              fontSize: 10.5,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF000000),
            ),
          ),
        ),
        const Spacer(),
        Row(
          children: [
            const Icon(Icons.verified_outlined,
                size: 13, color: Color(0xFF000000)),
            const SizedBox(width: 4),
            Text(
              'Verified City Zone',
              style: GoogleFonts.literata(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF000000),
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ADDRESS CARD
  // ---------------------------------------------------------------------------
  Widget _buildAddressCard(DeliveryAddress address) {
    final isDefault = address.id == _defaultAddressId;

    return Container(
      margin: const EdgeInsets.only(bottom: 14),
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
              Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFF142D4E),
                  shape: BoxShape.circle,
                ),
                child: Icon(address.labelIcon, size: 14, color: const Color(0xFF142D4E)),
              ),
              const SizedBox(width: 8),
              Text(
                address.label,
                style: GoogleFonts.literata(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
              if (isDefault) ...[
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF000000),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Row(
                    children: const [
                      Icon(Icons.star, size: 9, color: Color(0xFFFDE68A)),
                      SizedBox(width: 3),
                      Text(
                        'DEFAULT ADDRESS',
                        style: TextStyle(
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.5,
                          color: Color(0xFFF8FAFC),
                        ),
                      ),
                    ],
                  ),
                ),
                const Spacer(),
                const Icon(Icons.check_circle, size: 16, color: Color(0xFF142D4E)),
              ] else ...[
                const Spacer(),
                GestureDetector(
                  onTap: () => _setDefault(address.id),
                  child: Text(
                    'Set as Default',
                    style: GoogleFonts.literata(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                address.name +
                    (address.companyTag != null ? ' ${address.companyTag}' : ''),
                style: GoogleFonts.literata(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
              Text(
                address.phone,
                style: GoogleFonts.literata(
                  fontSize: 11.5,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            address.addressLine,
            style: GoogleFonts.literata(
              fontSize: 12,
              height: 1.35,
              color: const Color(0xFF000000),
            ),
          ),
          if (address.deliveryEstimate != null) ...[
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFF142D4E),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Icon(Icons.info_outline, size: 13, color: Color(0xFF000000)),
                  const SizedBox(width: 6),
                  Text(
                    address.deliveryEstimate!,
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
          ],
          const SizedBox(height: 12),
          Row(
            children: [
              if (isDefault)
                Text(
                  'Active for one-click checkout',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    fontStyle: FontStyle.italic,
                    color: const Color(0xFF000000),
                  ),
                ),
              const Spacer(),
              if (!isDefault) ...[
                GestureDetector(
                  onTap: () => widget.onDeleteAddress?.call(address),
                  child: Container(
                    padding: const EdgeInsets.all(6),
                    decoration: BoxDecoration(
                      color: const Color(0xFF142D4E),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: const Icon(Icons.delete_outline,
                        size: 16, color: Color(0xFF000000)),
                  ),
                ),
                const SizedBox(width: 8),
              ],
              GestureDetector(
                onTap: () {
                  if (widget.onEditAddress != null) {
                    widget.onEditAddress!(address);
                  } else {
                    AppNavigator.toEditAddress(
                      context,
                      initialAddress: address,
                    );
                  }
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF142D4E),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.edit_outlined,
                          size: 13, color: Color(0xFF000000)),
                      const SizedBox(width: 4),
                      Text(
                        'Edit',
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ],
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
  // CITY ZONE ASSURANCE BANNER
  // ---------------------------------------------------------------------------
  Widget _buildCityZoneAssurance() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF142D4E),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          const Icon(Icons.local_shipping_outlined,
              size: 16, color: Color(0xFF000000)),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              'Addresses are verified for guaranteed express dispatch across Mumbai metropolitan region.',
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF000000),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ADD NEW ADDRESS BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildAddNewAddressButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton.icon(
        onPressed: widget.onAddNewAddress ??
            () => AppNavigator.toEditAddress(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF142D4E), // Deep dark button
          foregroundColor: const Color(0xFFF8FAFC),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        icon: const Icon(Icons.add, size: 16),
        label: Text(
          'Add New Address',
          style: GoogleFonts.literata(
            fontSize: 14.5,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }
}
