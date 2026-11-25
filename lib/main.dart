import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_routes/app_navigator.dart';
import 'authentication/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Cap image cache to prevent GPU/Gralloc buffer memory crashes on physical devices
  PaintingBinding.instance.imageCache.maximumSize = 100;
  PaintingBinding.instance.imageCache.maximumSizeBytes = 50 * 1024 * 1024; // 50MB

  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness: Brightness.light,
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ),
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TechKart',
      debugShowCheckedModeBanner: false,
      navigatorKey: AppNavigator.navigatorKey,
      home: const SplashScreen(),
      onGenerateRoute: AppNavigator.onGenerateRoute,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1B365D),
          primary: const Color(0xFF0D1B2A),
          secondary: const Color(0xFF1B365D),
          tertiary: const Color(0xFFB8860B),
          surface: const Color(0xFFF5EBDD),
          
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFDFBCF),
        cardColor: const Color(0xFFF5EBDD),
        dividerColor: const Color(0xFFE6C17A),
        focusColor: Colors.transparent,
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        textSelectionTheme: const TextSelectionThemeData(
          cursorColor: Color(0xFF0D1B2A),
          selectionColor: Color(0x33E6C17A),
          selectionHandleColor: Color(0xFF0D1B2A),
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFFFDFBCF),
          foregroundColor: Color(0xFF0D1B2A),
          elevation: 0,
          scrolledUnderElevation: 0,
          iconTheme: IconThemeData(color: Color(0xFF0D1B2A)),
          titleTextStyle: TextStyle(
            color: Color(0xFF0D1B2A),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        cardTheme: CardThemeData(
          color: const Color(0xFFF5EBDD),
          elevation: 0,
          shape: RoundedRectangleBorder(
            side: const BorderSide(color: Color(0xFFE6C17A)),
            borderRadius: BorderRadius.circular(16),
          ),
        ),
        inputDecorationTheme: InputDecorationTheme(
          filled: false,
          fillColor: Colors.transparent,
          focusColor: Colors.transparent,
          hoverColor: Colors.transparent,
          hintStyle: const TextStyle(color: Color(0xFF1B365D)),
          labelStyle: const TextStyle(color: Color(0xFF1B365D)),
          prefixIconColor: const Color(0xFF1B365D),
          suffixIconColor: const Color(0xFF1B365D),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE6C17A)),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE6C17A)),
          ),
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE6C17A)),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: Color(0xFFE6C17A)),
          ),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF0D1B2A),
            foregroundColor: const Color(0xFFF5EBDD),
            elevation: 0,
            side: const BorderSide(color: Color(0xFF0D1B2A)),
          ),
        ),
        outlinedButtonTheme: OutlinedButtonThemeData(
          style: OutlinedButton.styleFrom(
            backgroundColor: const Color(0xFFF5EBDD),
            foregroundColor: const Color(0xFF1B365D),
            side: const BorderSide(color: Color(0xFF1B365D)),
          ),
        ),
        textButtonTheme: TextButtonThemeData(
          style: TextButton.styleFrom(
            foregroundColor: const Color(0xFF1B365D),
          ),
        ),
        iconTheme: const IconThemeData(
          color: Color(0xFF0D1B2A),
        ),
        dividerTheme: const DividerThemeData(
          color: Color(0xFFE6C17A),
          thickness: 1,
        ),
        bottomNavigationBarTheme: const BottomNavigationBarThemeData(
          backgroundColor: Color(0xFF0D1B2A),
          selectedItemColor: Color(0xFFF5EBDD),
          unselectedItemColor: Color(0xFFE6C17A),
        ),
        dialogTheme: const DialogThemeData(
          backgroundColor: Color(0xFFF5EBDD),
          surfaceTintColor: Colors.transparent,
        ),
        bottomSheetTheme: const BottomSheetThemeData(
          backgroundColor: Color(0xFFF5EBDD),
          surfaceTintColor: Colors.transparent,
        ),
        useMaterial3: true,
      ),
    );
  }
}
