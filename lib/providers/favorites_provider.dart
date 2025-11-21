import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class FavoritesProvider extends ChangeNotifier {
  Set<Map<String, dynamic>> _favorites = {};
  static const String _favoritesKey = 'favorites';

  Set<Map<String, dynamic>> get favorites => _favorites;

  FavoritesProvider() {
    _loadFavorites();
  }

  Future<void> _loadFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = prefs.getStringList(_favoritesKey) ?? [];
    
    _favorites = favoritesJson
        .map((jsonString) => Map<String, dynamic>.from(json.decode(jsonString)))
        .toSet();
    
    notifyListeners();
  }

  Future<void> _saveFavorites() async {
    final prefs = await SharedPreferences.getInstance();
    final favoritesJson = _favorites
        .map((favorite) => json.encode(favorite))
        .toList();
    
    await prefs.setStringList(_favoritesKey, favoritesJson);
  }

  bool isFavorite(int id) {
    return _favorites.any((favorite) => favorite['id'] == id);
  }

  Future<void> toggleFavorite(int id, String name) async {
    final favoriteData = {'id': id, 'name': name};
    
    if (isFavorite(id)) {
      _favorites.removeWhere((favorite) => favorite['id'] == id);
    } else {
      _favorites.add(favoriteData);
    }
    
    await _saveFavorites();
    notifyListeners();
  }

  List<Map<String, dynamic>> getFavoritesList() {
    return _favorites.toList();
  }
}