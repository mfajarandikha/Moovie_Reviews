import 'package:flutter/material.dart';
import 'package:moovie/pages/splash_screen.dart'; // Import the splash screen
import 'package:moovie/theme/app_theme.dart'; // Import your theme

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moovie',
      theme: AppTheme.darkTheme, // Apply your custom dark theme
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(), // Start the app with the SplashScreen
    );
  }
}
