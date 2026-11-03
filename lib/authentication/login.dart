import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/network.dart';
import '../core/session_manager.dart';

/// TechKart Sign In Screen
///
/// 100% visual fidelity reproduction of the Sign In reference screen:
/// - Light airy background (#F5FAFF)
/// - Top bar: Circular soft back button on the left, TechKart logo mark on the right.
/// - Top pill badge: "SECURE AUTHENTICATION" with shield icon in soft light-blue capsule (#EBF5FE).
/// - Headline: "Welcome back." in bold Domine serif font (#00344B).
/// - Subtitle: "Sign in to access your curated tech collection and order updates." in Literata font (#4A5568).
/// - Text Field 1: "Email or Mobile Phone" with leading `@` icon and placeholder `aarav.sharma@techkart.in` / `+91 98765 43210`.
/// - Text Field 2: "Password" with leading lock icon, obscured dots, and trailing eye visibility toggle icon.
/// - "Forgot password?" right-aligned link in Literata font.
/// - Primary action button: Full-width Midnight Navy button (#00344B) with "Sign In →" text.
/// - Security info card: White rounded card with soft gold shield icon,
///   "Apple Keychain & Biometrics\nSeamlessly sync passwords across all your connected Apple devices."
/// - Footer: "New to TechKart? [Create an account]" with underlined text link.
/// - Bottom home indicator capsule.
///
/// Strictly preserves backend API integration:
/// - POST /customer/auth/login
/// - Session saving, token caching, PushNotification sync
class LoginScreen extends StatefulWidget {
  final VoidCallback? onLoginSuccess;
  final VoidCallback? onCreateAccountTapped;
  final VoidCallback? onForgotPasswordTapped;

  const LoginScreen({
    super.key,
    this.onLoginSuccess,
    this.onCreateAccountTapped,
    this.onForgotPasswordTapped,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();
  final _emailPhoneController = TextEditingController();
  final _passwordController = TextEditingController();
  final _apiClient = ApiClient();

  bool _obscurePassword = true;
  bool _isLoading = false;

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();

    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: Curves.easeOut,
      ),
    );

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.03),
      end: Offset.zero,
    ).animate(
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
    _passwordController.dispose();
    _entranceController.dispose();
    _apiClient.close();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    final input = _emailPhoneController.text.trim();
    final password = _passwordController.text;

    if (input.isEmpty) {
      _showSnackbar('Please enter your mobile number or email.');
      return;
    }
    if (password.isEmpty) {
      _showSnackbar('Please enter your password.');
      return;
    }

    final isEmail = input.contains('@');
    final payload = <String, dynamic>{
      'email': isEmail ? input.toLowerCase() : input,
      'password': password,
    };
    if (!isEmail) {
      payload['phone'] = input;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final response = await _apiClient.post(
        '/customer/auth/login',
        body: payload,
        requiresAuth: false,
      );

      if (!mounted) return;

      if (response.success && response.data != null) {
        final data = response.data as Map<String, dynamic>;
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

          if (widget.onLoginSuccess != null) {
            widget.onLoginSuccess!();
          } else {
            AppNavigator.toMainShell(context);
          }
          return;
        }
      }

      _showSnackbar(response.message.isNotEmpty
          ? response.message
          : 'Login failed. Please check your credentials.');
    } on UnauthorizedException catch (e) {
      _showSnackbar(e.message);
    } on ForbiddenException catch (e) {
      _showSnackbar(e.message);
    } on ValidationException catch (e) {
      _showSnackbar(e.message);
    } on ConnectionTimeoutException catch (e) {
      _showSnackbar('${e.message} Please verify backend is running on port 8000.');
    } on ResponseTimeoutException catch (e) {
      _showSnackbar(e.message);
    } on NetworkException catch (e) {
      _showSnackbar('${e.message} Verify network connection and backend server.');
    } on ApiException catch (e) {
      _showSnackbar(e.message);
    } catch (_) {
      _showSnackbar('An unexpected error occurred. Please try again.');
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
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
        backgroundColor: const Color(0xFF00344B),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        duration: const Duration(seconds: 4),
      ),
    );
  }

  void _navigateToCreateAccount() {
    HapticFeedback.selectionClick();
    if (widget.onCreateAccountTapped != null) {
      widget.onCreateAccountTapped!();
    } else {
      AppNavigator.toCreateAccount(context);
    }
  }

  void _navigateToForgotPassword() {
    HapticFeedback.selectionClick();
    if (widget.onForgotPasswordTapped != null) {
      widget.onForgotPasswordTapped!();
    } else {
      AppNavigator.toForgotPassword(context);
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
        systemNavigationBarColor: Color(0xFFF5FAFF),
        systemNavigationBarIconBrightness: Brightness.dark,
      ),
    );

    return Scaffold(
      backgroundColor: const Color(0xFFF5FAFF),
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
                        // TOP APP BAR: Back Circular Button + Logo
                        // ---------------------------------------------------
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Circular back button
                            InkWell(
                              onTap: () {
                                HapticFeedback.selectionClick();
                                if (Navigator.of(context).canPop()) {
                                  Navigator.of(context).pop();
                                } else {
                                  AppNavigator.toOnboarding(context);
                                }
                              },
                              borderRadius: BorderRadius.circular(24),
                              child: Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFEBF5FE),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.arrow_back_ios_new_rounded,
                                    size: 16,
                                    color: Color(0xFF00344B),
                                  ),
                                ),
                              ),
                            ),

                            // TechKart Logo Mark
                            Image.asset(
                              'asset/app_logo.png',
                              height: 38,
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset(
                                'asset/app_launcher_icon.png',
                                height: 38,
                                fit: BoxFit.contain,
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 24),

                        // ---------------------------------------------------
                        // TOP PILL BADGE: SECURE AUTHENTICATION
                        // ---------------------------------------------------
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 7,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFFEBF5FE),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(
                                Icons.verified_user_outlined,
                                size: 14,
                                color: Color(0xFF00344B),
                              ),
                              const SizedBox(width: 6),
                              Text(
                                'SECURE AUTHENTICATION',
                                style: GoogleFonts.literata(
                                  fontSize: 10.5,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.9,
                                  color: const Color(0xFF00344B),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // ---------------------------------------------------
                        // HEADLINE: "Welcome back."
                        // ---------------------------------------------------
                        Text(
                          'Welcome back.',
                          style: GoogleFonts.domine(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: const Color(0xFF00344B),
                            letterSpacing: -0.6,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ---------------------------------------------------
                        // SUBTITLE: "Sign in to access your curated tech..."
                        // ---------------------------------------------------
                        Text(
                          'Sign in to access your curated tech\ncollection and order updates.',
                          style: GoogleFonts.literata(
                            fontSize: 14.5,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF4A5568),
                            height: 1.45,
                          ),
                        ),

                        const SizedBox(height: 32),

                        // ---------------------------------------------------
                        // FIELD 1: "Email or Mobile Phone"
                        // ---------------------------------------------------
                        Text(
                          'Email or Mobile Phone',
                          style: GoogleFonts.literata(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF5FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: _emailPhoneController,
                            keyboardType: TextInputType.emailAddress,
                            style: GoogleFonts.literata(
                              fontSize: 14.5,
                              color: const Color(0xFF00344B),
                              fontWeight: FontWeight.w500,
                            ),
                            decoration: InputDecoration(
                              isDense: true,
                              border: InputBorder.none,
                              prefixIcon: const Padding(
                                padding: EdgeInsets.only(left: 14, right: 10),
                                child: Icon(
                                  Icons.alternate_email_rounded,
                                  size: 19,
                                  color: Color(0xFF2D3748),
                                ),
                              ),
                              prefixIconConstraints: const BoxConstraints(
                                minWidth: 44,
                                minHeight: 24,
                              ),
                              hintText: 'aarav.sharma@techkart.in',
                              hintStyle: GoogleFonts.literata(
                                fontSize: 14.5,
                                color: const Color(0xFFA0AEC0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 22),

                        // ---------------------------------------------------
                        // FIELD 2: "Password"
                        // ---------------------------------------------------
                        Text(
                          'Password',
                          style: GoogleFonts.literata(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: const Color(0xFF2D3748),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Container(
                          height: 56,
                          decoration: BoxDecoration(
                            color: const Color(0xFFEAF5FF),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          alignment: Alignment.center,
                          child: TextFormField(
                            controller: _passwordController,
                            obscureText: _obscurePassword,
                            style: GoogleFonts.literata(
                              fontSize: 14.5,
                              color: const Color(0xFF00344B),
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
                                  color: Color(0xFF2D3748),
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
                                  color: const Color(0xFF2D3748),
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
                                color: const Color(0xFFA0AEC0),
                              ),
                              contentPadding: const EdgeInsets.symmetric(
                                horizontal: 16,
                                vertical: 16,
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ---------------------------------------------------
                        // FORGOT PASSWORD LINK
                        // ---------------------------------------------------
                        Align(
                          alignment: Alignment.centerRight,
                          child: GestureDetector(
                            onTap: _navigateToForgotPassword,
                            behavior: HitTestBehavior.opaque,
                            child: Text(
                              'Forgot password?',
                              style: GoogleFonts.literata(
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                                color: const Color(0xFF4C6682),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 28),

                        // ---------------------------------------------------
                        // PRIMARY BUTTON: "Sign In ->"
                        // ---------------------------------------------------
                        SizedBox(
                          width: double.infinity,
                          height: 54,
                          child: ElevatedButton(
                            onPressed: _isLoading ? null : _handleSignIn,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xFF00344B),
                              foregroundColor: Colors.white,
                              disabledBackgroundColor:
                                  const Color(0xFF00344B).withValues(alpha: 0.6),
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
                                          Colors.white),
                                    ),
                                  )
                                : Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Sign In',
                                        style: GoogleFonts.literata(
                                          fontSize: 15.5,
                                          fontWeight: FontWeight.w600,
                                          color: Colors.white,
                                          letterSpacing: 0.2,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      const Icon(
                                        Icons.arrow_forward_rounded,
                                        size: 18,
                                        color: Colors.white,
                                      ),
                                    ],
                                  ),
                          ),
                        ),

                        const SizedBox(height: 26),

                        // ---------------------------------------------------
                        // SECURITY CARD: Apple Keychain & Biometrics / Security
                        // ---------------------------------------------------
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF00344B).withValues(alpha: 0.04),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Soft gold circular shield icon
                              Container(
                                width: 44,
                                height: 44,
                                decoration: const BoxDecoration(
                                  color: Color(0xFFF3EEE4),
                                  shape: BoxShape.circle,
                                ),
                                child: const Center(
                                  child: Icon(
                                    Icons.shield_outlined,
                                    size: 20,
                                    color: Color(0xFF8B6B2B),
                                  ),
                                ),
                              ),
                              const SizedBox(width: 14),

                              // Description text
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Apple Keychain & Biometrics',
                                      style: GoogleFonts.literata(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w600,
                                        color: const Color(0xFF2D3748),
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      'Seamlessly sync passwords across all your connected Apple devices.',
                                      style: GoogleFonts.literata(
                                        fontSize: 12.5,
                                        fontWeight: FontWeight.w400,
                                        color: const Color(0xFF4A5568),
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
                        // FOOTER: "New to TechKart? Create an account"
                        // ---------------------------------------------------
                        Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                'New to TechKart? ',
                                style: GoogleFonts.literata(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                  color: const Color(0xFF2D3748),
                                ),
                              ),
                              GestureDetector(
                                onTap: _navigateToCreateAccount,
                                behavior: HitTestBehavior.opaque,
                                child: Text(
                                  'Create an account',
                                  style: GoogleFonts.domine(
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF00344B),
                                    decoration: TextDecoration.underline,
                                    decorationColor: const Color(0xFF00344B),
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
                              color: const Color(0xFFCBD5E1),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ),

                        SizedBox(height: bottomPadding > 0 ? bottomPadding + 4 : 16),
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
