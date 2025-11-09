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
  List<Pokemon> displayList = [];
  bool isLoading = false;
  bool hasError = false;
  String? nextUrl;
  int currentOffset = 0;
  final int limit = 20;
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _searchController = TextEditingController();
  bool isSearchMode = false;
  Pokemon? searchResult;

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
    debugPrint('_onScroll');

    if (!isSearchMode &&
        _scrollController.position.pixels >=
            _scrollController.position.maxScrollExtent - 200) {
      if (!isLoading && nextUrl != null) {
        _loadMorePokemon();
      }
    }
  }

  Future<void> _loadPokemon() async {
    debugPrint('_loadPokemon.start');

    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      // Solo para hacer más evidente el estado de carga.
      await Future.delayed(const Duration(seconds: 3));

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
          displayList = pokemonResponse.results; // Show the loaded list
          nextUrl = pokemonResponse.next;
          isLoading = false;
          isSearchMode = false; // Reset search mode
          searchResult = null;
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
    debugPrint('_loadMorePokemon');

    if (nextUrl == null || isSearchMode) return;

    setState(() {
      isLoading = true;
    });

    try {
      // Este delay es solamente para que sea más evidente
      // el estado de Loading, es decir, que se pueda ver
      // claramente que se está usando el CircularProgressIndicator
      await Future.delayed(const Duration(seconds: 3));

      final response = await http.get(Uri.parse(nextUrl!));

      if (response.statusCode == 200) {
        final pokemonResponse = PokemonListResponse.fromJson(
          json.decode(response.body),
        );

        setState(() {
          pokemonList.addAll(pokemonResponse.results);
          displayList.addAll(pokemonResponse.results);
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
    debugPrint('_refreshPokemon');

    setState(() {
      pokemonList.clear();
      displayList.clear();
      currentOffset = 0;
      nextUrl = null;
      isSearchMode = false;
      searchResult = null;
      _searchController.clear();
    });

    await _loadPokemon();
  }

  Future<void> _performSearch() async {
    debugPrint('_performSearch');

    final query = _searchController.text.trim().toLowerCase();

    if (query.isEmpty) {
      // If search is empty, return to normal list view
      setState(() {
        isSearchMode = false;
        displayList = pokemonList;
        searchResult = null;
      });
      return;
    }

    setState(() {
      isLoading = true;
      hasError = false;
    });

    try {
      // Try to search by exact name or ID
      final response = await http.get(
        Uri.parse('https://pokeapi.co/api/v2/pokemon/$query'),
      );

      debugPrint('_performSearch.response: ${response.statusCode}');

      if (response.statusCode == 200) {
        final pokemonData = json.decode(response.body);

        // Create a Pokemon object from the detailed response
        final foundPokemon = Pokemon(
          name: pokemonData['name'],
          url: 'https://pokeapi.co/api/v2/pokemon/${pokemonData['id']}/',
        );

        setState(() {
          isSearchMode = true;
          searchResult = foundPokemon;
          displayList = [foundPokemon]; // Show only the found pokemon
          isLoading = false;
        });
      } else if (response.statusCode == 404) {
        // Pokemon not found
        setState(() {
          isSearchMode = true;
          searchResult = null;
          displayList = [];
          isLoading = false;
        });
      } else {
        setState(() {
          hasError = true;
          isLoading = false;
        });
      }
    } catch (e) {
      debugPrint('Search error: $e');
      setState(() {
        hasError = true;
        isLoading = false;
      });
    }
  }

  void _clearSearch() {
    _searchController.clear();
    setState(() {
      isSearchMode = false;
      displayList = pokemonList;
      searchResult = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint('widgetBuild');

    return Scaffold(
      appBar: AppBar(
        title: Text(
          isSearchMode ? 'Resultado de Búsqueda' : 'Lista de Pokemones',
        ),
        actions: [
          if (isSearchMode)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
              tooltip: 'Limpiar búsqueda',
            ),
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
                      hintText: 'Buscar por nombre',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                      helperText: 'Ejemplo: pikachu, charmander',
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
    debugPrint('_buildList');

    if (hasError && displayList.isEmpty) {
      return ErrorMsgWidget(
        onRetry: isSearchMode ? _performSearch : _loadPokemon,
      );
    }

    if (isLoading && displayList.isEmpty) {
      return const Center(child: CircularProgressIndicator());
    }

    if (isSearchMode && displayList.isEmpty && !isLoading) {
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

    return ListView.builder(
      controller: _scrollController,
      itemCount:
          displayList.length + (!isSearchMode && nextUrl != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= displayList.length && !isSearchMode) {
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
