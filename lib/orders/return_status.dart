import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

/// TechKart Orders - Return Status & Logistics Screen (SCR-34)
/// Recreated to match original reference UI with 100% visual fidelity.
class ReturnStatusScreen extends StatefulWidget {
  final String caseId;
  final String orderId;
  final double estimatedRefund;
  final String cardLast4;
  final String pickupDateText;
  final String pickupTimeWindow;
  final String productName;
  final String productSpecs;
  final String returnReason;
  final String courierName;
  final String recipientName;
  final String recipientPhone;
  final String recipientAddress;
  final VoidCallback? onBack;
  final VoidCallback? onReschedule;
  final VoidCallback? onCallCourier;
  final VoidCallback? onDownloadSlip;

  const ReturnStatusScreen({
    super.key,
    this.caseId = 'RET-84920',
    this.orderId = 'TK-89421',
    this.estimatedRefund = 15649.00,
    this.cardLast4 = '4092',
    this.pickupDateText = 'Tomorrow, Oct 28',
    this.pickupTimeWindow = 'Between 10:00 AM – 2:00 PM',
    this.productName = 'Chronos Ultra 2 GPS Edition',
    this.productSpecs = 'Titanium Grey • 49mm Cellular Case',
    this.returnReason = 'Defective / Item Not Working',
    this.courierName = 'Apex Express',
    this.recipientName = 'Tanvir Ahmed',
    this.recipientPhone = '+91 98765-43210',
    this.recipientAddress =
        'House 42, Road 11, Block D, Bandra West, Mumbai - 400050, India',
    this.onBack,
    this.onReschedule,
    this.onCallCourier,
    this.onDownloadSlip,
  });

  @override
  State<ReturnStatusScreen> createState() => _ReturnStatusScreenState();
}

class _ReturnStatusScreenState extends State<ReturnStatusScreen> {
  void _copyCaseId() {
    Clipboard.setData(ClipboardData(text: '#${widget.caseId}'));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Case ID copied to clipboard', style: GoogleFonts.literata()),
        behavior: SnackBarBehavior.floating,
      ),
    );
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
                  _buildCaseHeaderRow(),
                  const SizedBox(height: 14),
                  _buildEstimatedRefundCard(),
                  const SizedBox(height: 16),
                  _buildReturnedItemCard(),
                  const SizedBox(height: 16),
                  _buildLifecycleProgressCard(),
                  const SizedBox(height: 16),
                  _buildLogisticsCard(),
                  const SizedBox(height: 16),
                  _buildDownloadSlipButton(),
                  const SizedBox(height: 12),
                  _buildNeedConciergeHelpRow(),
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
              'Return Status',
              style: GoogleFonts.domine(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline, size: 22, color: Color(0xFF0F172A)),
            onPressed: () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF64748B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 18, color: Colors.white),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CASE HEADER ROW
  // ---------------------------------------------------------------------------
  Widget _buildCaseHeaderRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF8B6B2B),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Flexible(
                child: Text(
                  'Case ID: #${widget.caseId}',
                  style: GoogleFonts.domine(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 4),
              GestureDetector(
                onTap: _copyCaseId,
                child: const Icon(Icons.copy_rounded,
                    size: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
        ),
        const SizedBox(width: 8),
        Text(
          'Order #${widget.orderId}',
          style: GoogleFonts.literata(
            fontSize: 11,
            color: const Color(0xFF64748B),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // ESTIMATED REFUND CARD
  // ---------------------------------------------------------------------------
  Widget _buildEstimatedRefundCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFEAF5FF),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFD3E7F8)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3EEE4),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.local_shipping_outlined,
                          size: 13, color: Color(0xFF8B6B2B)),
                      const SizedBox(width: 4),
                      Flexible(
                        child: Text(
                          'Pickup Scheduled',
                          style: TextStyle(
                            fontFamily: 'Literata',
                            fontSize: 10.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF8B6B2B),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.credit_card,
                      size: 13, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  Text(
                    'Visa •••• ${widget.cardLast4}',
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            'Estimated Refund',
            style: GoogleFonts.literata(
              fontSize: 11,
              color: const Color(0xFF64748B),
            ),
          ),
          const SizedBox(height: 2),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.baseline,
            textBaseline: TextBaseline.alphabetic,
            children: [
              Flexible(
                child: Text(
                  '₹${widget.estimatedRefund.toStringAsFixed(2)}',
                  style: GoogleFonts.domine(
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  'Original payment method',
                  style: GoogleFonts.literata(
                    fontSize: 10.5,
                    color: const Color(0xFF64748B),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                    color: Color(0xFFEAF5FF),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.inventory_2_outlined,
                      size: 16, color: Color(0xFF00344B)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pickup: ${widget.pickupDateText}',
                        style: GoogleFonts.literata(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${widget.pickupTimeWindow}. Please hand over the device packed securely inside its original TechKart box with charging cable.',
                        style: GoogleFonts.literata(
                          fontSize: 11,
                          height: 1.35,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
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
  // RETURNED ITEM CARD
  // ---------------------------------------------------------------------------
  Widget _buildReturnedItemCard() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'RETURNED ITEM',
              style: GoogleFonts.literata(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.8,
                color: const Color(0xFF64748B),
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5FF),
                borderRadius: BorderRadius.circular(4),
              ),
              child: Text(
                'Qty: 1',
                style: TextStyle(
                  fontFamily: 'Literata',
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00344B),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE2EDF3)),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.asset(
                  'asset/chronos_ultra_2.jpg',
                  width: 52,
                  height: 52,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      const Icon(Icons.devices, size: 24, color: Colors.grey),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.productName,
                      style: GoogleFonts.domine(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      widget.productSpecs,
                      style: GoogleFonts.literata(
                        fontSize: 10.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Flexible(
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF5FF),
                              borderRadius: BorderRadius.circular(4),
                            ),
                            child: Text(
                              widget.returnReason,
                              style: const TextStyle(
                                fontFamily: 'Literata',
                                fontSize: 9.5,
                                color: Color(0xFF00344B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '₹${widget.estimatedRefund.toStringAsFixed(2)}',
                          style: GoogleFonts.domine(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
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
  // LIFECYCLE PROGRESS
  // ---------------------------------------------------------------------------
  Widget _buildLifecycleProgressCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EDF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  'Lifecycle Progress',
                  style: GoogleFonts.domine(
                    fontSize: 14.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'Updated 14m ago',
                style: GoogleFonts.literata(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Step 1: Return Requested
          _buildTimelineStep(
            icon: Icons.check,
            isDone: true,
            isActive: false,
            title: 'Return Requested',
            timestamp: 'Oct 26, 11:15 AM',
            description:
                'Approved instantly under TechKart 7-Day Hassle-Free Guarantee.',
            isLast: false,
          ),
          // Step 2: Pickup Scheduled (Active)
          _buildTimelineStep(
            icon: Icons.local_shipping,
            isDone: false,
            isActive: true,
            title: 'Pickup Scheduled',
            activeTag: 'Active',
            description:
                'Apex Express agent assigned to verify sealed packaging & issue pickup receipt.',
            extraWidget: Container(
              margin: const EdgeInsets.only(top: 8),
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFEAF5FF),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.access_time_rounded,
                      size: 13, color: Color(0xFF00344B)),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      'Window: ${widget.pickupDateText}, 10:00 AM – 2:00 PM',
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF00344B),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
            isLast: false,
          ),
          // Step 3: Quality Inspection
          _buildTimelineStep(
            icon: Icons.verified_outlined,
            isDone: false,
            isActive: false,
            title: 'Quality Inspection',
            timestamp: 'Est. Oct 29',
            description:
                'Mumbai Hub diagnostics team evaluates touchscreen power failure diagnosis.',
            isLast: false,
          ),
          // Step 4: Refund Released
          _buildTimelineStep(
            icon: Icons.payments_outlined,
            isDone: false,
            isActive: false,
            title: 'Refund Released',
            timestamp: '1–2 Business Days',
            description:
                '₹${widget.estimatedRefund.toStringAsFixed(2)} reversed to Visa card ending in ${widget.cardLast4}.',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required bool isDone,
    required bool isActive,
    required String title,
    String? timestamp,
    String? activeTag,
    required String description,
    Widget? extraWidget,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isDone
                      ? const Color(0xFF64748B)
                      : (isActive ? const Color(0xFF00344B) : const Color(0xFFEAF5FF)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 13,
                  color: (isDone || isActive) ? Colors.white : const Color(0xFF00344B),
                ),
              ),
              if (!isLast)
                Expanded(
                  child: Container(
                    width: 2,
                    color: const Color(0xFFE2EDF3),
                  ),
                ),
            ],
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          title,
                          style: GoogleFonts.domine(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 8),
                      if (activeTag != null)
                        Text(
                          activeTag,
                          style: GoogleFonts.literata(
                            fontSize: 11,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00344B),
                          ),
                        )
                      else if (timestamp != null)
                        Text(
                          timestamp,
                          style: GoogleFonts.literata(
                            fontSize: 10.5,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    description,
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                      height: 1.35,
                    ),
                  ),
                  if (extraWidget != null) ...[
                    extraWidget,
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LOGISTICS & COLLECTION CARD
  // ---------------------------------------------------------------------------
  Widget _buildLogisticsCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EDF3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.sync_alt, size: 16, color: Color(0xFF00344B)),
              const SizedBox(width: 8),
              Text(
                'Logistics & Collection',
                style: GoogleFonts.domine(
                  fontSize: 13.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5FF),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'Reverse Logistics',
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
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEAF5FF),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Partner: ${widget.courierName}',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'APX-RET-4910',
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(color: const Color(0xFFCBD5E1)),
                  ),
                  child: Text(
                    'Track Agent',
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 14, color: Color(0xFF00344B)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.recipientName} (${widget.recipientPhone})',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      widget.recipientAddress,
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton.icon(
                    onPressed: widget.onReschedule ?? () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEAF5FF),
                      foregroundColor: const Color(0xFF00344B),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                    icon: const Icon(Icons.calendar_month_outlined, size: 14),
                    label: Text(
                      'Reschedule',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton.icon(
                    onPressed: widget.onCallCourier ?? () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFEAF5FF),
                      foregroundColor: const Color(0xFF00344B),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                    icon: const Icon(Icons.phone_outlined, size: 14),
                    label: Text(
                      'Call Courier',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
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
  // DOWNLOAD OFFICIAL RETURN SLIP BUTTON
  // ---------------------------------------------------------------------------
  Widget _buildDownloadSlipButton() {
    return SizedBox(
      width: double.infinity,
      height: 44,
      child: ElevatedButton.icon(
        onPressed: widget.onDownloadSlip ?? () {},
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFEAF5FF),
          foregroundColor: const Color(0xFF00344B),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(22),
          ),
        ),
        icon: const Icon(Icons.receipt_long_outlined, size: 16),
        label: Text(
          'Download Official Return Slip (PDF)',
          style: GoogleFonts.literata(
            fontSize: 13,
            fontWeight: FontWeight.w700,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NEED CONCIERGE HELP
  // ---------------------------------------------------------------------------
  Widget _buildNeedConciergeHelpRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Icon(Icons.headset_mic_outlined, size: 14, color: Color(0xFF00344B)),
        const SizedBox(width: 6),
        Text(
          'Need Concierge Help with this Return?',
          style: GoogleFonts.literata(
            fontSize: 11.5,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF00344B),
          ),
        ),
      ],
    );
  }
}
