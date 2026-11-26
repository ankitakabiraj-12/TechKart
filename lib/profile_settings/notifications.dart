import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/profile_avatar.dart';

/// TechKart Profile & Settings - Notifications Screen
/// Recreated to match original reference UI with 100% visual fidelity.
class TechKartNotification {
  final String id;
  final String title;
  final String? time;
  final String? description;

  const TechKartNotification({
    required this.id,
    required this.title,
    this.time,
    this.description,
  });
}

class NotificationsScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onMarkAllRead;
  final VoidCallback? onProfilePressed;
  final ValueChanged<TechKartNotification>? onNotificationAction;
  final ValueChanged<String>? onCategorySelected;

  const NotificationsScreen({
    super.key,
    this.onBack,
    this.onMarkAllRead,
    this.onProfilePressed,
    this.onNotificationAction,
    this.onCategorySelected,
  });

  @override
  State<NotificationsScreen> createState() => _NotificationsScreenState();
}

class _NotificationsScreenState extends State<NotificationsScreen> {
  String _selectedTab = 'all'; // 'all', 'orders', 'deliveries'

  void _markAllAsRead() {
    HapticFeedback.selectionClick();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('All notifications marked as read', style: GoogleFonts.literata()),
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  _buildUnreadPillHeader(),
                  const SizedBox(height: 12),
                  _buildFilterChips(),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Today', badge: '2 New'),
                  const SizedBox(height: 8),
                  _buildNotificationCard(
                    id: 'notif_1',
                    actionKey: const Key('notif_action_notif_1'),
                    icon: Icons.local_shipping_outlined,
                    iconBg: const Color(0xFF142D4E),
                    iconColor: const Color(0xFF142D4E),
                    title: 'Out for delivery today',
                    timeText: '12m ago',
                    isUnread: true,
                    description:
                        'Sony WH-1000XM5 is on the delivery van. Apex Express courier arriving by 5:30 PM at Bandra.',
                    actionButtonText: 'Track Courier',
                    actionButtonIcon: Icons.near_me_outlined,
                    onAction: () => AppNavigator.toShipmentTracking(context),
                  ),
                  const SizedBox(height: 10),
                  _buildNotificationCard(
                    icon: Icons.assignment_return_outlined,
                    iconBg: const Color(0xFF142D4E),
                    iconColor: const Color(0xFF142D4E),
                    title: 'Return pickup scheduled #RET-...',
                    timeText: '2h ago',
                    isUnread: true,
                    description:
                        'Apex Express agent pickup confirmed for tomorrow between 10:00 AM – 2:00 PM.',
                    actionButtonText: 'View Status',
                    isOutlinedAction: true,
                    onAction: () => AppNavigator.toReturnStatus(context),
                  ),
                  const SizedBox(height: 10),
                  _buildNotificationCard(
                    icon: Icons.local_offer_outlined,
                    iconBg: const Color(0xFF142D4E),
                    iconColor: const Color(0xFF142D4E),
                    title: 'Flash Sale: GaN Chargers & Cables',
                    timeText: '5h ago',
                    description:
                        'Get 20% off high-speed dual GaN fast chargers with code TECHFAST20. Valid today only.',
                    actionButtonText: 'Shop Chargers',
                    isOutlinedAction: true,
                    onAction: () => AppNavigator.toSubcategoryProducts(
                      context,
                      categoryName: 'Accessories',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader('Yesterday', badge: '1 New'),
                  const SizedBox(height: 8),
                  _buildNotificationCard(
                    icon: Icons.shield_outlined,
                    iconBg: const Color(0xFF142D4E),
                    iconColor: const Color(0xFF142D4E),
                    title: 'Two-Step Verification activated',
                    timeText: '4:15 PM',
                    isUnread: true,
                    description:
                        'New SMS verification device added for +91 98765-43210. If this wasn\'t you, review security.',
                    actionButtonText: 'Review Security',
                    isOutlinedAction: true,
                    onAction: () => AppNavigator.toSettings(context),
                  ),
                  const SizedBox(height: 10),
                  _buildNotificationCard(
                    icon: Icons.inventory_2_outlined,
                    iconBg: const Color(0xFF142D4E),
                    iconColor: const Color(0xFF142D4E),
                    title: 'Order #TK-89421 dispatched',
                    timeText: '10:30 AM',
                    description:
                        'Your Chronos Ultra 2 GPS Edition has departed Mumbai Central Logistics Facility.',
                    actionButtonText: 'Track Order',
                    isOutlinedAction: true,
                    onAction: () => AppNavigator.toShipmentTracking(
                      context,
                      trackingId: 'TRK-98214-DEL',
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildSectionHeader('Earlier this week', badge: 'All Read'),
                  const SizedBox(height: 8),
                  _buildNotificationCard(
                    icon: Icons.star_border,
                    iconBg: const Color(0xFF142D4E),
                    iconColor: const Color(0xFF142D4E),
                    title: 'Welcome to TechKart VIP Plus',
                    timeText: 'Oct 22',
                    description:
                        'You\'ve unlocked 5% bonus credit on all returns and free priority shipping on orders over ₹4,000.',
                  ),
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
              child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF000000)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'Notifications',
              style: GoogleFonts.literata(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF000000),
              ),
            ),
          ),
          GestureDetector(
            key: const Key('top_bar_mark_read_button'),
            onTap: () {
              widget.onMarkAllRead?.call();
              _markAllAsRead();
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
          GestureDetector(
            key: const Key('notifications_profile_button'),
            onTap: widget.onProfilePressed,
            child: const ProfileAvatar(size: 32),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UNREAD PILL HEADER
  // ---------------------------------------------------------------------------
  Widget _buildUnreadPillHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3.5),
          decoration: BoxDecoration(
            color: const Color(0xFF142D4E),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Row(
            children: [
              Container(
                width: 6,
                height: 6,
                decoration: const BoxDecoration(
                  color: Color(0xFF000000),
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                '3 unread notifications',
                style: GoogleFonts.literata(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
        ),
        GestureDetector(
          key: const Key('sub_header_mark_read_button'),
          onTap: () {
            widget.onMarkAllRead?.call();
            _markAllAsRead();
          },
          child: Row(
            children: [
              const Icon(Icons.done_all, size: 12, color: Color(0xFF000000)),
              const SizedBox(width: 4),
              Text(
                'Mark all read',
                style: GoogleFonts.literata(
                  fontSize: 11,
                  color: const Color(0xFF000000),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // FILTER CHIPS
  // ---------------------------------------------------------------------------
  Widget _buildFilterChips() {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          _buildFilterChip('all', 'All (5)', key: const Key('filter_all'), categoryName: 'All'),
          const SizedBox(width: 8),
          _buildFilterChip('orders', 'Orders (2)', key: const Key('filter_orders'), categoryName: 'Orders'),
          const SizedBox(width: 8),
          _buildFilterChip('deliveries', 'Deliveries (1)', key: const Key('filter_deliveries'), categoryName: 'Deliveries'),
          const SizedBox(width: 8),
          _buildFilterChip('offers', 'Offers', key: const Key('filter_offers'), categoryName: 'Offers'),
        ],
      ),
    );
  }

  Widget _buildFilterChip(String id, String label, {Key? key, String? categoryName}) {
    final isSelected = _selectedTab == id;

    return GestureDetector(
      key: key,
      onTap: () {
        HapticFeedback.selectionClick();
        setState(() => _selectedTab = id);
        widget.onCategorySelected?.call(categoryName ?? id);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF142D4E) : const Color(0xFF142D4E),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: GoogleFonts.literata(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w600,
            color: isSelected ? const Color(0xFFF8FAFC) : const Color(0xFF142D4E),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SECTION HEADER
  // ---------------------------------------------------------------------------
  Widget _buildSectionHeader(String title, {String? badge}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: GoogleFonts.literata(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF000000),
          ),
        ),
        if (badge != null)
          Text(
            badge,
            style: GoogleFonts.literata(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF000000),
            ),
          ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // NOTIFICATION CARD
  // ---------------------------------------------------------------------------
  Widget _buildNotificationCard({
    String? id,
    Key? actionKey,
    required IconData icon,
    required Color iconBg,
    required Color iconColor,
    required String title,
    required String timeText,
    bool isUnread = false,
    required String description,
    String? actionButtonText,
    IconData? actionButtonIcon,
    bool isOutlinedAction = false,
    VoidCallback? onAction,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF142D4E)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: iconBg,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: iconColor),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: GoogleFonts.literata(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                    Row(
                      children: [
                        Text(
                          timeText,
                          style: GoogleFonts.literata(
                            fontSize: 10.5,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        if (isUnread) ...[
                          const SizedBox(width: 4),
                          Container(
                            width: 6,
                            height: 6,
                            decoration: const BoxDecoration(
                              color: Color(0xFF000000),
                              shape: BoxShape.circle,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  description,
                  style: GoogleFonts.literata(
                    fontSize: 11.5,
                    height: 1.35,
                    color: const Color(0xFF000000),
                  ),
                ),
                if (actionButtonText != null) ...[
                  const SizedBox(height: 10),
                  if (!isOutlinedAction)
                    ElevatedButton.icon(
                      key: actionKey,
                      onPressed: () {
                        if (id != null) {
                          widget.onNotificationAction?.call(
                            TechKartNotification(
                              id: id,
                              title: title,
                              time: timeText,
                              description: description,
                            ),
                          );
                        }
                        onAction?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF142D4E),
                        foregroundColor: const Color(0xFFF8FAFC),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        minimumSize: Size.zero,
                      ),
                      icon: actionButtonIcon != null
                          ? Icon(actionButtonIcon, size: 13)
                          : const SizedBox.shrink(),
                      label: Text(
                        actionButtonText,
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    )
                  else
                    ElevatedButton(
                      key: actionKey,
                      onPressed: () {
                        if (id != null) {
                          widget.onNotificationAction?.call(
                            TechKartNotification(
                              id: id,
                              title: title,
                              time: timeText,
                              description: description,
                            ),
                          );
                        }
                        onAction?.call();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF142D4E),
                        foregroundColor: const Color(0xFF142D4E),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                        minimumSize: Size.zero,
                      ),
                      child: Text(
                        actionButtonText,
                        style: GoogleFonts.literata(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }
}
