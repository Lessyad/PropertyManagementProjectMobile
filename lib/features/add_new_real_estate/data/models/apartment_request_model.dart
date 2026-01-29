import 'package:dio/dio.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/property_request_model.dart';
import '../../../../core/constants/json_keys.dart';

class ApartmentRequestModel extends PropertyRequestModel {
  final String area;
  final bool isFurnitured;
  final String floor;
  final String rooms;
  final String bathrooms;

  ApartmentRequestModel({
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
    required this.area,
    required this.isFurnitured,
    required this.floor,
    required this.rooms,
    required this.bathrooms,

    super.monthlyRentPeriod,
    super.isRenewable,
    super.paymentMethod,
  });
  @override
  Future<Map<String, dynamic>> toJson() async {
    final Map<String, dynamic> data = await super.toJson();

    data.addAll({
      JsonKeys.area: double.tryParse(area),
      JsonKeys.isFurnitured: isFurnitured,
      JsonKeys.floor: int.tryParse(floor),
      JsonKeys.rooms: int.tryParse(rooms),
      JsonKeys.bathrooms: int.tryParse(bathrooms),
    });

    return data;
  }
  @override
  Future<FormData> toFormData() async {
    final formData = await super.toFormData();

    formData.fields.addAll([
      MapEntry(JsonKeys.area, double.tryParse(area)?.toString() ?? '0'),
      MapEntry(JsonKeys.isFurnitured, isFurnitured.toString()),
      MapEntry(JsonKeys.floor, int.tryParse(floor)?.toString() ?? '0'),
      MapEntry(JsonKeys.rooms, int.tryParse(rooms)?.toString() ?? '0'),
      MapEntry(JsonKeys.bathrooms, int.tryParse(bathrooms)?.toString() ?? '0'),
    ]);

    return formData;
  }

  /// Nouvelle méthode pour créer un ApartmentRequestModel avec des URLs d'images
  Future<Map<String, dynamic>> toJsonWithImageUrls(List<String> imageUrls) async {
    final baseData = await super.toJsonWithImageUrls(imageUrls);
    
    baseData.addAll({
      JsonKeys.area: double.tryParse(area),
      JsonKeys.isFurnitured: isFurnitured,
      JsonKeys.floor: int.tryParse(floor),
      JsonKeys.rooms: int.tryParse(rooms),
      JsonKeys.bathrooms: int.tryParse(bathrooms),
    });

    return baseData;
  }
}
