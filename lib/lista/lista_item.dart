import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_pokemon/providers/favorites_provider.dart';

import '../detalle/pokemon_detail_screen.dart';
import '../../utils/string_utils.dart';

class ListaItemWidget extends StatelessWidget {
  final String name;
  final int id;
  final bool isGridView;

  const ListaItemWidget({
    super.key,
    required this.name,
    required this.id,
    this.isGridView = false,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => PokemonDetailScreen(id: id, name: name),
            ),
          );
        },
        child: isGridView
            ? _buildGridLayout(context)
            : _buildListLayout(context),
      ),
    );
  }

  Widget _buildListLayout(BuildContext context) {
    return ListTile(
      leading: SizedBox(width: 56, height: 56, child: _buildImage()),
      title: Text("#$id - ${StringUtils.getNombre(name)}"),
      trailing: _buildFavoriteIcon(),
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    );
  }

  Widget _buildGridLayout(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(child: _buildImage()),
          const SizedBox(height: 8),
          Text('#$id', style: Theme.of(context).textTheme.bodySmall),
          Text(
            StringUtils.getNombre(name),
            style: Theme.of(context).textTheme.bodyMedium,
            textAlign: TextAlign.center,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          const SizedBox(height: 4),
          _buildFavoriteIcon(),
        ],
      ),
    );
  }

  Widget _buildImage() {
    return Hero(
      tag: 'pokemon_$id',
      child: Image.network(
        'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/$id.png',
        fit: BoxFit.contain,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return const Center(child: CircularProgressIndicator(strokeWidth: 2));
        },
        errorBuilder: (context, error, stackTrace) {
          return CircleAvatar(
            backgroundColor: Colors.blue.shade100,
            child: Text(
              '#$id',
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          );
        },
      ),
    );
  }

  Widget _buildFavoriteIcon() {
    return Consumer<FavoritesProvider>(
      builder: (context, favoritesProvider, child) {
        return favoritesProvider.isFavorite(id)
            ? const Icon(Icons.favorite, color: Colors.red, size: 20)
            : const SizedBox.shrink();
      },
    );
  }
}
