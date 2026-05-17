import 'package:flutter_test/flutter_test.dart';

import 'package:recipe_app/models/meal.dart';
import 'package:recipe_app/providers/favourites_provider.dart';
import 'package:recipe_app/providers/ingredients_provider.dart';
import 'package:recipe_app/services/favourites_service.dart';

class _FakeFavouritesService extends FavouritesService {
  List<String> storedIds = [];
  List<Meal> storedMeals = [];

  @override
  Future<List<String>> loadIds() async => storedIds;

  @override
  Future<void> saveIds(List<String> ids) async {
    storedIds = List<String>.from(ids);
  }

  @override
  Future<List<Meal>> loadMeals() async => storedMeals;

  @override
  Future<void> saveMeals(List<Meal> meals) async {
    storedMeals = List<Meal>.from(meals);
  }
}

Meal _meal({required String id, required String name}) {
  return Meal(
    id: id,
    name: name,
    category: 'Category',
    area: 'Area',
    instructions: 'Instructions',
    thumbUrl: 'https://example.com/$id.jpg',
    youtubeUrl: null,
    ingredients: const [
      IngredientMeasure(ingredient: 'Ingredient', measure: '1 cup'),
    ],
  );
}

void main() {
  group('FavouritesProvider', () {
    test('load hydrates ids and meals', () async {
      final service = _FakeFavouritesService()
        ..storedIds = ['m1']
        ..storedMeals = [_meal(id: 'm1', name: 'Meal 1')];
      final provider = FavouritesProvider(service);

      await provider.load();

      expect(provider.status, LoadStatus.success);
      expect(provider.isFavourite('m1'), isTrue);
      expect(provider.favouriteMeals, hasLength(1));
      expect(provider.favouriteMeals.first.name, 'Meal 1');
    });

    test('toggle adds and removes favourites', () async {
      final service = _FakeFavouritesService();
      final provider = FavouritesProvider(service);
      final meal = _meal(id: 'm2', name: 'Meal 2');

      await provider.toggle(meal.id, meal);

      expect(provider.status, LoadStatus.success);
      expect(provider.isFavourite(meal.id), isTrue);
      expect(provider.favouriteMeals, hasLength(1));
      expect(service.storedIds, contains('m2'));

      await provider.toggle(meal.id, meal);

      expect(provider.status, LoadStatus.empty);
      expect(provider.isFavourite(meal.id), isFalse);
      expect(provider.favouriteMeals, isEmpty);
      expect(service.storedIds, isEmpty);
    });
  });
}
