import 'package:flutter/material.dart';
import '../models/category.dart';
import '../services/meal_db_service.dart';
import 'ingredients_provider.dart'; // Reusing LoadStatus enum

class CategoriesProvider extends ChangeNotifier {
  final MealDbService _service;

  LoadStatus _status = LoadStatus.idle;
  List<Category> _categories = [];
  List<Category> _filtered = [];
  String _error = '';

  LoadStatus get status => _status;
  List<Category> get categories => _filtered;
  String get error => _error;

  CategoriesProvider(this._service);

  Future<void> fetch() async {
    _status = LoadStatus.loading;
    notifyListeners();
    try {
      final data = await _service.fetchCategories();
      _categories = data;
      _filtered = data;
      _status = data.isEmpty ? LoadStatus.empty : LoadStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = LoadStatus.error;
    }
    notifyListeners();
  }

  void filter(String query) {
    if (query.isEmpty) {
      _filtered = _categories;
    } else {
      final lowerQuery = query.toLowerCase();
      _filtered = _categories.where((cat) {
        return cat.name.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    if (_status == LoadStatus.success || _status == LoadStatus.empty) {
       _status = _filtered.isEmpty ? LoadStatus.empty : LoadStatus.success;
    }
    notifyListeners();
  }
}
