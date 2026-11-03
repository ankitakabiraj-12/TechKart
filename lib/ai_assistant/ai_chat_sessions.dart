import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/bottom_navbar.dart';

/// TechKart AI Chat Sessions Screen
///
/// 100% visual fidelity reproduction of the Chat Sessions reference:
/// - Light airy background (#F5FAFF)
/// - Top Bar: Back button, "Chat Sessions" in bold Domine serif, filter sliders icon, cart with badge 2.
/// - Search Bar: Rounded input (#EAF5FF) with search icon and placeholder "Search conversations...".
/// - Filter Category Pills:
///   - "∞ All Sessions" (Active dark navy #00344B pill)
///   - "Recommendations" (Pill)
///   - "Spec Checks" (Pill)
/// - Grouped Sessions:
///   1. RECENT (2 sessions):
///      - Session 1: Watch icon (Beige circle), "Titanium Smartwatch..." (Today, 10:24 AM), "2 products recommended • Chronos ...", "✨ AI Concierge Summary ready", 3-dots menu & chevron >.
///      - Session 2: Phone icon (Sky blue circle), "Foldable Phone vs Compa..." (Yesterday), "Spec comparison • Aura Fold Pro", "🗂 Comparison table exported", 3-dots menu & chevron >.
///   2. LAST 7 DAYS (2 sessions):
///      - Session 3: Keyboard icon, "Mechanical Wireless Keyboa..." (Oct 24), "Ergonomics & Tactile switches inquiry", "🎛 Filter: Hot-swappable", 3-dots menu & chevron >.
///      - Session 4: Headphones icon, "ANC Noise Cancelling Studio..." (Oct 18), "AeroPulse ANC query • In Stock check", "🚚 Fast Delivery Verified", 3-dots menu & chevron >.
///   3. PREVIOUS MONTH (2 sessions):
///      - Session 5: Bolt/charge icon, "MagSafe 3-in-1 Charging Sta..." (Oct 12), "Qi2 standard verification", "✔ Compatibility Confirmed", 3-dots menu & chevron >.
///      - Session 6: Multilingual translate icon, "বাংলা পরামর্শ — বাজেট গে..." (Sep 28), "GPU specs & thermal benchmark", "💬 Multilingual Engine (Bangla)", 3-dots menu & chevron >.
/// - Personalized Hardware Memory Card:
///   - Microchip icon, "Personalized Hardware Memory", "Preferences saved across your sessions", "Manage" pill button.
/// - Floating Action Button: "+ New Chat" (Midnight navy capsule).
/// - Bottom Navigation Bar (AI Search active).
class AiChatSessionsScreen extends StatefulWidget {
  const AiChatSessionsScreen({super.key});

  @override
  State<AiChatSessionsScreen> createState() => _AiChatSessionsScreenState();
}

class _AiChatSessionsScreenState extends State<AiChatSessionsScreen> {
  int _selectedFilterIndex = 0;
  final List<String> _filters = [
    'All Sessions',
    'Recommendations',
    'Spec Checks',
  ];

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;
    final double fabBottom = (bottomPadding > 0 ? bottomPadding + 6.0 : 14.0) + 64.0 + 16.0;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFF5FAFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
      body: SafeArea(
        top: false,
        bottom: false,
        child: Stack(
          children: [
            Column(
              children: [
                SizedBox(height: topPadding > 0 ? topPadding + 6 : 24),

                // -----------------------------------------------------------
                // TOP BAR
                // -----------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).pop(),
                        icon: const Icon(
                          Icons.arrow_back_rounded,
                          color: Color(0xFF00344B),
                          size: 22,
                        ),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 36, minHeight: 36),
                      ),
                      const SizedBox(width: 8),

                      Expanded(
                        child: Text(
                          'Chat Sessions',
                          style: GoogleFonts.domine(
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00344B),
                          ),
                        ),
                      ),

                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.tune_rounded,
                          size: 20,
                          color: Color(0xFF2D3748),
                        ),
                        padding: EdgeInsets.zero,
                        constraints:
                            const BoxConstraints(minWidth: 34, minHeight: 34),
                      ),
                      const SizedBox(width: 6),

                      // Cart with badge 2
                      Stack(
                        children: [
                          IconButton(
                            onPressed: () => AppNavigator.toCart(context),
                            icon: const Icon(
                              Icons.shopping_bag_outlined,
                              size: 22,
                              color: Color(0xFF2D3748),
                            ),
                            padding: EdgeInsets.zero,
                            constraints: const BoxConstraints(
                                minWidth: 34, minHeight: 34),
                          ),
                          Positioned(
                            top: 4,
                            right: 4,
                            child: Container(
                              width: 15,
                              height: 15,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE53E3E),
                                shape: BoxShape.circle,
                              ),
                              child: Center(
                                child: Text(
                                  '2',
                                  style: GoogleFonts.literata(
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 10),

                // Search field
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Container(
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFFEAF5FF),
                      borderRadius: BorderRadius.circular(22),
                    ),
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.search_rounded,
                          size: 18,
                          color: Color(0xFF718096),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'Search conversations...',
                            style: GoogleFonts.literata(
                              fontSize: 13,
                              color: const Color(0xFFA0AEC0),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 12),

                // Filter Pills
                SizedBox(
                  height: 34,
                  child: ListView.builder(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _filters.length,
                    itemBuilder: (context, index) {
                      final isSelected = _selectedFilterIndex == index;
                      return Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: GestureDetector(
                          onTap: () {
                            HapticFeedback.selectionClick();
                            setState(() {
                              _selectedFilterIndex = index;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF00344B)
                                  : const Color(0xFFEAF5FF),
                              borderRadius: BorderRadius.circular(18),
                            ),
                            child: Row(
                              children: [
                                if (index == 0) ...[
                                  const Icon(Icons.all_inclusive_rounded,
                                      size: 14, color: Colors.white),
                                  const SizedBox(width: 5),
                                ],
                                Text(
                                  _filters[index],
                                  style: GoogleFonts.literata(
                                    fontSize: 12,
                                    fontWeight: isSelected
                                        ? FontWeight.w600
                                        : FontWeight.w500,
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF00344B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 14),

                // -----------------------------------------------------------
                // SESSIONS LIST
                // -----------------------------------------------------------
                Expanded(
                  child: SingleChildScrollView(
                    physics: const BouncingScrollPhysics(),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // SECTION: RECENT
                          _buildGroupHeader('RECENT', '2 sessions'),
                          _buildSessionCard(
                            icon: Icons.watch_outlined,
                            iconBg: const Color(0xFFF3EEE4),
                            iconColor: const Color(0xFF8B6B2B),
                            title: 'Titanium Smartwatch...',
                            time: 'Today, 10:24 AM',
                            subtitle:
                                '2 products recommended • Chronos ...',
                            footerIcon: Icons.auto_awesome_rounded,
                            footerText: 'AI Concierge Summary ready',
                          ),
                          const SizedBox(height: 10),
                          _buildSessionCard(
                            icon: Icons.smartphone_outlined,
                            iconBg: const Color(0xFFD9ECFE),
                            iconColor: const Color(0xFF00344B),
                            title: 'Foldable Phone vs Compa...',
                            time: 'Yesterday',
                            subtitle: 'Spec comparison • Aura Fold Pro',
                            footerIcon: Icons.table_chart_outlined,
                            footerText: 'Comparison table exported',
                          ),

                          const SizedBox(height: 22),

                          // SECTION: LAST 7 DAYS
                          _buildGroupHeader('LAST 7 DAYS', '2 sessions'),
                          _buildSessionCard(
                            icon: Icons.keyboard_outlined,
                            iconBg: const Color(0xFFEAF5FF),
                            iconColor: const Color(0xFF00344B),
                            title: 'Mechanical Wireless Keyboa...',
                            time: 'Oct 24',
                            subtitle:
                                'Ergonomics & Tactile switches inquiry',
                            footerIcon: Icons.tune_rounded,
                            footerText: 'Filter: Hot-swappable',
                          ),
                          const SizedBox(height: 10),
                          _buildSessionCard(
                            icon: Icons.headphones_outlined,
                            iconBg: const Color(0xFFD9ECFE),
                            iconColor: const Color(0xFF00344B),
                            title: 'ANC Noise Cancelling Studio...',
                            time: 'Oct 18',
                            subtitle:
                                'AeroPulse ANC query • In Stock check',
                            footerIcon: Icons.local_shipping_outlined,
                            footerText: 'Fast Delivery Verified',
                          ),

                          const SizedBox(height: 22),

                          // SECTION: PREVIOUS MONTH
                          _buildGroupHeader('PREVIOUS MONTH', '2 sessions'),
                          _buildSessionCard(
                            icon: Icons.bolt_rounded,
                            iconBg: const Color(0xFFF3EEE4),
                            iconColor: const Color(0xFF8B6B2B),
                            title: 'MagSafe 3-in-1 Charging Sta...',
                            time: 'Oct 12',
                            subtitle: 'Qi2 standard verification',
                            footerIcon: Icons.check_circle_outline_rounded,
                            footerText: 'Compatibility Confirmed',
                          ),
                          const SizedBox(height: 10),
                          _buildSessionCard(
                            icon: Icons.translate_rounded,
                            iconBg: const Color(0xFFD9ECFE),
                            iconColor: const Color(0xFF00344B),
                            title: 'বাংলা পরামর্শ — বাজেট গে...',
                            time: 'Sep 28',
                            subtitle: 'GPU specs & thermal benchmark',
                            footerIcon: Icons.chat_bubble_outline_rounded,
                            footerText: 'Multilingual Engine (Bangla)',
                          ),

                          const SizedBox(height: 22),

                          // Personalized Hardware Memory Card
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: const Color(0xFFEAF5FF),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Row(
                              children: [
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Colors.white,
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Icon(
                                      Icons.memory_rounded,
                                      size: 18,
                                      color: Color(0xFF00344B),
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Personalized Hardware Memory',
                                        style: GoogleFonts.domine(
                                          fontSize: 12.5,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF00344B),
                                        ),
                                      ),
                                      const SizedBox(height: 2),
                                      Text(
                                        'Preferences saved across your sessions',
                                        style: GoogleFonts.literata(
                                          fontSize: 11,
                                          color: const Color(0xFF718096),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFD9ECFE),
                                    borderRadius: BorderRadius.circular(12),
                                  ),
                                  child: Text(
                                    'Manage',
                                    style: GoogleFonts.literata(
                                      fontSize: 11,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF00344B),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          const SizedBox(height: 100),
                        ],
                      ),
                    ),
                  ),
                ),

                // -----------------------------------------------------------
                // BOTTOM NAVIGATION BAR
                // -----------------------------------------------------------
                TechKartBottomNavBar(
                  currentIndex: 2, // AI Search active
                  onTabSelected: (index) {
                    if (index == 0) {
                      AppNavigator.toHome(context);
                    } else if (index == 1) {
                      AppNavigator.toCategories(context);
                    } else if (index == 3) {
                      AppNavigator.toCart(context);
                    } else if (index == 4) {
                      AppNavigator.toCustomerProfileHub(context);
                    }
                  },
                ),
              ],
            ),

            // Floating "+ New Chat" Button
            Positioned(
              bottom: fabBottom,
              right: 18,
              child: GestureDetector(
                onTap: () {
                  HapticFeedback.lightImpact();
                  AppNavigator.toConversationalShoppingAssistant(context);
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF00344B),
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF00344B).withValues(alpha: 0.25),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Icon(Icons.add_comment_rounded,
                          size: 16, color: Colors.white),
                      const SizedBox(width: 8),
                      Text(
                        'New Chat',
                        style: GoogleFonts.literata(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupHeader(String title, String count) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: GoogleFonts.literata(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.8,
              color: const Color(0xFF718096),
            ),
          ),
          Text(
            count,
            style: GoogleFonts.literata(
              fontSize: 11,
              color: const Color(0xFFA0AEC0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionCard({
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String time,
    required String subtitle,
    required IconData footerIcon,
    required String footerText,
  }) {
    return GestureDetector(
      onTap: () {
        HapticFeedback.lightImpact();
        AppNavigator.toConversationalShoppingAssistant(context);
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF00344B).withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconBg,
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Icon(icon, size: 18, color: iconColor),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Flexible(
                            child: Text(
                              title,
                              style: GoogleFonts.domine(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF00344B),
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            time,
                            style: GoogleFonts.literata(
                              fontSize: 10.5,
                              color: const Color(0xFFA0AEC0),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: GoogleFonts.literata(
                          fontSize: 11,
                          color: const Color(0xFF718096),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 4),
                const Icon(Icons.more_vert_rounded,
                    size: 16, color: Color(0xFF718096)),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                Icon(footerIcon, size: 13, color: const Color(0xFF718096)),
                const SizedBox(width: 6),
                Expanded(
                  child: Text(
                    footerText,
                    style: GoogleFonts.literata(
                      fontSize: 10.5,
                      color: const Color(0xFF718096),
                    ),
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    size: 15, color: Color(0xFF718096)),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
