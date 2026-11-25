import 'package:flutter/material.dart';

/// TechKart Diwali Festive Bottom Decorative Footer
///
/// Clean, transparent festive clipart displaying Diwali oil lamps (diyas),
/// gift boxes, marigold flowers, and golden rangoli motifs.
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
    this.height = 70.0,
    this.bottomSpacing = 0.0,
    this.opacity = 1.0,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    // Responsive height: adapt gracefully on smaller compact phones (e.g. 320-360px width)
    final double effectiveHeight = screenWidth < 360 ? (height * 0.85) : height;

    return IgnorePointer(
      ignoring: true, // Non-interactive so clicks pass straight through
      child: Container(
        width: double.infinity,
        margin: EdgeInsets.only(bottom: bottomSpacing),
        child: Center(
          child: Opacity(
            opacity: opacity.clamp(0.0, 1.0),
            child: Image.asset(
              'asset/diwali_footer.png',
              height: effectiveHeight,
              width: screenWidth > 600 ? 600 : screenWidth,
              fit: BoxFit.contain,
              alignment: Alignment.bottomCenter,
              filterQuality: FilterQuality.high,
              errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
            ),
          ),
        ),
      ),
    );
  }
}
