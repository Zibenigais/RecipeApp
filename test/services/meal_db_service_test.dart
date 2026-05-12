import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:recipe_app/services/meal_db_service.dart';

void main() {
  group('MealDbService.fetchIngredients', () {
    test('parses ingredient list on 200', () async {
      final client = MockClient((_) async => http.Response(
            jsonEncode({
              'meals': [
                {
                  'idIngredient': '1',
                  'strIngredient': 'Chicken',
                  'strDescription': null,
                  'strType': null,
                },
                {
                  'idIngredient': '2',
                  'strIngredient': 'Salmon',
                  'strDescription': null,
                  'strType': null,
                },
              ]
            }),
            200,
          ));

      final service = MealDbService(client: client);
      final ingredients = await service.fetchIngredients();

      expect(ingredients.length, 2);
      expect(ingredients.first.name, 'Chicken');
      expect(ingredients.last.name, 'Salmon');
    });

    test('throws on non-200 status', () async {
      final client = MockClient((_) async => http.Response('Error', 500));
      final service = MealDbService(client: client);

      expect(() => service.fetchIngredients(), throwsException);
    });
  });
}
