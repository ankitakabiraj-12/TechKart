import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../theme/profile_avatar.dart';

/// TechKart Conversational Shopping Assistant Screen
/// Recreated to match original UI reference with 100% visual fidelity.
class ConversationalShoppingAssistantScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onCameraPressed;
  final VoidCallback? onNotificationPressed;
  final VoidCallback? onProfilePressed;
  final bool showBottomNav;
  final ValueChanged<int>? onNavTabSelected;

  const ConversationalShoppingAssistantScreen({
    super.key,
    this.onBack,
    this.onCameraPressed,
    this.onNotificationPressed,
    this.onProfilePressed,
    this.showBottomNav = true,
    this.onNavTabSelected,
  });

  @override
  State<ConversationalShoppingAssistantScreen> createState() =>
      _ConversationalShoppingAssistantScreenState();
}

class _ConversationalShoppingAssistantScreenState
    extends State<ConversationalShoppingAssistantScreen> {
  final TextEditingController _inputController = TextEditingController();

  final List<Map<String, dynamic>> _matchedProducts = [
    {
      'title': 'Chronos Ultra 2 (49mm GPS)',
      'subtitle': 'Grade 5 Titanium • 3000 Nit LTPO',
      'price': '₹35,499.00',
      'cutPrice': '₹41,499.00',
      'status': 'In Stock (3)',
      'badge': '99% Match',
      'image': 'asset/chronos_ultra_2.jpg',
    },
    {
      'title': 'VoltFast 65W GaN Dual US...',
      'subtitle': 'Ultra Compact • 45W+20W Split',
      'price': '₹3,999.00',
      'status': 'Free Next-Day Shipping',
      'badge': 'Bundle Save ₹800',
      'image': 'asset/carousel_fast_gan_charger.jpg',
    },
  ];

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
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
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  _buildTimestampHeader('Today, 10:24 AM'),
                  const SizedBox(height: 14),
                  _buildAiWelcomeBubble(),
                  const SizedBox(height: 14),
                  _buildUserBubble(
                    'I need a durable titanium smartwatch for outdoor trail running, plus a fast GaN charger.',
                  ),
                  const SizedBox(height: 16),
                  _buildAiResponseBubble(
                    'I found 2 top-tier matches with aerospace titanium chassis and high-speed GaN fast-charging efficiency in stock right now:',
                  ),
                  const SizedBox(height: 12),
                  ..._matchedProducts.map(_buildProductCard),
                  const SizedBox(height: 12),
                  _buildAiFollowUpBubble(
                    'Would you like me to add both to your cart with the bundle discount applied, or compare battery endurance against the Chronos Active Pro?',
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            _buildSuggestedQuestionsRail(),
            _buildChatInputBar(),
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
        border: Border(
          bottom: BorderSide(color: Color(0xFFE2EDF3), width: 1),
        ),
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
              child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF00344B)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'TechKart AI',
              style: GoogleFonts.domine(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, size: 22, color: Color(0xFF0F172A)),
            onPressed: widget.onCameraPressed ??
                () => AppNavigator.toAiVisualSearchCamera(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 22, color: Color(0xFF0F172A)),
            onPressed: widget.onNotificationPressed ??
                () => AppNavigator.toNotifications(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          const ProfileAvatar(size: 32),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TIMESTAMP HEADER
  // ---------------------------------------------------------------------------
  Widget _buildTimestampHeader(String timestamp) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFEAF5FF),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          timestamp,
          style: GoogleFonts.literata(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF64748B),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // AI WELCOME BUBBLE
  // ---------------------------------------------------------------------------
  Widget _buildAiWelcomeBubble() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFFDCEEFB),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF00344B)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: const Color(0xFFE2EDF3)),
            ),
            child: Text(
              'Hello! I can help you find compatible accessories, compare flagship specs, or track the best tech deals today. What are you looking to upgrade?',
              style: GoogleFonts.literata(
                fontSize: 12.5,
                height: 1.45,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // USER BUBBLE
  // ---------------------------------------------------------------------------
  Widget _buildUserBubble(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 300),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF00344B),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(4),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(16),
          ),
        ),
        child: Text(
          message,
          style: GoogleFonts.literata(
            fontSize: 12.5,
            height: 1.4,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // AI RESPONSE BUBBLE
  // ---------------------------------------------------------------------------
  Widget _buildAiResponseBubble(String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFFDCEEFB),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF00344B)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: const Color(0xFFE2EDF3)),
            ),
            child: Text(
              message,
              style: GoogleFonts.literata(
                fontSize: 12.5,
                height: 1.45,
                color: const Color(0xFF0F172A),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // PRODUCT CARD
  // ---------------------------------------------------------------------------
  Widget _buildProductCard(Map<String, dynamic> product) {
    return Container(
      margin: const EdgeInsets.only(left: 38, bottom: 12),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EDF3)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x04000000),
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: Container(
                      width: 58,
                      height: 58,
                      color: const Color(0xFFF1F5F9),
                      child: Image.asset(
                        product['image'] as String,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) =>
                            const Icon(Icons.devices, size: 24, color: Colors.grey),
                      ),
                    ),
                  ),
                  Positioned(
                    top: 2,
                    left: 2,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1.5),
                      decoration: BoxDecoration(
                        color: const Color(0xFFEAF5FF),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product['badge'] as String,
                        style: TextStyle(
                          fontFamily: 'Literata',
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF00344B),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product['title'] as String,
                      style: GoogleFonts.domine(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF0F172A),
                      ),
                    ),
                    Text(
                      product['subtitle'] as String,
                      style: GoogleFonts.literata(
                        fontSize: 10.5,
                        color: const Color(0xFF64748B),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Text(
                          product['price'] as String,
                          style: GoogleFonts.domine(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0F172A),
                          ),
                        ),
                        if (product['cutPrice'] != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            product['cutPrice'] as String,
                            style: GoogleFonts.literata(
                              fontSize: 10.5,
                              color: const Color(0xFF94A3B8),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          product['status'] as String,
                          style: GoogleFonts.literata(
                            fontSize: 10,
                            color: const Color(0xFF64748B),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Expanded(
                child: SizedBox(
                  height: 38,
                  child: ElevatedButton(
                    onPressed: () => AppNavigator.toProductDetails(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF00344B),
                      foregroundColor: Colors.white,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(19),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'View Product',
                          style: GoogleFonts.literata(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward, size: 14),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                height: 38,
                width: 38,
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5FF),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: const Icon(Icons.bookmark_border,
                    size: 16, color: Color(0xFF00344B)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // AI FOLLOW UP BUBBLE
  // ---------------------------------------------------------------------------
  Widget _buildAiFollowUpBubble(String message) {
    return Container(
      margin: const EdgeInsets.only(left: 38),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EDF3)),
      ),
      child: Text(
        message,
        style: GoogleFonts.literata(
          fontSize: 12.5,
          height: 1.45,
          color: const Color(0xFF0F172A),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // SUGGESTED QUESTIONS RAIL
  // ---------------------------------------------------------------------------
  Widget _buildSuggestedQuestionsRail() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'SUGGESTED QUESTIONS',
                style: GoogleFonts.literata(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: const Color(0xFF64748B),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.tune, size: 12, color: Color(0xFF64748B)),
                  const SizedBox(width: 4),
                  Text(
                    'Refine',
                    style: GoogleFonts.literata(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildPromptChip('Compare battery life', Icons.battery_charging_full),
                const SizedBox(width: 8),
                _buildPromptChip('Check trail GPS accuracy', Icons.check_circle_outline),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPromptChip(String label, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE2EDF3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 13, color: const Color(0xFF00344B)),
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.literata(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: const Color(0xFF0F172A),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CHAT INPUT BAR
  // ---------------------------------------------------------------------------
  Widget _buildChatInputBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Color(0xFFE2EDF3), width: 1)),
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFF1F5F9),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFEAF5FF),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.image_outlined,
                  size: 18, color: Color(0xFF00344B)),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _inputController,
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  color: const Color(0xFF0F172A),
                ),
                decoration: InputDecoration(
                  border: InputBorder.none,
                  hintText: 'Ask about specs, compatibility, deals...',
                  hintStyle: GoogleFonts.literata(
                    fontSize: 12,
                    color: const Color(0xFF94A3B8),
                  ),
                ),
              ),
            ),
            Container(
              width: 32,
              height: 32,
              decoration: const BoxDecoration(
                color: Color(0xFF00344B),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.arrow_upward, size: 16, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }
}
