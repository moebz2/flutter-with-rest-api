import 'package:flutter/material.dart';
import '../detalle/screen.dart';

class ListaItemWidget extends StatelessWidget {
  final String name;
  final int id;

  const ListaItemWidget({
    super.key,
    required this.name,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      child: ListTile(
        leading: SizedBox(
          width: 56,
          height: 56,
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
        title: Text(
          name
              .split('-')
              .map((word) => word[0].toUpperCase() + word.substring(1))
              .join(' '),
          style: const TextStyle(fontWeight: FontWeight.w500),
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