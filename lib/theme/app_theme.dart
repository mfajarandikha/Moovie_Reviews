import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

class AppTheme {
  AppTheme._();

  static final ThemeData darkTheme = ThemeData(
    fontFamily: GoogleFonts.poppins().fontFamily,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.netflixRed,
      background: AppColors.netflixBlack,
      surface: AppColors.netflixDarkGrey,
      onPrimary: Colors.white,
      onBackground: AppColors.netflixLightGrey,
      onSurface: Colors.white,
    ),

    scaffoldBackgroundColor: AppColors.netflixBlack,

    appBarTheme: const AppBarTheme(
      backgroundColor: Colors.transparent,
      elevation: 0,
    ),

    textTheme: TextTheme(
      headlineLarge: GoogleFonts.poppins(fontSize: 32.0, fontWeight: FontWeight.bold),
      bodyLarge: GoogleFonts.poppins(fontSize: 16.0),
    ),
  );
}