import 'package:flutter/material.dart';
import '../app_routes/app_navigator.dart';

/// TechKart System - Scheduled Maintenance & System Degradation Screen
///
/// A high-fidelity pixel-perfect recreation of the "Scheduled Maintenance" screen:
/// - Top Bar:
///   - Brand title: 'TechKart•' (with bold bullet dot)
///   - Status Pill: '• OFFLINE MODE' (sand/olive dot, uppercase label)
/// - Center Visual:
///   - Concentric layered blue rings (system calibration aesthetic)
///   - Center white circular disc with tune/sliders icon (Icons.tune)
/// - Headline & Message:
///   - 'Scheduled Maintenance' (Serif editorial headline)
///   - 'We’re performing brief scheduled upgrades to improve your shopping and discovery experience. TechKart will be back online shortly.'
/// - Card 1 (Expected Completion & Protection):
///   - Clock icon in warm tan circle
///   - 'Expected completion: 3:00 PM EST'
///   - 'Estimated duration ~ 25 minutes remaining'
///   - Thin divider
///   - Shield checkmark icon
///   - 'All pending carts, checkout data, and orders are safely stored.'
/// - Card 2 (Platform Sync in progress):
///   - Light blue card with sync icon
///   - 'Platform Sync in progress' & 'STAGE 3/4'
/// - Primary Action Button:
///   - Dark navy pill: '↻ Check Connection'
/// - Support Link:
///   - 'Need urgent order support? Contact Desk ↗'
/// - Footer Diagnostics Metadata:
///   - '• Storefront Edge Gateway Offline'
///   - 'Incident ID: TK-M802 • Region: US-EAST-1'
class MaintainDegradationScreen extends StatefulWidget {
  final VoidCallback? onCheckConnection;
  final VoidCallback? onContactDesk;

  const MaintainDegradationScreen({
    super.key,
    this.onCheckConnection,
    this.onContactDesk,
  });

  @override
  State<MaintainDegradationScreen> createState() => _MaintainDegradationScreenState();
}

class _MaintainDegradationScreenState extends State<MaintainDegradationScreen> {
  bool _isChecking = false;

  Future<void> _handleCheckConnection() async {
    setState(() => _isChecking = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isChecking = false);

    if (widget.onCheckConnection != null) {
      widget.onCheckConnection!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Maintenance in progress (Stage 3/4). System returning soon.'),
          duration: Duration(seconds: 2),
          behavior: SnackBarBehavior.floating,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF7FAFD),
      body: SafeArea(
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 14),

              // Top Bar: TechKart• & • OFFLINE MODE
              _buildTopBar(),

              const SizedBox(height: 28),

              // Concentric Layered Rings with Tune/Sliders Icon
              _buildSystemTuneVisual(),

              const SizedBox(height: 26),

              // Title: Scheduled Maintenance
              const Text(
                'Scheduled Maintenance',
                style: TextStyle(
                  fontFamily: 'Literata',
                  fontSize: 29,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF000000),
                  letterSpacing: -0.4,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 12),

              // Subtitle / Body Copy
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: const Text(
                  'We’re performing brief scheduled upgrades to improve your shopping and discovery experience. TechKart will be back online shortly.',
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 24),

              // Card 1: Expected completion & Safe Storage Card
              _buildCompletionCard(),

              const SizedBox(height: 12),

              // Card 2: Platform Sync in progress (STAGE 3/4)
              _buildPlatformSyncCard(),

              const SizedBox(height: 24),

              // Primary Action: Check Connection Button
              _buildCheckConnectionButton(),

              const SizedBox(height: 18),

              // Support Link: Need urgent order support? Contact Desk ↗
              _buildSupportLink(context),

              const SizedBox(height: 32),

              // Footer Diagnostic Telemetry Metadata
              _buildFooterDiagnostics(),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Bar (TechKart• & OFFLINE MODE)
  // ---------------------------------------------------------------------------
  Widget _buildTopBar() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Brand Title with Bullet Dot
        Row(
          children: [
            Container(
              width: 24,
              height: 24,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.asset(
                  'asset/app_logo.png',
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'TechKart',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 19,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
            const Text(
              '•',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),

        // OFFLINE MODE capsule badge
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          decoration: BoxDecoration(
            color: const Color(0xFFE8F3FD),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF65605A),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              const Text(
                'OFFLINE MODE',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Concentric Layered Rings with Tune/Sliders Icon
  // ---------------------------------------------------------------------------
  Widget _buildSystemTuneVisual() {
    return Container(
      width: 146,
      height: 146,
      decoration: const BoxDecoration(
        color: Color(0xFFEDF6FD),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 112,
        height: 112,
        decoration: const BoxDecoration(
          color: Color(0xFFD6EBFC),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 68,
          height: 68,
          decoration: BoxDecoration(
            color: const Color(0xFFF8FAFC),
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.04),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.tune,
            color: Color(0xFF000000),
            size: 26,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Card 1: Expected Completion & Safe Data Storage
  // ---------------------------------------------------------------------------
  Widget _buildCompletionCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE8EEF5)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.015),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          // Top Row: Clock in tan circle + Expected completion
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  color: Color(0xFFEFE8DB),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.access_time_rounded,
                  color: Color(0xFF78624C),
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Expected completion: 3:00 PM EST',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Estimated duration ~ 25 minutes remaining',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 11.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: Color(0xFFE8EEF5)),
          const SizedBox(height: 12),

          // Bottom Row: Shield Checkmark + Data Protection
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              Icon(
                Icons.gpp_good_outlined,
                color: Color(0xFF3B82F6),
                size: 16,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'All pending carts, checkout data, and orders are safely stored.',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 11.5,
                    height: 1.4,
                    fontWeight: FontWeight.w400,
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
  // Card 2: Platform Sync in progress (STAGE 3/4)
  // ---------------------------------------------------------------------------
  Widget _buildPlatformSyncCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEEF6FD),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: const [
              Icon(
                Icons.sync_alt_rounded,
                color: Color(0xFF000000),
                size: 16,
              ),
              SizedBox(width: 8),
              Text(
                'Platform Sync in progress',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          const Text(
            'STAGE 3/4',
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Primary Button: Check Connection
  // ---------------------------------------------------------------------------
  Widget _buildCheckConnectionButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isChecking ? null : _handleCheckConnection,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF142D4E),
          foregroundColor: const Color(0xFFF8FAFC),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          disabledBackgroundColor: const Color(0xFF142D4E).withValues(alpha: 0.7),
        ),
        child: _isChecking
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF8FAFC)),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.refresh_rounded, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Check Connection',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Support Link
  // ---------------------------------------------------------------------------
  Widget _buildSupportLink(BuildContext context) {
    return InkWell(
      onTap: () {
        if (widget.onContactDesk != null) {
          widget.onContactDesk!();
        } else {
          _showSupportSheet(context);
        }
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: const [
            Text(
              'Need urgent order support? ',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 13,
                fontWeight: FontWeight.w400,
              ),
            ),
            Text(
              'Contact Desk',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 13,
                fontWeight: FontWeight.w700,
                decoration: TextDecoration.underline,
              ),
            ),
            SizedBox(width: 2),
            Icon(
              Icons.north_east,
              color: Color(0xFF000000),
              size: 13,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Footer Diagnostics
  // ---------------------------------------------------------------------------
  Widget _buildFooterDiagnostics() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 5,
              height: 5,
              decoration: const BoxDecoration(
                color: Color(0xFF000000),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            const Text(
              'Storefront Edge Gateway Offline',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        const Text(
          'Incident ID: TK-M802 • Region: US-EAST-1',
          style: TextStyle(
            color: Color(0xFF000000),
            fontSize: 11,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  void _showSupportSheet(BuildContext context) {
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
              'TechKart 24/7 Priority Desk',
              style: TextStyle(fontFamily: 'Literata', fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'If you have an urgent order arriving today or need payment assistance, our priority concierge is on standby:',
              style: TextStyle(color: Color(0xFF000000), fontSize: 13, height: 1.4),
            ),
            const SizedBox(height: 16),
            ListTile(
              leading: const Icon(Icons.support_agent_rounded, color: Color(0xFF142D4E)),
              title: const Text('Connect with Live Concierge'),
              subtitle: const Text('Estimated wait time: < 1 min'),
              onTap: () {
                AppNavigator.pop(ctx);
                AppNavigator.toSupportChat(context);
              },
            ),
            ListTile(
              leading: const Icon(Icons.email_outlined, color: Color(0xFF142D4E)),
              title: const Text('Email priority@techkart.com'),
              onTap: () => AppNavigator.pop(ctx),
            ),
          ],
        ),
      ),
    );
  }
}
