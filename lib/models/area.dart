class Area {
  final String name;

  const Area({required this.name});

  factory Area.fromJson(Map<String, dynamic> json) {
    return Area(name: json['strArea'] as String);
  }
}
