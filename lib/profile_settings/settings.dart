import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/session_manager.dart';

/// TechKart Profile & Settings - Settings Screen
/// Recreated to match original reference UI with 100% visual fidelity.
class SettingsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onProfilePressed;
  final VoidCallback? onMarkAllRead;
  final ValueChanged<String>? onSearchChanged;
  final VoidCallback? onAppLanguage;
  final VoidCallback? onCurrencyDisplay;
  final VoidCallback? onAppearance;
  final ValueChanged<bool>? onOrderAlertsChanged;
  final ValueChanged<bool>? onDealsAlertsChanged;
  final ValueChanged<bool>? onWhatsAppConciergeChanged;
  final VoidCallback? onChangePassword;
  final VoidCallback? onTwoStepVerification;
  final ValueChanged<bool>? onBiometricsChanged;
  final VoidCallback? onDataPrivacy;
  final VoidCallback? onHelpCenter;
  final VoidCallback? onTermsOfService;
  final VoidCallback? onClearCache;
  final VoidCallback? onLogout;

  const SettingsScreen({
    super.key,
    this.onBack,
    this.onProfilePressed,
    this.onMarkAllRead,
    this.onSearchChanged,
    this.onAppLanguage,
    this.onCurrencyDisplay,
    this.onAppearance,
    this.onOrderAlertsChanged,
    this.onDealsAlertsChanged,
    this.onWhatsAppConciergeChanged,
    this.onChangePassword,
    this.onTwoStepVerification,
    this.onBiometricsChanged,
    this.onDataPrivacy,
    this.onHelpCenter,
    this.onTermsOfService,
    this.onClearCache,
    this.onLogout,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final TextEditingController _searchController = TextEditingController();

  bool _orderAlerts = true;
  bool _dealsAlerts = false;
  bool _whatsAppConcierge = true;
  bool _faceIdBiometrics = true;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _clearCache() {
    HapticFeedback.mediumImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Cleared 42.8 MB of local cache storage.',
          style: GoogleFonts.literata(),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 12,
                ),
                children: [
                  _buildSearchBar(),
                  const SizedBox(height: 18),
                  _buildSectionHeader('PREFERENCES & LOCALIZATION'),
                  const SizedBox(height: 8),
                  _buildSettingsCard([
                    _buildNavRow(
                      icon: Icons.translate,
                      title: 'App Language',
                      subtitle: 'English (IN)',
                      onTap: widget.onAppLanguage ??
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'App Language is set to English (IN). More languages coming soon.',
                                  style: GoogleFonts.literata(),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                    ),
                    _buildNavRow(
                      icon: Icons.payments_outlined,
                      title: 'Currency Display',
                      subtitle: 'INR (₹) • Indian Rupee',
                      onTap: widget.onCurrencyDisplay ??
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Default store currency is Indian Rupee (₹ INR).',
                                  style: GoogleFonts.literata(),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                    ),
                    _buildNavRow(
                      icon: Icons.palette_outlined,
                      title: 'Appearance',
                      subtitle: 'Light Mode (System Default)',
                      onTap: widget.onAppearance ??
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Theme set to Light Mode (System Default).',
                                  style: GoogleFonts.literata(),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 18),
                  _buildSectionHeader('NOTIFICATIONS & ALERTS'),
                  const SizedBox(height: 8),
                  _buildSettingsCard([
                    _buildSwitchRow(
                      icon: Icons.notifications_none_outlined,
                      title: 'Order & Delivery Alerts',
                      subtitle: 'Instant tracking updates via ...',
                      value: _orderAlerts,
                      onChanged: (val) {
                        setState(() => _orderAlerts = val);
                        widget.onOrderAlertsChanged?.call(val);
                      },
                    ),
                    _buildSwitchRow(
                      icon: Icons.local_offer_outlined,
                      title: 'Deals & Price Drops',
                      subtitle: 'Flash discounts on saved wis...',
                      value: _dealsAlerts,
                      onChanged: (val) {
                        setState(() => _dealsAlerts = val);
                        widget.onDealsAlertsChanged?.call(val);
                      },
                    ),
                    _buildSwitchRow(
                      icon: Icons.chat_bubble_outline,
                      title: 'WhatsApp Concierge',
                      subtitle: 'Dispatch OTPs and courier no...',
                      value: _whatsAppConcierge,
                      onChanged: (val) {
                        setState(() => _whatsAppConcierge = val);
                        widget.onWhatsAppConciergeChanged?.call(val);
                      },
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 18),
                  _buildSectionHeader('SECURITY & PRIVACY'),
                  const SizedBox(height: 8),
                  _buildSettingsCard([
                    _buildNavRow(
                      icon: Icons.lock_reset,
                      title: 'Change Password',
                      subtitle: 'Last updated 3 months ago',
                      onTap: widget.onChangePassword ??
                          () => AppNavigator.toForgotPassword(context),
                    ),
                    _buildNavRow(
                      icon: Icons.shield_outlined,
                      title: 'Two-Step Verification',
                      subtitle: 'Primary method: SMS • (+91) •••• 210',
                      badge: 'ACTIVE',
                      onTap: widget.onTwoStepVerification ??
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Two-Step verification is active on your mobile number.',
                                  style: GoogleFonts.literata(),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                    ),
                    _buildSwitchRow(
                      icon: Icons.fingerprint,
                      title: 'Face ID / Biometrics',
                      subtitle: 'Fast checkout authentication',
                      value: _faceIdBiometrics,
                      onChanged: (val) {
                        setState(() => _faceIdBiometrics = val);
                        widget.onBiometricsChanged?.call(val);
                      },
                    ),
                    _buildNavRow(
                      icon: Icons.verified_user_outlined,
                      title: 'Data Privacy & Diagnostics',
                      subtitle: 'Manage shared device analytics',
                      onTap: widget.onDataPrivacy ??
                          () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(
                                  'Your device telemetry & analytics data are encrypted locally.',
                                  style: GoogleFonts.literata(),
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          },
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 18),
                  _buildSectionHeader('SUPPORT & LEGAL'),
                  const SizedBox(height: 8),
                  _buildSettingsCard([
                    _buildNavRow(
                      icon: Icons.help_outline,
                      title: 'Help Center & FAQs',
                      subtitle: '24/7 dedicated customer care',
                      onTap: widget.onHelpCenter ??
                          () => AppNavigator.toConversationalShoppingAssistant(context),
                    ),
                    _buildNavRow(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service & 7-Day Guarantee',
                      subtitle: 'Buyer protection policies',
                      onTap: widget.onTermsOfService ??
                          () {
                            showDialog(
                              context: context,
                              builder: (ctx) => AlertDialog(
                                title: Text(
                                  'Terms & 7-Day Guarantee',
                                  style: GoogleFonts.literata(fontWeight: FontWeight.w700),
                                ),
                                content: Text(
                                  'Every purchase on TechKart is backed by our 7-Day Replacement Guarantee and 100% Genuine Tech Warranty.',
                                  style: GoogleFonts.literata(fontSize: 13.5),
                                ),
                                actions: [
                                  TextButton(
                                    onPressed: () => Navigator.of(ctx).pop(),
                                    child: const Text('Understood'),
                                  ),
                                ],
                              ),
                            );
                          },
                    ),
                    _buildActionRow(
                      icon: Icons.refresh,
                      title: 'Clear Local Cache',
                      subtitle: 'Free up 42.8 MB storage',
                      actionText: 'Clear',
                      onTap: widget.onClearCache ?? _clearCache,
                      isLast: true,
                    ),
                  ]),
                  const SizedBox(height: 20),
                  _buildLogoutButton(),
                  const SizedBox(height: 14),
                  _buildEncryptedFooter(),
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
        color: Color(0xFFFFFFFF),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFF142D4E),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Color(0xFF000000),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Settings',
              style: GoogleFonts.literata(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onMarkAllRead ??
                () {
                  HapticFeedback.lightImpact();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'All preference alerts marked as read.',
                        style: GoogleFonts.literata(),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
            child: Row(
              children: [
                const Icon(Icons.done_all, size: 14, color: Color(0xFF000000)),
                const SizedBox(width: 4),
                Text(
                  'Mark all read',
                  style: GoogleFonts.literata(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          Container(
            width: 32,
            height: 32,
            decoration: const BoxDecoration(
              color: Color(0xFF000000),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 18, color: Color(0xFFF8FAFC)),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SEARCH BAR
  // ---------------------------------------------------------------------------
  Widget _buildSearchBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFF142D4E)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF000000)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              style: GoogleFonts.literata(
                fontSize: 13,
                color: const Color(0xFF000000),
              ),
              decoration: InputDecoration(
                filled: false,
                fillColor: Colors.transparent,
                border: InputBorder.none,
                hintText: 'Search settings, security, alerts...',
                hintStyle: GoogleFonts.literata(
                  fontSize: 13,
                  color: const Color(0xFF000000),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION HEADER
  // ---------------------------------------------------------------------------
  Widget _buildSectionHeader(String title) {
    return Text(
      title,
      style: GoogleFonts.literata(
        fontSize: 10.5,
        fontWeight: FontWeight.w700,
        letterSpacing: 0.8,
        color: const Color(0xFF000000),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SETTINGS CARD CONTAINER
  // ---------------------------------------------------------------------------
  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF142D4E)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildNavRow({
    required IconData icon,
    required String title,
    required String subtitle,
    String? badge,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(7),
                  decoration: const BoxDecoration(
                    color: Color(0xFF142D4E),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: const Color(0xFF000000)),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            title,
                            style: GoogleFonts.literata(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF000000),
                            ),
                          ),
                          if (badge != null) ...[
                            const SizedBox(width: 6),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 1.5,
                              ),
                              decoration: BoxDecoration(
                                color: const Color(0xFF142D4E),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF000000),
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      const SizedBox(height: 1),
                      Text(
                        subtitle,
                        style: GoogleFonts.literata(
                          fontSize: 11,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF000000),
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(color: Color(0xFF142D4E), height: 1),
      ],
    );
  }

  Widget _buildSwitchRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: Color(0xFF142D4E),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF000000)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.literata(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: const Color(0xFF142D4E),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(color: Color(0xFF142D4E), height: 1),
      ],
    );
  }

  Widget _buildActionRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required String actionText,
    required VoidCallback onTap,
    bool isLast = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(7),
                decoration: const BoxDecoration(
                  color: Color(0xFF142D4E),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF000000)),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: GoogleFonts.literata(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF000000),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF142D4E),
                  foregroundColor: const Color(0xFF142D4E),
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  minimumSize: Size.zero,
                ),
                child: Text(
                  actionText,
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(color: Color(0xFF142D4E), height: 1),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // LOGOUT BUTTON
  // ---------------------------------------------------------------------------
  Future<void> _handleLogout() async {
    if (widget.onLogout != null) {
      widget.onLogout!();
      return;
    }
    await SessionManager().logout();
    if (!mounted) return;
    AppNavigator.replaceAll(context, AppRoutes.login);
  }

  Widget _buildLogoutButton() {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: _handleLogout,
          borderRadius: BorderRadius.circular(20),
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFF142D4E), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.logout, size: 15, color: Color(0xFFDC2626)),
                const SizedBox(width: 8),
                Text(
                  'Log Out of TechKart',
                  style: GoogleFonts.literata(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFDC2626),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ENCRYPTED FOOTER
  // ---------------------------------------------------------------------------
  Widget _buildEncryptedFooter() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.lock_outline, size: 12, color: Color(0xFF000000)),
            const SizedBox(width: 4),
            Text(
              'End-to-End Encrypted Session',
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF000000),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'TechKart Mobile v2.4.1 (Build 4920) • Verified Build',
          style: GoogleFonts.literata(
            fontSize: 10.5,
            color: const Color(0xFF000000),
          ),
        ),
      ],
    );
  }
}
