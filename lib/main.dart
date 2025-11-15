import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:tp_pokemon/lista/pokemon_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokemones', // En dónde se ve este título??
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: const Color(0xFF87CEEB),
        scaffoldBackgroundColor: const Color(0xFFF8F9FA),
        textTheme: GoogleFonts.shareTechTextTheme(Theme.of(context).textTheme)
            .copyWith(
              headlineLarge: GoogleFonts.pressStart2p(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              headlineMedium: GoogleFonts.pressStart2p(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
              headlineSmall: GoogleFonts.pressStart2p(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
              titleLarge: GoogleFonts.pressStart2p(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              titleMedium: GoogleFonts.pressStart2p(
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ),
              titleSmall: GoogleFonts.pressStart2p(
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            ),
        appBarTheme: AppBarTheme(
          backgroundColor: Color(0xFF87CEEB),
          foregroundColor: Colors.white,
          elevation: 2,
          titleTextStyle: GoogleFonts.pressStart2p(
            color: Colors.white,
            fontSize: 16, // Reduced from 20
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
      ),
      home: const PokemonListScreen(),
    );
  }
}
