import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/ingredient.dart';
import '../models/category.dart';
import '../models/meal_summary.dart';
import '../models/meal.dart';

class MealDbService {
  static const _base = 'https://www.themealdb.com/api/json/v1/1';

  final http.Client _client;

  MealDbService({http.Client? client}) : _client = client ?? http.Client();

  Future<List<Ingredient>> fetchIngredients() async {
    final uri = Uri.parse('$_base/list.php?i=list');
    final response = await _client.get(uri);
    _checkStatus(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = body['meals'] as List<dynamic>? ?? [];
    return meals
        .map((e) => Ingredient.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MealSummary>> fetchMealsByIngredient(String ingredient) async {
    final uri = Uri.parse('$_base/filter.php?i=${Uri.encodeComponent(ingredient)}');
    final response = await _client.get(uri);
    _checkStatus(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = body['meals'] as List<dynamic>? ?? [];
    return meals
        .map((e) => MealSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<Category>> fetchCategories() async {
    final uri = Uri.parse('$_base/categories.php');
    final response = await _client.get(uri);
    _checkStatus(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final categories = body['categories'] as List<dynamic>? ?? [];
    return categories
        .map((e) => Category.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<List<MealSummary>> fetchMealsByCategory(String category) async {
    final uri = Uri.parse('$_base/filter.php?c=${Uri.encodeComponent(category)}');
    final response = await _client.get(uri);
    _checkStatus(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = body['meals'] as List<dynamic>? ?? [];
    return meals
        .map((e) => MealSummary.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  Future<Meal> fetchMealById(String id) async {
    final uri = Uri.parse('$_base/lookup.php?i=$id');
    final response = await _client.get(uri);
    _checkStatus(response);
    final body = jsonDecode(response.body) as Map<String, dynamic>;
    final meals = body['meals'] as List<dynamic>?;
    if (meals == null || meals.isEmpty) {
      throw Exception('Meal not found');
    }
    return Meal.fromJson(meals.first as Map<String, dynamic>);
  }

  void _checkStatus(http.Response response) {
    if (response.statusCode != 200) {
      throw Exception('HTTP ${response.statusCode}');
    }
  }
}
