import 'package:dio/dio.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/property_request_model.dart';

import '../../../../core/constants/json_keys.dart';

class VillaRequestModel extends PropertyRequestModel {
  final String area;
  final bool isFurnitured;
  final int numberOfFloors;
  final int rooms;
  final int bathrooms;

  VillaRequestModel({
    required super.currentPropertyOperationType,
    required super.title,
    required super.description,
    required super.price,
    required super.images,
    required super.city,
    required super.latitude,
    required super.longitude,
    required super.amenities,
    super.monthlyRentPeriod,
    super.isRenewable,
    super.paymentMethod,
    required super.propertySubType,
    //
    required this.area,
    required this.isFurnitured,
    required this.numberOfFloors,
    required this.rooms,
    required this.bathrooms,
  });

  @override
  Future<FormData> toFormData() async {
    final formData = await super.toFormData();

    formData.fields.addAll([
      MapEntry(JsonKeys.area, area),
      MapEntry(JsonKeys.isFurnitured, isFurnitured.toString()),
      MapEntry(JsonKeys.numberOfFloors, numberOfFloors.toString()),
      MapEntry(JsonKeys.rooms, rooms.toString()),
      MapEntry(JsonKeys.bathrooms, bathrooms.toString()),
    ]);

    return formData;
  }

  @override
  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = await super.toJson();

    data.addAll({
      JsonKeys.area: double.tryParse(area),
      JsonKeys.isFurnitured: isFurnitured,
      JsonKeys.numberOfFloors: numberOfFloors,
      JsonKeys.rooms: rooms,
      JsonKeys.bathrooms: bathrooms,
    });

    return data;
  }
}