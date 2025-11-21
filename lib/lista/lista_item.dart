import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_pokemon/providers/favorites_provider.dart';

import '../detalle/pokemon_detail_screen.dart';
import '../../utils/string_utils.dart';

class ListaItemWidget extends StatelessWidget {
  final String name;
  final int id;

  const ListaItemWidget({super.key, required this.name, required this.id});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: SizedBox(
          width: 56,
          height: 56,
          child: Hero(
            tag: 'pokemon_$id',
            child: Image.network(
              'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
              fit: BoxFit.contain,
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return const Center(
                  child: CircularProgressIndicator(strokeWidth: 2),
                );
              },
              errorBuilder: (context, error, stackTrace) {
                return CircleAvatar(
                  backgroundColor: Colors.blue.shade100,
                  child: Text(
                    '#$id',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        title: Text("#$id - ${StringUtils.getNombre(name)}"),

        trailing: Consumer<FavoritesProvider>(
          builder: (context, favoritesProvider, child) {
            return favoritesProvider.isFavorite(id)
                ? const Icon(Icons.favorite, color: Colors.red, size: 20)
                : const SizedBox.shrink();
          },
        ),
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetailScreen(id: id, name: name),
            ),
          );
        },
      ),
    );
  }
}
