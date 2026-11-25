import 'package:flutter/material.dart';
import '../app_routes/app_navigator.dart';

/// TechKart System - Offline & Network Reconnection Screen
///
/// A high-fidelity pixel-perfect recreation of the "You're Offline" screen:
/// - Top Bar:
///   - Brand mark: Lightning bolt in light blue circle + 'TechKart'
///   - Close button (✕) in soft light blue circle
/// - Center Visual:
///   - Concentric layered blue circles (radar effect)
///   - Disconnected Wi-Fi icon in the center
/// - Headline & Message:
///   - 'You’re Offline' (Serif editorial headline)
///   - 'Please check your internet connection or cellular data to resume discovering gadgets.'
/// - Cached Status Banner:
///   - Light blue rounded pill with sand/tan dot
///   - 'Last synced today at 10:42 AM • Cached browsing available'
/// - Primary Action Button:
///   - Dark navy pill: '↻ Try Again'
/// - Secondary Action Link:
///   - 'View Saved Items'
class OfflineReconnectionScreen extends StatefulWidget {
  final VoidCallback? onRetry;
  final VoidCallback? onViewSavedItems;
  final VoidCallback? onClose;

  const OfflineReconnectionScreen({
    super.key,
    this.onRetry,
    this.onViewSavedItems,
    this.onClose,
  });

  @override
  State<OfflineReconnectionScreen> createState() => _OfflineReconnectionScreenState();
}

class _OfflineReconnectionScreenState extends State<OfflineReconnectionScreen> {
  bool _isRetrying = false;

  Future<void> _handleRetry() async {
    setState(() => _isRetrying = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _isRetrying = false);

    if (widget.onRetry != null) {
      widget.onRetry!();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Reconnection attempt failed. Still offline.'),
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
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 12),

              // Top Bar: TechKart Brand Mark (Left) & Close Button (Right)
              _buildTopBar(context),

              const Spacer(flex: 2),

              // Concentric Pulsing Radar Circle with Wi-Fi Off Icon
              _buildWifiOffVisual(),

              const SizedBox(height: 32),

              // Title: You're Offline
              const Text(
                'You’re Offline',
                style: TextStyle(
                  fontFamily: 'serif',
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF0D1B2A),
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),

              const SizedBox(height: 14),

              // Subtitle / Description
              ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 320),
                child: const Text(
                  'Please check your internet connection or cellular data to resume discovering gadgets.',
                  style: TextStyle(
                    fontSize: 14.5,
                    height: 1.5,
                    color: Color(0xFF1B365D),
                    fontWeight: FontWeight.w400,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),

              const SizedBox(height: 28),

              // Cached Status Capsule Banner
              _buildCachedStatusBanner(),

              const SizedBox(height: 36),

              // Primary Action: Try Again Button
              _buildTryAgainButton(),

              const SizedBox(height: 18),

              // Secondary Action: View Saved Items Link
              InkWell(
                onTap: () {
                  if (widget.onViewSavedItems != null) {
                    widget.onViewSavedItems!();
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Opening cached wishlist & saved gadgets...'),
                        duration: Duration(seconds: 1),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  }
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Text(
                    'View Saved Items',
                    style: TextStyle(
                      color: Color(0xFF1B365D),
                      fontSize: 13.5,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),

              const Spacer(flex: 3),

              // Bottom Home Indicator Bar
              _buildHomeIndicator(),

              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top Bar
  // ---------------------------------------------------------------------------
  Widget _buildTopBar(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Left: Brand Lightning glyph + TechKart
        Row(
          children: [
            Container(
              width: 32,
              height: 32,
              padding: const EdgeInsets.all(4),
              decoration: const BoxDecoration(
                color: Color(0xFFE6C17A),
                shape: BoxShape.circle,
              ),
              child: Image.asset(
                'asset/app_logo.png',
                fit: BoxFit.contain,
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'TechKart',
              style: TextStyle(
                color: Color(0xFF0D1B2A),
                fontSize: 15.5,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),

        // Right: Close Button (✕)
        InkWell(
          onTap: () {
            if (widget.onClose != null) {
              widget.onClose!();
            } else {
              AppNavigator.pop(context);
            }
          },
          borderRadius: BorderRadius.circular(20),
          child: Container(
            width: 38,
            height: 38,
            decoration: const BoxDecoration(
              color: Color(0xFFE8F2FA),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.close,
              color: Color(0xFF1B365D),
              size: 20,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Concentric Radar Wi-Fi Visual
  // ---------------------------------------------------------------------------
  Widget _buildWifiOffVisual() {
    return Container(
      width: 140,
      height: 140,
      decoration: const BoxDecoration(
        color: Color(0xFFEDF6FD),
        shape: BoxShape.circle,
      ),
      alignment: Alignment.center,
      child: Container(
        width: 104,
        height: 104,
        decoration: const BoxDecoration(
          color: Color(0xFFD8ECFD),
          shape: BoxShape.circle,
        ),
        alignment: Alignment.center,
        child: Container(
          width: 70,
          height: 70,
          decoration: const BoxDecoration(
            color: Color(0xFFC7E2FD),
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: const Icon(
            Icons.wifi_off_rounded,
            color: Color(0xFF434E6B),
            size: 32,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Cached Status Capsule Banner
  // ---------------------------------------------------------------------------
  Widget _buildCachedStatusBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEBF4FD),
        borderRadius: BorderRadius.circular(26),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          // Tan/sand indicator dot
          Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFFC4B5A5),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          const Flexible(
            child: Text(
              'Last synced today at 10:42 AM • Cached browsing available',
              style: TextStyle(
                color: Color(0xFF1B365D),
                fontSize: 12,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.center,
              maxLines: 2,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Try Again Button
  // ---------------------------------------------------------------------------
  Widget _buildTryAgainButton() {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: _isRetrying ? null : _handleRetry,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF0D1B2A),
          foregroundColor: const Color(0xFFF5EBDD),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
          disabledBackgroundColor: const Color(0xFF0D1B2A).withValues(alpha: 0.7),
        ),
        child: _isRetrying
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFF5EBDD)),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.refresh_rounded, size: 18),
                  SizedBox(width: 8),
                  Text(
                    'Try Again',
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
  // Bottom Home Indicator Bar
  // ---------------------------------------------------------------------------
  Widget _buildHomeIndicator() {
    return Container(
      width: 134,
      height: 4,
      decoration: BoxDecoration(
        color: const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}
