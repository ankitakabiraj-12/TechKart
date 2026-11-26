import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_routes/app_navigator.dart';
import 'authentication/splash_screen.dart';
import 'theme/app_theme.dart';

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
      theme: AppTheme.lightTheme,
    );
  }
}
