// file: lib/features/real_estates/data/models/property_model.dart
import 'package:enmaa/features/real_estates/data/models/apartment_model.dart';
import 'package:enmaa/features/real_estates/data/models/villa_model.dart';
import 'package:enmaa/features/real_estates/data/models/land_model.dart';
import 'package:enmaa/features/real_estates/data/models/building_model.dart';

import '../../domain/entities/base_property_entity.dart';

class PropertyModel {
  static PropertyEntity fromJson(Map<String, dynamic> json) {
    final String propertyType = json['type'];
    try {
      switch (propertyType) {
        case 'apartment':
          return ApartmentModel.fromJson(json);
        case 'villa':
          return VillaModel.fromJson(json);
        case 'land':
          return LandModel.fromJson(json);
        case 'building':
          return BuildingModel.fromJson(json);
        default:
          throw Exception('Unknown property type: $propertyType');
      }
    }catch( e )
    {
      throw e ;
    }
  }
}
