import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/recent_meals_service.dart';
import 'ingredients_provider.dart';

class RecentMealsProvider extends ChangeNotifier {
  final RecentMealsService _service;

  LoadStatus _status = LoadStatus.idle;
  List<Meal> _items = [];

  LoadStatus get status => _status;
  List<Meal> get items => _items;

  RecentMealsProvider(this._service);

  Future<void> load() async {
    _status = LoadStatus.loading;
    notifyListeners();
    try {
      _items = await _service.getRecentMeals();
      _status = _items.isEmpty ? LoadStatus.empty : LoadStatus.success;
    } catch (_) {
      _status = LoadStatus.error;
    }
    notifyListeners();
  }

  Future<void> add(Meal meal) async {
    // Remove if it already exists to move it to the top
    _items.removeWhere((m) => m.id == meal.id);
    _items.insert(0, meal);
    
    // Cap at 20 items
    if (_items.length > 20) {
      _items = _items.take(20).toList();
    }

    _status = _items.isEmpty ? LoadStatus.empty : LoadStatus.success;
    notifyListeners();

    await _service.saveRecentMeals(_items);
  }

  Future<void> clearAll() async {
    _items.clear();
    _status = LoadStatus.empty;
    notifyListeners();
    await _service.clearAll();
  }
}
