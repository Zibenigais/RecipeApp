class MealSummary {
  final String id;
  final String name;
  final String thumbUrl;

  const MealSummary({
    required this.id,
    required this.name,
    required this.thumbUrl,
  });

  factory MealSummary.fromJson(Map<String, dynamic> json) {
    return MealSummary(
      id: json['idMeal'] as String,
      name: json['strMeal'] as String,
      thumbUrl: json['strMealThumb'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'idMeal': id,
      'strMeal': name,
      'strMealThumb': thumbUrl,
    };
  }
}
