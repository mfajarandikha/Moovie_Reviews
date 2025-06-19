import 'package:flutter/material.dart';
import 'package:moovie/pages/splash_screen.dart';
import 'package:moovie/theme/app_theme.dart';
void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Moovie',
      theme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      home: const SplashScreen(),
    );
  }
}
