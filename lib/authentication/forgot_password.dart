import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/session_manager.dart';

/// TechKart Forgot Password Screen
///
/// 100% visual fidelity reproduction of the Forgot Password reference screen:
/// - Light airy background (#F5FAFF)
/// - Top bar: Circular soft back button on the left, TechKart logo mark on the right.
/// - Top pill badge: "PASSWORD RECOVERY" with lock outline icon in soft light-blue capsule (#EBF5FE).
/// - Headline: "Forgot password." in bold Domine serif font (#00344B).
/// - Subtitle: "Enter the email address registered with\nyour account to receive a verification code." in Literata font (#4A5568).
/// - Text Field: "Email or Mobile Phone" with identity badge / contact card icon,
///   prefilled with `aarav.sharma@techkart.in`.
/// - Helper text: "We'll send a 6-digit one-time code to reset your password." in Literata font.
/// - Primary action button: Full-width Midnight Navy button (#00344B) with "Send Reset Code →" text.
/// - Security info card: Soft light-blue container (#EAF5FF) with circular shield icon and text:
///   "Protected by TechKart Security\n256-bit SSL encrypted recovery process safeguarding your account credentials."
/// - Footer: "Remember your password? Sign In" with underlined link.
/// - Bottom home indicator capsule.
///
/// Strictly frontend only: Preserves navigation to OTP verification with Indian target.
class ForgotPasswordScreen extends StatefulWidget {
  final VoidCallback? onResetCodeSent;
  final VoidCallback? onSignInTapped;

  const ForgotPasswordScreen({
    super.key,
    this.onResetCodeSent,
    this.onSignInTapped,
  });

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  final ApiClient _apiClient = ApiClient();

  bool _isLoading = false;

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    final cachedEmail = SessionManager().userEmail;
    if (cachedEmail != null && cachedEmail.isNotEmpty) {
      _emailPhoneController.text = cachedEmail;
    }

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _entranceController, curve: Curves.easeOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.03), end: Offset.zero).animate(
          CurvedAnimation(
            parent: _entranceController,
            curve: Curves.easeOutCubic,
          ),
        );

    _entranceController.forward();
  }

  @override
  void dispose() {
    _emailPhoneController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _handleSendResetCode() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    final email = _emailPhoneController.text.trim().toLowerCase();
    if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$').hasMatch(email)) {
      _showError('Enter the email address registered with your account.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiClient.post<void>(
        '/customer/auth/forgot-password',
        body: {'email': email},
        requiresAuth: false,
      );

      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });

      if (widget.onResetCodeSent != null) {
        widget.onResetCodeSent!();
      } else {
        AppNavigator.toOtpVerification(context, destinationTarget: email);
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError(e.message);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Unable to send the reset code right now. Please try again.');
    }
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: GoogleFonts.literata(
            fontSize: 13.5,
            fontWeight: FontWeight.w500,
          ),
        ),
        backgroundColor: const Color(0xFF142D4E),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _navigateToSignIn() {
    HapticFeedback.selectionClick();
    if (widget.onSignInTapped != null) {
      widget.onSignInTapped!();
    } else {
      AppNavigator.toLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFFFFFFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        top: false,
        bottom: false,
        child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          behavior: HitTestBehavior.translucent,
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: SlideTransition(
              position: _slideAnimation,
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: topPadding > 0 ? topPadding + 8 : 28),

                        // ---------------------------------------------------
                        // TOP APP BAR: Circular Back Button + Logo Mark
                        // ---------------------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            InkWell(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                } else {
                                  AppNavigator.toLogin(context);
                                }
                              },
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF142D4E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 16,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              width: 38,
                              height: 38,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                              ),
                              child: ClipOval(
                                child: Image.asset(
                                  'asset/app_logo.png',
                                  fit: BoxFit.cover,
                                  errorBuilder: (context, error, stackTrace) =>
                                      Image.asset(
                                    'asset/app_launcher_icon.png',
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ---------------------------------------------------
                        // TOP PILL BADGE: PASSWORD RECOVERY
                        // ---------------------------------------------------
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF142D4E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.lock_outline_rounded,
                                size: 14,
                                color: Color(0xFF000000),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'PASSWORD RECOVERY',
                                style: GoogleFonts.literata(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.9,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // ---------------------------------------------------
                        // HEADLINE: "Forgot password."
                        // ---------------------------------------------------
                        Text(
                          'Forgot password.',
                          style: GoogleFonts.literata(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF000000),
                            letterSpacing: -0.6,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ---------------------------------------------------
                        // SUBTITLE: "Enter your registered email..."
                        // ---------------------------------------------------
                        Text(
                          'Enter the email address registered with\nyour account to receive a verification code.',
                          style: GoogleFonts.literata(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF000000),
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ---------------------------------------------------
                        // FIELD: "Email or Mobile Phone"
                        // ---------------------------------------------------
                        Text(
                          'Email Address',
                          style: GoogleFonts.literata(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF000000),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFF142D4E),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: _emailPhoneController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.literata(
                              fontSize: 14.5,
                              color: const Color(0xFF000000),
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 14, right: 10),
                                child: Icon(
                                  Icons.mail_outline_rounded,
                                  size: 21,
                                  color: Color(0xFF000000),
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 44,
                                minHeight: 24,
                              ),
                              hintText: 'name@example.com',
                              hintStyle: GoogleFonts.literata(
                                fontSize: 14.5,
                                color: const Color(0xFF000000),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // ---------------------------------------------------
                        // HELPER TEXT
                        // ---------------------------------------------------
                        Text(
                          'We\'ll send a 6-digit one-time code to reset your password.',
                          style: GoogleFonts.literata(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF000000),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ---------------------------------------------------
                        // PRIMARY BUTTON: "Send Reset Code ->"
                        // ---------------------------------------------------
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSendResetCode,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF142D4E),
                              foregroundColor: const Color(0xFFF8FAFC),
                              disabledBackgroundColor: const Color(
                                0xFF142D4E,
                              ).withValues(alpha: 0.6),
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(28),
                              ),
                            ),
                            child: _isLoading
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(
                                      strokeWidth: 2,
                                      valueColor: AlwaysStoppedAnimation<Color>(
                                        Color(0xFFF8FAFC),
                                      ),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Send Reset Code',
                                        style: GoogleFonts.literata(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFFF8FAFC),
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 18,
                                        color: Color(0xFFF8FAFC),
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 26),

                        // ---------------------------------------------------
                        // SECURITY CARD: Protected by TechKart Security
                        // ---------------------------------------------------
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF142D4E),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF142D4E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.verified_user_outlined,
                                    size: 20,
                                    color: Color(0xFF000000),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Protected by TechKart Security',
                                      style: GoogleFonts.literata(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF000000),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      '256-bit SSL encrypted recovery process safeguarding your account credentials.',
                                      style: GoogleFonts.literata(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF000000),
                                        height: 1.35,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 36),

                        // ---------------------------------------------------
                        // FOOTER: "Remember your password? Sign In"
                        // ---------------------------------------------------
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Remember your password? ',
                                style: GoogleFonts.literata(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToSignIn,
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  'Sign In',
                                  style: GoogleFonts.literata(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF000000),
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(0xFF142D4E),
                                    decorationThickness: 1.5,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 24),

                        // ---------------------------------------------------
                        // BOTTOM HOME INDICATOR BAR
                        // ---------------------------------------------------
                        Center(
                          child: Container(
                            width: 134,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF142D4E),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        SizedBox(
                          height: bottomPadding > 0 ? bottomPadding + 4 : 16,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
