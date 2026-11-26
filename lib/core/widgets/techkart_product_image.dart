import 'package:flutter/material.dart';
import '../network/api_config.dart';

/// Production-ready Flipkart-style Product Image component for TechKart.
/// Handles asset paths, remote network URLs, smooth loading states, and
/// a clean neutral fallback placeholder without broken boxes or unrelated pictures.
class TechKartProductImage extends StatelessWidget {
  final String? imageUrl;
  final double? width;
  final double? height;
  final BoxFit fit;
  final BorderRadius? borderRadius;
  final String? categoryName;
  final String? productTitle;
  final IconData? placeholderIcon;
  final String? heroTag;

  const TechKartProductImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.fit = BoxFit.cover,
    this.borderRadius,
    this.categoryName,
    this.productTitle,
    this.placeholderIcon,
    this.heroTag,
  });

  IconData _resolveIcon() {
    if (placeholderIcon != null) return placeholderIcon!;
    final text = '${categoryName ?? ''} ${productTitle ?? ''}'.toLowerCase();
    if (text.contains('phone') || text.contains('mobile') || text.contains('iphone') || text.contains('pixel')) {
      return Icons.phone_android_rounded;
    }
    if (text.contains('laptop') || text.contains('macbook') || text.contains('notebook') || text.contains('chromebook')) {
      return Icons.laptop_mac_rounded;
    }
    if (text.contains('watch') || text.contains('wearable') || text.contains('band')) {
      return Icons.watch_rounded;
    }
    if (text.contains('audio') || text.contains('headphone') || text.contains('earbud') || text.contains('sound')) {
      return Icons.headphones_rounded;
    }
    if (text.contains('camera') || text.contains('photo') || text.contains('lens')) {
      return Icons.camera_alt_rounded;
    }
    if (text.contains('game') || text.contains('gaming') || text.contains('playstation') || text.contains('xbox')) {
      return Icons.sports_esports_rounded;
    }
    if (text.contains('tv') || text.contains('display') || text.contains('monitor')) {
      return Icons.tv_rounded;
    }
    if (text.contains('charge') || text.contains('power') || text.contains('battery')) {
      return Icons.battery_charging_full_rounded;
    }
    if (text.contains('cable') || text.contains('adapter') || text.contains('hub')) {
      return Icons.cable_rounded;
    }
    if (text.contains('appliance') || text.contains('kitchen') || text.contains('refrigerator') || text.contains('cooling')) {
      return Icons.kitchen_rounded;
    }
    return Icons.devices_other_rounded;
  }

  Widget _buildPlaceholder() {
    final icon = _resolveIcon();
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFF1F5F9),
        borderRadius: borderRadius ?? BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFFCBD5E1).withValues(alpha: 0.6),
          width: 0.8,
        ),
      ),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: (width != null && width! < 60) ? 22 : 32,
              color: const Color(0xFF000000).withValues(alpha: 0.65),
            ),
            if (height != null && height! >= 90 && productTitle != null && productTitle!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: Text(
                  productTitle!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF64748B),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final raw = imageUrl?.trim() ?? '';
    if (raw.isEmpty || raw == 'null' || raw == 'undefined') {
      return _buildPlaceholder();
    }

    Widget imageWidget;

    if (raw.startsWith('asset/') || raw.startsWith('assets/')) {
      // Local asset image
      imageWidget = Image.asset(
        raw,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: 600,
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    } else {
      // Remote or API network image
      final fullUrl = (raw.startsWith('http://') || raw.startsWith('https://'))
          ? raw
          : ApiConfig.resolveImageUrl(raw);

      imageWidget = Image.network(
        fullUrl,
        width: width,
        height: height,
        fit: fit,
        cacheWidth: 600,
        frameBuilder: (context, child, frame, wasSynchronouslyLoaded) {
          if (wasSynchronouslyLoaded || frame != null) {
            return child;
          }
          return Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: const Color(0xFFE2E8F0).withValues(alpha: 0.5),
              borderRadius: borderRadius ?? BorderRadius.circular(8),
            ),
            child: const Center(
              child: SizedBox(
                width: 18,
                height: 18,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF142D4E)),
                ),
              ),
            ),
          );
        },
        errorBuilder: (context, error, stackTrace) => _buildPlaceholder(),
      );
    }

    if (borderRadius != null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius!,
        child: imageWidget,
      );
    }

    if (heroTag != null && heroTag!.isNotEmpty) {
      return Hero(
        tag: heroTag!,
        child: imageWidget,
      );
    }

    return imageWidget;
  }
}
