import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class YoshiTheme {
  // Colors
  static const Color yoshiGreen = Color(0xFF76C043);
  static const Color yoshiLightGreen = Color(0xFFB8E986);
  static const Color yoshiBootsOrange = Color(0xFFFF9900);
  static const Color yoshiBellyWhite = Color(0xFFF9F9F9);
  static const Color skyBlue = Color(0xFF87CEEB);
  static const Color darkText = Color(0xFF333333);

  static ThemeData get themeData {
    return ThemeData(
      primaryColor: yoshiGreen,
      scaffoldBackgroundColor: yoshiBellyWhite,
      colorScheme: ColorScheme.fromSeed(
        seedColor: yoshiGreen,
        secondary: yoshiBootsOrange,
        background: yoshiBellyWhite,
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: yoshiGreen,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        titleTextStyle: GoogleFonts.fredoka(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ),
      textTheme: TextTheme(
        bodyLarge: GoogleFonts.nunito(fontSize: 18, color: darkText),
        bodyMedium: GoogleFonts.nunito(fontSize: 16, color: darkText),
        titleLarge: GoogleFonts.fredoka(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: yoshiGreen,
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: yoshiGreen,
          foregroundColor: Colors.white,
          textStyle: GoogleFonts.fredoka(fontSize: 18, fontWeight: FontWeight.bold),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      useMaterial3: true,
    );
  }
}
