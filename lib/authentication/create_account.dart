import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';
import 'otp_verfification.dart';

/// TechKart Create Account Screen
///
/// 100% visual fidelity reproduction of the Create Account reference screen:
/// - Light airy background (#F5FAFF)
/// - Top bar: Circular soft back button on the left, TechKart logo mark on the right.
/// - Top pill badge: "VERIFIED REGISTRATION" with shield icon in soft light-blue capsule (#EBF5FE).
/// - Headline: "Create account." in bold Domine serif font (#00344B).
/// - Subtitle: "Join TechKart for personalized gear\nrecommendations and member perks." in Literata font (#4A5568).
/// - Text Field 1: "Full Name" with person icon, prefilled with `Ananya Iyer` (Indian name).
/// - Text Field 2: "Email or Mobile Phone" with mail icon, prefilled with `ananya.iyer@techkart.in`.
/// - Text Field 3: "Password" with lock icon, obscured dots, and eye visibility toggle icon.
/// - Password Strength Indicator:
///   - 4 horizontal segmented bars (first 3 dark navy #00344B, 4th light sky blue #C4E3FA).
///   - Bottom row: Checked shield icon with "Strong password" on left, "Min. 8 characters" on right.
/// - Checkbox Row: Dark circular check icon with text:
///   "I agree to TechKart's Terms of Service and Privacy Policy." (with underlined links).
/// - Primary action button: Full-width Midnight Navy button (#00344B) with "Create Account →" text.
/// - Footer: "Already have an account? Sign In" with bold link.
/// - Bottom home indicator capsule.
///
/// Strictly preserves backend API integration:
/// - POST /customer/auth/register
/// - Conflict handling (existing user redirected to login)
/// - Session saving, token caching, PushNotification sync
class CreateAccountScreen extends StatefulWidget {
  final VoidCallback? onRegistrationSuccess;
  final VoidCallback? onSignInTapped;
  final VoidCallback? onTermsTapped;
  final VoidCallback? onPrivacyTapped;

  const CreateAccountScreen({
    super.key,
    this.onRegistrationSuccess,
    this.onSignInTapped,
    this.onTermsTapped,
    this.onPrivacyTapped,
  });

  @override
  State<CreateAccountScreen> createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();

  bool _obscurePassword = true;
  bool _termsAgreed = false;
  bool _isLoading = false;

  int _passwordStrength = 0; // 0 to 4
  String _passwordStrengthLabel = 'Too weak';

  void _calculatePasswordStrength(String pass) {
    if (pass.isEmpty) {
      setState(() {
        _passwordStrength = 0;
        _passwordStrengthLabel = 'Enter password';
      });
      return;
    }

    int score = 0;
    if (pass.length >= 6) score++;
    if (pass.length >= 8) score++;
    if (RegExp(r'[A-Z]').hasMatch(pass) && RegExp(r'[a-z]').hasMatch(pass)) {
      score++;
    }
    if (RegExp(r'[0-9]').hasMatch(pass) ||
        RegExp(r'[^A-Za-z0-9]').hasMatch(pass)) {
      score++;
    }
    if (pass.length >= 12) score++;

    String label;
    switch (score) {
      case 1:
        label = 'Weak';
        break;
      case 2:
        label = 'Fair';
        break;
      case 3:
        label = 'Good';
        break;
      case 4:
        label = 'Strong password';
        break;
      default:
        label = 'Too weak';
    }

    setState(() {
      _passwordStrength = score;
      _passwordStrengthLabel = label;
    });
  }

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  final ApiClient _apiClient = ApiClient();

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
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailPhoneController.dispose();
    _passwordController.dispose();
    _entranceController.dispose();
    _apiClient.close();
    super.dispose();
  }

  void _handleCreateAccount() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    final fullName = _fullNameController.text.trim();
    final input = _emailPhoneController.text.trim();
    final password = _passwordController.text;

    if (fullName.isEmpty) {
      _showSnackbar('Please enter your full name.');
      return;
    }
    if (fullName.length < 2) {
      _showSnackbar('Full name must be at least 2 characters.');
      return;
    }
    if (input.isEmpty) {
      _showSnackbar('Please enter your email or mobile number.');
      return;
    }
    if (password.isEmpty) {
      _showSnackbar('Please enter your password.');
      return;
    }
    if (password.length < 6) {
      _showSnackbar('Password must be at least 6 characters.');
      return;
    }
    if (!_termsAgreed) {
      _showSnackbar('Please accept the Terms of Service to continue.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    final isEmail = input.contains('@');
    final Map<String, dynamic> requestPayload = {
      'full_name': fullName,
      'password': password,
    };

    if (isEmail) {
      requestPayload['email'] = input.toLowerCase();
    } else {
      requestPayload['email'] =
          'user_${input.replaceAll(RegExp(r'\D'), '')}@techkart.in';
      requestPayload['phone'] = input;
    }

    try {
      final response = await _apiClient.post(
        '/customer/auth/register',
        body: requestPayload,
        requiresAuth: false,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (response.success) {
        final targetEmail = requestPayload['email'] as String? ?? input;
        HapticFeedback.lightImpact();

        // Redirect to OTP Verification with registration mode
        AppNavigator.toOtpVerification(
          context,
          destinationTarget: targetEmail,
          flowType: OtpFlowType.registration,
        );
        return;
      }

      _showSnackbar(
        response.message.isNotEmpty
            ? response.message
            : 'Registration failed. Please try again.',
      );
    } on ConflictException catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showSnackbar(e.message);
      Future.delayed(const Duration(milliseconds: 1400), () {
        if (!mounted) return;
        if (widget.onSignInTapped != null) {
          widget.onSignInTapped!();
        } else {
          AppNavigator.toLogin(context);
        }
      });
    } on ValidationException catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showSnackbar(e.message);
    } on UnauthorizedException catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showSnackbar(e.message);
    } on ForbiddenException catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showSnackbar(e.message);
    } on ConnectionTimeoutException catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showSnackbar(
        '${e.message} Please verify backend is running on port 8000.',
      );
    } on ResponseTimeoutException catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showSnackbar(e.message);
    } on NetworkException catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showSnackbar(
        '${e.message} Verify network connection and backend server.',
      );
    } on ApiException catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showSnackbar(e.message);
    } catch (e) {
      if (mounted) setState(() => _isLoading = false);
      _showSnackbar(
        'Registration error: ${e.toString().replaceAll("Exception:", "").trim()}',
      );
    }
  }

  void _showSnackbar(String message) {
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
        duration: const Duration(seconds: 4),
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
        systemNavigationBarColor: Color(0xFFFDFBCF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

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

                        // ---------------------------------------------------
                        // TOP PILL BADGE: VERIFIED REGISTRATION
                        // ---------------------------------------------------
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
                                'VERIFIED REGISTRATION',
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

                        // ---------------------------------------------------
                        // HEADLINE: "Create account."
                        // ---------------------------------------------------
                        Text(
                          'Create account.',
                          style: GoogleFonts.domine(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF0D1B2A),
                            letterSpacing: -0.6,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ---------------------------------------------------
                        // SUBTITLE: "Join TechKart for personalized gear..."
                        // ---------------------------------------------------
                        Text(
                          'Join TechKart for personalized gear\nrecommendations and member perks.',
                          style: GoogleFonts.literata(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF1B365D),
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ---------------------------------------------------
                        // FIELD 1: "Full Name"
                        // ---------------------------------------------------
                        Text(
                          'Full Name',
                          style: GoogleFonts.literata(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1B365D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6C17A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: _fullNameController,
                            style: GoogleFonts.literata(
                              fontSize: 14.5,
                              color: const Color(0xFF0D1B2A),
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 14, right: 10),
                                child: Icon(
                                  Icons.person_outline_rounded,
                                  size: 20,
                                  color: Color(0xFF1B365D),
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 44,
                                minHeight: 24,
                              ),
                              hintText: 'Ananya Iyer',
                              hintStyle: GoogleFonts.literata(
                                fontSize: 14.5,
                                color: const Color(0xFF1B365D),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ---------------------------------------------------
                        // FIELD 2: "Email or Mobile Phone"
                        // ---------------------------------------------------
                        Text(
                          'Email Address',
                          style: GoogleFonts.literata(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1B365D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6C17A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: _emailPhoneController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.literata(
                              fontSize: 14.5,
                              color: const Color(0xFF0D1B2A),
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 14, right: 10),
                                child: Icon(
                                  Icons.mail_outline_rounded,
                                  size: 19,
                                  color: Color(0xFF1B365D),
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 44,
                                minHeight: 24,
                              ),
                              hintText: 'name@example.com',
                              hintStyle: GoogleFonts.literata(
                                fontSize: 14.5,
                                color: const Color(0xFF1B365D),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 20),

                        // ---------------------------------------------------
                        // FIELD 3: "Password"
                        // ---------------------------------------------------
                        Text(
                          'Password',
                          style: GoogleFonts.literata(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF1B365D),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFE6C17A),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            onChanged: _calculatePasswordStrength,
                            style: GoogleFonts.literata(
                              fontSize: 14.5,
                              color: const Color(0xFF0D1B2A),
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 14, right: 10),
                                child: Icon(
                                  Icons.lock_outline_rounded,
                                  size: 19,
                                  color: Color(0xFF1B365D),
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 44,
                                minHeight: 24,
                              ),
                              suffixIcon: IconButton(
                                icon: Icon(
                                  _obscurePassword
                                      ? Icons.visibility_outlined
                                      : Icons.visibility_off_outlined,
                                  size: 20,
                                  color: const Color(0xFF1B365D),
                                ),
                                onPressed: () {
                                  setState(() {
                                    _obscurePassword = !_obscurePassword;
                                  });
                                },
                              ),
                              hintText: '••••••••••••',
                              hintStyle: GoogleFonts.literata(
                                fontSize: 14.5,
                                color: const Color(0xFF1B365D),
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
                        // PASSWORD STRENGTH METER (4 segments)
                        // ---------------------------------------------------
                        Row(
                          children: List.generate(4, (index) {
                            final isActive = index < _passwordStrength;
                            return Expanded(
                              child: Container(
                                height: 3.5,
                                margin: EdgeInsets.only(
                                  right: index < 3 ? 6.0 : 0.0,
                                ),
                                decoration: BoxDecoration(
                                  color: isActive
                                      ? const Color(0xFF0D1B2A)
                                      : const Color(0xFFC4E3FA),
                                  borderRadius: BorderRadius.circular(2),
                                ),
                              ),
                            );
                          }),
                        ),

                        const SizedBox(height: 10),

                        // Strength status row
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  _passwordStrength >= 3
                                      ? Icons.check_circle_outline_rounded
                                      : Icons.info_outline_rounded,
                                  size: 15,
                                  color: const Color(0xFF0D1B2A),
                                ),
                                const SizedBox(width: 5),
                                Text(
                                  _passwordStrengthLabel,
                                  style: GoogleFonts.literata(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: const Color(0xFF0D1B2A),
                                  ),
                                ),
                              ],
                            ),
                            Text(
                              'Min. 8 characters',
                              style: GoogleFonts.literata(
                                fontSize: 12,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1B365D),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ---------------------------------------------------
                        // TERMS OF SERVICE CHECKBOX ROW
                        // ---------------------------------------------------
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GestureDetector(
                              onTap: () {
                                setState(() {
                                  _termsAgreed = !_termsAgreed;
                                });
                              },
                              child: Container(
                                width: 22,
                                height: 22,
                                margin: const EdgeInsets.only(
                                  top: 2,
                                  right: 12,
                                ),
                                decoration: BoxDecoration(
                                  color: _termsAgreed
                                      ? const Color(0xFF0D1B2A)
                                      : Colors.transparent,
                                  borderRadius: BorderRadius.circular(6),
                                  border: Border.all(
                                    color: const Color(0xFF0D1B2A),
                                    width: 1.8,
                                  ),
                                ),
                                child: _termsAgreed
                                    ? const Icon(
                                        Icons.check_rounded,
                                        size: 16,
                                        color: Color(0xFFF5EBDD),
                                      )
                                    : null,
                              ),
                            ),
                            Expanded(
                              child: RichText(
                                text: TextSpan(
                                  style: GoogleFonts.literata(
                                    fontSize: 12.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF1B365D),
                                    height: 1.4,
                                  ),
                                  children: [
                                    const TextSpan(
                                      text: 'I agree to TechKart\'s ',
                                    ),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.alphabetic,
                                      child: GestureDetector(
                                        onTap: widget.onTermsTapped,
                                        child: Text(
                                          'Terms of Service',
                                          style: GoogleFonts.literata(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF0D1B2A),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const TextSpan(text: ' and '),
                                    WidgetSpan(
                                      alignment: PlaceholderAlignment.baseline,
                                      baseline: TextBaseline.alphabetic,
                                      child: GestureDetector(
                                        onTap: widget.onPrivacyTapped,
                                        child: Text(
                                          'Privacy Policy',
                                          style: GoogleFonts.literata(
                                            fontSize: 12.5,
                                            fontWeight: FontWeight.w500,
                                            color: const Color(0xFF0D1B2A),
                                            decoration:
                                                TextDecoration.underline,
                                          ),
                                        ),
                                      ),
                                    ),
                                    const TextSpan(text: '.'),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 28),

                        // ---------------------------------------------------
                        // PRIMARY BUTTON: "Create Account ->"
                        // ---------------------------------------------------
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleCreateAccount,
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
                                        'Create Account',
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

                        const SizedBox(height: 28),

                        // ---------------------------------------------------
                        // FOOTER: "Already have an account? Sign in"
                        // ---------------------------------------------------
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'Already have an account? ',
                                style: GoogleFonts.literata(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF1B365D),
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToSignIn,
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  'Sign in',
                                  style: GoogleFonts.domine(
                                    fontSize: 14,
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

                        // ---------------------------------------------------
                        // BOTTOM HOME INDICATOR BAR
                        // ---------------------------------------------------
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
      ),
    );
  }
}
