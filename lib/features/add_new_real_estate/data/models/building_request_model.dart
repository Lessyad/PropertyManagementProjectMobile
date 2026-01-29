import 'package:dio/dio.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/property_request_model.dart';
import '../../../../core/constants/json_keys.dart';

class BuildingRequestModel extends PropertyRequestModel {
  final String area;
  final int numberOfFloors;
  final int numberOfApartments;

  BuildingRequestModel({
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

    required this.area,
    required this.numberOfFloors,
    required this.numberOfApartments,
  });

  @override
  Future<FormData> toFormData() async {
    final formData = await super.toFormData();

    formData.fields.addAll([
      MapEntry(JsonKeys.area, area),
      MapEntry(JsonKeys.numberOfFloors, numberOfFloors.toString()),
      MapEntry(JsonKeys.numberOfApartments, numberOfApartments.toString()),
    ]);

    return formData;
  }
  @override
  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = await super.toJson();

    data.addAll({


      JsonKeys.area: double.tryParse(area),
      JsonKeys.numberOfApartments: numberOfApartments,
      JsonKeys.numberOfFloors: numberOfFloors,

    });

    return data;
  }



}
