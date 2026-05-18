import 'package:flutter/material.dart';

import '../models/meal.dart';
import '../services/favourites_service.dart';
import 'ingredients_provider.dart';

class FavouritesProvider extends ChangeNotifier {
  final FavouritesService _service;

  LoadStatus _status = LoadStatus.idle;
  final Set<String> _favouriteIds = <String>{};
  final List<Meal> _favouriteMeals = <Meal>[];
  String _error = '';

  LoadStatus get status => _status;
  List<Meal> get favouriteMeals => List.unmodifiable(_favouriteMeals);
  String get error => _error;

  FavouritesProvider(this._service);

  bool isFavourite(String id) => _favouriteIds.contains(id);

  Future<void> load() async {
    _status = LoadStatus.loading;
    _error = '';
    notifyListeners();

    try {
      final loadedIds = await _service.loadIds();
      final loadedMeals = await _service.loadMeals();

      _favouriteIds
        ..clear()
        ..addAll(loadedIds)
        ..addAll(loadedMeals.map((meal) => meal.id));

      final mealById = <String, Meal>{
        for (final meal in loadedMeals) meal.id: meal,
      };
      _favouriteMeals
        ..clear()
        ..addAll(
          _favouriteIds.where(mealById.containsKey).map((id) => mealById[id]!),
        );

      _status = _favouriteIds.isEmpty ? LoadStatus.empty : LoadStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = LoadStatus.error;
    }

    notifyListeners();
  }

  Future<void> toggle(String id, Meal meal) async {
    _error = '';

    if (_favouriteIds.contains(id)) {
      _favouriteIds.remove(id);
      _favouriteMeals.removeWhere((m) => m.id == id);
    } else {
      _favouriteIds.add(id);
      final index = _favouriteMeals.indexWhere((m) => m.id == id);
      if (index >= 0) {
        _favouriteMeals[index] = meal;
      } else {
        _favouriteMeals.add(meal);
      }
    }

    try {
      await _service.saveIds(_favouriteIds.toList());
      await _service.saveMeals(_favouriteMeals);
      _status = _favouriteIds.isEmpty ? LoadStatus.empty : LoadStatus.success;
    } catch (e) {
      _error = e.toString();
      _status = LoadStatus.error;
    }

    notifyListeners();
  }
}
