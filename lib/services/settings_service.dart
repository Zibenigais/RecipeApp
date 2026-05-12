import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/ingredient.dart';

class SettingsService {
  static const _keyDarkMode = 'dark_mode';
  static const _keyIngredientCache = 'ingredient_cache';

  Future<bool> getDarkMode() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyDarkMode) ?? false;
  }

  Future<void> setDarkMode(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyDarkMode, value);
  }

  Future<List<Ingredient>?> loadIngredientCache() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyIngredientCache);
    if (raw == null) return null;
    final list = jsonDecode(raw) as List<dynamic>;
    return list.map((e) => Ingredient.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<void> saveIngredientCache(List<Ingredient> ingredients) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyIngredientCache,
      jsonEncode(ingredients.map((i) => i.toJson()).toList()),
    );
  }
}
