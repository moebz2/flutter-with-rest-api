import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:tp_pokemon/utils/string_utils.dart';

class PokemonDetailScreen extends StatefulWidget {
  final int id;
  final String name;

  const PokemonDetailScreen({super.key, required this.id, required this.name});

  @override
  State<PokemonDetailScreen> createState() => _PokemonDetailScreenState();
}

class _PokemonDetailScreenState extends State<PokemonDetailScreen> {
  List<String> types = [];
  int height = 0;
  int weight = 0;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadPokemonDetails();
  }

  Future<void> _loadPokemonDetails() async {
    try {
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/${widget.id}'),
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final List<dynamic> typesData = data['types'];

        setState(() {
          types = typesData
              .map<String>(
                (type) =>
                    StringUtils.traducirTipo(type['type']['name'] as String),
              )
              .toList();
          height = data['height'];
          weight = data['weight'];
          isLoading = false;
        });
      } else {
        setState(() {
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(StringUtils.getNombre(widget.name))),
      // Hacer scrolleable por si acaso.
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [_imageSection(), _textSection(context)],
        ),
      ),
    );
  }

  Padding _textSection(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 24),
          _characteristicRow(context, Icons.tag, 'Número: ${widget.id}'),
          const SizedBox(height: 8),
          _characteristicRow(
            context,
            Icons.catching_pokemon,
            "Nombre: ${StringUtils.getNombre(widget.name)}",
          ),
          const SizedBox(height: 8),
          _characteristicRow(
            context,
            Icons.category,
            isLoading ? 'Tipos: Cargando...' : 'Tipos: ${types.join(', ')}',
          ),
          const SizedBox(height: 8),
          _characteristicRow(
            context,
            Icons.height,
            isLoading ? 'Altura: Cargando...' : 'Altura: ${height / 10} m',
          ),
          const SizedBox(height: 8),
          _characteristicRow(
            context,
            Icons.fitness_center,
            isLoading ? 'Peso: Cargando...' : 'Peso: ${weight / 10} kg',
          ),
        ],
      ),
    );
  }

  Center _imageSection() {
    return Center(
      child: Container(
        width: 300,
        height: 300,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          color: Colors.grey.shade100,
        ),
        child: _bigImage(),
      ),
    );
  }

  Image _bigImage() {
    return Image.network(
      // Imagen grande
      'https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/${widget.id}.png',
      fit: BoxFit.contain,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(child: CircularProgressIndicator());
      },
      errorBuilder: (context, error, stackTrace) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.image_not_supported,
                size: 64,
                color: Colors.grey.shade400,
              ),
              const SizedBox(height: 8),
              Text(
                'Imagen no disponible',
                style: TextStyle(color: Colors.grey.shade600),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _characteristicRow(BuildContext context, IconData icon, String text) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, size: 20, color: Theme.of(context).primaryColor),
        const SizedBox(width: 8),
        Expanded(
          child: Text(text, style: Theme.of(context).textTheme.bodyLarge),
        ),
      ],
    );
  }
}
