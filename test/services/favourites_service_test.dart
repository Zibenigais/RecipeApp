import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/services/favourites_service.dart';

Meal _sampleMeal() {
  return const Meal(
    id: '52772',
    name: 'Teriyaki Chicken Casserole',
    category: 'Chicken',
    area: 'Japanese',
    instructions: 'Cook it.',
    thumbUrl: 'https://example.com/thumb.jpg',
    youtubeUrl: null,
    ingredients: [IngredientMeasure(ingredient: 'Chicken', measure: '500g')],
  );
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('FavouritesService', () {
    test('loadIds returns empty list by default', () async {
      SharedPreferences.setMockInitialValues({});
      final service = FavouritesService();

      final ids = await service.loadIds();
      expect(ids, isEmpty);
    });

    test('saveIds and loadIds round-trip values', () async {
      SharedPreferences.setMockInitialValues({});
      final service = FavouritesService();

      await service.saveIds(['1', '2']);
      final ids = await service.loadIds();

      expect(ids, ['1', '2']);
    });

    test('saveMeals and loadMeals round-trip values', () async {
      SharedPreferences.setMockInitialValues({});
      final service = FavouritesService();

      await service.saveMeals([_sampleMeal()]);
      final meals = await service.loadMeals();

      expect(meals, hasLength(1));
      expect(meals.first.id, '52772');
      expect(meals.first.name, 'Teriyaki Chicken Casserole');
    });
  });
}
