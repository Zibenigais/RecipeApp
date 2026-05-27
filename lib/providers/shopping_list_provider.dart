import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weekly_meal_plan.dart';
import '../services/meal_db_service.dart';

class ShoppingListItem {
  final String displayName;
  final String combinedMeasures;
  final bool checked;

  const ShoppingListItem({
    required this.displayName,
    required this.combinedMeasures,
    this.checked = false,
  });

  ShoppingListItem copyWith({
    String? displayName,
    String? combinedMeasures,
    bool? checked,
  }) =>
      ShoppingListItem(
        displayName: displayName ?? this.displayName,
        combinedMeasures: combinedMeasures ?? this.combinedMeasures,
        checked: checked ?? this.checked,
      );

  Map<String, dynamic> toJson() => {
        'displayName': displayName,
        'combinedMeasures': combinedMeasures,
        'checked': checked,
      };

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      ShoppingListItem(
        displayName: json['displayName'] as String,
        combinedMeasures: json['combinedMeasures'] as String? ?? '',
        checked: json['checked'] as bool? ?? false,
      );
}

class ShoppingListProvider extends ChangeNotifier {
  static const _prefsKey = 'shopping_list';

  final MealDbService _mealDb;
  Map<String, ShoppingListItem> _items = {};
  bool _isLoading = false;

  ShoppingListProvider(this._mealDb) {
    _load();
  }

  Map<String, ShoppingListItem> get items => _items;
  bool get isLoading => _isLoading;

  Future<void> generate(WeeklyMealPlan plan) async {
    _isLoading = true;
    notifyListeners();

    final mealIds = <String>{};
    for (final list in plan.meals.values) {
      for (final m in list) {
        mealIds.add(m.mealId);
      }
    }

    final previousChecked = {
      for (final entry in _items.entries) entry.key: entry.value.checked,
    };

    final results = await Future.wait(
      mealIds.map((id) async {
        try {
          return await _mealDb.fetchMealById(id);
        } catch (_) {
          return null;
        }
      }),
    );

    final newItems = <String, ShoppingListItem>{};
    for (final meal in results) {
      if (meal == null) continue;
      for (final im in meal.ingredients) {
        final key = im.ingredient.toLowerCase().trim();
        if (key.isEmpty) continue;
        final measure = im.measure.trim();
        final existing = newItems[key];
        if (existing == null) {
          newItems[key] = ShoppingListItem(
            displayName: im.ingredient.trim(),
            combinedMeasures: measure,
            checked: previousChecked[key] ?? false,
          );
        } else {
          final combined = measure.isEmpty
              ? existing.combinedMeasures
              : (existing.combinedMeasures.isEmpty
                  ? measure
                  : '${existing.combinedMeasures}, $measure');
          newItems[key] = existing.copyWith(combinedMeasures: combined);
        }
      }
    }

    _items = newItems;
    _isLoading = false;
    notifyListeners();
    _save();
  }

  void toggle(String key) {
    final item = _items[key];
    if (item == null) return;
    _items[key] = item.copyWith(checked: !item.checked);
    notifyListeners();
    _save();
  }

  void clearChecked() {
    _items = {
      for (final entry in _items.entries)
        if (!entry.value.checked) entry.key: entry.value,
    };
    notifyListeners();
    _save();
  }

  Future<void> _save() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = jsonEncode(
      _items.map((k, v) => MapEntry(k, v.toJson())),
    );
    prefs.setString(_prefsKey, encoded);
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_prefsKey);
    if (jsonStr == null) return;
    final decoded = jsonDecode(jsonStr) as Map<String, dynamic>;
    _items = decoded.map(
      (k, v) =>
          MapEntry(k, ShoppingListItem.fromJson(v as Map<String, dynamic>)),
    );
    notifyListeners();
  }
}
