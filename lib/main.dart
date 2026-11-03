import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'app_routes/app_navigator.dart';
import 'authentication/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

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
          seedColor: const Color(0xFF00E5FF),
          brightness: Brightness.light,
        ),
        scaffoldBackgroundColor: const Color(0xFFFAF7EE),
        useMaterial3: true,
      ),
    );
  }
}
