import 'package:flutter/material.dart';

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

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});
  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  // Suppose you have a list of Pokémon names/IDs to show
  final List<Map<String, dynamic>> pokemonItems = [
    {'id': 1, 'name': 'Bulbasaur'},
    {'id': 2, 'name': 'Ivysaur'},
    // ... etc
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pokémon List')),
      body: ListView.builder(
        itemCount: pokemonItems.length,
        itemBuilder: (context, index) {
          final item = pokemonItems[index];
          return ListTile(
            title: Text(item['name']),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => PokemonDetailScreen(
                    id: item['id'],
                    name: item['name'],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

class PokemonDetailScreen extends StatelessWidget {
  final int id;
  final String name;

  const PokemonDetailScreen({
    super.key,
    required this.id,
    required this.name,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(name)),
      body: Center(
        child: Text('Details for Pokémon #$id: $name'),
      ),
    );
  }
}