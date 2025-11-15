import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_pokemon/lista/pokemon_list_screen.dart';
import 'package:tp_pokemon/theme/theme_provider.dart';
import 'package:tp_pokemon/theme/app_themes.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeProvider>(
      builder: (context, themeProvider, child) {
        return MaterialApp(
          title: 'Pokemones', // En dónde se ve este título??
          theme: AppThemes.lightTheme,
          darkTheme: AppThemes.darkTheme,
          themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,
          home: const PokemonListScreen(),
        );
      },
    );
  }
}