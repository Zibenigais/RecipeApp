import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_db_service.dart';
import 'ingredients_provider.dart'; // For LoadStatus enum

class RandomMealProvider extends ChangeNotifier {
  final MealDbService _service;

  LoadStatus _status = LoadStatus.idle;
  Meal? _meal;
  String _error = '';

  LoadStatus get status => _status;
  Meal? get meal => _meal;
  String get error => _error;

  RandomMealProvider(this._service);

  Future<void> fetchRandomMeal() async {
    _status = LoadStatus.loading;
    _meal = null;
    notifyListeners();
    try {
      _meal = await _service.fetchRandomMeal();
      _status = LoadStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = LoadStatus.error;
    }
    notifyListeners();
  }

  void reset() {
    _status = LoadStatus.idle;
    _meal = null;
    notifyListeners();
  }
}
