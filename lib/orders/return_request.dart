import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/profile_avatar.dart';

/// TechKart Orders - Return Request Screen
/// Recreated to match original reference UI with 100% visual fidelity.
class ReturnRequestScreen extends StatefulWidget {
  final String orderId;
  final String deliveredDateText;
  final double estimatedRefund;
  final String productName;
  final String productSpecs;
  final String recipientName;
  final String recipientPhone;
  final String recipientAddress;
  final String? deliveredDate;
  final String? customerName;
  final String? customerPhone;
  final String? pickupAddress;
  final VoidCallback? onBack;
  final VoidCallback? onLockPressed;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onChangePickupAddress;
  final VoidCallback? onCancelAndKeep;
  final dynamic onSubmitReturn;

  const ReturnRequestScreen({
    super.key,
    this.orderId = 'TK-89421',
    this.deliveredDateText = 'Delivered Oct 14',
    this.estimatedRefund = 15649.00,
    this.productName = 'Chronos Ultra 2 GPS Edition',
    this.productSpecs = 'Titanium Grey • 49mm Cellular Case',
    this.recipientName = 'Tanvir Ahmed',
    this.recipientPhone = '+91 98765-43210',
    this.recipientAddress =
        'House 42, Road 11, Block D, Bandra West, Mumbai - 400050, India',
    this.deliveredDate,
    this.customerName,
    this.customerPhone,
    this.pickupAddress,
    this.onBack,
    this.onLockPressed,
    this.onProfilePressed,
    this.onChangePickupAddress,
    this.onCancelAndKeep,
    this.onSubmitReturn,
  });

  @override
  State<ReturnRequestScreen> createState() => _ReturnRequestScreenState();
}

class _ReturnRequestScreenState extends State<ReturnRequestScreen> {
  String _selectedReason = 'defective'; // 'defective', 'wrong_item', 'performance', 'changed_mind'
  String _resolutionPreference = 'original'; // 'original', 'wallet'
  final TextEditingController _symptomsController = TextEditingController(
    text: 'Screen flickers when adjusting brightness dial, power drops intermittently...',
  );

  @override
  void dispose() {
    _symptomsController.dispose();
    super.dispose();
  }

  void _handleSubmit() {
    HapticFeedback.mediumImpact();
    if (widget.onSubmitReturn != null) {
      final data = {
        'orderId': widget.orderId,
        'reason': _selectedReason,
        'resolution': _resolutionPreference,
        'symptoms': _symptomsController.text,
      };
      try {
        (widget.onSubmitReturn as dynamic)(data);
      } catch (_) {
        (widget.onSubmitReturn as dynamic)();
      }
    } else {
      AppNavigator.toReturnStatus(
        context,
        orderId: widget.orderId,
        caseId: 'RET-84920',
      );
    }
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
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  _buildOrderEligibilityPills(),
                  const SizedBox(height: 14),
                  _buildStatusGuaranteeCard(),
                  const SizedBox(height: 16),
                  _buildProductForReturnCard(),
                  const SizedBox(height: 16),
                  _buildReasonForReturnCard(),
                  const SizedBox(height: 16),
                  _buildResolutionPreferenceCard(),
                  const SizedBox(height: 16),
                  _buildIssueOverviewCard(),
                  const SizedBox(height: 16),
                  _buildPickupDetailsCard(),
                  const SizedBox(height: 16),
                  _buildConfirmationLegalNote(),
                  const SizedBox(height: 14),
                  _buildSubmitButton(),
                  const SizedBox(height: 12),
                  _buildCancelKeepItemButton(),
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
            child: Container(padding: const EdgeInsets.all(8), decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle), child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF000000))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Return',
              style: GoogleFonts.literata(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          IconButton(
            key: const Key('return_lock_button'),
            icon: const Icon(Icons.lock_outline, size: 22, color: Color(0xFF000000)),
            onPressed: widget.onLockPressed ?? () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    'Return protection & 7-day guarantee verified.',
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
            key: const Key('return_profile_button'),
            onTap: widget.onProfilePressed,
            child: const ProfileAvatar(size: 32),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ORDER ELIGIBILITY PILLS
  // ---------------------------------------------------------------------------
  Widget _buildOrderEligibilityPills() {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
          decoration: BoxDecoration(
            color: const Color(0xFF142D4E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.inventory_2_outlined,
                  size: 13, color: Color(0xFF000000)),
              const SizedBox(width: 4),
              Text(
                'Order #${widget.orderId}',
                style: GoogleFonts.literata(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          widget.deliveredDateText,
          style: GoogleFonts.literata(
            fontSize: 11,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2.5),
          decoration: BoxDecoration(
            color: const Color(0xFF142D4E),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.check_circle_outline,
                  size: 11, color: Color(0xFF142D4E)),
              const SizedBox(width: 4),
              Text(
                'Eligible',
                style: TextStyle(
                  fontFamily: 'Literata',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF142D4E),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // STATUS & GUARANTEE CARD
  // ---------------------------------------------------------------------------
  Widget _buildStatusGuaranteeCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'STATUS & GUARANTEE',
                style: GoogleFonts.literata(
                  fontSize: 9.5,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                  color: const Color(0xFF000000),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFF8FAFC),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  '7 Days Return Window',
                  style: GoogleFonts.literata(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(Icons.check_circle, size: 16, color: Color(0xFF000000)),
              const SizedBox(width: 8),
              Text(
                'Full refund window valid until Oct 21, 2024',
                style: GoogleFonts.literata(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Estimated Refund',
                  style: GoogleFonts.literata(
                    fontSize: 11.5,
                    color: const Color(0xFF000000),
                  ),
                ),
                Text(
                  '₹${widget.estimatedRefund.toStringAsFixed(2)}',
                  style: GoogleFonts.literata(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
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
  // PRODUCT FOR RETURN CARD
  // ---------------------------------------------------------------------------
  Widget _buildProductForReturnCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'PRODUCT FOR RETURN',
          style: GoogleFonts.literata(
            fontSize: 10,
            fontWeight: FontWeight.w700,
            letterSpacing: 0.8,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Image.asset(
                      'asset/chronos_ultra_2.jpg',
                      width: 54,
                      height: 54,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          const Icon(Icons.devices, size: 24, color: Colors.grey),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '1x',
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFF8FAFC),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: GoogleFonts.literata(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    Text(
                      widget.productSpecs,
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          '₹${widget.estimatedRefund.toStringAsFixed(2)}',
                          style: GoogleFonts.literata(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFF142D4E),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Complete in box',
                            style: TextStyle(
                              fontFamily: 'Literata',
                              fontSize: 9.5,
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
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // REASON FOR RETURN CARD
  // ---------------------------------------------------------------------------
  Widget _buildReasonForReturnCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Reason for Return',
              style: GoogleFonts.literata(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
            Text(
              'Required *',
              style: GoogleFonts.literata(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFDC2626),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Select the main reason to initiate rapid inspection approval.',
          style: GoogleFonts.literata(
            fontSize: 11.5,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 10),
        Container(
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: Column(
            children: [
              _buildReasonItem(
                id: 'defective',
                title: 'Defective / Item Not Working',
                icon: Icons.electric_bolt_outlined,
              ),
              Divider(color: const Color(0xFFE2E8F0), height: 1),
              _buildReasonItem(
                id: 'wrong_item',
                title: 'Wrong Item Delivered',
                icon: Icons.swap_horiz,
              ),
              Divider(color: const Color(0xFFE2E8F0), height: 1),
              _buildReasonItem(
                id: 'performance',
                title: 'Performance Not as Expected',
                icon: Icons.speed,
              ),
              Divider(color: const Color(0xFFE2E8F0), height: 1),
              _buildReasonItem(
                id: 'changed_mind',
                title: 'Changed Mind / No Longer Needed',
                icon: Icons.sentiment_neutral,
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            const Icon(Icons.info_outline, size: 12, color: Color(0xFF000000)),
            const SizedBox(width: 4),
            Expanded(
              child: Text(
                'Free reverse collection applies for hardware anomalies and verified dispatch errors.',
                style: GoogleFonts.literata(
                  fontSize: 10.5,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildReasonItem({
    required String id,
    required String title,
    required IconData icon,
  }) {
    final isSelected = _selectedReason == id;

    return InkWell(
      onTap: () => setState(() => _selectedReason = id),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        color: isSelected ? const Color(0xFF142D4E) : Colors.transparent,
        child: Row(
          children: [
            Container(
              width: 18,
              height: 18,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF142D4E) : const Color(0xFFF8FAFC),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF142D4E) : const Color(0xFFE2E8F0),
                ),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 6,
                        height: 6,
                        decoration: const BoxDecoration(
                          color: Color(0xFFF8FAFC),
                          shape: BoxShape.circle,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                title,
                style: GoogleFonts.literata(
                  fontSize: 12,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
                  color: isSelected ? const Color(0xFF142D4E) : const Color(0xFFE2E8F0),
                ),
              ),
            ),
            Icon(icon, size: 16, color: const Color(0xFF000000)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // RESOLUTION PREFERENCE
  // ---------------------------------------------------------------------------
  Widget _buildResolutionPreferenceCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Resolution Preference',
          style: GoogleFonts.literata(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Select how you\'d like your refund settled once approved.',
          style: GoogleFonts.literata(
            fontSize: 11.5,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 10),
        // Option 1: Original Payment Method
        GestureDetector(
          onTap: () => setState(() => _resolutionPreference = 'original'),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _resolutionPreference == 'original'
                  ? const Color(0xFF142D4E)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _resolutionPreference == 'original'
                    ? const Color(0xFF142D4E)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: _resolutionPreference == 'original'
                        ? const Color(0xFF142D4E)
                        : const Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _resolutionPreference == 'original'
                          ? const Color(0xFF142D4E)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: _resolutionPreference == 'original'
                      ? Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'Original Payment Method',
                            style: GoogleFonts.literata(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Icon(Icons.credit_card, size: 14, color: Color(0xFF000000)),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '₹${widget.estimatedRefund.toStringAsFixed(2)} returned to Visa ending in 4092. Cleared in 3–5 banking business days.',
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
        ),
        const SizedBox(height: 10),
        // Option 2: TechKart Wallet Credit
        GestureDetector(
          onTap: () => setState(() => _resolutionPreference = 'wallet'),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: _resolutionPreference == 'wallet'
                  ? const Color(0xFF142D4E)
                  : const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                color: _resolutionPreference == 'wallet'
                    ? const Color(0xFF142D4E)
                    : const Color(0xFFE2E8F0),
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 18,
                  height: 18,
                  margin: const EdgeInsets.only(top: 2),
                  decoration: BoxDecoration(
                    color: _resolutionPreference == 'wallet'
                        ? const Color(0xFF142D4E)
                        : const Color(0xFFF8FAFC),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: _resolutionPreference == 'wallet'
                          ? const Color(0xFF142D4E)
                          : const Color(0xFFE2E8F0),
                    ),
                  ),
                  child: _resolutionPreference == 'wallet'
                      ? Center(
                          child: Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFFF8FAFC),
                              shape: BoxShape.circle,
                            ),
                          ),
                        )
                      : null,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            'TechKart Wallet Credit',
                            style: GoogleFonts.literata(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 1.5),
                            decoration: BoxDecoration(
                              color: const Color(0xFF142D4E),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              '+5% Bonus',
                              style: TextStyle(
                                fontFamily: 'Literata',
                                fontSize: 9.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF142D4E),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Receive ₹${(widget.estimatedRefund * 1.05).toStringAsFixed(2)} instantly available upon courier pickup.',
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
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ISSUE OVERVIEW & VERIFICATION
  // ---------------------------------------------------------------------------
  Widget _buildIssueOverviewCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Issue Overview & Verification',
          style: GoogleFonts.literata(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Describe symptoms or anomalies to accelerate processing.',
          style: GoogleFonts.literata(
            fontSize: 11.5,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFFE2E8F0)),
          ),
          child: TextField(
            controller: _symptomsController,
            maxLines: 3,
            style: GoogleFonts.literata(
              fontSize: 12.5,
              height: 1.35,
              color: const Color(0xFF000000),
            ),
            decoration: const InputDecoration(
              border: InputBorder.none,
            ),
          ),
        ),
        const SizedBox(height: 12),
        // Visual Proof (Optional, Max 3)
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Visual Proof (Optional, Max 3)',
              style: GoogleFonts.literata(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
            Text(
              '1 of 3 added',
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF000000),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'Accelerates instant doorstep signoff without transit delays.',
          style: GoogleFonts.literata(
            fontSize: 10.5,
            color: const Color(0xFF000000),
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            // Thumbnail with remove badge
            Stack(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10),
                  child: Image.asset(
                    'asset/chronos_lug_angle.jpg',
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.devices, size: 24, color: Colors.grey),
                  ),
                ),
                Positioned(
                  top: 2,
                  right: 2,
                  child: Container(
                    padding: const EdgeInsets.all(2),
                    decoration: const BoxDecoration(
                      color: Color(0xCC000000),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, size: 10, color: Color(0xFFF8FAFC)),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 10),
            // Add Photo Box
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF142D4E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.photo_camera_outlined,
                      size: 18, color: Color(0xFF000000)),
                  const SizedBox(height: 2),
                  Text(
                    'Add Photo',
                    style: GoogleFonts.literata(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            // Add Video Box
            Container(
              width: 60,
              height: 60,
              decoration: BoxDecoration(
                color: const Color(0xFF142D4E),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.videocam_outlined,
                      size: 18, color: Color(0xFF000000)),
                  const SizedBox(height: 2),
                  Text(
                    'Add Video',
                    style: GoogleFonts.literata(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PICKUP DETAILS CARD
  // ---------------------------------------------------------------------------
  Widget _buildPickupDetailsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2E8F0)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.local_shipping_outlined,
                  size: 16, color: Color(0xFF000000)),
              const SizedBox(width: 8),
              Text(
                'Pickup Details',
                style: GoogleFonts.literata(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
              const Spacer(),
              GestureDetector(
                onTap: widget.onChangePickupAddress,
                child: Text(
                  'Change',
                  style: GoogleFonts.literata(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                  ),
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
          const SizedBox(height: 10),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 14, color: Color(0xFF000000)),
              const SizedBox(width: 6),
              Text(
                'Reverse collection by Apex Express within 24–48 hrs.',
                style: GoogleFonts.literata(
                  fontSize: 11,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CONFIRMATION LEGAL NOTE
  // ---------------------------------------------------------------------------
  Widget _buildConfirmationLegalNote() {
    return Text(
      'By continuing, you confirm the item is packed with its original serial number and accessories intact.',
      textAlign: TextAlign.center,
      style: GoogleFonts.literata(
        fontSize: 11,
        color: const Color(0xFF000000),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUBMIT BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        onPressed: _handleSubmit,
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
          children: [
            Text(
              'Submit Return Request',
              style: GoogleFonts.literata(
                fontSize: 14.5,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward, size: 16, color: Color(0xFFF8FAFC)),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CANCEL & KEEP ITEM
  // ---------------------------------------------------------------------------
  Widget _buildCancelKeepItemButton() {
    return Center(
      child: GestureDetector(
        onTap: widget.onCancelAndKeep ?? () => Navigator.of(context).maybePop(),
        child: Text(
          'Cancel & Keep Item',
          style: GoogleFonts.literata(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF000000),
          ),
        ),
      ),
    );
  }
}
