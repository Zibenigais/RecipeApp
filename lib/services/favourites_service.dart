import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../models/meal.dart';

class FavouritesService {
  static const _keyFavouriteIds = 'favourite_meal_ids';
  static const _keyFavouriteMeals = 'favourite_meals';

  Future<List<String>> loadIds() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFavouriteIds);
    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded.map((id) => id as String).toList();
  }

  Future<void> saveIds(List<String> ids) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFavouriteIds, jsonEncode(ids));
  }

  Future<List<Meal>> loadMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_keyFavouriteMeals);
    if (raw == null) return [];

    final decoded = jsonDecode(raw) as List<dynamic>;
    return decoded
        .map((entry) => Meal.fromJson(entry as Map<String, dynamic>))
        .toList();
  }

  Future<void> saveMeals(List<Meal> meals) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(
      _keyFavouriteMeals,
      jsonEncode(meals.map((meal) => meal.toJson()).toList()),
    );
  }
}
