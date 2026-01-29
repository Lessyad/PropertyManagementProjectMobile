import 'package:dio/dio.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/property_request_model.dart';
import '../../../../core/constants/json_keys.dart';

class LandRequestModel extends PropertyRequestModel {
  final String area;
  final bool isLicensed;

  LandRequestModel({
    // Common fields from PropertyRequestModel
    required super.currentPropertyOperationType,
    required super.title,
    required super.description,
    required super.price,
    required super.images,
    required super.city,
    required super.latitude,
    required super.longitude,
    required super.amenities,
    required super.propertySubType,
    super.monthlyRentPeriod,
    super.isRenewable,
    super.paymentMethod,
    // Land-specific fields:
    required this.area,
    required this.isLicensed,
  });

  @override
  Future<FormData> toFormData() async {
    final formData = await super.toFormData();

    // Convertir l'aire en double avec une valeur par défaut si la conversion échoue
    final double areaValue = double.tryParse(area) ?? 0.0;

    formData.fields.addAll([
      MapEntry(JsonKeys.area, areaValue.toString()),
      MapEntry(JsonKeys.isLicensed, isLicensed.toString()),
      MapEntry('request', 'land'), // Ajouter le champ request manquant
    ]);

    return formData;
  }
  @override
  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = await super.toJson();

    // Convertir l'aire en double avec une valeur par défaut si la conversion échoue
    final double areaValue = double.tryParse(area) ?? 0.0;

    data.addAll({
      JsonKeys.area: areaValue,
      JsonKeys.isLicensed: isLicensed,
      'request': 'land' // Ajouter le champ request manquant
    });

    return data;
  }
}
