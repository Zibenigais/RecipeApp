import 'package:flutter/foundation.dart';

class PlannedMeal {
  final String mealId;
  final String mealName;
  final String mealThumb;

  PlannedMeal({required this.mealId, required this.mealName, required this.mealThumb});

  Map<String, dynamic> toJson() => {
    'mealId': mealId,
    'mealName': mealName,
    'mealThumb': mealThumb,
  };

  factory PlannedMeal.fromJson(Map<String, dynamic> json) => PlannedMeal(
    mealId: json['mealId'],
    mealName: json['mealName'],
    mealThumb: json['mealThumb'],
  );
}


class WeeklyMealPlan {
  final Map<int, List<PlannedMeal>> meals;

  WeeklyMealPlan({Map<int, List<PlannedMeal>>? meals})
      : meals = meals ?? Map.fromIterable(List.generate(7, (i) => i), value: (_) => <PlannedMeal>[]);

  Map<String, dynamic> toJson() => {
        'meals': meals.map((k, v) => MapEntry(k.toString(), v.map((m) => m.toJson()).toList())),
      };

  factory WeeklyMealPlan.fromJson(Map<String, dynamic> json) => WeeklyMealPlan(
        meals: (json['meals'] as Map<String, dynamic>).map(
          (k, v) => MapEntry(
            int.parse(k),
            (v as List<dynamic>).map((e) => PlannedMeal.fromJson(e)).toList(),
          ),
        ),
      );
}

