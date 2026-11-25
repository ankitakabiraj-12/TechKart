import 'dart:ui';
import 'package:flutter/material.dart';

/// Reusable glassmorphic container widget for top header buttons, search bars, chips, and controls.
/// Provides a subtle blur, soft translucent white surface, fine border, and soft shadow.
class HeaderGlassContainer extends StatelessWidget {
  final Widget child;
  final double? width;
  final double? height;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final ShapeBorder? customShape;
  final Color backgroundColor;
  final Color borderColor;
  final double blurSigma;
  final List<BoxShadow>? shadows;
  final VoidCallback? onTap;

  const HeaderGlassContainer({
    super.key,
    required this.child,
    this.width,
    this.height,
    this.padding,
    this.margin,
    this.borderRadius = 16.0,
    this.customShape,
    this.backgroundColor = const Color(0xB8F2EFE9), // ~72% translucent white
    this.borderColor = const Color(0x66D6C2A5),     // ~40% translucent white border
    this.blurSigma = 10.0,
    this.shadows,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: customShape == null ? BorderRadius.circular(borderRadius) : null,
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: shadows ??
            const [
              BoxShadow(
                color: Color(0x14000000),
                blurRadius: 10,
                offset: Offset(0, 3),
              ),
            ],
      ),
      child: child,
    );

    content = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: content,
      ),
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}

/// Circular variant of HeaderGlassContainer for circular icons/buttons (e.g. back buttons, avatars, action icons)
class HeaderGlassCircle extends StatelessWidget {
  final Widget child;
  final double size;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final Color backgroundColor;
  final Color borderColor;
  final double blurSigma;
  final VoidCallback? onTap;

  const HeaderGlassCircle({
    super.key,
    required this.child,
    this.size = 36.0,
    this.padding,
    this.margin,
    this.backgroundColor = const Color(0xB8F2EFE9),
    this.borderColor = const Color(0x66D6C2A5),
    this.blurSigma = 10.0,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    Widget content = Container(
      width: size,
      height: size,
      padding: padding,
      decoration: BoxDecoration(
        color: backgroundColor,
        shape: BoxShape.circle,
        border: Border.all(color: borderColor, width: 1.0),
        boxShadow: const [
          BoxShadow(
            color: Color(0x14000000),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      alignment: Alignment.center,
      child: child,
    );

    content = ClipOval(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: blurSigma, sigmaY: blurSigma),
        child: content,
      ),
    );

    if (margin != null) {
      content = Padding(padding: margin!, child: content);
    }

    if (onTap != null) {
      content = GestureDetector(
        onTap: onTap,
        behavior: HitTestBehavior.opaque,
        child: content,
      );
    }

    return content;
  }
}
