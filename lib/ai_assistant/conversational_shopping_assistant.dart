import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
  final ScrollController _scrollController = ScrollController();
  bool _isTyping = false;

  final List<Map<String, dynamic>> _messages = [
    {
      'type': 'ai_welcome',
      'text':
          'Hello! I can help you find compatible accessories, compare flagship specs, or track the best tech deals today. What are you looking to upgrade?',
    },
    {
      'type': 'user',
      'text':
          'I need a durable titanium smartwatch for outdoor trail running, plus a fast GaN charger.',
    },
    {
      'type': 'ai_response',
      'text':
          'I found 2 top-tier matches with aerospace titanium chassis and high-speed GaN fast-charging efficiency in stock right now:',
      'showProducts': true,
    },
    {
      'type': 'ai_followup',
      'text':
          'Would you like me to add both to your cart with the bundle discount applied, or compare battery endurance against the Chronos Active Pro?',
    },
  ];

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
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent + 80,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _handleSendMessage([String? manualText]) {
    final text = manualText ?? _inputController.text.trim();
    if (text.isEmpty) return;

    _inputController.clear();
    setState(() {
      _messages.add({
        'type': 'user',
        'text': text,
      });
      _isTyping = true;
    });
    _scrollToBottom();

    // Generate responsive intelligent AI reply
    Future.delayed(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        _isTyping = false;
        _messages.add({
          'type': 'ai_response',
          'text': _generateAiReply(text),
        });
      });
      _scrollToBottom();
    });
  }

  String _generateAiReply(String query) {
    final lower = query.toLowerCase();
    if (lower.contains('battery')) {
      return 'The Chronos Ultra 2 offers up to 72 hours of continuous multi-band GPS endurance with low-power battery optimization mode enabled.';
    } else if (lower.contains('gps') || lower.contains('trail')) {
      return 'Precision dual-frequency L1 & L5 GPS ensures accurate route tracking even through dense tree canopies and deep valleys.';
    } else if (lower.contains('charger') || lower.contains('gan')) {
      return 'The VoltFast 65W GaN dual-port charger can fast charge both your Chronos smartwatch and laptop simultaneously with full surge protection.';
    } else if (lower.contains('delivery') || lower.contains('shipping') || lower.contains('price')) {
      return 'Free express next-day delivery is included on all verified TechKart flagship purchases, backed by official local manufacturer warranty.';
    }
    return 'I checked our live catalog: your request matches certified TechKart hardware specs. Would you like me to reserve units or inspect technical benchmarks?';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final bottomInset = mediaQuery.viewInsets.bottom;
    final bottomPadding = mediaQuery.padding.bottom;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBCF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
                Expanded(
                  child: ListView.builder(
                    controller: _scrollController,
                    physics: const BouncingScrollPhysics(),
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                    itemCount: _messages.length + 1 + (_isTyping ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 14),
                          child: _buildTimestampHeader('Today, 10:24 AM'),
                        );
                      }
                      final msgIndex = index - 1;
                      if (msgIndex < _messages.length) {
                        final msg = _messages[msgIndex];
                        final type = msg['type'] as String;
                        final text = msg['text'] as String;
                        final showProducts = msg['showProducts'] == true;

                        if (type == 'ai_welcome') {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildAiWelcomeBubble(text),
                          );
                        } else if (type == 'user') {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildUserBubble(text),
                          );
                        } else if (type == 'ai_response') {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                _buildAiResponseBubble(text),
                                if (showProducts) ...[
                                  const SizedBox(height: 12),
                                  ..._matchedProducts.map(_buildProductCard),
                                ],
                              ],
                            ),
                          );
                        } else {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 14),
                            child: _buildAiFollowUpBubble(text),
                          );
                        }
                      }

                      // Typing indicator
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 14),
                        child: Row(
                          children: [
                            Container(
                              width: 28,
                              height: 28,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE6C17A),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF0D1B2A)),
                            ),
                            const SizedBox(width: 10),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                              decoration: BoxDecoration(
                                color: const Color(0xFFF5EBDD),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(color: const Color(0xFFE6C17A)),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const SizedBox(
                                    width: 12,
                                    height: 12,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      color: Color(0xFF0D1B2A),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    'TechKart AI is thinking...',
                                    style: GoogleFonts.literata(
                                      fontSize: 11,
                                      color: const Color(0xFF1B365D),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
                _buildSuggestedQuestionsRail(),
                _buildChatInputBar(bottomInset: bottomInset, bottomPadding: bottomPadding),
              ],
            ),
          ),
        );
  }

  // ---------------------------------------------------------------------------
  // CLEAN MINIMAL TOP APP BAR
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
              child: const Icon(Icons.arrow_back, size: 20, color: Color(0xFF0D1B2A)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              'TechKart AI',
              style: GoogleFonts.domine(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.camera_alt_outlined, size: 22, color: Color(0xFF0D1B2A)),
            onPressed: widget.onCameraPressed ??
                () => AppNavigator.toAiVisualSearchCamera(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          IconButton(
            icon: const Icon(Icons.notifications_none_outlined, size: 22, color: Color(0xFF0D1B2A)),
            onPressed: widget.onNotificationPressed ??
                () => AppNavigator.toNotifications(context),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 12),
          GestureDetector(
            onTap: widget.onProfilePressed ??
                () => AppNavigator.toCustomerProfileHub(context),
            child: const ProfileAvatar(size: 32),
          ),
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
          color: const Color(0xFFE6C17A),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          timestamp,
          style: GoogleFonts.literata(
            fontSize: 10.5,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF1B365D),
          ),
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // AI WELCOME BUBBLE
  // ---------------------------------------------------------------------------
  Widget _buildAiWelcomeBubble(String message) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: const BoxDecoration(
            color: Color(0xFFE6C17A),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF0D1B2A)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EBDD),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: const Color(0xFFE6C17A)),
            ),
            child: Text(
              message,
              style: GoogleFonts.literata(
                fontSize: 12.5,
                height: 1.45,
                color: const Color(0xFF0D1B2A),
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
          color: const Color(0xFF0D1B2A),
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
            color: const Color(0xFFF5EBDD),
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
            color: Color(0xFFE6C17A),
            shape: BoxShape.circle,
          ),
          child: const Icon(Icons.auto_awesome, size: 14, color: Color(0xFF0D1B2A)),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFF5EBDD),
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(16),
                bottomLeft: Radius.circular(16),
                bottomRight: Radius.circular(16),
              ),
              border: Border.all(color: const Color(0xFFE6C17A)),
            ),
            child: Text(
              message,
              style: GoogleFonts.literata(
                fontSize: 12.5,
                height: 1.45,
                color: const Color(0xFF0D1B2A),
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
        color: const Color(0xFFF5EBDD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6C17A)),
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
                      color: const Color(0xFFE6C17A),
                      child: Image.asset(
                        product['image'] as String,
                        fit: BoxFit.cover,
                        cacheWidth: 200,
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
                        color: const Color(0xFFE6C17A),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        product['badge'] as String,
                        style: TextStyle(
                          fontFamily: 'Literata',
                          fontSize: 8.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
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
                        color: const Color(0xFF0D1B2A),
                      ),
                    ),
                    Text(
                      product['subtitle'] as String,
                      style: GoogleFonts.literata(
                        fontSize: 10.5,
                        color: const Color(0xFF1B365D),
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
                            color: const Color(0xFF0D1B2A),
                          ),
                        ),
                        if (product['cutPrice'] != null) ...[
                          const SizedBox(width: 6),
                          Text(
                            product['cutPrice'] as String,
                            style: GoogleFonts.literata(
                              fontSize: 10.5,
                              color: const Color(0xFF1B365D),
                              decoration: TextDecoration.lineThrough,
                            ),
                          ),
                        ],
                        const Spacer(),
                        Text(
                          product['status'] as String,
                          style: GoogleFonts.literata(
                            fontSize: 10,
                            color: const Color(0xFF1B365D),
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
                      backgroundColor: const Color(0xFF0D1B2A),
                      foregroundColor: const Color(0xFFF5EBDD),
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
                  color: const Color(0xFFE6C17A),
                  borderRadius: BorderRadius.circular(19),
                ),
                child: const Icon(Icons.bookmark_border,
                    size: 16, color: Color(0xFF0D1B2A)),
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
        color: const Color(0xFFF5EBDD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6C17A)),
      ),
      child: Text(
        message,
        style: GoogleFonts.literata(
          fontSize: 12.5,
          height: 1.45,
          color: const Color(0xFF0D1B2A),
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
                  color: const Color(0xFF1B365D),
                ),
              ),
              Row(
                children: [
                  const Icon(Icons.tune, size: 12, color: Color(0xFF1B365D)),
                  const SizedBox(width: 4),
                  Text(
                    'Refine',
                    style: GoogleFonts.literata(
                      fontSize: 10.5,
                      fontWeight: FontWeight.w600,
                      color: const Color(0xFF1B365D),
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
    return GestureDetector(
      onTap: () {
        HapticFeedback.selectionClick();
        _handleSendMessage(label);
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE6C17A)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 13, color: const Color(0xFF0D1B2A)),
            const SizedBox(width: 6),
            Text(
              label,
              style: GoogleFonts.literata(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                color: const Color(0xFF0D1B2A),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CHAT INPUT BAR
  // ---------------------------------------------------------------------------
  Widget _buildChatInputBar({double bottomInset = 0.0, double bottomPadding = 0.0}) {
    // If keyboard is open, add bottomInset; if closed, add bottomPadding so it stays comfortably above Android gesture bar
    final double effectiveBottomPadding = bottomInset > 0 ? bottomInset + 8.0 : (bottomPadding > 0 ? bottomPadding + 10.0 : 16.0);

    return Container(
      padding: EdgeInsets.fromLTRB(16, 10, 16, effectiveBottomPadding),
      decoration: const BoxDecoration(
        color: Colors.transparent,
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
        decoration: BoxDecoration(
          color: const Color(0xFFE6C17A),
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: [
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                AppNavigator.toAiVisualSearchCamera(context);
              },
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                  color: Color(0xFFE6C17A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.image_outlined,
                    size: 18, color: Color(0xFF0D1B2A)),
              ),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: TextField(
                controller: _inputController,
                textInputAction: TextInputAction.send,
                onSubmitted: (value) => _handleSendMessage(value),
                style: GoogleFonts.literata(
                  fontSize: 12.5,
                  color: const Color(0xFF0D1B2A),
                ),
                decoration: InputDecoration(
                  filled: false,
                  fillColor: Colors.transparent,
                  border: InputBorder.none,
                  hintText: 'Ask about specs, compatibility, deals...',
                  hintStyle: GoogleFonts.literata(
                    fontSize: 12,
                    color: const Color(0xFF1B365D),
                  ),
                ),
              ),
            ),
            GestureDetector(
              onTap: () {
                HapticFeedback.lightImpact();
                _handleSendMessage();
              },
              child: Container(
                width: 32,
                height: 32,
                decoration: const BoxDecoration(
                  color: Color(0xFF0D1B2A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.arrow_upward, size: 16, color: Color(0xFFF5EBDD)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
