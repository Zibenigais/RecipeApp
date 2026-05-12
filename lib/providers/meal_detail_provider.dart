import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../services/meal_db_service.dart';
import 'ingredients_provider.dart';

class MealDetailProvider extends ChangeNotifier {
  final MealDbService _service;

  LoadStatus _status = LoadStatus.idle;
  Meal? _meal;
  String _error = '';

  LoadStatus get status => _status;
  Meal? get meal => _meal;
  String get error => _error;

  MealDetailProvider(this._service);

  Future<void> fetch(String id) async {
    _status = LoadStatus.loading;
    _meal = null;
    notifyListeners();
    try {
      _meal = await _service.fetchMealById(id);
      _status = LoadStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = LoadStatus.error;
    }
    notifyListeners();
  }
}
