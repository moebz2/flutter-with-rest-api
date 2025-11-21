import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:tp_pokemon/providers/favorites_provider.dart';
import 'package:tp_pokemon/lista/lista_item.dart';

class FavoritesScreen extends StatelessWidget {
  const FavoritesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favoritos')),
      body: Consumer<FavoritesProvider>(
        builder: (context, favoritesProvider, child) {
          final favoritesList = favoritesProvider.getFavoritesList();

          if (favoritesList.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.favorite_border, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'No tienes favoritos aún',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Agrega a favoritos desde la página de detalle',
                    style: TextStyle(color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            itemCount: favoritesList.length,
            itemBuilder: (context, index) {
              final favorite = favoritesList[index];
              return ListaItemWidget(
                name: favorite['name'],
                id: favorite['id'],
              );
            },
          );
        },
      ),
    );
  }
}
