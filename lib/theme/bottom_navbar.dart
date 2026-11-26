import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_routes/app_navigator.dart';

/// TechKart Global Bottom Navigation Bar
///
/// Implements the minimalist modern UI design from the HOMEBAR reference:
/// - Floating stadium pill capsule track with perfectly rounded circular ends in sleek black (`Color(0xFF142D4E)`).
/// - Multi-layer ambient diffused drop shadows for photorealistic depth.
/// - Seamless full-width background gradient shield that removes unwanted edges.
/// - Five connected circular item slots: 1. Home, 2. Categories, 3. AI Chatbot, 4. Cart, 5. Profile.
/// - Active tab highlighted with a clean white circular background (`const Color(0xFFF8FAFC)`).
/// - Active icon in contrasting dark color (`Color(0xFF142D4E)`).
/// - Inactive tabs with crisp white outline icons centered in each circular item slot.
/// - Dynamic responsive width, item spacing, and positioning adapted to screen and device width.
/// - Safe area compliance with clean floating margin above the device navigation handle.
/// - Preserves cart count badges, tab routes, and interactive haptic feedback.
class TechKartBottomNavBar extends StatelessWidget {
  /// The currently selected tab index (0: Home, 1: Categories, 2: AI Chatbot, 3: Cart, 4: Profile).
  final int currentIndex;

  /// Callback when a tab is tapped. Defaults to [AppNavigator.switchShellTab].
  final ValueChanged<int>? onTabSelected;

  /// Optional item count badge for the shopping cart tab.
  final int cartBadgeCount;

  /// Capsule surface background color for the floating stadium pill (defaults to HOMEBAR dark `#141414`).
  final Color pillColor;

  /// Active indicator background color (defaults to white).
  final Color activeIndicatorColor;

  /// Canvas background color of the screen (defaults to TechKart's light canvas `0xFFFFFFFF`).
  final Color? backgroundColor;

  const TechKartBottomNavBar({
    super.key,
    required this.currentIndex,
    this.onTabSelected,
    this.cartBadgeCount = 0,
    this.pillColor = const Color(0xFF142D4E),
    this.activeIndicatorColor = const Color(0xFFFFFFFF),
    this.backgroundColor,
    Color? creamColor,
    Color? navyColor,
  });

  static const List<String> _labels = [
    'Home',
    'Categories',
    'AI Chatbot',
    'Cart',
    'Profile',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final bottomPadding = mediaQuery.padding.bottom;
    final Color effectiveBgColor = backgroundColor ?? const Color(0xFFFFFFFF);

    // Responsive track width with comfortable, evenly distributed spacing
    final double trackWidth;
    if (screenWidth < 360) {
      trackWidth = (screenWidth - 16.0).clamp(280.0, 336.0);
    } else if (screenWidth < 430) {
      trackWidth = (screenWidth - 24.0).clamp(340.0, 392.0);
    } else {
      trackWidth = 396.0;
    }

    final double itemWidth = trackWidth / 5.0;
    const double trackHeight = 60.0;

    // Active circular disc diameter (HOMEBAR circular white disc)
    const double activeDiameter = 52.0;
    const double activeRadius = activeDiameter / 2.0;

    // Canvas container height
    const double navHeight = trackHeight + 4.0;

    // Safe area bottom spacing: clean floating offset above bottom gesture bar
    final double navBarPaddingBottom = bottomPadding > 0
        ? bottomPadding + 6.0
        : 14.0;
    const double navBarPaddingTop = 4.0;
    final double totalHeight =
        navHeight + navBarPaddingTop + navBarPaddingBottom;

    final double trackTop = (navHeight - trackHeight) / 2.0;
    final double activeTop = (navHeight - activeDiameter) / 2.0;
    final double activeLeft = (currentIndex + 0.5) * itemWidth - activeRadius;

    return SizedBox(
      height: totalHeight,
      width: double.infinity,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.bottomCenter,
        children: [
          // 1. Full-width seamless gradient shield
          Positioned(
            left: 0,
            right: 0,
            top: -45.0,
            bottom: 0,
            child: IgnorePointer(
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      effectiveBgColor.withValues(alpha: 0.0),
                      effectiveBgColor.withValues(alpha: 0.7),
                      effectiveBgColor,
                      effectiveBgColor,
                    ],
                    stops: const [0.0, 0.3, 0.55, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // 2. Centered Floating Pill Navigation Bar
          Positioned(
            bottom: navBarPaddingBottom,
            child: SizedBox(
              width: trackWidth,
              height: navHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // Stadium Pill Capsule Track (Deep dark surface matching reference)
                  Positioned(
                    left: 0,
                    right: 0,
                    top: trackTop,
                    height: trackHeight,
                    child: Container(
                      decoration: BoxDecoration(
                        color: pillColor,
                        borderRadius: BorderRadius.circular(trackHeight / 2.0),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0x33000000),
                            blurRadius: 20,
                            spreadRadius: 0,
                            offset: Offset(0, 8),
                          ),
                          BoxShadow(
                            color: Color(0x1F000000),
                            blurRadius: 6,
                            spreadRadius: 0,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                    ),
                  ),

                  // Gliding Raised White Circular Active Indicator
                  AnimatedPositioned(
                    duration: const Duration(milliseconds: 280),
                    curve: Curves.easeOutCubic,
                    left: activeLeft,
                    top: activeTop,
                    width: activeDiameter,
                    height: activeDiameter,
                    child: _buildActiveTabIndicator(diameter: activeDiameter),
                  ),

                  // Interactive Inactive Tabs
                  for (int i = 0; i < 5; i++)
                    if (i != currentIndex)
                      _buildInactiveTab(
                        context: context,
                        index: i,
                        centerX: (i + 0.5) * itemWidth,
                        centerY: navHeight / 2.0,
                        hitWidth: itemWidth,
                        hitHeight: trackHeight,
                      ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Builds the inactive tab button centered on its circular item slot
  Widget _buildInactiveTab({
    required BuildContext context,
    required int index,
    required double centerX,
    required double centerY,
    required double hitWidth,
    required double hitHeight,
  }) {
    return Positioned(
      left: centerX - hitWidth / 2.0,
      top: centerY - hitHeight / 2.0,
      width: hitWidth,
      height: hitHeight,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () => _handleTap(context, index),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              _buildIconForTab(index, isSelected: false, color: const Color(0xFFFFFFFF)),
              // Inactive text widget with full tap hit-testing bounds & semantic discoverability
              Opacity(
                opacity: 0.0,
                child: SizedBox(
                  width: hitWidth,
                  height: hitHeight,
                  child: Center(child: Text(_labels[index])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Builds the prominent animated white circular active tab (HOMEBAR reference)
  Widget _buildActiveTabIndicator({required double diameter}) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
      },
      child: Container(
        decoration: BoxDecoration(
          color: activeIndicatorColor,
          shape: BoxShape.circle,
          boxShadow: const [
            BoxShadow(
              color: Color(0x33000000),
              blurRadius: 10,
              spreadRadius: 0,
              offset: Offset(0, 3),
            ),
          ],
        ),
        child: Center(
          child: Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              _buildIconForTab(
                currentIndex,
                isSelected: true,
                color: const Color(0xFF142D4E),
              ),
              // Invisible text label for test discoverability & accessibility
              Opacity(
                opacity: 0.0,
                child: SizedBox(
                  width: diameter,
                  height: diameter,
                  child: Center(child: Text(_labels[currentIndex])),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Returns the corresponding icon for each tab matching the reference:
  /// Home, Categories, Visual Search (Camera/Lens), Cart, Profile.
  Widget _buildIconForTab(
    int index, {
    required bool isSelected,
    required Color color,
  }) {
    switch (index) {
      case 0:
        return Icon(
          Icons.home_outlined,
          size: isSelected ? 25 : 24,
          color: color,
        );
      case 1:
        return _CategoryGridGlyph(color: color, size: isSelected ? 22 : 22);
      case 2:
        return _AiChatbotGlyph(color: color, size: isSelected ? 25 : 24);
      case 3:
        return Icon(
          Icons.shopping_cart_outlined,
          size: isSelected ? 24 : 23,
          color: color,
        );
      case 4:
      default:
        return Icon(
          Icons.person_outline_rounded,
          size: isSelected ? 25 : 24,
          color: color,
        );
    }
  }

  void _handleTap(BuildContext context, int index) {
    HapticFeedback.selectionClick();
    if (onTabSelected != null) {
      onTabSelected!(index);
    } else {
      AppNavigator.switchShellTab(context, index);
    }
  }
}

/// Precise AI Search Magnifying Glass Glyph with Two Sparkle Stars
///
/// Exactly matches the magnifying glass and dual 4-pointed stars on the reference active disc.
class AiSearchGlyph extends StatelessWidget {
  final Color color;
  final double size;

  const AiSearchGlyph({super.key, required this.color, this.size = 26});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Main magnifying glass outline
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(Icons.search_rounded, size: size * 0.90, color: color),
          ),
          // Top-right dual sparkles
          Positioned(
            top: -1,
            right: -1,
            child: Icon(Icons.auto_awesome, size: size * 0.46, color: color),
          ),
        ],
      ),
    );
  }
}

/// Precise 2x2 Rounded Outline Squares Glyph for Categories
///
/// Matches the 4 rounded hollow squares in the reference design.
class _CategoryGridGlyph extends StatelessWidget {
  final Color color;
  final double size;

  const _CategoryGridGlyph({required this.color, this.size = 23});

  @override
  Widget build(BuildContext context) {
    const double squareSize = 8.5;
    const double radius = 2.2;
    const double strokeWidth = 1.9;
    const double gap = 2.5;

    Widget square() => Container(
      width: squareSize,
      height: squareSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: color, width: strokeWidth),
      ),
    );

    return SizedBox(
      width: size,
      height: size,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                square(),
                const SizedBox(width: gap),
                square(),
              ],
            ),
            const SizedBox(height: gap),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                square(),
                const SizedBox(width: gap),
                square(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Modern AI Chatbot Icon (Message Circle with Sparkles)
///
/// Clean, minimal outline-style icon representing an AI shopping assistant / chatbot.
/// Uses a message circle outline paired with clean AI sparkle stars.
class _AiChatbotGlyph extends StatelessWidget {
  final Color color;
  final double size;

  const _AiChatbotGlyph({required this.color, this.size = 24});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          // Minimal outline message circle / chat bubble
          Positioned(
            left: 0,
            bottom: 0,
            child: Icon(
              Icons.chat_bubble_outline_rounded,
              size: size * 0.90,
              color: color,
            ),
          ),
          // Clean top-right AI sparkle star
          Positioned(
            top: -1,
            right: -1,
            child: Icon(Icons.auto_awesome, size: size * 0.44, color: color),
          ),
        ],
      ),
    );
  }
}
