import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/network.dart';
import '../theme/profile_avatar.dart';

/// TechKart Checkout - Choose Payment Method Screen (SCR-29)
/// Recreated to match original reference UI with 100% visual fidelity.
class PaymentMethodScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onLockPressed;
  final VoidCallback? onProfilePressed;
  final ValueChanged<String>? onPaymentMethodSelected;
  final VoidCallback? onProceedToPay;
  final VoidCallback? onAddNewCard;

  const PaymentMethodScreen({
    super.key,
    this.onBack,
    this.onLockPressed,
    this.onProfilePressed,
    this.onPaymentMethodSelected,
    this.onProceedToPay,
    this.onAddNewCard,
  });

  @override
  State<PaymentMethodScreen> createState() => _PaymentMethodScreenState();
}

class _PaymentMethodScreenState extends State<PaymentMethodScreen> {
  String _selectedMethod = 'card'; // 'card', 'upi', 'netbanking', 'cod'
  bool _saveCard = true;
  bool _isSubmitting = false;
  final ApiClient _apiClient = ApiClient();
  final TextEditingController _cvvController = TextEditingController(text: '•••');

  final double _totalAmount = 40273.95; // ₹40,273.95 INR equivalent

  @override
  void dispose() {
    _apiClient.close();
    _cvvController.dispose();
    super.dispose();
  }

  void _handlePay() async {
    HapticFeedback.heavyImpact();
    if (_isSubmitting) return;

    if (widget.onProceedToPay != null) {
      widget.onProceedToPay!();
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final orderPayload = {
        'payment_method': _selectedMethod,
        'items': [
          {'product_id': 2, 'quantity': 1},
        ],
        'shipping_address': {
          'recipient_name': 'Tanvir Ahmed',
          'phone': '+91 98765-43210',
          'address_line1': 'House 42, Road 11, Block D, Bandra West',
          'city': 'Mumbai',
          'state': 'Maharashtra',
          'postal_code': '400050',
          'country': 'India',
        },
      };

      final response = await _apiClient.post('/customer/orders', body: orderPayload);

      if (!mounted) return;
      setState(() => _isSubmitting = false);

      final data = response.data is Map ? response.data as Map<String, dynamic> : <String, dynamic>{};
      final orderNum = data['order_number']?.toString() ?? 'TK-89421';

      if (_selectedMethod == 'cod') {
        AppNavigator.toOrderConfirmation(
          context,
          orderId: orderNum,
        );
      } else {
        AppNavigator.toSecurePayment(
          context,
        );
      }
    } catch (e) {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      AppNavigator.toSecurePayment(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDFBCF),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                children: [
                  _buildStepPillHeader(),
                  const SizedBox(height: 14),
                  _buildTitleHeader(),
                  const SizedBox(height: 14),
                  _buildSelectedItemsBanner(),
                  const SizedBox(height: 18),
                  _buildCreditDebitCardOption(),
                  const SizedBox(height: 12),
                  _buildUpiOption(),
                  const SizedBox(height: 12),
                  _buildNetBankingOption(),
                  const SizedBox(height: 12),
                  _buildCodOption(),
                  const SizedBox(height: 16),
                  _buildBankProtectionCard(),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            _buildStickyPayBar(),
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
              'Checkout',
              style: GoogleFonts.domine(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.lock_outline, size: 22, color: Color(0xFF0D1B2A)),
            onPressed: widget.onLockPressed ??
                () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'PCI-DSS compliant tokenized payment channel.',
                        style: GoogleFonts.literata(),
                      ),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 14),
          const ProfileAvatar(size: 32),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // STEP PILL HEADER (STEP 3 OF 3 • FINAL STEP)
  // ---------------------------------------------------------------------------
  Widget _buildStepPillHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE6C17A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 6,
                    height: 6,
                    decoration: const BoxDecoration(
                      color: Color(0xFF0D1B2A),
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'STEP 3 OF 3 • FINAL STEP',
                    style: GoogleFonts.literata(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(Icons.receipt_long_outlined,
                    size: 13, color: Color(0xFF1B365D)),
                const SizedBox(width: 4),
                Text(
                  'Order #TK-89421',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    color: const Color(0xFF1B365D),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 12),
        // Timeline Row
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _buildTimelinePill(icon: Icons.check, label: 'Address', isDone: true, isActive: false),
            _buildTimelinePill(icon: Icons.check, label: 'Review', isDone: true, isActive: false),
            _buildTimelinePill(icon: Icons.credit_card, label: 'Payment', isDone: false, isActive: true),
          ],
        ),
      ],
    );
  }

  Widget _buildTimelinePill({
    required IconData icon,
    required String label,
    required bool isDone,
    required bool isActive,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: isActive
            ? const Color(0xFFE6C17A)
            : const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 13,
            color: isActive ? const Color(0xFF0D1B2A) : const Color(0xFFB8860B),
          ),
          const SizedBox(width: 5),
          Text(
            label,
            style: GoogleFonts.literata(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: isActive ? const Color(0xFF0D1B2A) : const Color(0xFFB8860B),
            ),
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // TITLE HEADER
  // ---------------------------------------------------------------------------
  Widget _buildTitleHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Choose Payment Method',
          style: GoogleFonts.domine(
            fontSize: 20,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF0D1B2A),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Select your preferred secure payment channel to confirm reservation & dispatch.',
          style: GoogleFonts.literata(
            fontSize: 12,
            height: 1.35,
            color: const Color(0xFF1B365D),
          ),
        ),
      ],
    );
  }

  // ---------------------------------------------------------------------------
  // SELECTED ITEMS BANNER
  // ---------------------------------------------------------------------------
  Widget _buildSelectedItemsBanner() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE6C17A)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: const BoxDecoration(
              color: Color(0xFFE6C17A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.shopping_bag_outlined,
                size: 18, color: Color(0xFF0D1B2A)),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '2 Selected Items',
                  style: GoogleFonts.domine(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
                Text(
                  'Chronos Ultra 2 + VoltFast ...',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    color: const Color(0xFF1B365D),
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '₹${_totalAmount.toStringAsFixed(2)}',
                style: GoogleFonts.domine(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1B2A),
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Details',
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                  const Icon(Icons.keyboard_arrow_down,
                      size: 14, color: Color(0xFF1B365D)),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CREDIT / DEBIT CARD OPTION (EXPANDED BY DEFAULT)
  // ---------------------------------------------------------------------------
  Widget _buildCreditDebitCardOption() {
    final isSelected = _selectedMethod == 'card';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFFF5EBDD),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFE6C17A),
          width: isSelected ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: () => setState(() => _selectedMethod = 'card'),
                child: Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFF5EBDD),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFE6C17A),
                      width: 1.5,
                    ),
                  ),
                  child: isSelected
                      ? const Icon(Icons.check, size: 13, color: Color(0xFFF5EBDD))
                      : null,
                ),
              ),
              const SizedBox(width: 10),
              Text(
                'Credit / Debit Card',
                style: GoogleFonts.domine(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF0D1B2A),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6C17A),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Recommended',
                  style: GoogleFonts.literata(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
              ),
              const Spacer(),
              // VISA & MC badges
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6C17A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'VISA',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF0D1B2A),
                  ),
                ),
              ),
              const SizedBox(width: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1.5),
                decoration: BoxDecoration(
                  color: const Color(0xFFE6C17A),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: const Text(
                  'MC',
                  style: TextStyle(
                    fontSize: 9.5,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFFB8860B),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Padding(
            padding: const EdgeInsets.only(left: 30),
            child: Text(
              'Visa, Mastercard, American Express, RuPay',
              style: GoogleFonts.literata(
                fontSize: 11,
                color: const Color(0xFF1B365D),
              ),
            ),
          ),
          if (isSelected) ...[
            const SizedBox(height: 14),
            // Saved Card Tile
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFE6C17A),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          const Icon(Icons.credit_card, size: 16, color: Color(0xFF0D1B2A)),
                          const SizedBox(width: 8),
                          Text(
                            'TechKart Platinum',
                            style: GoogleFonts.domine(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF0D1B2A),
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '•••• 4829',
                        style: GoogleFonts.literata(
                          fontSize: 12.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'CARDHOLDER',
                            style: GoogleFonts.literata(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                          Text(
                            'Tanvir Ahmed',
                            style: GoogleFonts.literata(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D1B2A),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            'EXPIRES',
                            style: GoogleFonts.literata(
                              fontSize: 9,
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                          Text(
                            '08/27',
                            style: GoogleFonts.literata(
                              fontSize: 11.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D1B2A),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 12),
            // CVV / CVC Security Code
            Text(
              'CVV / CVC Security Code',
              style: GoogleFonts.literata(
                fontSize: 11.5,
                fontWeight: FontWeight.w700,
                color: const Color(0xFF0D1B2A),
              ),
            ),
            const SizedBox(height: 6),
            Row(
              children: [
                Container(
                  width: 90,
                  height: 38,
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE6C17A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFFE6C17A)),
                  ),
                  child: Row(
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _cvvController,
                          keyboardType: TextInputType.number,
                          obscureText: true,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            letterSpacing: 2.0,
                          ),
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            isDense: true,
                            contentPadding: EdgeInsets.zero,
                          ),
                        ),
                      ),
                      const Icon(Icons.help_outline, size: 14, color: Color(0xFF1B365D)),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Text(
                    '3 or 4 digits located on signature strip',
                    style: GoogleFonts.literata(
                      fontSize: 10.5,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                GestureDetector(
                  onTap: () => setState(() => _saveCard = !_saveCard),
                  child: Container(
                    width: 18,
                    height: 18,
                    decoration: BoxDecoration(
                      color: _saveCard ? const Color(0xFF0D1B2A) : const Color(0xFFF5EBDD),
                      borderRadius: BorderRadius.circular(4),
                      border: Border.all(
                        color: _saveCard ? const Color(0xFF0D1B2A) : const Color(0xFFE6C17A),
                      ),
                    ),
                    child: _saveCard
                        ? const Icon(Icons.check, size: 12, color: Color(0xFFF5EBDD))
                        : null,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  'Save card securely for 1-click checkout',
                  style: GoogleFonts.literata(
                    fontSize: 11.5,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: [
                const Icon(Icons.add_card, size: 14, color: Color(0xFF0D1B2A)),
                const SizedBox(width: 6),
                Text(
                  '+ Add New Card',
                  style: GoogleFonts.literata(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // UPI & MOBILE WALLET OPTION
  // ---------------------------------------------------------------------------
  Widget _buildUpiOption() {
    final isSelected = _selectedMethod == 'upi';

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = 'upi'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFE6C17A),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFF5EBDD),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFE6C17A),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 13, color: Color(0xFFF5EBDD))
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'UPI & Mobile Wallet',
                        style: GoogleFonts.domine(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6C17A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Instant',
                          style: TextStyle(
                            fontFamily: 'Literata',
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFFB8860B),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Google Pay, PhonePe, Paytm, BHIM UPI',
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFE6C17A),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.qr_code_scanner, size: 16, color: Color(0xFF0D1B2A)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // NET BANKING OPTION
  // ---------------------------------------------------------------------------
  Widget _buildNetBankingOption() {
    final isSelected = _selectedMethod == 'netbanking';

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = 'netbanking'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFE6C17A),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFF5EBDD),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFE6C17A),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 13, color: Color(0xFFF5EBDD))
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Net Banking',
                    style: GoogleFonts.domine(
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '50+ authorized commercial & private banks',
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFE6C17A),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.account_balance_outlined, size: 16, color: Color(0xFF0D1B2A)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // CASH ON DELIVERY (COD) OPTION
  // ---------------------------------------------------------------------------
  Widget _buildCodOption() {
    final isSelected = _selectedMethod == 'cod';

    return GestureDetector(
      onTap: () => setState(() => _selectedMethod = 'cod'),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFFF5EBDD),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFE6C17A),
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFF5EBDD),
                shape: BoxShape.circle,
                border: Border.all(
                  color: isSelected ? const Color(0xFF0D1B2A) : const Color(0xFFE6C17A),
                  width: 1.5,
                ),
              ),
              child: isSelected
                  ? const Icon(Icons.check, size: 13, color: Color(0xFFF5EBDD))
                  : null,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        'Cash on Delivery (COD)',
                        style: GoogleFonts.domine(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6C17A),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          'Eligible',
                          style: TextStyle(
                            fontFamily: 'Literata',
                            fontSize: 9.5,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0D1B2A),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    'Pay via cash or POS card machine at your doorstep',
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(6),
              decoration: const BoxDecoration(
                color: Color(0xFFE6C17A),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.payments_outlined, size: 16, color: Color(0xFF0D1B2A)),
            ),
          ],
        ),
      ),
    );
  }

  // ---------------------------------------------------------------------------
  // BANK-GRADE PROTECTION CARD
  // ---------------------------------------------------------------------------
  Widget _buildBankProtectionCard() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFFE6C17A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE6C17A)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: const BoxDecoration(
              color: Color(0xFFE6C17A),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.verified_user, size: 16, color: Color(0xFF0D1B2A)),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Bank-Grade 256-Bit SSL Protection',
                  style: GoogleFonts.domine(
                    fontSize: 12.5,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF0D1B2A),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'TechKart Buyer Assurance guarantees an immediate 100% refund for damaged packages, transit delays, or unfulfilled merchant orders.',
                  style: GoogleFonts.literata(
                    fontSize: 11,
                    height: 1.35,
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
  // STICKY PAY BAR
  // ---------------------------------------------------------------------------
  Widget _buildStickyPayBar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: Color(0xFFF5EBDD),
        border: Border(top: BorderSide(color: Color(0xFFE6C17A), width: 1)),
        boxShadow: [
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 10,
            offset: Offset(0, -3),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'TOTAL PAYABLE',
                    style: GoogleFonts.literata(
                      fontSize: 9.5,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.5,
                      color: const Color(0xFF1B365D),
                    ),
                  ),
                  Text(
                    '₹${_totalAmount.toStringAsFixed(2)}',
                    style: GoogleFonts.domine(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0D1B2A),
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: SizedBox(
                  height: 48,
                  child: ElevatedButton(
                    onPressed: _handlePay,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0D1B2A),
                      foregroundColor: const Color(0xFFF5EBDD),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.lock_outline, size: 16, color: Color(0xFFF5EBDD)),
                        const SizedBox(width: 8),
                        Text(
                          'Pay ₹${_totalAmount.toStringAsFixed(2)}',
                          style: GoogleFonts.literata(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(Icons.arrow_forward, size: 16, color: Color(0xFFF5EBDD)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.check_circle_outline, size: 12, color: Color(0xFF1B365D)),
              const SizedBox(width: 4),
              Text(
                'PCI-DSS Level 1 Compliant • Encrypted Checkout',
                style: GoogleFonts.literata(
                  fontSize: 10.5,
                  color: const Color(0xFF1B365D),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
