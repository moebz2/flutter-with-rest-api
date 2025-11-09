import 'package:tp_pokemon/models/pokemon.dart';

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