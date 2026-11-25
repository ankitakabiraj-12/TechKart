import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/session_manager.dart';
import '../theme/bottom_navbar.dart';
import '../theme/profile_avatar.dart';

/// TechKart Profile & Settings - Customer Profile Hub Screen (SCR-35)
/// Recreated to match original reference UI with 100% visual fidelity.
class CustomerProfileHubScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onEditProfile;
  final VoidCallback? onSettings;
  final VoidCallback? onTrackDelivery;
  final VoidCallback? onOrderHistory;
  final VoidCallback? onReturnsRefunds;
  final VoidCallback? onWishlist;
  final VoidCallback? onProductReviews;
  final VoidCallback? onSavedAddresses;
  final VoidCallback? onPaymentMethods;
  final VoidCallback? onAiPreferences;
  final VoidCallback? onNotificationsAlerts;
  final VoidCallback? onLanguageRegion;
  final VoidCallback? onConciergeSupport;
  final VoidCallback? onAppSettingsPrivacy;
  final VoidCallback? onLogout;
  final bool showBottomNav;
  final ValueChanged<int>? onNavTabSelected;

  const CustomerProfileHubScreen({
    super.key,
    this.onBack,
    this.onEditProfile,
    this.onSettings,
    this.onTrackDelivery,
    this.onOrderHistory,
    this.onReturnsRefunds,
    this.onWishlist,
    this.onProductReviews,
    this.onSavedAddresses,
    this.onPaymentMethods,
    this.onAiPreferences,
    this.onNotificationsAlerts,
    this.onLanguageRegion,
    this.onConciergeSupport,
    this.onAppSettingsPrivacy,
    this.onLogout,
    this.showBottomNav = true,
    this.onNavTabSelected,
  });

  @override
  State<CustomerProfileHubScreen> createState() =>
      _CustomerProfileHubScreenState();
}

class _CustomerProfileHubScreenState extends State<CustomerProfileHubScreen> {
  Map<String, dynamic>? _stats;

  @override
  void initState() {
    super.initState();
    _stats = SessionManager().profileStats;
    _refreshProfile();
  }

  Future<void> _refreshProfile() async {
    final stats = await SessionManager().refreshProfile();
    if (!mounted) return;
    setState(() => _stats = stats);
  }

  int _statInt(String key) {
    final value = _stats?[key];
    if (value is num) return value.toInt();
    return int.tryParse(value?.toString() ?? '') ?? 0;
  }

  String _statString(String key, {String fallback = ''}) {
    final value = _stats?[key]?.toString().trim();
    return (value == null || value.isEmpty) ? fallback : value;
  }

  String _defaultAddressLabel() {
    final address = _stats?['default_address'];
    if (address is Map<String, dynamic>) {
      final formatted = address['formatted']?.toString().trim();
      if (formatted != null && formatted.isNotEmpty) return formatted;
      final parts = [address['line1'], address['city']]
          .whereType<Object>()
          .map((e) => e.toString().trim())
          .where((e) => e.isNotEmpty);
      final label = parts.join(', ');
      if (label.isNotEmpty) return label;
    }
    final count = _statInt('address_count');
    return count > 0
        ? '$count saved address${count == 1 ? '' : 'es'}'
        : 'No saved addresses';
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return ValueListenableBuilder<Map<String, dynamic>?>(
      valueListenable: SessionManager().currentUserNotifier,
      builder: (context, user, child) {
        return Scaffold(
          backgroundColor: const Color(0xFFFDFBCF),
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
                      _buildProfileHeroCard(),
                      const SizedBox(height: 14),
                      _buildStatsRow(),
                      const SizedBox(height: 16),
                      _buildActiveDeliveryBanner(),
                      const SizedBox(height: 20),
                      _buildSectionHeader('ORDERS & ACTIVITY'),
                      const SizedBox(height: 8),
                      _buildMenuCard([
                        _buildMenuItem(
                          icon: Icons.inventory_2_outlined,
                          title: 'Order History',
                          badge: _statInt('orders_in_progress') > 0
                              ? '${_statInt('orders_in_progress')} in progress'
                              : null,
                          badgeBg: const Color(0xFFE6C17A),
                          badgeColor: const Color(0xFF0D1B2A),
                          onTap:
                              widget.onOrderHistory ??
                              () => AppNavigator.toOrderHistory(context),
                        ),
                        _buildMenuItem(
                          icon: Icons.assignment_return_outlined,
                          title: 'Returns & Refunds',
                          badge: _statInt('active_returns') > 0
                              ? '${_statInt('active_returns')} active'
                              : null,
                          badgeBg: const Color(0xFFE6C17A),
                          badgeColor: const Color(0xFFB8860B),
                          onTap:
                              widget.onReturnsRefunds ??
                              () => AppNavigator.toReturnStatus(
                                context,
                                orderId: 'TK-89421',
                                caseId: 'RET-84920',
                              ),
                        ),
                        _buildMenuItem(
                          icon: Icons.favorite_border,
                          title: 'Wishlist & Saved Items',
                          badge: _statInt('wishlist_count') > 0
                              ? '${_statInt('wishlist_count')} items'
                              : null,
                          onTap:
                              widget.onWishlist ??
                              () => AppNavigator.toWishlist(context),
                        ),
                        _buildMenuItem(
                          icon: Icons.rate_review_outlined,
                          title: 'Product Reviews',
                          badge: _statInt('pending_reviews') > 0
                              ? '${_statInt('pending_reviews')} pending'
                              : null,
                          badgeBg: const Color(0xFFE6C17A),
                          badgeColor: const Color(0xFF0D1B2A),
                          onTap:
                              widget.onProductReviews ??
                              () => AppNavigator.toWriteReviews(context),
                          isLast: true,
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildSectionHeader('PERSONAL & DELIVERY'),
                      const SizedBox(height: 8),
                      _buildMenuCard([
                        _buildMenuItem(
                          icon: Icons.location_on_outlined,
                          title: 'Saved Addresses',
                          subtitle: _defaultAddressLabel(),
                          onTap:
                              widget.onSavedAddresses ??
                              () => AppNavigator.toDeliveryAddress(context),
                        ),
                        _buildMenuItem(
                          icon: Icons.credit_card_outlined,
                          title: 'Payment Methods',
                          subtitle: _statString(
                            'payment_summary',
                            fallback: 'No saved payment methods',
                          ),
                          onTap:
                              widget.onPaymentMethods ??
                              () => AppNavigator.toPaymentMethod(context),
                        ),
                        _buildMenuItem(
                          icon: Icons.auto_awesome_outlined,
                          title: 'TechKart AI Preferences',
                          subtitle: 'Gadget alerts & smart specs matching',
                          onTap:
                              widget.onAiPreferences ??
                              () => AppNavigator.toAiChatSessions(context),
                          isLast: true,
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildSectionHeader('SUPPORT & PREFERENCES'),
                      const SizedBox(height: 8),
                      _buildMenuCard([
                        _buildMenuItem(
                          icon: Icons.notifications_none_outlined,
                          title: 'Notifications & Alerts',
                          onTap: widget.onNotificationsAlerts ?? () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.language_outlined,
                          title: 'Language & Region',
                          trailingText: 'English (IN)',
                          onTap: widget.onLanguageRegion ?? () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.headset_mic_outlined,
                          title: '24/7 Concierge Support',
                          badge: 'Live Chat',
                          badgeBg: const Color(0xFFE6C17A),
                          badgeColor: const Color(0xFF0D1B2A),
                          onTap: widget.onConciergeSupport ?? () {},
                        ),
                        _buildMenuItem(
                          icon: Icons.lock_outline,
                          title: 'App Settings & Privacy',
                          onTap: widget.onAppSettingsPrivacy ?? () {},
                          isLast: true,
                        ),
                      ]),
                      const SizedBox(height: 20),
                      _buildLogoutButton(),
                      const SizedBox(height: 14),
                      _buildAppVersionFooter(),
                      const SizedBox(height: 70),
                    ],
                  ),
                ),
                if (widget.showBottomNav)
                  TechKartBottomNavBar(
                    currentIndex: 4,
                    onTabSelected: widget.onNavTabSelected ??
                        (index) {
                          if (index == 0) AppNavigator.toHome(context);
                          if (index == 1) AppNavigator.toCategories(context);
                          if (index == 2) AppNavigator.toAiChatSessions(context);
                          if (index == 3) AppNavigator.toCart(context);
                        },
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  // ---------------------------------------------------------------------------
  // CLEAN MINIMAL APP BAR
  // ---------------------------------------------------------------------------
  Widget _buildAppBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFFDFBCF),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: widget.onBack ?? () => Navigator.of(context).maybePop(),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: const BoxDecoration(
                color: Color(0xFFE6C17A),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.arrow_back,
                size: 20,
                color: Color(0xFF0D1B2A),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Account',
              style: GoogleFonts.domine(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(
              Icons.notifications_none_outlined,
              color: Color(0xFF0D1B2A),
              size: 24,
            ),
            onPressed: widget.onNotificationsAlerts ?? () {},
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // PROFILE HERO CARD
  // ---------------------------------------------------------------------------
  Widget _buildProfileHeroCard() {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: const Color(0xFFE6C17A)),
      ),
      child: Row(
            children: [
              const ProfileAvatar(size: 54),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          SessionManager().userName ?? 'Customer',
                          style: GoogleFonts.domine(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0D1B2A),
                          ),
                        ),
                        if (_statString('vip_tier', fallback: 'MEMBER') !=
                            'MEMBER') ...[
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE6C17A),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(
                                  Icons.star,
                                  size: 10,
                                  color: Color(0xFFB8860B),
                                ),
                                const SizedBox(width: 3),
                                Text(
                                  _statString('vip_tier'),
                                  style: TextStyle(
                                    fontFamily: 'Literata',
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFFB8860B),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                        const Spacer(),
                        GestureDetector(
                          onTap:
                              widget.onEditProfile ??
                              () => AppNavigator.toEditProfile(context),
                          child: const Icon(
                            Icons.edit_outlined,
                            size: 16,
                            color: Color(0xFF0D1B2A),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      SessionManager().userEmail ?? 'No email on file',
                      style: GoogleFonts.literata(
                        fontSize: 11.5,
                        color: const Color(0xFF1B365D),
                      ),
                    ),
                    if ((SessionManager().userPhone ?? '').isNotEmpty)
                      Text(
                        SessionManager().userPhone!,
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          color: const Color(0xFF1B365D),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        );
  }

  // ---------------------------------------------------------------------------
  // STATS ROW (14 Orders, 5 Wishlist, ₹16,450 TechWallet)
  // ---------------------------------------------------------------------------
  Widget _buildStatsRow() {
    final wallet = _stats?['wallet_balance'];
    final walletAmount = wallet is num ? wallet.toDouble() : 0.0;
    return Row(
      children: [
        _buildStatCard(
          icon: Icons.inventory_2_outlined,
          value: '${_statInt('order_count')}',
          label: 'Orders',
          onTap: widget.onOrderHistory ?? () => AppNavigator.toOrderHistory(context),
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          icon: Icons.favorite,
          value: '${_statInt('wishlist_count')}',
          label: 'Wishlist',
          isHeart: true,
          onTap: widget.onWishlist ?? () => AppNavigator.toWishlist(context),
        ),
        const SizedBox(width: 10),
        _buildStatCard(
          icon: Icons.account_balance_wallet_outlined,
          value:
              '₹${walletAmount.toStringAsFixed(walletAmount == walletAmount.roundToDouble() ? 0 : 2)}',
          label: 'TechWallet',
        ),
      ],
    );
  }

  Widget _buildStatCard({
    required IconData icon,
    required String value,
    required String label,
    bool isHeart = false,
    VoidCallback? onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap != null ? () { HapticFeedback.lightImpact(); onTap(); } : null,
        child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: const Color(0xFFE6C17A)),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: 14,
                  color: isHeart
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF1B365D),
                ),
                const SizedBox(width: 5),
                Text(
                  value,
                  style: GoogleFonts.domine(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 3),
            Text(
              label,
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF1B365D),
              ),
            ),
          ],
        ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // ACTIVE DELIVERY BANNER
  // ---------------------------------------------------------------------------
  Widget _buildActiveDeliveryBanner() {
    final delivery = _stats?['active_delivery'];
    if (delivery is! Map<String, dynamic>) {
      return const SizedBox.shrink();
    }

    final title = delivery['title']?.toString() ?? 'Active delivery';
    final subtitle =
        delivery['subtitle']?.toString() ?? 'Tracking update in progress';
    final trackingId = delivery['tracking_number']?.toString();
    final trackingRef = (trackingId != null && trackingId.isNotEmpty)
        ? trackingId
        : delivery['order_number']?.toString() ?? '';

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6C17A)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFF5EBDD),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.local_shipping,
              size: 18,
              color: Color(0xFF0D1B2A),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.isNotEmpty ? title : 'Chronos Ultra 2 • Out for delivery',
                  style: GoogleFonts.literata(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
                Text(
                  subtitle.isNotEmpty ? subtitle : 'Arriving today by 5:30 PM • Bandra West',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    color: const Color(0xFF1B365D),
                  ),
                ),
              ],
            ),
          ),
          ElevatedButton(
            onPressed:
                widget.onTrackDelivery ??
                () => AppNavigator.toShipmentTracking(
                  context,
                  trackingId: trackingRef,
                ),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF0D1B2A),
              foregroundColor: const Color(0xFFF5EBDD),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: Size.zero,
            ),
            child: Text(
              'Track',
              style: GoogleFonts.literata(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
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
        color: const Color(0xFF1B365D),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // MENU CARD WRAPPER
  // ---------------------------------------------------------------------------
  Widget _buildMenuCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6C17A)),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildMenuItem({
    required IconData icon,
    required String title,
    String? subtitle,
    String? badge,
    Color? badgeBg,
    Color? badgeColor,
    String? trailingText,
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
                    color: Color(0xFFE6C17A),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(icon, size: 16, color: const Color(0xFF0D1B2A)),
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
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                      if (subtitle != null) ...[
                        const SizedBox(height: 1),
                        Text(
                          subtitle,
                          style: GoogleFonts.literata(
                            fontSize: 11,
                            color: const Color(0xFF1B365D),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (badge != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 3,
                    ),
                    decoration: BoxDecoration(
                      color: badgeBg ?? const Color(0xFFE6C17A),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badge,
                      style: TextStyle(
                        fontFamily: 'Literata',
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: badgeColor ?? const Color(0xFF1B365D),
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                if (trailingText != null) ...[
                  Text(
                    trailingText,
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                  const SizedBox(width: 6),
                ],
                const Icon(
                  Icons.arrow_forward_ios,
                  size: 12,
                  color: Color(0xFF1B365D),
                ),
              ],
            ),
          ),
        ),
        if (!isLast) const Divider(color: Color(0xFFE6C17A), height: 1),
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
              color: const Color(0xFFF5EBDD),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: const Color(0xFFE6C17A), width: 1),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.logout, size: 15, color: Color(0xFFEF4444)),
                const SizedBox(width: 8),
                Text(
                  'Log Out of TechKart',
                  style: GoogleFonts.literata(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFEF4444),
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
  // APP VERSION FOOTER
  // ---------------------------------------------------------------------------
  Widget _buildAppVersionFooter() {
    return Column(
      children: [
        Text(
          'TechKart v1.0',
          style: GoogleFonts.literata(
            fontSize: 11,
            color: const Color(0xFF1B365D),
          ),
        ),
        const SizedBox(height: 2),
        Text(
          'Secure account & profile management',
          style: GoogleFonts.literata(
            fontSize: 10.5,
            color: const Color(0xFF1B365D),
          ),
        ),
      ],
    );
  }
}
