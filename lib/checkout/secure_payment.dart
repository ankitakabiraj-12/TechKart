import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';

/// TechKart Checkout - Secure Payment Processing Screen (SCR-30)
/// Recreated to match original UI reference with 100% visual fidelity.
class SecurePaymentScreen extends StatefulWidget {
  final double amount;
  final String currency;
  final String orderId;
  final String cardLast4;
  final String? transactionReference;
  final Duration simulationDuration;
  final bool autoSimulate;
  final VoidCallback? onPaymentCompleted;
  final VoidCallback? onBack;

  const SecurePaymentScreen({
    super.key,
    this.amount = 40273.95,
    this.currency = 'INR',
    this.orderId = 'TK-89421',
    this.cardLast4 = '4829',
    this.transactionReference,
    this.simulationDuration = const Duration(seconds: 4),
    this.autoSimulate = true,
    this.onPaymentCompleted,
    this.onBack,
  });

  @override
  State<SecurePaymentScreen> createState() => _SecurePaymentScreenState();
}

class _SecurePaymentScreenState extends State<SecurePaymentScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _rotationController;
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    if (widget.autoSimulate) {
      _timer = Timer(widget.simulationDuration, () {
        if (mounted) {
          if (widget.onPaymentCompleted != null) {
            widget.onPaymentCompleted!();
          } else {
            AppNavigator.toOrderConfirmation(context);
          }
        }
      });
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _rotationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6FAFC),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            children: [
              // Top Session Pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5FF),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFD3E7F8)),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.lock_outline, size: 14, color: Color(0xFF00344B)),
                    const SizedBox(width: 6),
                    Text(
                      '256-BIT SSL ENCRYPTED SESSION',
                      style: GoogleFonts.literata(
                        fontSize: 10.5,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.8,
                        color: const Color(0xFF00344B),
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              // Animated Circular Orbit Radar
              RotationTransition(
                turns: _rotationController,
                child: Container(
                  width: 140,
                  height: 140,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFFDCEEFB),
                      width: 4,
                    ),
                  ),
                  child: Center(
                    child: Container(
                      width: 100,
                      height: 100,
                      decoration: const BoxDecoration(
                        color: Color(0xFFEAF5FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.security,
                          size: 38,
                          color: Color(0xFF00344B),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 36),
              // Amount in INR
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    '₹${widget.amount.toStringAsFixed(2)}',
                    style: GoogleFonts.domine(
                      fontSize: 32,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF0F172A),
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    'INR',
                    style: GoogleFonts.literata(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Order # pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFF3EEE4),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  'Order #${widget.orderId}',
                  style: TextStyle(
                    fontFamily: 'Literata',
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF8B6B2B),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              // Title and Subtitle
              Text(
                'Processing Payment\nsecurely...',
                textAlign: TextAlign.center,
                style: GoogleFonts.domine(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                  height: 1.25,
                  color: const Color(0xFF0F172A),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Please do not refresh, close the\napp, or press back while we\ncommunicate with your bank.',
                textAlign: TextAlign.center,
                style: GoogleFonts.literata(
                  fontSize: 13,
                  height: 1.45,
                  color: const Color(0xFF64748B),
                ),
              ),
              const Spacer(),
              // Authorizing card capsule
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF5FF),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFD3E7F8)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.credit_card, size: 16, color: Color(0xFF00344B)),
                    const SizedBox(width: 8),
                    Text(
                      'Authorizing card ending in •••• ${widget.cardLast4}',
                      style: GoogleFonts.literata(
                        fontSize: 12.5,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFF00344B),
                      ),
                    ),
                    const SizedBox(width: 8),
                    const Text('•••', style: TextStyle(letterSpacing: 2, color: Color(0xFF00344B))),
                  ],
                ),
              ),
              const SizedBox(height: 14),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shield_outlined, size: 14, color: Color(0xFF64748B)),
                  const SizedBox(width: 6),
                  Text(
                    'TechKart End-to-End Buyer Protection',
                    style: GoogleFonts.literata(
                      fontSize: 11,
                      color: const Color(0xFF64748B),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
