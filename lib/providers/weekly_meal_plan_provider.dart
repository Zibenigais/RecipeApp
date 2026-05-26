import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/weekly_meal_plan.dart';
import 'dart:convert';


class WeeklyMealPlanProvider extends ChangeNotifier {
  static const _prefsKey = 'weekly_meal_plan';
  WeeklyMealPlan _plan = WeeklyMealPlan();

  WeeklyMealPlan get plan => _plan;

  WeeklyMealPlanProvider() {
    _loadPlan();
  }

  void addMeal(int day, PlannedMeal meal) {
    final list = _plan.meals[day] ?? <PlannedMeal>[];
    list.add(meal);
    _plan.meals[day] = list;
    notifyListeners();
    _savePlan();
  }

  void removeMeal(int day, int mealIndex) {
    final list = _plan.meals[day];
    if (list != null && mealIndex >= 0 && mealIndex < list.length) {
      list.removeAt(mealIndex);
      _plan.meals[day] = list;
      notifyListeners();
      _savePlan();
    }
  }

  Future<void> _savePlan() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString(_prefsKey, jsonEncode(_plan.toJson()));
  }

  Future<void> _loadPlan() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonStr = prefs.getString(_prefsKey);
    if (jsonStr != null) {
      _plan = WeeklyMealPlan.fromJson(jsonDecode(jsonStr));
      notifyListeners();
    }
  }
}

