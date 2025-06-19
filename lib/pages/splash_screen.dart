import 'dart:async';
import 'package:flutter/material.dart';
import 'package:moovie/theme/app_colors.dart';
import 'main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(
      const Duration(seconds: 2),
          () => Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => MainPage()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/splash_screen.png',
              height: 450,
              errorBuilder: (context, error, stackTrace) {
                return const Icon(
                  Icons.movie_creation_outlined,
                  size: 150,
                  color: AppColors.netflixRed,
                );
              },
            ),
            const SizedBox(height: 24),
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.netflixLightGrey),
            ),
          ],
        ),
      ),
    );
  }
}
