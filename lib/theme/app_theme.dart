import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// TechKart Customer App Unified Global Theme
///
/// Official Brand Colour Palette:
/// - Pure White: #FFFFFF (70% visual distribution - dominant background & surfaces)
/// - Pure Black: #000000 (15% visual distribution - typography, primary text & icons)
/// - Navy Blue: #142D4E (15% visual distribution - brand highlights, primary buttons, active navigation)
class AppTheme {
  // 1. Core Official Brand Palette
  static const Color pureWhite = Color(0xFFFFFFFF);
  static const Color pureBlack = Color(0xFF000000);
  static const Color navyBlue = Color(0xFF142D4E);

  // 2. Supporting Light Theme Neutrals & Surfaces (70% White / Neutral Surface Hierarchy)
  static const Color scaffoldBackground = Color(0xFFFFFFFF);
  static const Color cardColor = Color(0xFFFFFFFF);
  static const Color surfaceLight = Color(0xFFF8FAFC);
  static const Color secondarySurface = Color(0xFFF1F5F9);
  static const Color softWhite = Color(0xFFF7F7F7);
  static const Color borders = Color(0xFFE2E8F0);
  static const Color dividerColor = Color(0xFFE2E8F0);

  // 3. Typography Hierarchy (15% Pure Black Contrast)
  static const Color primaryText = Color(0xFF000000);
  static const Color secondaryText = Color(0xFF4A5568);
  static const Color textMuted = Color(0xFF64748B);
  static const Color bodyText = Color(0xFF000000);

  // 4. Primary Brand Accents & Interactive Elements (15% Navy Blue)
  static const Color primaryNavy = Color(0xFF142D4E);
  static const Color primaryButton = Color(0xFF142D4E);
  static const Color activeNavPill = Color(0xFF142D4E);
  static const Color brandAccent = Color(0xFF142D4E);

  // 5. Semantic Status Colors (Preserved for status indicators)
  static const Color success = Color(0xFF107C41);
  static const Color error = Color(0xFFDC2626);
  static const Color warning = Color(0xFFF59E0B);
  static const Color pending = Color(0xFFED6C02);

  // 6. Backward Compatibility Aliases for Legacy Screen References
  static const Color christmasRed = Color(0xFF142D4E);
  static const Color evergreen = Color(0xFF142D4E);
  static const Color snowWhite = Color(0xFFFFFFFF);
  static const Color christmasGold = Color(0xFFE2E8F0);
  static const Color winterIceBlue = Color(0xFFF8FAFC);
  static const Color midnightNavy = Color(0xFF000000);
  static const Color champagneGold = Color(0xFFE2E8F0);
  static const Color winterMist = Color(0xFFF8FAFC);
  static const Color starGold = Color(0xFF142D4E);
  static const Color snowySage = Color(0xFFF8FAFC);
  static const Color softBerry = Color(0xFF142D4E);
  static const Color oceanBlue = Color(0xFF142D4E);
  static const Color ivory = Color(0xFFF8FAFC);
  static const Color highlightBg = Color(0xFFFFFFFF);
  static const Color darkGoldenrod = Color(0xFF142D4E);
  static const Color black = Color(0xFF000000);

  // 7. Typography Styles: Literata (Official global font family for TechKart)
  static TextStyle headlineStyle({
    double fontSize = 20,
    FontWeight fontWeight = FontWeight.w700,
    Color color = primaryText,
    double? height,
    TextOverflow? overflow,
  }) {
    return GoogleFonts.literata(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle bodyStyle({
    double fontSize = 14,
    FontWeight fontWeight = FontWeight.w400,
    Color color = primaryText,
    double? height,
    TextOverflow? overflow,
  }) {
    return GoogleFonts.literata(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  static TextStyle labelStyle({
    double fontSize = 12,
    FontWeight fontWeight = FontWeight.w500,
    Color color = secondaryText,
    double? height,
  }) {
    return GoogleFonts.literata(
      fontSize: fontSize,
      fontWeight: fontWeight,
      color: color,
      height: height,
    );
  }

  // 8. Reusable Centralized ThemeData for Root MaterialApp
  static ThemeData get lightTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      fontFamily: GoogleFonts.literata().fontFamily,
      focusColor: Colors.transparent,
      primaryColor: navyBlue,
      scaffoldBackgroundColor: pureWhite,
      cardColor: pureWhite,
      dividerColor: borders,
      colorScheme: const ColorScheme(
        brightness: Brightness.light,
        primary: navyBlue,
        onPrimary: pureWhite,
        secondary: pureBlack,
        onSecondary: pureWhite,
        tertiary: navyBlue,
        onTertiary: pureWhite,
        error: error,
        onError: pureWhite,
        surface: pureWhite,
        onSurface: pureBlack,
      ),
      textTheme: GoogleFonts.literataTextTheme().copyWith(
        headlineLarge: GoogleFonts.literata(color: pureBlack, fontWeight: FontWeight.w700),
        headlineMedium: GoogleFonts.literata(color: pureBlack, fontWeight: FontWeight.w700),
        titleLarge: GoogleFonts.literata(color: pureBlack, fontWeight: FontWeight.w700),
        titleMedium: GoogleFonts.literata(color: pureBlack, fontWeight: FontWeight.w600),
        bodyLarge: GoogleFonts.literata(color: pureBlack, fontWeight: FontWeight.w400),
        bodyMedium: GoogleFonts.literata(color: pureBlack, fontWeight: FontWeight.w400),
        bodySmall: GoogleFonts.literata(color: secondaryText, fontWeight: FontWeight.w400),
        labelLarge: GoogleFonts.literata(color: pureBlack, fontWeight: FontWeight.w600),
        labelMedium: GoogleFonts.literata(color: secondaryText, fontWeight: FontWeight.w500),
        labelSmall: GoogleFonts.literata(color: textMuted, fontWeight: FontWeight.w500),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: pureWhite,
        foregroundColor: pureBlack,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        titleTextStyle: GoogleFonts.literata(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: pureBlack,
        ),
        iconTheme: const IconThemeData(color: pureBlack, size: 22),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: navyBlue,
          foregroundColor: pureWhite,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.literata(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: pureWhite,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: navyBlue,
          side: const BorderSide(color: navyBlue, width: 1.2),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          textStyle: GoogleFonts.literata(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: navyBlue,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: navyBlue,
          textStyle: GoogleFonts.literata(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: navyBlue,
          ),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: pureWhite,
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borders, width: 1),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borders, width: 1),
        ),
        // Globally remove unwanted focus outlines: match enabledBorder thickness and color
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: borders, width: 1),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: error, width: 1),
        ),
        hintStyle: GoogleFonts.literata(
          fontSize: 13,
          color: textMuted,
        ),
        labelStyle: GoogleFonts.literata(
          fontSize: 14,
          color: secondaryText,
        ),
      ),
      cardTheme: CardThemeData(
        color: pureWhite,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: borders, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: pureWhite,
        surfaceTintColor: Colors.transparent,
        elevation: 8,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
      ),
      dialogTheme: DialogThemeData(
        backgroundColor: pureWhite,
        surfaceTintColor: Colors.transparent,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        titleTextStyle: GoogleFonts.literata(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: pureBlack,
        ),
        contentTextStyle: GoogleFonts.literata(
          fontSize: 14,
          color: primaryText,
        ),
      ),
    );
  }
}
