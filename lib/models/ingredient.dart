class Ingredient {
  final String id;
  final String name;
  final String? description;
  final String? type;

  const Ingredient({
    required this.id,
    required this.name,
    this.description,
    this.type,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['idIngredient'] as String,
      name: json['strIngredient'] as String,
      description: json['strDescription'] as String?,
      type: json['strType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idIngredient': id,
      'strIngredient': name,
      'strDescription': description,
      'strType': type,
    };
  }
}
