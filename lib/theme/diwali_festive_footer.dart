import 'package:flutter/material.dart';
import 'app_theme.dart';

/// TechKart Winter & Christmas Festive Bottom Decorative Footer
///
/// Clean, elegant festive footer displaying subtle evergreen branches,
/// champagne gold ornaments, and winter foliage motifs.
/// Positioned fixed right above the bottom navigation bar or input bar.
/// Uses IgnorePointer to ensure no scrolling or button clicks are ever obstructed.
class DiwaliFestiveFooter extends StatelessWidget {
  /// Maximum height constraint for the festive banner (responsive to device size).
  final double height;

  /// Optional margin/padding below the decorative footer.
  final double bottomSpacing;

  /// Opacity if subtle watermark blending is needed (default 1.0 = 100% vibrant colors).
  final double opacity;

  const DiwaliFestiveFooter({
    super.key,
    this.height = 36.0,
    this.bottomSpacing = 0.0,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final double effectiveHeight = screenWidth < 360 ? (height * 0.85) : height;

    return IgnorePointer(
      ignoring: true, // Non-interactive so clicks pass straight through
      child: Container(
        width: double.infinity,
        height: effectiveHeight,
        margin: EdgeInsets.only(bottom: bottomSpacing),
        child: Opacity(
          opacity: opacity.clamp(0.0, 1.0),
          child: CustomPaint(
            size: Size(screenWidth, effectiveHeight),
            painter: _WinterGarlandPainter(),
          ),
        ),
      ),
    );
  }
}

class _WinterGarlandPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    if (w <= 0 || h <= 0) return;

    // Subtle evergreen base line
    final Paint pinePaint = Paint()
      ..color = AppTheme.evergreen.withValues(alpha: 0.22)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.2;

    final Path garlandPath = Path()..moveTo(0, h * 0.5);
    const int segments = 8;
    final double segWidth = w / segments;

    for (int i = 0; i < segments; i++) {
      final double startX = i * segWidth;
      final double midX = startX + segWidth / 2;
      final double endX = (i + 1) * segWidth;
      final double dip = h * 0.35;
      garlandPath.quadraticBezierTo(midX, h * 0.5 + dip, endX, h * 0.5);
    }
    canvas.drawPath(garlandPath, pinePaint);

    // Subtle champagne gold & berry ornament dots at dips
    final Paint goldPaint = Paint()..color = AppTheme.champagneGold.withValues(alpha: 0.65);
    final Paint berryPaint = Paint()..color = AppTheme.christmasRed.withValues(alpha: 0.6);

    for (int i = 0; i < segments; i++) {
      final double midX = (i + 0.5) * segWidth;
      final double ornamentY = h * 0.75;
      canvas.drawCircle(Offset(midX, ornamentY), 2.5, i % 2 == 0 ? goldPaint : berryPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
