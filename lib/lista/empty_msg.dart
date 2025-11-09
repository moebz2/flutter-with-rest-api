import 'package:flutter/material.dart';

class EmptyMsgWidget extends StatelessWidget {
  const EmptyMsgWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 64, color: Colors.grey),
          SizedBox(height: 16),
          Text(
            'No se encontraron resultados',
            style: TextStyle(fontSize: 18, color: Colors.grey),
          ),
          SizedBox(height: 8),
          Text(
            'Intenta buscar con el nombre exacto o ID del Pokémon',
            style: TextStyle(color: Colors.grey),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
