import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/models/meal.dart';

Map<String, dynamic> _buildMealJson({int ingredientCount = 3}) {
  final json = <String, dynamic>{
    'idMeal': '52772',
    'strMeal': 'Teriyaki Chicken Casserole',
    'strCategory': 'Chicken',
    'strArea': 'Japanese',
    'strInstructions': 'Cook it.',
    'strMealThumb': 'https://example.com/thumb.jpg',
    'strYoutube': 'https://youtube.com/watch?v=abc',
  };
  for (int i = 1; i <= 20; i++) {
    if (i <= ingredientCount) {
      json['strIngredient$i'] = 'Ingredient $i';
      json['strMeasure$i'] = '${i}g';
    } else {
      json['strIngredient$i'] = '';
      json['strMeasure$i'] = '';
    }
  }
  return json;
}

void main() {
  group('Meal', () {
    test('fromJson parses basic fields', () {
      final meal = Meal.fromJson(_buildMealJson());
      expect(meal.id, '52772');
      expect(meal.name, 'Teriyaki Chicken Casserole');
      expect(meal.category, 'Chicken');
      expect(meal.area, 'Japanese');
    });

    test('fromJson parses correct number of ingredients', () {
      final meal = Meal.fromJson(_buildMealJson(ingredientCount: 5));
      expect(meal.ingredients.length, 5);
    });

    test('fromJson skips empty ingredient slots', () {
      final meal = Meal.fromJson(_buildMealJson(ingredientCount: 2));
      expect(meal.ingredients.length, 2);
      expect(meal.ingredients.first.ingredient, 'Ingredient 1');
      expect(meal.ingredients.first.measure, '1g');
    });

    test('toJson round-trips id and name', () {
      final meal = Meal.fromJson(_buildMealJson());
      final result = meal.toJson();
      expect(result['idMeal'], '52772');
      expect(result['strMeal'], 'Teriyaki Chicken Casserole');
    });
  });
}
