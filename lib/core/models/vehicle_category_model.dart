class VehicleCategory {
  final int id;
  final String name;
  final String? description;
  final int age; // Âge minimum requis pour louer un véhicule de cette catégorie
  final bool deleted;
  final DateTime created;
  final DateTime modified;
  final List<dynamic> models;

  VehicleCategory({
    required this.id,
    required this.name,
    this.description,
    this.age = 18, // Valeur par défaut : 18
    required this.deleted,
    required this.created,
    required this.modified,
    required this.models,
  });

  factory VehicleCategory.fromJson(Map<String, dynamic> json) {
    return VehicleCategory(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      description: json['description'],
      age: json['age'] ?? 18, // Valeur par défaut : 18
      deleted: json['deleted'] ?? false,
      created: DateTime.tryParse(json['created'] ?? '') ?? DateTime.now(),
      modified: DateTime.tryParse(json['modified'] ?? '') ?? DateTime.now(),
      models: json['models'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'age': age,
      'deleted': deleted,
      'created': created.toIso8601String(),
      'modified': modified.toIso8601String(),
      'models': models,
    };
  }
}
