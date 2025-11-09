import 'package:flutter/material.dart';
import 'package:tp_pokemon/lista/pokemon_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Pokémon List',
      theme: ThemeData(primarySwatch: Colors.blue),
      home: const PokemonListScreen(),
    );
  }
}
