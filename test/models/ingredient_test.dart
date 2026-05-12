import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/models/ingredient.dart';

void main() {
  group('Ingredient', () {
    final json = {
      'idIngredient': '1',
      'strIngredient': 'Chicken',
      'strDescription': 'A bird',
      'strType': 'Meat',
    };

    test('fromJson parses all fields', () {
      final ingredient = Ingredient.fromJson(json);
      expect(ingredient.id, '1');
      expect(ingredient.name, 'Chicken');
      expect(ingredient.description, 'A bird');
      expect(ingredient.type, 'Meat');
    });

    test('fromJson handles null optional fields', () {
      final ingredient = Ingredient.fromJson({
        'idIngredient': '2',
        'strIngredient': 'Salt',
        'strDescription': null,
        'strType': null,
      });
      expect(ingredient.description, isNull);
      expect(ingredient.type, isNull);
    });

    test('toJson round-trips correctly', () {
      final ingredient = Ingredient.fromJson(json);
      final result = ingredient.toJson();
      expect(result['idIngredient'], '1');
      expect(result['strIngredient'], 'Chicken');
      expect(result['strDescription'], 'A bird');
      expect(result['strType'], 'Meat');
    });
  });
}
