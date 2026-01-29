import 'package:enmaa/features/real_estates/data/models/apartment_details_model.dart';
import 'package:enmaa/features/real_estates/data/models/villa_details_model.dart';

import '../../domain/entities/property_details_entity.dart';
import 'building_drtails_model.dart';
import 'land_details_model.dart';

class PropertyDetailsModel {
  static BasePropertyDetailsEntity fromJson(Map<String, dynamic> json) {
    final String propertyType = json['type'];

    switch (propertyType) {
      case 'villa':
        try {
        return VillaDetailsModel.fromJson(json);

        } catch (e, stack) {
          print('Erreur mapping: $e\n$stack');
          rethrow;
        }
      case 'apartment':
        return ApartmentDetailsModel.fromJson(json);
      case 'building':
        try {
        return BuildingDetailsModel.fromJson(json);
    } catch (e, stack) {
    print('Erreur mapping: $e\n$stack');
    rethrow;
    }
      case 'land':
        try{
        return LandDetailsModel.fromJson(json);
    } catch (e, stack) {
    print('Erreur mapping: $e\n$stack');
    rethrow;
    }
      default:
        throw Exception('Unknown property type: $propertyType');
    }
  }
}
