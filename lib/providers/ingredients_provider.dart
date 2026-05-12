import 'package:flutter/material.dart';
import '../models/ingredient.dart';
import '../services/meal_db_service.dart';
import '../services/settings_service.dart';

enum LoadStatus { idle, loading, success, empty, error }

class IngredientsProvider extends ChangeNotifier {
  final MealDbService _service;
  final SettingsService _settings;

  LoadStatus _status = LoadStatus.idle;
  List<Ingredient> _ingredients = [];
  List<Ingredient> _filtered = [];
  String _error = '';

  LoadStatus get status => _status;
  List<Ingredient> get ingredients => _filtered;
  String get error => _error;

  IngredientsProvider(this._service, this._settings);

  Future<void> fetch() async {
    _status = LoadStatus.loading;
    notifyListeners();

    // Load from cache first for instant display
    final cached = await _settings.loadIngredientCache();
    if (cached != null && cached.isNotEmpty) {
      _ingredients = cached;
      _filtered = cached;
      _status = LoadStatus.success;
      notifyListeners();
    }

    // Always refresh from network in background
    try {
      final data = await _service.fetchIngredients();
      final processed = _deduplicate(_filterMain(data));
      _ingredients = processed;
      _filtered = processed;
      _status = processed.isEmpty ? LoadStatus.empty : LoadStatus.success;
      await _settings.saveIngredientCache(processed);
    } catch (e) {
      // Keep cached data if network fails; only show error when no cache
      if (cached == null || cached.isEmpty) {
        _error = e.toString();
        _status = LoadStatus.error;
      }
    }
    notifyListeners();
  }

  void filter(String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) {
      _filtered = _ingredients;
    } else {
      _filtered =
          _ingredients.where((i) => i.name.toLowerCase().contains(q)).toList();
    }
    _status = _filtered.isEmpty && _ingredients.isNotEmpty
        ? LoadStatus.empty
        : LoadStatus.success;
    notifyListeners();
  }

  // ---------- filtering ----------

  static const _excludeTypes = {'spice', 'herb', 'condiment', 'alcohol', 'alcoholic'};

  static const _excludeKeywords = [
    'sauce', ' oil', 'powder', 'extract', 'vinegar', 'syrup',
    'paste', 'flakes', 'seasoning', 'baking', 'yeast',
    'vanilla', 'mustard', 'ketchup', 'mayo', 'stock', 'broth',
    'flour', 'salt', 'sugar', 'pepper', 'spice', 'herb',
    'essence', 'concentrate', 'dried ', 'food colour',
  ];

  static bool _isMainIngredient(Ingredient i) {
    final type = (i.type ?? '').toLowerCase();
    if (type.isNotEmpty && _excludeTypes.any(type.contains)) return false;
    final name = i.name.toLowerCase();
    return !_excludeKeywords.any(name.contains);
  }

  static List<Ingredient> _filterMain(List<Ingredient> ingredients) =>
      ingredients.where(_isMainIngredient).toList();

  // ---------- deduplication ----------

  static String _singularize(String name) {
    final s = name.toLowerCase().trim();
    if (s.endsWith('ies')) return '${s.substring(0, s.length - 3)}y';
    if (s.endsWith('ves')) return '${s.substring(0, s.length - 3)}f';
    if (s.endsWith('es')) return s.substring(0, s.length - 2);
    if (s.endsWith('s') && s.length > 2) return s.substring(0, s.length - 1);
    return s;
  }

  static List<Ingredient> _deduplicate(List<Ingredient> ingredients) {
    final sorted = [...ingredients]
      ..sort((a, b) => a.name.length.compareTo(b.name.length));
    final seen = <String>{};
    final result = <Ingredient>[];
    for (final ingredient in sorted) {
      if (seen.add(_singularize(ingredient.name))) result.add(ingredient);
    }
    result.sort((a, b) => a.name.compareTo(b.name));
    return result;
  }
}
