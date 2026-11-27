import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../app_routes/app_navigator.dart';
import '../system/currency_service.dart';

/// TechKart Admin - Admin Overview Dashboard Screen
///
/// A high-fidelity pixel-perfect recreation of the Admin Overview dashboard:
/// - Top Navigation Bar: Back button, TechKart logo glyph, 'Notifica...', '✓ Mark all read', User Avatar
/// - Header Card: 'LIVE SYNC • TechKart Global', '100% Operational', 'Admin Overview', Notification bell, 'AD' Admin Avatar
/// - 2x2 KPI Cards:
///   1. Gross Revenue ($28,490.50, +14.2%, vs $24,910 yesterday)
///   2. Orders Today (148 orders, 12 pending, 98.4% fulfillment rate)
///   3. Active Shoppers (342 online, • Live, Peak traffic right now)
///   4. Low Stock Alert (6 items, Action Req., 3 reach 0 in <6 hrs - warm background)
/// - Hourly Revenue Pulse: Bar chart visualization with peak indicator ($5,420 peak at 14:00)
/// - Critical Reserve Alert Card: Chronos Ultra 2 Titanium, Only 3 units left in Dhaka Central Hub, 'Restock' button
/// - Store Operations Quick Launcher: New Item, Dispatch (badge 12), Stock, Customers
/// - Recent Live Orders: List of real-time orders with statuses, timestamps, customer location, and amounts
/// - Dedicated Order Manager button at the bottom
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: _buildTopAppBar(context),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Card with Live Sync & Admin Overview
              _buildHeaderCard(context),

              const SizedBox(height: 16),

              // 2x2 Stat Cards Grid
              _buildStatGrid(context),

              const SizedBox(height: 16),

              // Hourly Revenue Pulse Card
              _buildHourlyRevenueCard(),

              const SizedBox(height: 16),

              // Critical Reserve Warning Banner
              _buildCriticalReserveCard(context),

              const SizedBox(height: 22),

              // Store Operations (Quick Launcher)
              _buildStoreOperationsSection(context),

              const SizedBox(height: 22),

              // Recent Live Orders
              _buildRecentLiveOrdersSection(context),

              const SizedBox(height: 18),

              // Open Dedicated Order Manager Button
              _buildDedicatedOrderManagerButton(context),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Top App Bar
  // ---------------------------------------------------------------------------
  PreferredSizeWidget _buildTopAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFFFFFFFF),
      elevation: 0,
      scrolledUnderElevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark,
      automaticallyImplyLeading: false,
      titleSpacing: 8,
      title: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, color: Color(0xFF000000), size: 22),
            onPressed: () => AppNavigator.pop(context),
            tooltip: 'Back',
          ),
          const SizedBox(width: 4),

          // TechKart Icon Glyph
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              shape: BoxShape.circle,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ],
            ),
            padding: const EdgeInsets.all(3),
            child: Image.asset(
              'asset/app_logo.png',
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => const Center(
                child: Icon(Icons.shopping_cart_rounded, color: Color(0xFF142D4E), size: 18),
              ),
            ),
          ),
          const SizedBox(width: 10),

          // Title
          const Text(
            'Notifica...',
            style: TextStyle(
              color: Color(0xFF000000),
              fontSize: 19,
              fontWeight: FontWeight.w700,
              fontFamily: 'Literata',
            ),
          ),
        ],
      ),
      actions: [
        // Mark all read button
        InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('All notifications marked as read'),
                duration: Duration(seconds: 1),
                behavior: SnackBarBehavior.floating,
              ),
            );
          },
          child: const Padding(
            padding: EdgeInsets.symmetric(horizontal: 6, vertical: 8),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.check, size: 16, color: Color(0xFF000000)),
                SizedBox(width: 4),
                Text(
                  'Mark all read',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF000000),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 6),

        // User Avatar Circle
        Container(
          width: 34,
          height: 34,
          margin: const EdgeInsets.only(right: 14),
          decoration: const BoxDecoration(
            color: Color(0xFF000000),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.person,
            color: Color(0xFFF8FAFC),
            size: 20,
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Header Card (Live Sync & Admin Overview)
  // ---------------------------------------------------------------------------
  Widget _buildHeaderCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFF142D4E),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Live Sync & Operational status bar
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: Color(0xFF000000),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Text(
                    'LIVE SYNC',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.4,
                    ),
                  ),
                  const Text(
                    ' • TechKart Global',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
              Row(
                children: const [
                  Icon(Icons.verified_outlined, size: 14, color: Color(0xFF000000)),
                  SizedBox(width: 4),
                  Text(
                    '100% Operational',
                    style: TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Admin Overview Title & Actions Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Admin Overview',
                      style: TextStyle(
                        fontFamily: 'Literata',
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                        letterSpacing: -0.4,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Today, Oct 24 • Real-time stream',
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 12.5,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),

              // Notification Bell with Badge
              Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: const BoxDecoration(
                      color: Color(0xFFF8FAFC),
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Color(0xFF000000),
                      size: 20,
                    ),
                  ),
                  Positioned(
                    top: 2,
                    right: 2,
                    child: Container(
                      width: 9,
                      height: 9,
                      decoration: BoxDecoration(
                        color: const Color(0xFFDC2626),
                        shape: BoxShape.circle,
                        border: Border.all(color: const Color(0xFFF8FAFC), width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 8),

              // AD Avatar Circle
              Container(
                width: 38,
                height: 38,
                decoration: const BoxDecoration(
                  color: Color(0xFFD6E9FA),
                  shape: BoxShape.circle,
                ),
                alignment: Alignment.center,
                child: const Text(
                  'AD',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // 2x2 KPI Stat Cards Grid
  // ---------------------------------------------------------------------------
  Widget _buildStatGrid(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            // Gross Revenue
            Expanded(
              child: _buildKpiCard(
                icon: Icons.payments_outlined,
                badgeText: '+14.2%',
                badgeBgColor: const Color(0xFF142D4E),
                badgeTextColor: const Color(0xFF142D4E),
                title: 'Gross Revenue',
                value: CurrencyService.formatUsdToInr(28490.50),
                subtext: 'vs ${CurrencyService.formatUsdToInr(24910.00, showDecimals: false)} yesterday',
              ),
            ),
            const SizedBox(width: 12),
            // Orders Today
            Expanded(
              child: _buildKpiCard(
                icon: Icons.shopping_bag_outlined,
                badgeText: '12 pending',
                badgeBgColor: const Color(0xFFFEF3C7),
                badgeTextColor: const Color(0xFFB45309),
                title: 'Orders Today',
                value: '148 orders',
                subtext: '98.4% fulfillment rate',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            // Active Shoppers
            Expanded(
              child: _buildKpiCard(
                icon: Icons.visibility_outlined,
                badgeText: '• Live',
                badgeBgColor: const Color(0xFF142D4E),
                badgeTextColor: const Color(0xFF142D4E),
                title: 'Active Shoppers',
                value: '342 online',
                subtext: 'Peak traffic right now',
              ),
            ),
            const SizedBox(width: 12),
            // Low Stock Alert (Warm beige card)
            Expanded(
              child: _buildKpiCard(
                icon: Icons.inventory_2_outlined,
                badgeText: 'Action Req.',
                badgeBgColor: const Color(0xFFFEE2E2),
                badgeTextColor: const Color(0xFFDC2626),
                title: 'Low Stock Alert',
                value: '6 items',
                subtext: '3 reach 0 in <6 hrs',
                cardBgColor: const Color(0xFFF5EFE6),
                onTap: () => AppNavigator.toProductManagement(context, filter: 'Low Stock'),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildKpiCard({
    required IconData icon,
    required String badgeText,
    required Color badgeBgColor,
    required Color badgeTextColor,
    required String title,
    required String value,
    required String subtext,
    Color? cardBgColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(22),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: cardBgColor ?? const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(22),
          border: Border.all(
            color: cardBgColor != null ? const Color(0xFFEBE0D2) : const Color(0xFF142D4E),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.02),
              blurRadius: 6,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Top Row: Icon Container and Badge
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  decoration: BoxDecoration(
                    color: cardBgColor != null ? const Color(0xFFEDE3D6) : const Color(0xFFEBF4FC),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Icon(
                    icon,
                    size: 18,
                    color: const Color(0xFF000000),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: badgeBgColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    badgeText,
                    style: TextStyle(
                      color: badgeTextColor,
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            // Title
            Text(
              title,
              style: const TextStyle(
                color: Color(0xFF000000),
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
            const SizedBox(height: 4),

            // Value
            Text(
              value,
              style: const TextStyle(
                fontFamily: 'Literata',
                color: Color(0xFF000000),
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 4),

            // Subtext
            Text(
              subtext,
              style: const TextStyle(
                color: Color(0xFF000000),
                fontSize: 10,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Hourly Revenue Pulse Card
  // ---------------------------------------------------------------------------
  Widget _buildHourlyRevenueCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.02),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: const [
                    Text(
                      'Hourly Revenue Pulse',
                      style: TextStyle(
                        fontFamily: 'Literata',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF000000),
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      "Today's trajectory across key peak cycles",
                      style: TextStyle(
                        color: Color(0xFF000000),
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFF142D4E),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Text(
                  'Peak: ${CurrencyService.formatUsdToInr(5420.00, showDecimals: false)}',
                  style: const TextStyle(
                    color: Color(0xFF142D4E),
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Bar Chart Graphic with horizontal guide lines
          SizedBox(
            height: 125,
            child: Stack(
              children: [
                // Dotted horizontal grid lines
                Positioned.fill(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildDottedLine(),
                      _buildDottedLine(),
                      _buildDottedLine(),
                    ],
                  ),
                ),

                // Bars Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    _buildChartBar(height: 38, isSkyBlue: true),
                    _buildChartBar(height: 52, isSkyBlue: true),
                    // 12:00 Stacked Bar
                    _buildStackedBar(totalHeight: 78, darkHeight: 30),
                    // 14:00 (Peak) Tallest Dark Bar with indicator
                    _buildPeakBar(height: 98),
                    _buildChartBar(height: 52, isSkyBlue: true),
                    _buildChartBar(height: 34, isSkyBlue: true, opacity: 0.6),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // Time labels row
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              Text('08:00', style: TextStyle(color: Color(0xFF000000), fontSize: 10.5, fontWeight: FontWeight.w500)),
              Text('10:00', style: TextStyle(color: Color(0xFF000000), fontSize: 10.5, fontWeight: FontWeight.w500)),
              Text('12:00', style: TextStyle(color: Color(0xFF000000), fontSize: 10.5, fontWeight: FontWeight.w500)),
              Text(
                '14:00 (Peak)',
                style: TextStyle(color: Color(0xFF000000), fontSize: 10.5, fontWeight: FontWeight.w800),
              ),
              Text('16:00', style: TextStyle(color: Color(0xFF000000), fontSize: 10.5, fontWeight: FontWeight.w500)),
              Text('Now', style: TextStyle(color: Color(0xFF000000), fontSize: 10.5, fontWeight: FontWeight.w500)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDottedLine() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxWidth = constraints.constrainWidth();
        const dashWidth = 4.0;
        const dashSpace = 4.0;
        final dashCount = (boxWidth / (dashWidth + dashSpace)).floor();
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(dashCount, (_) {
            return const SizedBox(
              width: dashWidth,
              height: 1,
              child: DecoratedBox(
                decoration: BoxDecoration(color: Color(0xFF142D4E)),
              ),
            );
          }),
        );
      },
    );
  }

  Widget _buildChartBar({
    required double height,
    required bool isSkyBlue,
    double opacity = 1.0,
  }) {
    return Container(
      width: 26,
      height: height,
      decoration: BoxDecoration(
        color: const Color(0xFFD8EDFD).withValues(alpha: opacity),
        shape: BoxShape.circle,
      ),
    );
  }

  Widget _buildStackedBar({required double totalHeight, required double darkHeight}) {
    final lightHeight = totalHeight - darkHeight;
    return Container(
      width: 26,
      height: totalHeight,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        children: [
          Container(
            width: 26,
            height: darkHeight,
            decoration: const BoxDecoration(
              color: Color(0xFF000000),
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(8),
                topRight: Radius.circular(8),
              ),
            ),
          ),
          Container(
            width: 26,
            height: lightHeight,
            color: const Color(0xFFD8EDFD),
          ),
        ],
      ),
    );
  }

  Widget _buildPeakBar({required double height}) {
    return Stack(
      alignment: Alignment.topCenter,
      clipBehavior: Clip.none,
      children: [
        Container(
          width: 26,
          height: height,
          decoration: BoxDecoration(
            color: const Color(0xFF434E6B),
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        Positioned(
          top: -4,
          child: Container(
            width: 7,
            height: 7,
            decoration: const BoxDecoration(
              color: Color(0xFF434E6B),
              shape: BoxShape.circle,
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // Critical Reserve Card
  // ---------------------------------------------------------------------------
  Widget _buildCriticalReserveCard(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFFEDE4D5),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: const Color(0xFFE2D6C3), width: 1),
      ),
      child: Row(
        children: [
          // Exclamation triangle in black circle
          Container(
            width: 36,
            height: 36,
            decoration: const BoxDecoration(
              color: Color(0xFF000000),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFF8FAFC),
              size: 20,
            ),
          ),
          const SizedBox(width: 12),

          // Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDE8E8),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'CRITICAL RESERVE',
                    style: TextStyle(
                      color: Color(0xFFDC2626),
                      fontSize: 8.5,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.3,
                    ),
                  ),
                ),
                const SizedBox(height: 3),
                const Text(
                  'Chronos Ultra 2 Titanium',
                  style: TextStyle(
                    fontFamily: 'Literata',
                    color: Color(0xFF000000),
                    fontSize: 14.5,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 1),
                const Text(
                  'Only 3 units left in Dhaka Central Hub',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),

          // Restock Button
          ElevatedButton(
            onPressed: () => AppNavigator.toEditProduct(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF142D4E),
              foregroundColor: const Color(0xFFF8FAFC),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              minimumSize: const Size(60, 32),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              elevation: 0,
            ),
            child: const Text(
              'Restock',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Store Operations (Quick Launcher)
  // ---------------------------------------------------------------------------
  Widget _buildStoreOperationsSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: const [
            Text(
              'Store Operations',
              style: TextStyle(
                fontFamily: 'Literata',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF000000),
              ),
            ),
            Text(
              'Quick Launcher',
              style: TextStyle(
                color: Color(0xFF000000),
                fontSize: 11.5,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // 1. New Item
            _buildOperationCircleButton(
              context: context,
              icon: Icons.add_box_outlined,
              label: 'New Item',
              onTap: () => AppNavigator.toEditProduct(context),
            ),

            // 2. Dispatch (Badge 12)
            _buildOperationCircleButton(
              context: context,
              icon: Icons.local_shipping_outlined,
              label: 'Dispatch',
              badgeCount: 12,
              onTap: () => AppNavigator.toAdminOrderManagement(context),
            ),

            // 3. Stock -> Inventory Management
            _buildOperationCircleButton(
              context: context,
              icon: Icons.storefront_outlined,
              label: 'Stock',
              onTap: () => AppNavigator.toInventoryManagement(context),
            ),

            // 4. Customers
            _buildOperationCircleButton(
              context: context,
              icon: Icons.people_outline_rounded,
              label: 'Customers',
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Customer Directory (482 registered active)'),
                    duration: Duration(seconds: 1),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildOperationCircleButton({
    required BuildContext context,
    required IconData icon,
    required String label,
    int? badgeCount,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(40),
      child: Column(
        children: [
          Container(
            width: 68,
            height: 68,
            decoration: BoxDecoration(
              color: const Color(0xFFF8FAFC),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.02),
                  blurRadius: 6,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Soft blue inner circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                  child: Icon(
                    icon,
                    size: 22,
                    color: const Color(0xFF142D4E),
                  ),
                ),

                // Badge (if any)
                if (badgeCount != null)
                  Positioned(
                    top: 10,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFF000000),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        '$badgeCount',
                        style: const TextStyle(
                          color: Color(0xFFF8FAFC),
                          fontSize: 8.5,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 6),
          Text(
            label,
            style: const TextStyle(
              color: Color(0xFF000000),
              fontSize: 11.5,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Recent Live Orders Section
  // ---------------------------------------------------------------------------
  Widget _buildRecentLiveOrdersSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: const [
                Text(
                  'Recent Live Orders',
                  style: TextStyle(
                    fontFamily: 'Literata',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF000000),
                  ),
                ),
                SizedBox(width: 4),
                Text(
                  '•',
                  style: TextStyle(
                    color: Color(0xFF000000),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            InkWell(
              onTap: () => AppNavigator.toAdminOrderManagement(context),
              child: const Text(
                'View All (148) →',
                style: TextStyle(
                  color: Color(0xFF000000),
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // Order 1
        _buildOrderItemCard(
          context: context,
          icon: Icons.watch_outlined,
          orderId: '#TK-98241',
          status: 'Packed',
          statusBgColor: const Color(0xFF142D4E),
          statusTextColor: const Color(0xFF142D4E),
          productTitle: 'Chronos Ultra 2 • Titanium ...',
          locationTime: 'Banani, Dhaka • 2 mins ago',
          price: CurrencyService.formatUsdToInr(429.00),
          paymentStatus: 'Paid Online',
          paymentColor: const Color(0xFF142D4E),
          onTap: () => AppNavigator.toEditProduct(context),
        ),

        const SizedBox(height: 10),

        // Order 2
        _buildOrderItemCard(
          context: context,
          icon: Icons.bolt_outlined,
          orderId: '#TK-98240',
          status: 'In Transit',
          statusBgColor: const Color(0xFFFEF3C7),
          statusTextColor: const Color(0xFFB45309),
          productTitle: 'VoltFast 65W GaN Fast Ch...',
          locationTime: 'Bandra West, Mumbai • 14 mins ago',
          price: CurrencyService.formatUsdToInr(49.00),
          paymentStatus: 'COD Confirmed',
          paymentColor: const Color(0xFF142D4E),
          onTap: () {
            _showOrderDetailsSheet(context, orderId: '#TK-98240');
          },
        ),

        const SizedBox(height: 10),

        // Order 3
        _buildOrderItemCard(
          context: context,
          icon: Icons.headphones_outlined,
          orderId: '#TK-98239',
          status: 'Processing',
          statusBgColor: const Color(0xFF142D4E),
          statusTextColor: const Color(0xFF142D4E),
          productTitle: 'QuietComfort Max Wireless...',
          locationTime: 'Andheri West, Mumbai • 28 mins ago',
          price: CurrencyService.formatUsdToInr(289.00),
          paymentStatus: 'Paid Online',
          paymentColor: const Color(0xFF142D4E),
          onTap: () {
            _showOrderDetailsSheet(context, orderId: '#TK-98239');
          },
        ),
      ],
    );
  }

  Widget _buildOrderItemCard({
    required BuildContext context,
    required IconData icon,
    required String orderId,
    required String status,
    required Color statusBgColor,
    required Color statusTextColor,
    required String productTitle,
    required String locationTime,
    required String price,
    required String paymentStatus,
    required Color paymentColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: const Color(0xFFF8FAFC),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE2E8F0), width: 1),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.015),
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          children: [
            // Icon in Light Blue Circle
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
              child: Icon(
                icon,
                color: const Color(0xFF142D4E),
                size: 20,
              ),
            ),
            const SizedBox(width: 12),

            // Middle Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        orderId,
                        style: const TextStyle(
                          color: Color(0xFF000000),
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
                        decoration: BoxDecoration(
                          color: statusBgColor,
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          status,
                          style: TextStyle(
                            color: statusTextColor,
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    productTitle,
                    style: const TextStyle(
                      fontFamily: 'Literata',
                      color: Color(0xFF000000),
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 1),
                  Text(
                    locationTime,
                    style: const TextStyle(
                      color: Color(0xFF000000),
                      fontSize: 10.5,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),

            // Right Column (Price & Payment)
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  price,
                  style: const TextStyle(
                    fontFamily: 'Literata',
                    color: Color(0xFF000000),
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  paymentStatus,
                  style: TextStyle(
                    color: paymentColor,
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // Dedicated Order Manager Bottom Button
  // ---------------------------------------------------------------------------
  Widget _buildDedicatedOrderManagerButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () => AppNavigator.toAdminOrderManagement(context),
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF142D4E),
          foregroundColor: const Color(0xFFF8FAFC),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(26),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            Icon(Icons.receipt_long_outlined, size: 20),
            SizedBox(width: 8),
            Text(
              'Open Dedicated Order Manager',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showOrderDetailsSheet(BuildContext context, {String orderId = '#TK-98241'}) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFFF8FAFC),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) {
        return Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF142D4E),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Order $orderId',
                    style: const TextStyle(
                      fontFamily: 'Literata',
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF142D4E),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Text(
                      'Live Tracking',
                      style: TextStyle(color: Color(0xFF142D4E), fontWeight: FontWeight.bold, fontSize: 11),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              const Text(
                'Customer: Mohammad Rahat • Banani, Dhaka\nItem: Chronos Ultra 2 Titanium (49mm GPS)\nFulfillment: Express Courier (Next-Day Delivery)',
                style: TextStyle(color: Color(0xFF000000), height: 1.5, fontSize: 13),
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                height: 46,
                child: ElevatedButton(
                  onPressed: () => AppNavigator.pop(ctx),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF142D4E),
                    foregroundColor: const Color(0xFFF8FAFC),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(23)),
                  ),
                  child: const Text('Close'),
                ),
              ),
              const SizedBox(height: 10),
            ],
          ),
        );
      },
    );
  }
}
