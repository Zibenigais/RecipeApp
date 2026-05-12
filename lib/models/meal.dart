class IngredientMeasure {
  final String ingredient;
  final String measure;

  const IngredientMeasure({required this.ingredient, required this.measure});
}

class Meal {
  final String id;
  final String name;
  final String category;
  final String area;
  final String instructions;
  final String thumbUrl;
  final String? youtubeUrl;
  final List<IngredientMeasure> ingredients;

  const Meal({
    required this.id,
    required this.name,
    required this.category,
    required this.area,
    required this.instructions,
    required this.thumbUrl,
    this.youtubeUrl,
    required this.ingredients,
  });

  factory Meal.fromJson(Map<String, dynamic> json) {
    final ingredients = <IngredientMeasure>[];
    for (int i = 1; i <= 20; i++) {
      final ingredient = json['strIngredient$i'] as String?;
      final measure = json['strMeasure$i'] as String?;
      if (ingredient != null && ingredient.trim().isNotEmpty) {
        ingredients.add(IngredientMeasure(
          ingredient: ingredient.trim(),
          measure: (measure ?? '').trim(),
        ));
      }
    }
    return Meal(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      category: json['strCategory'] as String? ?? '',
      area: json['strArea'] as String? ?? '',
      instructions: json['strInstructions'] as String? ?? '',
      thumbUrl: json['strMealThumb'] as String? ?? '',
      youtubeUrl: json['strYoutube'] as String?,
      ingredients: ingredients,
    );
  }

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{
      'idMeal': id,
      'strMeal': name,
      'strCategory': category,
      'strArea': area,
      'strInstructions': instructions,
      'strMealThumb': thumbUrl,
      'strYoutube': youtubeUrl,
    };
    for (int i = 0; i < ingredients.length; i++) {
      map['strIngredient${i + 1}'] = ingredients[i].ingredient;
      map['strMeasure${i + 1}'] = ingredients[i].measure;
    }
    return map;
  }
}
