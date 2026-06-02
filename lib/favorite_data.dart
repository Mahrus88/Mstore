// lib/favorite_data.dart
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoriteData extends ChangeNotifier {
  static final FavoriteData _instance = FavoriteData._internal();
  factory FavoriteData() => _instance;
  FavoriteData._internal();

  static List<Map<String, dynamic>> _favorites = [];

  static List<Map<String, dynamic>> get favorites => _favorites;

  static Future<void> muatFavorit() async {
    final prefs = await SharedPreferences.getInstance();
    final String? data = prefs.getString('daftar_favorit');
    if (data != null) {
      final List decoded = jsonDecode(data);
      _favorites = decoded.map((e) => Map<String, dynamic>.from(e)).toList();
    }
  }

  static Future<void> simpanFavorit() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('daftar_favorit', jsonEncode(_favorites));
    _instance.notifyListeners();
  }

  static bool isFavorit(String name) {
    return _favorites.any((e) => e['name'] == name);
  }

  static Future<void> toggleFavorit(Map<String, dynamic> produk) async {
    final index = _favorites.indexWhere((e) => e['name'] == produk['name']);
    if (index != -1) {
      _favorites.removeAt(index);
    } else {
      _favorites.add(produk);
    }
    await simpanFavorit();
  }

  static int get totalFavorit => _favorites.length;
}