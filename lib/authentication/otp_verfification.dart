import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import '../core/session_manager.dart';

/// TechKart OTP Verification Screen
///
/// 100% visual fidelity reproduction of the OTP Verification reference screen:
/// - Light airy background (#F5FAFF)
/// - Top bar: Circular soft back button on the left, TechKart logo mark on the right.
/// - Top pill badge: "SECURE OTP VERIFICATION" with shield icon in soft light-blue capsule (#EBF5FE).
/// - Headline: "Verify code." in bold Domine serif font (#00344B).
/// - Subtitle with bold Indian target & Edit email action:
///   "We sent a 6-digit verification code to
///    aarav.sharma@techkart.in. Enter it below to
///    confirm your identity. Edit email"
/// - 6 OTP digit containers:
///   - Digits 1-4: prefilled '4', '8', '2', '9' with soft light-blue fill (#EBF5FE).
///   - Digit 5 (active): white container with subtle shadow, soft border (#CBD5E1), and vertical cursor bar (#0E5B75).
///   - Digit 6 (empty): soft light-blue fill (#EBF5FE) with centered dot indicator.
/// - Resend Code Row:
///   - Clock icon with "Resend code in 00:46" on left.
///   - Disabled/soft "Resend Code" link on right.
/// - Security Handshake Card:
///   - Soft light-blue background (#EAF5FF) with white circular lock shield icon.
///   - Title: "Encrypted Handshake •" with blue bullet.
///   - Body: "One-time code expires in 10 minutes.\nNever share this code with anyone."
/// - Primary action button: Full-width Midnight Navy button (#00344B) with "Verify & Continue →" text.
/// - Footer: "Having trouble? Contact Support" with bold underlined link.
/// - Bottom home indicator capsule.
///
/// Strictly frontend only: Preserves navigation to SetNewPasswordScreen.
enum OtpFlowType {
  passwordReset,
  registration,
}

class OtpVerificationScreen extends StatefulWidget {
  final String destinationTarget;
  final OtpFlowType flowType;
  final VoidCallback? onVerificationSuccess;
  final VoidCallback? onResendCode;
  final VoidCallback? onEditEmail;
  final VoidCallback? onContactSupport;

  const OtpVerificationScreen({
    super.key,
    this.destinationTarget = '',
    this.flowType = OtpFlowType.passwordReset,
    this.onVerificationSuccess,
    this.onResendCode,
    this.onEditEmail,
    this.onContactSupport,
  });

  @override
  State<OtpVerificationScreen> createState() => _OtpVerificationScreenState();
}

class _OtpVerificationScreenState extends State<OtpVerificationScreen>
    with SingleTickerProviderStateMixin {
  final ApiClient _apiClient = ApiClient();
  final TextEditingController _pinController = TextEditingController();
  final FocusNode _pinFocusNode = FocusNode();

  int _secondsRemaining = 60;
  Timer? _countdownTimer;
  bool _isLoading = false;

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool _showCursor = true;
  Timer? _cursorTimer;

  String get _email {
    final configured = widget.destinationTarget.trim().toLowerCase();
    if (configured.isNotEmpty) return configured;
    return (SessionManager().userEmail ?? '').toLowerCase();
  }

  @override
  void initState() {
    super.initState();

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
    _startCountdown();
    _startCursorBlink();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        if (mounted) {
          setState(() {
            _secondsRemaining--;
          });
        }
      } else {
        timer.cancel();
      }
    });
  }

  void _startCursorBlink() {
    _cursorTimer = Timer.periodic(const Duration(milliseconds: 550), (timer) {
      if (mounted) {
        setState(() {
          _showCursor = !_showCursor;
        });
      }
    });
  }

  Future<void> _handleResend() async {
    if (_secondsRemaining > 0 || _isLoading) return;
    HapticFeedback.selectionClick();

    final email = _email;
    if (email.isEmpty) {
      _showError('Enter the email address registered with your account.');
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (widget.flowType == OtpFlowType.registration) {
        await _apiClient.post<void>(
          '/customer/auth/resend-register-otp',
          body: {'email': email},
          requiresAuth: false,
        );
      } else {
        await _apiClient.post<void>(
          '/customer/auth/forgot-password',
          body: {'email': email},
          requiresAuth: false,
        );
      }
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _secondsRemaining = 60;
      });
      _startCountdown();
      widget.onResendCode?.call();
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Unable to resend the code right now. Please try again.');
    }
  }

  Future<void> _handleVerify() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    if (_isLoading) return;

    final email = _email;
    final otp = _pinController.text.trim();
    if (email.isEmpty) {
      _showError('Enter the email address registered with your account.');
      return;
    }
    if (otp.length != 6) {
      _showError('Enter the 6-digit verification code.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.flowType == OtpFlowType.registration) {
        final response = await _apiClient.post<Map<String, dynamic>>(
          '/customer/auth/verify-register-otp',
          body: {'email': email, 'otp': otp},
          requiresAuth: false,
          fromJsonData: (data) =>
              data is Map<String, dynamic> ? data : <String, dynamic>{},
        );

        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        if (response.success && response.data != null) {
          final data = response.data!;
          final token = data['token'] as String?;
          final userData = data['user'];

          if (token != null && token.isNotEmpty) {
            final refreshToken = data['refresh_token'] as String?;
            if (userData != null && userData is Map<String, dynamic>) {
              await SessionManager().saveSession(
                token: token,
                userData: userData,
                refreshToken: refreshToken,
              );
            } else {
              await _apiClient.tokenStorage.saveToken(token);
              if (refreshToken != null) {
                await _apiClient.tokenStorage.saveRefreshToken(refreshToken);
              }
            }
            await SessionManager().setOnboardingCompleted();

            HapticFeedback.mediumImpact();

            if (!mounted) return;
            if (widget.onVerificationSuccess != null) {
              widget.onVerificationSuccess!();
            } else {
              AppNavigator.toMainShell(context);
            }
            return;
          }
        }

        _showError(
          response.message.isNotEmpty
              ? response.message
              : 'Registration verification failed. Please try again.',
        );
      } else {
        final response = await _apiClient.post<Map<String, dynamic>>(
          '/customer/auth/verify-reset-otp',
          body: {'email': email, 'otp': otp},
          requiresAuth: false,
          fromJsonData: (data) =>
              data is Map<String, dynamic> ? data : <String, dynamic>{},
        );

        if (!mounted) return;
        setState(() {
          _isLoading = false;
        });

        if (widget.onVerificationSuccess != null) {
          widget.onVerificationSuccess!();
        } else {
          final token = response.data?['reset_token'] as String?;
          if (token == null || token.isEmpty) {
            _showError(
              'The verification response was incomplete. Please request a new code.',
            );
            return;
          }
          AppNavigator.toSetNewPassword(context, email: email, resetToken: token);
        }
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _pinController.clear();
      _pinFocusNode.requestFocus();
      _showError(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Unable to verify the code right now. Please try again.');
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
        backgroundColor: const Color(0xFF0D1B2A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _cursorTimer?.cancel();
    _pinController.dispose();
    _pinFocusNode.dispose();
    _apiClient.close();
    _entranceController.dispose();
    super.dispose();
  }

  String _formatTimer(int seconds) {
    final m = (seconds ~/ 60).toString().padLeft(2, '0');
    final s = (seconds % 60).toString().padLeft(2, '0');
    return '$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;

    final target = _email.isNotEmpty ? _email : 'your registered email';

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.dark,
        systemNavigationBarColor: Color(0xFFFDFBCF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    final pinText = _pinController.text;

    return Scaffold(
      backgroundColor: const Color(0xFFFDFBCF),
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: topPadding > 0 ? topPadding + 8 : 28),

                      // -----------------------------------------------------
                      // TOP APP BAR: Circular Back Button + Logo Mark
                      // -----------------------------------------------------
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
                                AppNavigator.toForgotPassword(context);
                              }
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFFE6C17A),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.arrow_back_ios_new_rounded,
                                  size: 16,
                                  color: Color(0xFF0D1B2A),
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

                      // -----------------------------------------------------
                      // TOP PILL BADGE: SECURE OTP VERIFICATION
                      // -----------------------------------------------------
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6C17A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            const Icon(
                              Icons.verified_user_outlined,
                              size: 14,
                              color: Color(0xFF0D1B2A),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'SECURE OTP VERIFICATION',
                              style: GoogleFonts.literata(
                                fontSize: 10.5,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 0.9,
                                color: const Color(0xFF0D1B2A),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 18),

                      // -----------------------------------------------------
                      // HEADLINE: "Verify code."
                      // -----------------------------------------------------
                      Text(
                        'Verify code.',
                        style: GoogleFonts.domine(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                          letterSpacing: -0.6,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // -----------------------------------------------------
                      // SUBTITLE & MASKED TARGET WITH "Edit email" ACTION
                      // -----------------------------------------------------
                      RichText(
                        text: TextSpan(
                          style: GoogleFonts.literata(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1B365D),
                            height: 1.45,
                          ),
                          children: [
                            const TextSpan(
                              text: 'We sent a 6-digit verification code to\n',
                            ),
                            TextSpan(
                              text: target,
                              style: GoogleFonts.literata(
                                fontWeight: FontWeight.w700,
                                color: const Color(0xFF0D1B2A),
                              ),
                            ),
                            const TextSpan(
                              text:
                                  '. Enter it below to\nconfirm your identity. ',
                            ),
                            WidgetSpan(
                              alignment: PlaceholderAlignment.baseline,
                              baseline: TextBaseline.alphabetic,
                              child: GestureDetector(
                                onTap: () {
                                  HapticFeedback.selectionClick();
                                  if (widget.onEditEmail != null) {
                                    widget.onEditEmail!();
                                  } else {
                                    Navigator.of(context).pop();
                                  }
                                },
                                child: Text(
                                  'Edit email',
                                  style: GoogleFonts.literata(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF1B365D),
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (widget.flowType == OtpFlowType.registration) ...[
                        const SizedBox(height: 14),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 10,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFFFF8E6),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFFFD580),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.info_outline_rounded,
                                size: 18,
                                color: Color(0xFFB7791F),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Text(
                                  'SMTP email dispatch is temporarily offline. Contact support or enter code to verify.',
                                  style: GoogleFonts.literata(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w500,
                                    color: const Color(0xFF744210),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      const SizedBox(height: 28),

                      // -----------------------------------------------------
                      // 6-DIGIT OTP BOXES (Hidden text field underneath)
                      // -----------------------------------------------------
                      Stack(
                        children: [
                          // Hidden actual text field to accept input
                          Opacity(
                            opacity: 0.0,
                            child: SizedBox(
                              height: 60,
                              child: TextField(
                                controller: _pinController,
                                focusNode: _pinFocusNode,
                                keyboardType: TextInputType.number,
                                maxLength: 6,
                                inputFormatters: [
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                onChanged: (value) {
                                  setState(() {});
                                  if (value.length == 6) {
                                    _handleVerify();
                                  }
                                },
                              ),
                            ),
                          ),

                          // Visual 6-box representation
                          GestureDetector(
                            onTap: () {
                              _pinFocusNode.requestFocus();
                            },
                            child: Row(
                              children: List.generate(6, (index) {
                                final hasDigit = index < pinText.length;
                                final isActive = index == pinText.length;
                                final digit = hasDigit ? pinText[index] : '';

                                return Expanded(
                                  child: Container(
                                    height: 62,
                                    margin: EdgeInsets.only(
                                      right: index < 5 ? 8 : 0,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isActive
                                          ? const Color(0xFFF5EBDD)
                                          : const Color(0xFFE6C17A),
                                      borderRadius: BorderRadius.circular(14),
                                      border: isActive
                                          ? Border.all(
                                              color: const Color(0xFFE6C17A),
                                              width: 1.5,
                                            )
                                          : null,
                                      boxShadow: isActive
                                          ? [
                                              BoxShadow(
                                                color: Colors.black.withValues(
                                                  alpha: 0.05,
                                                ),
                                                blurRadius: 8,
                                                offset: const Offset(0, 3),
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Center(
                                      child: hasDigit
                                          ? Text(
                                              digit,
                                              style: GoogleFonts.domine(
                                                fontSize: 22,
                                                fontWeight: FontWeight.w700,
                                                color: const Color(0xFF0D1B2A),
                                              ),
                                            )
                                          : isActive
                                          ? (_showCursor
                                                ? Container(
                                                    width: 2.2,
                                                    height: 24,
                                                    decoration: BoxDecoration(
                                                      color: const Color(
                                                        0xFF0E5B75,
                                                      ),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                            1,
                                                          ),
                                                    ),
                                                  )
                                                : const SizedBox(
                                                    width: 2.2,
                                                    height: 24,
                                                  ))
                                          : Container(
                                              width: 6,
                                              height: 6,
                                              decoration: const BoxDecoration(
                                                color: Color(0xFFE6C17A),
                                                shape: BoxShape.circle,
                                              ),
                                            ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 18),

                      // -----------------------------------------------------
                      // RESEND CODE ROW WITH COUNTDOWN
                      // -----------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time_rounded,
                                size: 16,
                                color: Color(0xFF1B365D),
                              ),
                              const SizedBox(width: 6),
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.literata(
                                    fontSize: 12.5,
                                    color: const Color(0xFF1B365D),
                                  ),
                                  children: [
                                    const TextSpan(text: 'Resend code in '),
                                    TextSpan(
                                      text: _formatTimer(_secondsRemaining),
                                      style: GoogleFonts.literata(
                                        fontWeight: FontWeight.w700,
                                        color: const Color(0xFF0D1B2A),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: _secondsRemaining == 0
                                ? _handleResend
                                : null,
                            child: Text(
                              'Resend Code',
                              style: GoogleFonts.literata(
                                fontSize: 12.5,
                                fontWeight: FontWeight.w500,
                                color: _secondsRemaining == 0
                                    ? const Color(0xFF0D1B2A)
                                    : const Color(0xFF1B365D),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 28),

                      // -----------------------------------------------------
                      // SECURITY HANDSHAKE CARD
                      // -----------------------------------------------------
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE6C17A),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Container(
                              width: 44,
                              height: 44,
                              decoration: const BoxDecoration(
                                color: Color(0xFFF5EBDD),
                                shape: BoxShape.circle,
                              ),
                              child: const Center(
                                child: Icon(
                                  Icons.shield_outlined,
                                  size: 20,
                                  color: Color(0xFF0D1B2A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Text(
                                        'Encrypted Handshake',
                                        style: GoogleFonts.literata(
                                          fontSize: 13,
                                          fontWeight: FontWeight.w700,
                                          color: const Color(0xFF0D1B2A),
                                        ),
                                      ),
                                      const SizedBox(width: 5),
                                      Container(
                                        width: 5,
                                        height: 5,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF1B365D),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'One-time code expires in 10 minutes.\nNever share this code with anyone.',
                                    style: GoogleFonts.literata(
                                      fontSize: 12.5,
                                      fontWeight: FontWeight.w400,
                                      color: const Color(0xFF1B365D),
                                      height: 1.35,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),

                      // -----------------------------------------------------
                      // PRIMARY BUTTON: "Verify & Continue ->"
                      // -----------------------------------------------------
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleVerify,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0D1B2A),
                            foregroundColor: const Color(0xFFF5EBDD),
                            disabledBackgroundColor: const Color(
                              0xFF0D1B2A,
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
                                      Color(0xFFF5EBDD),
                                    ),
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Verify & Continue',
                                      style: GoogleFonts.literata(
                                        fontSize: 15.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFFF5EBDD),
                                        letterSpacing: 0.2,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(
                                      Icons.arrow_forward_rounded,
                                      size: 18,
                                      color: Color(0xFFF5EBDD),
                                    ),
                                  ],
                                ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // -----------------------------------------------------
                      // FOOTER: "Having trouble? Contact Support"
                      // -----------------------------------------------------
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Having trouble? ',
                              style: GoogleFonts.literata(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1B365D),
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                widget.onContactSupport?.call();
                              },
                              behavior: HitTestBehavior.opaque,
                              child: Text(
                                'Contact Support',
                                style: GoogleFonts.domine(
                                  fontSize: 13.5,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF0D1B2A),
                                  decoration: TextDecoration.underline,
                                  decorationColor: const Color(0xFF0D1B2A),
                                  decorationThickness: 1.5,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // -----------------------------------------------------
                      // BOTTOM HOME INDICATOR BAR
                      // -----------------------------------------------------
                      Center(
                        child: Container(
                          width: 134,
                          height: 4,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6C17A),
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
    );
  }
}
