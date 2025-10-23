import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'lista_item.dart';
import 'error_msg.dart';

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

class Pokemon {
  final String name;
  final String url;

  Pokemon({required this.name, required this.url});

  factory Pokemon.fromJson(Map<String, dynamic> json) {
    return Pokemon(name: json['name'], url: json['url']);
  }

  int get id {
    final parts = url.split('/');
    return int.parse(parts[parts.length - 2]);
  }
}

class PokemonListResponse {
  final int count;
  final String? next;
  final String? previous;
  final List<Pokemon> results;

  PokemonListResponse({
    required this.count,
    this.next,
    this.previous,
    required this.results,
  });

  factory PokemonListResponse.fromJson(Map<String, dynamic> json) {
    return PokemonListResponse(
      count: json['count'],
      next: json['next'],
      previous: json['previous'],
      results: (json['results'] as List)
          .map((pokemon) => Pokemon.fromJson(pokemon))
          .toList(),
    );
  }
}

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});
  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  List<Pokemon> pokemonList = [];
  bool isLoading = false;
  bool hasError = false;
  String? nextUrl;
  int currentOffset = 0;
  final int limit = 20;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _loadPokemon();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      if (!isLoading && nextUrl != null) {
        _loadMorePokemon();
      }
    }
  }

  Future<void> _loadPokemon() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      final response = await http.get(
        Uri.parse(
          'https://pokeapi.co/api/v2/pokemon?limit=$limit&offset=$currentOffset',
        ),
      );

      if (response.statusCode == 200) {
        final pokemonResponse = PokemonListResponse.fromJson(
          json.decode(response.body),
        );

        setState(() {
          pokemonList = pokemonResponse.results;
          nextUrl = pokemonResponse.next;
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  Future<void> _loadMorePokemon() async {
    if (nextUrl == null) return;

    setState(() {
      isLoading = true;
    });

    try {
      final response = await http.get(Uri.parse(nextUrl!));

      if (response.statusCode == 200) {
        final pokemonResponse = PokemonListResponse.fromJson(
          json.decode(response.body),
        );

        setState(() {
          pokemonList.addAll(pokemonResponse.results);
          nextUrl = pokemonResponse.next;
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

  Future<void> _refreshPokemon() async {
    setState(() {
      pokemonList.clear();
      currentOffset = 0;
      nextUrl = null;
    });
    await _loadPokemon();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Lista de Pokemones'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPokemon,
          ),
        ],
      ),
      body: RefreshIndicator(onRefresh: _refreshPokemon, child: _buildBody()),
    );
  }

  Widget _buildBody() {
    if (hasError && pokemonList.isEmpty) {
      return ErrorMsgWidget(onRetry: _loadPokemon);
    }

    if (isLoading && pokemonList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    return ListView.builder(
      controller: _scrollController,
      itemCount: pokemonList.length + (nextUrl != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= pokemonList.length) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final pokemon = pokemonList[index];

        return ListaItemWidget(name: pokemon.name, id: pokemon.id);
      },
    );
  }
}
