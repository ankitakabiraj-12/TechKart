import 'package:flutter/material.dart';
import '../app_routes/app_navigator.dart';
import '../core/session_manager.dart';

/// Reusable User Profile Avatar Widget that automatically reflects
/// the user's gender-based avatar ('assets/female_avatar.png' or 'assets/male_avatar.png'),
/// guests use 'assets/avatar.png', and updates reactively whenever the profile or gender changes.
class ProfileAvatar extends StatelessWidget {
  final double size;
  final VoidCallback? onTap;
  final Color? borderColor;
  final double borderWidth;
  final Color? fallbackBgColor;
  final Widget? badge;

  const ProfileAvatar({
    super.key,
    this.size = 30.0,
    this.onTap,
    this.borderColor,
    this.borderWidth = 0.0,
    this.fallbackBgColor,
    this.badge,
  });

  @override
  Widget build(BuildContext context) {
    final sessionManager = SessionManager();

    return ValueListenableBuilder<Map<String, dynamic>?>(
      valueListenable: sessionManager.currentUserNotifier,
      builder: (context, user, child) {
        final assetPath = sessionManager.avatarAssetPath;
        final isNetwork = assetPath.startsWith('http://') || assetPath.startsWith('https://');

        Widget imageWidget;
        if (isNetwork) {
          imageWidget = Image.network(
            assetPath,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) => _buildFallbackIcon(),
          );
        } else {
          imageWidget = Image.asset(
            assetPath,
            width: size,
            height: size,
            fit: BoxFit.cover,
            errorBuilder: (context, error, stackTrace) {
              // Try fallback to asset/ path if assets/ fails
              final fallbackPath = assetPath.startsWith('assets/')
                  ? assetPath.replaceFirst('assets/', 'asset/')
                  : (assetPath.endsWith('.png') ? assetPath.replaceAll('.png', '.jpg') : 'asset/avatar.jpg');
              return Image.asset(
                fallbackPath,
                width: size,
                height: size,
                fit: BoxFit.cover,
                errorBuilder: (ctx, err, st) => _buildFallbackIcon(),
              );
            },
          );
        }

        Widget avatar = Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: borderWidth > 0 && borderColor != null
                ? Border.all(color: borderColor!, width: borderWidth)
                : null,
            color: fallbackBgColor ?? const Color(0xFF0D1B2A),
          ),
          clipBehavior: Clip.antiAlias,
          child: imageWidget,
        );

        if (badge != null) {
          avatar = Stack(
            clipBehavior: Clip.none,
            children: [
              avatar,
              badge!,
            ],
          );
        }

        final effectiveOnTap = onTap ?? () => AppNavigator.toCustomerProfileHub(context);

        return GestureDetector(
          onTap: effectiveOnTap,
          behavior: HitTestBehavior.opaque,
          child: avatar,
        );
      },
    );
  }

  Widget _buildFallbackIcon() {
    return Container(
      width: size,
      height: size,
      color: fallbackBgColor ?? const Color(0xFF0D1B2A),
      child: Center(
        child: Icon(
          Icons.person,
          size: size * 0.55,
          color: const Color(0xFFF5EBDD),
        ),
      ),
    );
  }
}
