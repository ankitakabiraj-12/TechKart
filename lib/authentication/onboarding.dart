import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';
import '../core/session_manager.dart';

/// TechKart 3-Step Onboarding Screen
///
/// 100% visual fidelity reproduction of the onboarding design:
/// - Light airy background (#F5FAFF)
/// - Top bar: TechKart brand logo mark on the left, "Skip" action on the right.
/// - Hero card: Smooth curved cream/white pedestal stage showcasing premium devices
///   (Aura ANC Headphones & Chronos Smartwatch) with floating "EFFORTLESS DISCOVERY" compass pill badge.
/// - Typography:
///   - Headline in Domine bold serif ("Smart tech curated for the way you live.")
///   - Subtitle in Literata serif ("Discover next-generation devices powered by personalized intelligence and verified authentic guarantees.")
/// - Elegant pagination pill & dots indicator (dark navy pill, 2 sky-blue dots).
/// - Primary action button: Full-width Midnight Navy button with "Continue →"
/// - Footer: "Already have an account? Sign In" with tap navigation.
/// - Bottom home indicator capsule.
class OnboardingScreen extends StatefulWidget {
  final VoidCallback? onFinish;
  final VoidCallback? onSignIn;

  const OnboardingScreen({
    super.key,
    this.onFinish,
    this.onSignIn,
  });

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with SingleTickerProviderStateMixin {
  late final PageController _pageController;
  int _currentPage = 0;

  late final AnimationController _entranceController;
  late final Animation<double> _fadeAnimation;
  late final Animation<Offset> _slideAnimation;

  // Onboarding slides data (Exclusively Indian context & TechKart products)
  final List<Map<String, String>> _slides = [
    {
      'badge': 'EFFORTLESS DISCOVERY',
      'title': 'Smart tech curated for the\nway you live.',
      'subtitle':
          'Discover next-generation devices powered by personalized intelligence and verified authentic guarantees.',
      'image': 'asset/onboarding_hero_1.png',
    },
    {
      'badge': 'VERIFIED AUTHENTIC',
      'title': 'Original gadgets from\ntop Indian brands.',
      'subtitle':
          'Every product backed by official 1-year brand warranty, doorstep GST invoice, and express 24-hr metro dispatch across India.',
      'image': 'asset/onboarding_hero_2.png',
    },
    {
      'badge': 'SEAMLESS PAYMENTS',
      'title': 'Instant UPI, EMI &\nfestive exchange.',
      'subtitle':
          'Pay with Google Pay, PhonePe, Paytm, or no-cost credit card EMIs with instant ₹1,500 bank discounts and gold coin rewards.',
      'image': 'asset/onboarding_hero_3.png',
    },
  ];

  @override
  void initState() {
    super.initState();
    _pageController = PageController();

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
    _pageController.dispose();
    _entranceController.dispose();
    super.dispose();
  }

  Future<void> _completeOnboarding() async {
    HapticFeedback.lightImpact();
    await SessionManager().setOnboardingCompleted();
    if (!mounted) return;

    if (widget.onFinish != null) {
      widget.onFinish!();
    } else {
      AppNavigator.toLogin(context);
    }
  }

  void _onNext() {
    HapticFeedback.selectionClick();
    if (_currentPage < _slides.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 350),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _completeOnboarding();
    }
  }

  void _goToSignIn() {
    HapticFeedback.selectionClick();
    if (widget.onSignIn != null) {
      widget.onSignIn!();
    } else {
      AppNavigator.toLogin(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final topPadding = mediaQuery.padding.top;
    final bottomPadding = mediaQuery.padding.bottom;
    final screenHeight = mediaQuery.size.height;

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
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: Column(
              children: [
                SizedBox(height: topPadding > 0 ? topPadding + 8 : 28),

                // -----------------------------------------------------------
                // TOP APP BAR: Brand Logo + Skip Action
                // -----------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // TechKart Logo Icon
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

                      // "Skip" button
                      CupertinoButton(
                        padding: EdgeInsets.zero,
                        minimumSize: const Size(32, 32),
                        onPressed: _completeOnboarding,
                        child: Text(
                          'Skip',
                          style: GoogleFonts.literata(
                            fontSize: 15,
                            fontWeight: FontWeight.w400,
                            color: const Color(0xFF000000),
                            letterSpacing: 0.1,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // -----------------------------------------------------------
                // PAGE VIEW: HERO CARDS & COPY
                // -----------------------------------------------------------
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: const BouncingScrollPhysics(),
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemCount: _slides.length,
                    itemBuilder: (context, index) {
                      final slide = _slides[index];
                      return SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // ---------------------------------------------
                              // HERO CARD WITH ROUNDED CORNERS & FLOATING BADGE
                              // ---------------------------------------------
                              Container(
                                width: double.infinity,
                                constraints: BoxConstraints(
                                  maxHeight: (screenHeight * 0.38).clamp(240.0, 320.0),
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(28),
                                  boxShadow: [
                                    BoxShadow(
                                      color: const Color(0xFF000000).withValues(alpha: 0.06),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: ClipRRect(
                                  borderRadius: BorderRadius.circular(28),
                                  child: Stack(
                                    fit: StackFit.expand,
                                    children: [
                                      // Product Stage Image
                                      Image.asset(
                                        slide['image']!,
                                        fit: BoxFit.cover,
                                        errorBuilder:
                                            (context, error, stackTrace) =>
                                                Image.asset(
                                          'asset/onboarding_hero_1.png',
                                          fit: BoxFit.cover,
                                        ),
                                      ),

                                      // Bottom gradient feather
                                      Positioned(
                                        bottom: 0,
                                        left: 0,
                                        right: 0,
                                        height: 60,
                                        child: DecoratedBox(
                                          decoration: BoxDecoration(
                                            gradient: LinearGradient(
                                              begin: Alignment.bottomCenter,
                                              end: Alignment.topCenter,
                                              colors: [
                                                Colors.black.withValues(alpha: 0.08),
                                                Colors.transparent,
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),

                                      // "EFFORTLESS DISCOVERY" Floating Pill Badge
                                      Positioned(
                                        bottom: 16,
                                        left: 16,
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 14,
                                            vertical: 7,
                                          ),
                                          decoration: BoxDecoration(
                                            color: const Color(0xFFF8FAFC),
                                            borderRadius:
                                                BorderRadius.circular(24),
                                            boxShadow: [
                                              BoxShadow(
                                                color: Colors.black
                                                    .withValues(alpha: 0.08),
                                                blurRadius: 10,
                                                offset: const Offset(0, 3),
                                              ),
                                            ],
                                          ),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              const Icon(
                                                Icons.explore_outlined,
                                                size: 14,
                                                color: Color(0xFF000000),
                                              ),
                                              const SizedBox(width: 6),
                                              Text(
                                                slide['badge']!,
                                                style: GoogleFonts.literata(
                                                  fontSize: 10.5,
                                                  fontWeight: FontWeight.w700,
                                                  letterSpacing: 0.9,
                                                  color:
                                                      const Color(0xFF142D4E),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              const SizedBox(height: 28),

                              // ---------------------------------------------
                              // HEADLINE (Domine Bold)
                              // ---------------------------------------------
                              Text(
                                slide['title']!,
                                textAlign: TextAlign.center,
                                style: GoogleFonts.literata(
                                  fontSize: 27,
                                  fontWeight: FontWeight.w700,
                                  color: const Color(0xFF000000),
                                  height: 1.25,
                                  letterSpacing: -0.5,
                                ),
                              ),

                              const SizedBox(height: 14),

                              // ---------------------------------------------
                              // SUBTITLE (Literata Regular)
                              // ---------------------------------------------
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Text(
                                  slide['subtitle']!,
                                  textAlign: TextAlign.center,
                                  style: GoogleFonts.literata(
                                    fontSize: 14.5,
                                    fontWeight: FontWeight.w400,
                                    color: const Color(0xFF000000),
                                    height: 1.45,
                                  ),
                                ),
                              ),

                              const SizedBox(height: 20),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),

                // -----------------------------------------------------------
                // PAGINATION INDICATORS (Pill + Dots)
                // -----------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _slides.length,
                    (index) {
                      final isActive = _currentPage == index;
                      return AnimatedContainer(
                        duration: const Duration(milliseconds: 250),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 5,
                        width: isActive ? 24 : 6,
                        decoration: BoxDecoration(
                          color: isActive
                              ? const Color(0xFF142D4E)
                              : const Color(0xFFE2E8F0),
                          borderRadius: BorderRadius.circular(3),
                        ),
                      );
                    },
                  ),
                ),

                const SizedBox(height: 24),

                // -----------------------------------------------------------
                // PRIMARY BUTTON: "Continue ->"
                // -----------------------------------------------------------
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    width: double.infinity,
                    height: 54,
                    child: ElevatedButton(
                      onPressed: _onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF142D4E),
                        foregroundColor: const Color(0xFFF8FAFC),
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(28),
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            _currentPage == _slides.length - 1
                                ? 'Get Started'
                                : 'Continue',
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
                ),

                const SizedBox(height: 16),

                // -----------------------------------------------------------
                // FOOTER: "Already have an account? Sign In"
                // -----------------------------------------------------------
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      'Already have an account? ',
                      style: GoogleFonts.literata(
                        fontSize: 13.5,
                        fontWeight: FontWeight.w400,
                        color: const Color(0xFF000000),
                      ),
                    ),
                    GestureDetector(
                      onTap: _goToSignIn,
                      behavior: HitTestBehavior.opaque,
                      child: Text(
                        'Sign In',
                        style: GoogleFonts.literata(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                        ),
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // -----------------------------------------------------------
                // BOTTOM HOME INDICATOR BAR
                // -----------------------------------------------------------
                Container(
                  width: 134,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFF142D4E),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),

                SizedBox(height: bottomPadding > 0 ? bottomPadding + 4 : 12),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
