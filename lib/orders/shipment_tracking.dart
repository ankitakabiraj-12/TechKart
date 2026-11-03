import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../theme/profile_avatar.dart';

/// TechKart Orders - Shipment Tracking Screen (SCR-32)
/// Recreated to match original UI reference with 100% visual fidelity.
class ShipmentTrackingScreen extends StatefulWidget {
  final String trackingId;
  final String orderId;
  final String estimatedDelivery;
  final String estimatedTime;
  final String currentStatus;
  final String nextStop;
  final String recipientName;
  final String recipientAddress;
  final String courierName;
  final String courierPhone;
  final VoidCallback? onBack;
  final VoidCallback? onShare;
  final VoidCallback? onGaugePressed;

  const ShipmentTrackingScreen({
    super.key,
    this.trackingId = 'APX-982140',
    this.orderId = 'TK-89421',
    this.estimatedDelivery = 'Tomorrow, Oct 27',
    this.estimatedTime = 'By 6:00 PM • On Schedule',
    this.currentStatus = 'In Transit — Regional Hub Transfer',
    this.nextStop = 'North Banani Dispatch Center',
    this.recipientName = 'Tanvir Ahmed',
    this.recipientAddress =
        'House 42, Road 11, Bandra West, Mumbai - 400050, India',
    this.courierName = 'Apex Courier Express',
    this.courierPhone = '+91 98765-43210',
    this.onBack,
    this.onShare,
    this.onGaugePressed,
  });

  @override
  State<ShipmentTrackingScreen> createState() => _ShipmentTrackingScreenState();
}

class _ShipmentTrackingScreenState extends State<ShipmentTrackingScreen> {
  bool _whatsappAlerts = true;

  void _copyTrackingNumber() {
    Clipboard.setData(ClipboardData(text: widget.trackingId));
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Tracking number copied to clipboard',
            style: GoogleFonts.literata()),
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
                  _buildLiveStatusHeroCard(),
                  const SizedBox(height: 16),
                  _buildTrackingDetailsCard(),
                  const SizedBox(height: 16),
                  _buildDeliveryProgressCard(),
                  const SizedBox(height: 16),
                  _buildAlertsSwitchCard(),
                  const SizedBox(height: 16),
                  _buildBottomActionButtons(),
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
              'Track Shipment',
              style: GoogleFonts.domine(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.speed, size: 22, color: Color(0xFF0F172A)),
            onPressed: widget.onGaugePressed ?? () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.share_outlined, size: 22, color: Color(0xFF0F172A)),
            onPressed: widget.onShare ?? () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          const ProfileAvatar(size: 32),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // LIVE STATUS HERO CARD
  // ---------------------------------------------------------------------------
  Widget _buildLiveStatusHeroCard() {
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
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.bolt, size: 14, color: Color(0xFF00344B)),
                    const SizedBox(width: 4),
                    Text(
                      'EXPRESS PRIORITY',
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
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0284C7),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'Live Tracking',
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
          const SizedBox(height: 14),
          Text(
            widget.estimatedDelivery,
            style: GoogleFonts.domine(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF0F172A),
            ),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(Icons.access_time_rounded,
                  size: 14, color: Color(0xFF00344B)),
              const SizedBox(width: 6),
              Text(
                widget.estimatedTime,
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
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
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: const BoxDecoration(
                    color: Color(0xFFDCEEFB),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.local_shipping,
                      size: 16, color: Color(0xFF00344B)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.currentStatus,
                        style: GoogleFonts.literata(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'Next stop: ${widget.nextStop}',
                        style: GoogleFonts.literata(
                          fontSize: 10.5,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Step 3 of 4',
                style: GoogleFonts.literata(
                  fontSize: 11,
                  color: const Color(0xFF64748B),
                ),
              ),
              Text(
                '75% Completed',
                style: GoogleFonts.literata(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF00344B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: const LinearProgressIndicator(
              value: 0.75,
              minHeight: 5,
              backgroundColor: Color(0xFFDCEEFB),
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF3B4875)),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TRACKING DETAILS CARD
  // ---------------------------------------------------------------------------
  Widget _buildTrackingDetailsCard() {
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
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TRACKING NUMBER',
                    style: GoogleFonts.literata(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    widget.trackingId,
                    style: GoogleFonts.domine(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                ],
              ),
              GestureDetector(
                onTap: _copyTrackingNumber,
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEAF5FF),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.copy_rounded, size: 13, color: Color(0xFF00344B)),
                      const SizedBox(width: 4),
                      Text(
                        'Copy',
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00344B),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // Courier Partner Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
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
                      widget.courierName,
                      style: GoogleFonts.literata(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      'Standard Courier Partner • Order #${widget.orderId}',
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFEAF5FF),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.phone_outlined,
                    size: 16, color: Color(0xFF00344B)),
              ),
            ],
          ),
          const SizedBox(height: 12),
          // 2 Items in Shipment Tile
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset(
                    'asset/chronos_ultra_2.jpg',
                    width: 40,
                    height: 40,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) =>
                        const Icon(Icons.devices, size: 20, color: Colors.grey),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '2 Items in Shipment',
                        style: GoogleFonts.literata(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0F172A),
                        ),
                      ),
                      Text(
                        'Chronos Ultra 2 + VoltFast GaN Cha...',
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
          ),
          const SizedBox(height: 12),
          // Destination Address
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.location_on_outlined,
                  size: 16, color: Color(0xFF00344B)),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Destination Address',
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      '${widget.recipientName} • ${widget.recipientAddress}',
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
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // DELIVERY PROGRESS TIMELINE
  // ---------------------------------------------------------------------------
  Widget _buildDeliveryProgressCard() {
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
              Text(
                'Delivery Progress',
                style: GoogleFonts.domine(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0F172A),
                ),
              ),
              Text(
                'IST (GMT+5:30)',
                style: GoogleFonts.literata(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF64748B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Step 1: Active
          _buildTimelineStep(
            icon: Icons.local_shipping,
            isActive: true,
            isDone: false,
            timestamp: 'Today, Oct 26 • 04:15 PM',
            tag: 'Mumbai Central Hub',
            title: 'Departed Sorting Facility',
            description:
                'Package is en route to Bandra Dispatch Center for final sort.',
            isLast: false,
          ),
          // Step 2: Done
          _buildTimelineStep(
            icon: Icons.check,
            isActive: false,
            isDone: true,
            timestamp: 'Today, Oct 26 • 11:30 AM',
            title: 'Package Scanned & Processed',
            description:
                'Custom packaging inspection passed and sealed securely.',
            isLast: false,
          ),
          // Step 3: Done
          _buildTimelineStep(
            icon: Icons.check,
            isActive: false,
            isDone: true,
            timestamp: 'Today, Oct 26 • 10:28 AM',
            title: 'Order Placed & Verified',
            description:
                'Payment confirmed via Mastercard •••• 4829. Warehouse picked.',
            isLast: false,
          ),
          // Step 4: Pending
          _buildTimelineStep(
            icon: Icons.access_time_rounded,
            isActive: false,
            isDone: false,
            timestamp: 'Expected Tomorrow, Oct 27 • By 6:00 PM',
            title: 'Out for Delivery & Handover',
            description:
                'Delivery executive will call prior to arrival with OTP verification.',
            isLast: true,
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineStep({
    required IconData icon,
    required bool isActive,
    required bool isDone,
    required String timestamp,
    String? tag,
    required String title,
    required String description,
    required bool isLast,
  }) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon & Line
          Column(
            children: [
              Container(
                width: 24,
                height: 24,
                decoration: BoxDecoration(
                  color: isActive
                      ? const Color(0xFF3B4875)
                      : (isDone ? const Color(0xFF00344B) : const Color(0xFFEAF5FF)),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  icon,
                  size: 13,
                  color: (isActive || isDone) ? Colors.white : const Color(0xFF00344B),
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
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        timestamp,
                        style: GoogleFonts.literata(
                          fontSize: 10.5,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF64748B),
                        ),
                      ),
                      if (tag != null) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 1.5),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF5FF),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            tag,
                            style: TextStyle(
                              fontFamily: 'Literata',
                              fontSize: 9.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF00344B),
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    title,
                    style: GoogleFonts.domine(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
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
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SMS & WHATSAPP ALERTS SWITCH
  // ---------------------------------------------------------------------------
  Widget _buildAlertsSwitchCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EDF3)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF3EEE4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Icon(Icons.notifications_active_outlined,
                size: 18, color: Color(0xFF8B6B2B)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'SMS & WhatsApp Alerts',
                  style: GoogleFonts.literata(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0F172A),
                  ),
                ),
                Text(
                  'Real-time status updates enabled',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    color: const Color(0xFF64748B),
                  ),
                ),
              ],
            ),
          ),
          Switch(
            value: _whatsappAlerts,
            onChanged: (val) => setState(() => _whatsappAlerts = val),
            activeThumbColor: const Color(0xFF00344B),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BOTTOM ACTIONS
  // ---------------------------------------------------------------------------
  Widget _buildBottomActionButtons() {
    return Row(
      children: [
        Expanded(
          child: SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: widget.onShare ?? () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFEAF5FF),
                foregroundColor: const Color(0xFF00344B),
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              icon: const Icon(Icons.share_outlined, size: 16),
              label: Text(
                'Share Status',
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SizedBox(
            height: 44,
            child: ElevatedButton.icon(
              onPressed: () {},
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF00344B),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(22),
                ),
              ),
              icon: const Icon(Icons.support_agent, size: 16),
              label: Text(
                'Get Support',
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
