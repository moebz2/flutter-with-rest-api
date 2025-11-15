import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppThemes {
  static ThemeData get lightTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF87CEEB),
      scaffoldBackgroundColor: const Color(0xFFF8F9FA),
      brightness: Brightness.light,
      textTheme: GoogleFonts.shareTechTextTheme().copyWith(
        headlineLarge: GoogleFonts.pressStart2p(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        headlineMedium: GoogleFonts.pressStart2p(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        titleLarge: GoogleFonts.pressStart2p(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.black,
        ),
        bodyLarge: GoogleFonts.shareTech(
          fontSize: 16,
          color: Colors.black87,
        ),
        bodyMedium: GoogleFonts.shareTech(
          fontSize: 14,
          color: Colors.black87,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF87CEEB),
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: GoogleFonts.pressStart2p(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFFF0F8FF),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF98FB98),
          foregroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.shareTech(fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF87CEEB)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF87CEEB), width: 2),
        ),
        labelStyle: GoogleFonts.shareTech(fontSize: 14),
        hintStyle: GoogleFonts.shareTech(fontSize: 14),
      ),
      colorScheme: const ColorScheme.light(
        primary: Color(0xFF87CEEB),
        secondary: Color(0xFF98FB98),
        error: Color(0xFFFF9999),
        surface: Color(0xFFF0F8FF),
      ),
    );
  }

  static ThemeData get darkTheme {
    return ThemeData(
      primarySwatch: Colors.blue,
      primaryColor: const Color(0xFF4A90E2),
      scaffoldBackgroundColor: const Color(0xFF121212),
      brightness: Brightness.dark,
      textTheme: GoogleFonts.shareTechTextTheme().copyWith(
        headlineLarge: GoogleFonts.pressStart2p(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        headlineMedium: GoogleFonts.pressStart2p(
          fontSize: 20,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        titleLarge: GoogleFonts.pressStart2p(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
        bodyLarge: GoogleFonts.shareTech(
          fontSize: 16,
          color: Colors.white,
        ),
        bodyMedium: GoogleFonts.shareTech(
          fontSize: 14,
          color: Colors.white70,
        ),
      ),
      appBarTheme: AppBarTheme(
        backgroundColor: const Color(0xFF1F1F1F),
        foregroundColor: Colors.white,
        elevation: 2,
        titleTextStyle: GoogleFonts.pressStart2p(
          color: Colors.white,
          fontSize: 16,
        ),
      ),
      cardTheme: const CardThemeData(
        color: Color(0xFF1E1E1E),
        elevation: 3,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(12)),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF4A90E2),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          textStyle: GoogleFonts.shareTech(fontSize: 16),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF2A2A2A),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4A90E2)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF4A90E2), width: 2),
        ),
        labelStyle: GoogleFonts.shareTech(fontSize: 14, color: Colors.white70),
        hintStyle: GoogleFonts.shareTech(fontSize: 14, color: Colors.white54),
      ),
      colorScheme: const ColorScheme.dark(
        primary: Color(0xFF4A90E2),
        secondary: Color(0xFF66BB6A),
        error: Color(0xFFFF6B6B),
        surface: Color(0xFF1E1E1E),
      ),
    );
  }
}