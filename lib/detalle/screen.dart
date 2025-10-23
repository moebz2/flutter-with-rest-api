import 'package:flutter/material.dart';

class PokemonDetailScreen extends StatelessWidget {
  final int id;
  final String name;

  const PokemonDetailScreen({super.key, required this.id, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          name
              .split('-')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' '),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            Text(
              'Pokémon #$id',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            Text(
              name
                  .split('-')
                  .map((word) => word[0].toUpperCase() + word.substring(1))
                  .join(' '),
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
    );
  }
}
