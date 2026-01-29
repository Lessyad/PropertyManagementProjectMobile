// // Dans vehicle_make_model.dart
// class VehicleMake {
//   final int id;
//   final String name;
//   final String? logoUrl;
//   final int modelCount;
//   final List<VehicleModel> models;
//
//   VehicleMake({
//     required this.id,
//     required this.name,
//     this.logoUrl,
//     required this.modelCount,
//     required this.models,
//   });
//
//   factory VehicleMake.fromJson(Map<String, dynamic> json) {
//     return VehicleMake(
//       id: json['id'] ?? 0, // minuscule
//       name: json['name'] ?? '', // minuscule
//       logoUrl: json['logoUrl'], // camelCase exact
//       modelCount: json['modelCount'] ?? 0, // camelCase exact
//       models: (json['models'] as List<dynamic>?) // minuscule
//           ?.map((modelJson) => VehicleModel.fromJson(modelJson))
//           .toList() ?? [],
//     );
//   }
// }
//
// class VehicleModel {
//   final int id;
//   final String name;
//   final int makeId;
//   final String? makeName;
//   final int vehicleCount;
//
//   VehicleModel({
//     required this.id,
//     required this.name,
//     required this.makeId,
//     this.makeName,
//     required this.vehicleCount,
//   });
//
//   factory VehicleModel.fromJson(Map<String, dynamic> json) {
//     return VehicleModel(
//       id: json['id'] ?? 0, // minuscule
//       name: json['name'] ?? '', // minuscule
//       makeId: json['makeId'] ?? 0, // camelCase exact
//       makeName: json['makeName'], // camelCase exact
//       vehicleCount: json['vehicleCount'] ?? 0, // camelCase exact
//     );
//   }
//
//   // Méthode utilitaire pour le débogage
//   @override
//   String toString() {
//     return 'VehicleModel{id: $id, name: $name, makeId: $makeId, makeName: $makeName, vehicleCount: $vehicleCount}';
//   }
// }

// Dans vehicle_make_model.dart
class VehicleMake {
  final int id;
  final String name;
  final String? logoUrl;
  final int modelCount;
  final List<VehicleModelMake> models;

  VehicleMake({
    required this.id,
    required this.name,
    this.logoUrl,
    required this.modelCount,
    required this.models,
  });

  factory VehicleMake.fromJson(Map<String, dynamic> json) {
    return VehicleMake(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      logoUrl: json['logoUrl'],
      modelCount: json['modelCount'] ?? 0,
      models: (json['models'] as List<dynamic>?)
          ?.map((modelJson) => VehicleModelMake.fromJson(modelJson))
          .toList() ?? [],
    );
  }
}

class VehicleModelMake {
  final int id;
  final String name;
  final int makeId;
  final String? makeName;
  final int vehicleCount;

  VehicleModelMake({
    required this.id,
    required this.name,
    required this.makeId,
    this.makeName,
    required this.vehicleCount,
  });

  factory VehicleModelMake.fromJson(Map<String, dynamic> json) {
    return VehicleModelMake(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      makeId: json['makeId'] ?? 0,
      makeName: json['makeName'],
      vehicleCount: json['vehicleCount'] ?? 0,
    );
  }

  // Méthode utilitaire pour le débogage
  @override
  String toString() {
    return 'VehicleModelMake{id: $id, name: $name, makeId: $makeId, makeName: $makeName, vehicleCount: $vehicleCount}';
  }
}