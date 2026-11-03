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
      backgroundColor: const Color(0xFFF6FAFC),
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
                      onTap: widget.onAppLanguage ?? () {},
                    ),
                    _buildNavRow(
                      icon: Icons.payments_outlined,
                      title: 'Currency Display',
                      subtitle: 'INR (₹) • Indian Rupee',
                      onTap: widget.onCurrencyDisplay ?? () {},
                    ),
                    _buildNavRow(
                      icon: Icons.palette_outlined,
                      title: 'Appearance',
                      subtitle: 'Light Mode (System Default)',
                      onTap: widget.onAppearance ?? () {},
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
                      onTap: widget.onChangePassword ?? () {},
                    ),
                    _buildNavRow(
                      icon: Icons.shield_outlined,
                      title: 'Two-Step Verification',
                      subtitle: 'Primary method: SMS • (+91) •••• 210',
                      badge: 'ACTIVE',
                      onTap: widget.onTwoStepVerification ?? () {},
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
                      onTap: widget.onDataPrivacy ?? () {},
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
                      onTap: widget.onHelpCenter ?? () {},
                    ),
                    _buildNavRow(
                      icon: Icons.description_outlined,
                      title: 'Terms of Service & 7-Day Guarantee',
                      subtitle: 'Buyer protection policies',
                      onTap: widget.onTermsOfService ?? () {},
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
        color: Color(0xFFF6FAFC),
        border: Border(bottom: BorderSide(color: Color(0xFFE2EDF3), width: 1)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF5FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Color(0xFF00344B),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Settings',
              style: GoogleFonts.domine(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          GestureDetector(
            onTap: widget.onMarkAllRead ?? () {},
            child: Row(
              children: [
                const Icon(Icons.done_all, size: 14, color: Color(0xFF00344B)),
                const SizedBox(width: 4),
                Text(
                  'Mark all read',
                  style: GoogleFonts.literata(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF00344B),
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
              color: Color(0xFF64748B),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, size: 18, color: Colors.white),
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
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2EDF3)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search, size: 20, color: Color(0xFF64748B)),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              controller: _searchController,
              onChanged: widget.onSearchChanged,
              style: GoogleFonts.literata(
                fontSize: 13,
                color: const Color(0xFF0F172A),
              ),
              decoration: InputDecoration(
                border: InputBorder.none,
                hintText: 'Search settings, security, alerts...',
                hintStyle: GoogleFonts.literata(
                  fontSize: 13,
                  color: const Color(0xFF94A3B8),
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
        color: const Color(0xFF64748B),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SETTINGS CARD CONTAINER
  // ---------------------------------------------------------------------------
  Widget _buildSettingsCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EDF3)),
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
                    color: Color(0xFFEAF5FF),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: const Color(0xFF00344B)),
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
                              color: const Color(0xFF0F172A),
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
                                color: const Color(0xFFDCEEFB),
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: Text(
                                badge,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: Color(0xFF00344B),
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
                          color: const Color(0xFF64748B),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF94A3B8),
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(color: Color(0xFFE2EDF3), height: 1),
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
                  color: Color(0xFFEAF5FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF00344B)),
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
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeThumbColor: const Color(0xFF00344B),
              ),
            ],
          ),
        ),
        if (!isLast) const Divider(color: Color(0xFFE2EDF3), height: 1),
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
                  color: Color(0xFFEAF5FF),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: const Color(0xFF00344B)),
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
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    const SizedBox(height: 1),
                    Text(
                      subtitle,
                      style: GoogleFonts.literata(
                        fontSize: 11,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                  ],
                ),
              ),
              ElevatedButton(
                onPressed: onTap,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEAF5FF),
                  foregroundColor: const Color(0xFF00344B),
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
        if (!isLast) const Divider(color: Color(0xFFE2EDF3), height: 1),
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
    return Container(
      width: double.infinity,
      height: 48,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2EDF3)),
      ),
      child: InkWell(
        onTap: _handleLogout,
        borderRadius: BorderRadius.circular(24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.logout, size: 16, color: Color(0xFFEF4444)),
            const SizedBox(width: 8),
            Text(
              'Log Out of TechKart',
              style: GoogleFonts.literata(
                fontSize: 13.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFFEF4444),
              ),
            ),
          ],
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
            const Icon(Icons.lock_outline, size: 12, color: Color(0xFF64748B)),
            const SizedBox(width: 4),
            Text(
              'End-to-End Encrypted Session',
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF64748B),
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          'TechKart Mobile v2.4.1 (Build 4920) • Verified Build',
          style: GoogleFonts.literata(
            fontSize: 10.5,
            color: const Color(0xFF94A3B8),
          ),
        ),
      ],
    );
  }
}
