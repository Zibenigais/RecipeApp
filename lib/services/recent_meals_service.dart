import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';

class RecentMealsService {
  static const _key = 'recent_meals';
  static const _maxItems = 20;

  Future<List<Meal>> getRecentMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list.map((e) => Meal.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return [];
    }
  }

  Future<void> saveRecentMeals(List<Meal> meals) async {
    final prefs = await SharedPreferences.getInstance();
    final limited = meals.take(_maxItems).toList();
    final raw = jsonEncode(limited.map((m) => m.toJson()).toList());
    await prefs.setString(_key, raw);
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
