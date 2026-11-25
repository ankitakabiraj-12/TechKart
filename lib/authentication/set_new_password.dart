import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/network/api_client.dart';
import '../core/network/api_exception.dart';

/// TechKart Set New Password Screen
///
/// 100% visual fidelity reproduction of the Create new password reference:
/// - Light airy background (#F5FAFF)
/// - Top bar: Circular soft back button on the left, TechKart logo mark on the right.
/// - Top pill badge: "SECURITY & CREDENTIALS" with shield icon in soft light-blue capsule (#EBF5FE).
/// - Headline: "Create new password." in bold Domine serif font (#00344B).
/// - Subtitle: "Your new password must be unique and\ndifferent from previously used passwords." in Literata font (#4A5568).
/// - Field 1: "New Password" label with right-aligned "Case-sensitive" note.
///   - Rounded container with leading lock icon, obscured dots, trailing eye toggle.
/// - Password Strength Row:
///   - "Password Strength" on left, "Strong password" on right in Literata font.
///   - 4-segment strength bar (3 dark navy #00344B, 1 light sky blue #C4E3FA).
///   - Criteria check indicators:
///     - "✔ Min. 8 characters"   "✔ Includes number & symbol"
///     - "○ Uppercase letter"
/// - Field 2: "Confirm New Password" label with right-aligned "✔ Passwords match".
///   - Rounded container with leading shield icon, obscured dots, trailing eye toggle.
/// - Info Card: "End-to-End Encryption"
///   - Circular sync/lock icon on left.
///   - "All active sessions on secondary devices will be safely invalidated once updated."
/// - Primary action button: Full-width Midnight Navy button (#00344B) with "Update Password →".
/// - Footer: "Remembered your credentials? Sign In" with link.
/// - Bottom home indicator capsule.
class SetNewPasswordScreen extends StatefulWidget {
  final String email;
  final String resetToken;
  final VoidCallback? onPasswordResetSuccess;
  final VoidCallback? onSignInTapped;
  final VoidCallback? onBackTapped;

  const SetNewPasswordScreen({
    super.key,
    this.email = '',
    this.resetToken = '',
    this.onPasswordResetSuccess,
    this.onSignInTapped,
    this.onBackTapped,
  });

  @override
  State<SetNewPasswordScreen> createState() => _SetNewPasswordScreenState();
}

class _SetNewPasswordScreenState extends State<SetNewPasswordScreen>
    with SingleTickerProviderStateMixin {
  final ApiClient _apiClient = ApiClient();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _isLoading = false;

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  bool get _passwordsMatch =>
      _passwordController.text.isNotEmpty &&
      _passwordController.text == _confirmPasswordController.text;

  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasNumberOrSymbol =>
      RegExp(r'[0-9]').hasMatch(_passwordController.text) ||
      RegExp(r'[^A-Za-z0-9]').hasMatch(_passwordController.text);
  bool get _hasUppercase => RegExp(r'[A-Z]').hasMatch(_passwordController.text);

  int get _passwordScore {
    if (_passwordController.text.isEmpty) return 0;
    var score = 0;
    if (_hasMinLength) score++;
    if (_hasNumberOrSymbol) score++;
    if (_hasUppercase) score++;
    if (_passwordController.text.length >= 12) score++;
    return score;
  }

  String get _strengthLabel {
    if (_passwordController.text.isEmpty) return 'Enter password';
    return switch (_passwordScore) {
      1 => 'Weak',
      2 => 'Fair',
      3 => 'Good',
      _ => 'Strong password',
    };
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
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _apiClient.close();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _handleUpdatePassword() async {
    HapticFeedback.lightImpact();
    FocusScope.of(context).unfocus();

    if (widget.email.isEmpty || widget.resetToken.isEmpty) {
      _showError('Your reset session is missing. Please request a new code.');
      return;
    }
    if (!_hasMinLength) {
      _showError('Password must be at least 8 characters.');
      return;
    }
    if (!_passwordsMatch) {
      _showError('Both passwords must match.');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await _apiClient.post<void>(
        '/customer/auth/reset-password',
        body: {
          'email': widget.email,
          'reset_token': widget.resetToken,
          'new_password': _passwordController.text,
        },
        requiresAuth: false,
      );

      if (!mounted) return;
      setState(() => _isLoading = false);

      if (widget.onPasswordResetSuccess != null) {
        widget.onPasswordResetSuccess!();
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Password reset successfully. Please sign in.',
              style: GoogleFonts.literata(),
            ),
            backgroundColor: const Color(0xFF0D1B2A),
            behavior: SnackBarBehavior.floating,
          ),
        );
        await Future.delayed(const Duration(milliseconds: 900));
        if (!mounted) return;
        AppNavigator.replaceAll(context, AppRoutes.login);
      }
    } on ApiException catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError(e.message);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showError('Unable to reset the password right now. Please try again.');
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
                              if (widget.onBackTapped != null) {
                                widget.onBackTapped!();
                              } else if (Navigator.of(context).canPop()) {
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

                      // -----------------------------------------------------
                      // TOP PILL BADGE: SECURITY & CREDENTIALS
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
                              'SECURITY & CREDENTIALS',
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
                      // HEADLINE: "Create new password."
                      // -----------------------------------------------------
                      Text(
                        'Create new password.',
                        style: GoogleFonts.domine(
                          fontSize: 34,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF0D1B2A),
                          letterSpacing: -0.6,
                        ),
                      ),

                      const SizedBox(height: 12),

                      // -----------------------------------------------------
                      // SUBTITLE
                      // -----------------------------------------------------
                      Text(
                        'Your new password must be unique and\ndifferent from previously used passwords.',
                        style: GoogleFonts.literata(
                          fontSize: 14.5,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF1B365D),
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 28),

                      // -----------------------------------------------------
                      // FIELD 1: "New Password"
                      // -----------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'New Password',
                            style: GoogleFonts.literata(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                          Text(
                            'Case-sensitive',
                            style: GoogleFonts.literata(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                        ],
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
                          onChanged: (_) => setState(() {}),
                          obscureText: _obscurePassword,
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

                      const SizedBox(height: 16),

                      // -----------------------------------------------------
                      // PASSWORD STRENGTH HEADER & 4-SEGMENT BAR
                      // -----------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Password Strength',
                            style: GoogleFonts.literata(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                          Text(
                            _strengthLabel,
                            style: GoogleFonts.literata(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF0D1B2A),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      Row(
                        children: List.generate(4, (index) {
                          return Expanded(
                            child: Container(
                              height: 4,
                              margin: EdgeInsets.only(right: index < 3 ? 6 : 0),
                              decoration: BoxDecoration(
                                color: index < _passwordScore
                                    ? const Color(0xFF1B365D)
                                    : const Color(0xFFC4E3FA),
                                borderRadius: BorderRadius.circular(2),
                              ),
                            ),
                          );
                        }),
                      ),

                      const SizedBox(height: 12),

                      // Requirements checklist row 1
                      Row(
                        children: [
                          Icon(
                            _hasMinLength
                                ? Icons.check_circle_outline_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 15,
                            color: const Color(0xFF1B365D),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Min. 8 characters',
                            style: GoogleFonts.literata(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                          const SizedBox(width: 18),
                          Icon(
                            _hasNumberOrSymbol
                                ? Icons.check_circle_outline_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 15,
                            color: const Color(0xFF1B365D),
                          ),
                          const SizedBox(width: 6),
                          Text(
                            'Includes number & symbol',
                            style: GoogleFonts.literata(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // Requirements checklist row 2
                      Row(
                        children: [
                          Icon(
                            _hasUppercase
                                ? Icons.check_circle_outline_rounded
                                : Icons.radio_button_unchecked_rounded,
                            size: 15,
                            color: const Color(0xFF1B365D),
                          ),
                          const SizedBox(width: 7),
                          Text(
                            'Uppercase letter',
                            style: GoogleFonts.literata(
                              fontSize: 12,
                              fontWeight: FontWeight.w400,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // -----------------------------------------------------
                      // FIELD 2: "Confirm New Password"
                      // -----------------------------------------------------
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Confirm New Password',
                            style: GoogleFonts.literata(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: const Color(0xFF1B365D),
                            ),
                          ),
                          if (_confirmPasswordController.text.isNotEmpty)
                            Row(
                              children: [
                                Icon(
                                  _passwordsMatch
                                      ? Icons.done_all_rounded
                                      : Icons.error_outline_rounded,
                                  size: 14,
                                  color: _passwordsMatch
                                      ? const Color(0xFF1B365D)
                                      : const Color(0xFFEF4444),
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  _passwordsMatch
                                      ? 'Passwords match'
                                      : 'Passwords do not match',
                                  style: GoogleFonts.literata(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w500,
                                    color: _passwordsMatch
                                        ? const Color(0xFF1B365D)
                                        : const Color(0xFFEF4444),
                                  ),
                                ),
                              ],
                            ),
                        ],
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
                          controller: _confirmPasswordController,
                          onChanged: (_) => setState(() {}),
                          obscureText: _obscureConfirmPassword,
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
                                Icons.shield_outlined,
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
                                _obscureConfirmPassword
                                    ? Icons.visibility_outlined
                                    : Icons.visibility_off_outlined,
                                size: 20,
                                color: const Color(0xFF1B365D),
                              ),
                              onPressed: () {
                                setState(() {
                                  _obscureConfirmPassword =
                                      !_obscureConfirmPassword;
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

                      const SizedBox(height: 24),

                      // -----------------------------------------------------
                      // END-TO-END ENCRYPTION CARD
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
                                  Icons.lock_reset_rounded,
                                  size: 22,
                                  color: Color(0xFF0D1B2A),
                                ),
                              ),
                            ),
                            const SizedBox(width: 14),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'End-to-End Encryption',
                                    style: GoogleFonts.literata(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w700,
                                      color: const Color(0xFF0D1B2A),
                                    ),
                                  ),
                                  const SizedBox(height: 3),
                                  Text(
                                    'All active sessions on secondary devices will be safely invalidated once updated.',
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

                      const SizedBox(height: 28),

                      // -----------------------------------------------------
                      // PRIMARY BUTTON: "Update Password ->"
                      // -----------------------------------------------------
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _handleUpdatePassword,
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
                                      'Update Password',
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

                      // -----------------------------------------------------
                      // FOOTER: "Remembered your credentials? Sign In"
                      // -----------------------------------------------------
                      Center(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              'Remembered your credentials? ',
                              style: GoogleFonts.literata(
                                fontSize: 13.5,
                                fontWeight: FontWeight.w400,
                                color: const Color(0xFF1B365D),
                              ),
                            ),
                            GestureDetector(
                              onTap: _navigateToSignIn,
                              behavior: HitTestBehavior.opaque,
                              child: Text(
                                'Sign In',
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
