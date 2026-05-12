import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:recipe_app/models/ingredient.dart';
import 'package:recipe_app/widgets/ingredient_tile.dart';

void main() {
  testWidgets('IngredientTile renders name and chevron', (tester) async {
    const ingredient = Ingredient(id: '1', name: 'Chicken');
    var tapped = false;

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: IngredientTile(
            ingredient: ingredient,
            onTap: () => tapped = true,
          ),
        ),
      ),
    );

    expect(find.text('Chicken'), findsOneWidget);
    expect(find.byIcon(Icons.chevron_right), findsOneWidget);

    await tester.tap(find.byType(ListTile));
    expect(tapped, isTrue);
  });
}
