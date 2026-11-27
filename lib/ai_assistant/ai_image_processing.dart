import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import '../app_routes/app_navigator.dart';

/// TechKart AI Image Processing Screen (Visual Search in Progress)
///
/// 100% visual fidelity reproduction of the AI Image Processing reference:
/// - Light airy background (#F5FAFF)
/// - Top bar: Circular back button (#EAF5FF) + "VISUAL SEARCH" in Domine / Literata bold.
/// - Hero Viewfinder Card:
///   - White rounded card (28px radius) showcasing the captured product (`asset/chronos_ultra_2.jpg`).
///   - Top floating badge: "Analyzing" with spinning sync icon.
///   - Top-right / bottom-left reticle bracket guides.
///   - Bottom-right pill badge: "• 98.4% FRAME LOCK".
///   - Simulated scanning beam / analysis overlay.
/// - Headline: "Identifying Hardware" in bold Domine serif font (#00344B).
/// - Subtitle: "Cross-referencing telemetry with 45,000+ certified smart devices, components, and live stock."
/// - 3-Dot Pager Indicator (Dark active pill + 2 light sky-blue dots).
/// - Detected Feature Pills:
///   - "• Wearable Detected" (Soft beige pill #F3EEE4, text #8B6B2B)
///   - "• Titanium Chassis • Round Bezel" (Soft sky blue pill #EAF5FF, text #00344B)
///   - "✔ Digital Crown Calibrated" (Soft light blue pill #D9ECFE, text #00344B)
/// - Primary Action Button: "Retake Photo" (#EAF5FF rounded button with refresh icon).
/// - Footer Hint: Lightbulb icon + "Keep device in centered, bright ambient lighting for instant match."
/// - Home indicator bar.
class AiImageProcessingScreen extends StatefulWidget {
  final String? imagePath;
  final VoidCallback? onClose;
  final VoidCallback? onRetakePhoto;

  const AiImageProcessingScreen({
    super.key,
    this.imagePath,
    this.onClose,
    this.onRetakePhoto,
  });

  @override
  State<AiImageProcessingScreen> createState() =>
      _AiImageProcessingScreenState();
}

class _AiImageProcessingScreenState extends State<AiImageProcessingScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _pulseController;
  Timer? _transitionTimer;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    // Auto-transition to Visual Search Results after simulating analysis
    _transitionTimer = Timer(const Duration(milliseconds: 2600), () {
      if (!mounted) return;
      AppNavigator.toVisualSearchResults(context);
    });
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _transitionTimer?.cancel();
    super.dispose();
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
        child: Column(
          children: [
            SizedBox(height: topPadding > 0 ? topPadding + 6 : 24),

            // ---------------------------------------------------------------
            // TOP BAR: Circular Back Button + "VISUAL SEARCH"
            // ---------------------------------------------------------------
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: [
                  GestureDetector(
                    onTap: widget.onClose ?? () => Navigator.of(context).pop(),
                    child: Container(
                      width: 42,
                      height: 42,
                      decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                      child: const Center(
                        child: Icon(
                          Icons.close_rounded,
                          size: 20,
                          color: Color(0xFF000000),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Text(
                    'VISUAL SEARCH',
                    style: GoogleFonts.literata(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.9,
                      color: const Color(0xFF000000),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            // ---------------------------------------------------------------
            // MAIN BODY
            // ---------------------------------------------------------------
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // Viewfinder Card
                      Container(
                        width: double.infinity,
                        height: 320,
                        decoration: BoxDecoration(
                          color: const Color(0xFFF8FAFC),
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF000000).withValues(alpha: 0.06),
                              blurRadius: 18,
                              offset: const Offset(0, 6),
                            ),
                          ],
                        ),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(28),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              Image.asset(
                                widget.imagePath ?? 'asset/chronos_ultra_2.jpg',
                                fit: BoxFit.cover,
                                errorBuilder: (context, error, stackTrace) =>
                                    Container(
                                  color: const Color(0xFF142D4E),
                                ),
                              ),

                              // Reticle brackets top-right & bottom-left
                              Positioned(
                                top: 20,
                                right: 20,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      top: BorderSide(
                                          color: Color(0xFF000000), width: 2),
                                      right: BorderSide(
                                          color: Color(0xFF000000), width: 2),
                                    ),
                                  ),
                                ),
                              ),
                              Positioned(
                                bottom: 20,
                                left: 20,
                                child: Container(
                                  width: 14,
                                  height: 14,
                                  decoration: const BoxDecoration(
                                    border: Border(
                                      bottom: BorderSide(
                                          color: Color(0xFF000000), width: 2),
                                      left: BorderSide(
                                          color: Color(0xFF000000), width: 2),
                                    ),
                                  ),
                                ),
                              ),

                              // Floating Top "Analyzing" Badge
                              Positioned(
                                top: 16,
                                left: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC).withValues(alpha: 0.95),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Icon(
                                        Icons.sync_rounded,
                                        size: 15,
                                        color: Color(0xFF000000),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        'Analyzing',
                                        style: GoogleFonts.literata(
                                          fontSize: 12,
                                          fontWeight: FontWeight.w600,
                                          color: const Color(0xFF000000),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              // Bottom-right Frame Lock Pill
                              Positioned(
                                bottom: 16,
                                right: 16,
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 12,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFFF8FAFC).withValues(alpha: 0.95),
                                    borderRadius: BorderRadius.circular(20),
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.black.withValues(alpha: 0.08),
                                        blurRadius: 8,
                                        offset: const Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Container(
                                        width: 6,
                                        height: 6,
                                        decoration: const BoxDecoration(
                                          color: Color(0xFF000000),
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        '98.4% FRAME LOCK',
                                        style: GoogleFonts.literata(
                                          fontSize: 10,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 0.6,
                                          color: const Color(0xFF000000),
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

                      // Headline: "Identifying Hardware"
                      Text(
                        'Identifying Hardware',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.literata(
                          fontSize: 27,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF000000),
                          letterSpacing: -0.5,
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Subtitle
                      Text(
                        'Cross-referencing telemetry with 45,000+\ncertified smart devices, components, and\nlive stock.',
                        textAlign: TextAlign.center,
                        style: GoogleFonts.literata(
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                          color: const Color(0xFF000000),
                          height: 1.45,
                        ),
                      ),

                      const SizedBox(height: 18),

                      // 3-Segment Pager Indicator
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 26,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF000000),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 6,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF142D4E),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                          const SizedBox(width: 5),
                          Container(
                            width: 6,
                            height: 4,
                            decoration: BoxDecoration(
                              color: const Color(0xFF142D4E),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 22),

                      // Detected Feature Pill 1: Wearable Detected
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFF142D4E),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(color: Color(0xFFF1F5F9), shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Wearable Detected',
                              style: GoogleFonts.literata(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF142D4E),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Detected Feature Pill 2: Titanium Chassis • Round Bezel
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 7,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE8F2FD),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                color: const Color(0xFF142D4E),
                                shape: BoxShape.circle,
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Titanium Chassis • Round Bezel',
                              style: GoogleFonts.literata(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF142D4E),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 10),

                      // Detected Feature Pill 3: Digital Crown Calibrated
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
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
                              Icons.check_circle_outline_rounded,
                              size: 14,
                              color: const Color(0xFF142D4E),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              'Digital Crown Calibrated',
                              style: GoogleFonts.literata(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF142D4E),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Retake Photo Button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            HapticFeedback.selectionClick();
                            if (widget.onRetakePhoto != null) {
                              widget.onRetakePhoto!();
                            } else {
                              Navigator.of(context).pop();
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF142D4E),
                            foregroundColor: const Color(0xFFFFFFFF),
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.refresh_rounded,
                                size: 18,
                                color: Color(0xFF000000),
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Retake Photo',
                                style: GoogleFonts.literata(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                  color: const Color(0xFF000000),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 16),

                      // Footer Hint
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.lightbulb_outline_rounded,
                            size: 14,
                            color: Color(0xFF000000),
                          ),
                          const SizedBox(width: 6),
                          Flexible(
                            child: Text(
                              'Keep device in centered, bright ambient lighting for instant match.',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.literata(
                                fontSize: 11,
                                color: const Color(0xFF000000),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),
            ),

            // Home indicator
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
            SizedBox(height: bottomPadding > 0 ? bottomPadding + 4 : 12),
          ],
        ),
      ),
    );
  }
}
