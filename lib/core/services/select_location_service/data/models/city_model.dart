import 'package:enmaa/core/services/select_location_service/domain/entities/city_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/country_entity.dart';
import 'package:enmaa/core/utils/localized_name.dart';

class CityModel extends CityEntity {
  const CityModel({
    required super.name,
    required super.id,
  }) ;

  factory CityModel.fromJson(Map<String, dynamic> json) {
    return CityModel(
      name: resolveLocalizedName(
        nameFr: json['nameFr'],
        nameAr: json['nameAr'],
        nameEn: json['nameEn'],
      ),
      id: json['id'].toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'id': id,
    };
  }
}