import 'package:flutter/material.dart';
import '../models/area.dart';
import '../services/meal_db_service.dart';
import 'ingredients_provider.dart'; // Reusing LoadStatus enum

class AreasProvider extends ChangeNotifier {
  final MealDbService _service;

  LoadStatus _status = LoadStatus.idle;
  List<Area> _areas = [];
  List<Area> _filtered = [];
  String _error = '';

  LoadStatus get status => _status;
  List<Area> get areas => _filtered;
  String get error => _error;

  AreasProvider(this._service);

  Future<void> fetch() async {
    _status = LoadStatus.loading;
    notifyListeners();
    try {
      final data = await _service.fetchAreas();
      _areas = data;
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
      _filtered = _areas;
    } else {
      final lowerQuery = query.toLowerCase();
      _filtered = _areas.where((area) {
        return area.name.toLowerCase().contains(lowerQuery);
      }).toList();
    }
    if (_status == LoadStatus.success || _status == LoadStatus.empty) {
      _status = _filtered.isEmpty ? LoadStatus.empty : LoadStatus.success;
    }
    notifyListeners();
  }
}
