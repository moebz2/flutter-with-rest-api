import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tp_pokemon/models/pokemon.dart';
import 'package:tp_pokemon/models/pokemon_list_response.dart';

import 'lista_item.dart';
import 'error_msg.dart';

class PokemonListScreen extends StatefulWidget {
  const PokemonListScreen({super.key});
  @override
  State<PokemonListScreen> createState() => _PokemonListScreenState();
}

class _PokemonListScreenState extends State<PokemonListScreen> {
  List<Pokemon> pokemonList = [];
  List<Pokemon> filteredPokemonList = [];
  bool isLoading = false;
  bool hasError = false;
  String? nextUrl;
  int currentOffset = 0;
  final int limit = 20;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadPokemon();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _searchController.dispose();
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

      debugPrint('_loadPokemon.response: ${response.body}');

      if (response.statusCode == 200) {
        final pokemonResponse = PokemonListResponse.fromJson(
          json.decode(response.body),
        );

        setState(() {
          pokemonList = pokemonResponse.results;
          filteredPokemonList = pokemonResponse.results;
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

  void _performSearch() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      if (query.isEmpty) {
        filteredPokemonList = pokemonList;
      } else {
        filteredPokemonList = pokemonList
            .where((pokemon) => pokemon.name.toLowerCase().contains(query))
            .toList();
      }
    });
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
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: const InputDecoration(
                      hintText: 'Buscar Pokemon...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _performSearch(), // Search on Enter key
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _performSearch,
                  child: const Text('Buscar'),
                ),
              ],
            ),
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: _refreshPokemon,
              child: _buildList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildList() {
    if (hasError && pokemonList.isEmpty) {
      return ErrorMsgWidget(onRetry: _loadPokemon);
    }

    if (isLoading && pokemonList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    final displayList = filteredPokemonList;
    final isFiltered = _searchController.text.isNotEmpty;

    return ListView.builder(
      controller: _scrollController,
      itemCount: displayList.length + (nextUrl != null && !isFiltered ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= displayList.length && !isFiltered) {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Center(child: CircularProgressIndicator()),
          );
        }

        final pokemon = displayList[index];

        return ListaItemWidget(name: pokemon.name, id: pokemon.id);
      },
    );
  }
}
