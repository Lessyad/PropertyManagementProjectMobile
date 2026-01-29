import 'package:enmaa/core/constants/json_keys.dart';
import 'package:enmaa/core/entites/amenity_entity.dart';

class AmenityModel extends AmenityEntity {
  const AmenityModel({
    required super.id,
    required super.name,
  });

  factory AmenityModel.fromJson(Map<String, dynamic> json) {
    return AmenityModel(
      id: json[JsonKeys.id],
      name: json[JsonKeys.name],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      JsonKeys.id: id,
      JsonKeys.name: name,
    };
  }

}
