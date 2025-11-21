import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:tp_pokemon/favoritos/favorites_screen.dart';

import 'package:tp_pokemon/lista/empty_msg.dart';
import 'package:tp_pokemon/models/pokemon.dart';
import 'package:tp_pokemon/models/pokemon_list_response.dart';

import 'lista_item.dart';
import 'error_msg.dart';
import 'loading_msg.dart';

import 'package:tp_pokemon/theme/theme_provider.dart';

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
  bool isGridView = false;
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

  void _toggleView() {
    setState(() {
      isGridView = !isGridView;
    });
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
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              isSearchMode ? Icons.search : Icons.catching_pokemon,
              size: 18,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                isSearchMode ? 'Búsqueda' : 'Pokemones',
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        actions: [
          if (isSearchMode)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: _clearSearch,
              tooltip: 'Limpiar búsqueda',
            ),
          IconButton(
            icon: Icon(isGridView ? Icons.list : Icons.grid_view),
            onPressed: _toggleView,
            tooltip: isGridView ? 'Vista de lista' : 'Vista de cuadrícula',
          ),
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const FavoritesScreen(),
                ),
              );
            },
            tooltip: 'Favoritos',
          ),
          Consumer<ThemeProvider>(
            builder: (context, themeProvider, child) {
              return IconButton(
                icon: Icon(
                  themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
                ),
                onPressed: () => themeProvider.toggleTheme(),
                tooltip: themeProvider.isDarkMode
                    ? 'Modo claro'
                    : 'Modo oscuro',
              );
            },
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _refreshPokemon,
          ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Column _buildBody() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [_buildSearchSection(), _buildListWithRefresh()],
    );
  }

  Expanded _buildListWithRefresh() {
    return Expanded(
      child: RefreshIndicator(onRefresh: _refreshPokemon, child: _buildList()),
    );
  }

  Padding _buildSearchSection() {
    return Padding(
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
              ),
              onSubmitted: (_) => _performSearch(),
            ),
          ),
          const SizedBox(width: 8),
          SizedBox(
            height: 56,
            child: ElevatedButton(
              onPressed: _performSearch,
              child: const Icon(Icons.search),
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
      return LoadingMsgWidget();
    }

    if (isSearchMode && displayList.isEmpty && !isLoading) {
      return EmptyMsgWidget();
    }

    // Single GridView.builder that adapts to list or grid
    return GridView.builder(
      controller: _scrollController,
      padding: const EdgeInsets.all(8),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: isGridView ? 2 : 1,
        mainAxisExtent: isGridView
            ? 180
            : 80, // Fixed height: 180 for grid, 80 for list
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount:
          displayList.length + (!isSearchMode && nextUrl != null ? 1 : 0),
      itemBuilder: (context, index) {
        if (index >= displayList.length && !isSearchMode) {
          return const Center(child: CircularProgressIndicator());
        }

        final pokemon = displayList[index];

        return ListaItemWidget(
          name: pokemon.name,
          id: pokemon.id,
          isGridView: isGridView, // Pass the grid view state
        );
      },
    );
  }
}
