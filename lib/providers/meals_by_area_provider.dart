import 'package:flutter/material.dart';
import '../models/meal_summary.dart';
import '../services/meal_db_service.dart';
import 'ingredients_provider.dart'; // Reusing LoadStatus

class MealsByAreaProvider extends ChangeNotifier {
  final MealDbService _service;

  LoadStatus _status = LoadStatus.idle;
  List<MealSummary> _meals = [];
  String _error = '';
  String _area = '';

  LoadStatus get status => _status;
  List<MealSummary> get meals => _meals;
  String get error => _error;
  String get area => _area;

  MealsByAreaProvider(this._service);

  Future<void> fetch(String area) async {
    _area = area;
    _status = LoadStatus.loading;
    notifyListeners();
    try {
      final data = await _service.fetchMealsByArea(area);
      _meals = data;
      _status = data.isEmpty ? LoadStatus.empty : LoadStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = LoadStatus.error;
    }
    notifyListeners();
  }
}
