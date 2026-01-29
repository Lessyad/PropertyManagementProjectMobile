import 'package:enmaa/features/vehicle_management/vehicle/data/models/vehicle_model.dart';

import '../../domain/entities/vehicle_details_entity.dart';

class VehicleDetailsModel extends VehicleModel {
  VehicleDetailsModel({
    required super.id,
    required super.licensePlate,
    required super.color,
    required super.year,
    required super.dailyPrice,
    required super.weeklyPrice,
    required super.mileage,
    required super.fuelType,
    required super.transmission,
    required super.vehicleAvailabilityStatus,
    required super.hasAirConditioning,
    required super.seats,
    required super.vin,
    required super.modelName,
    required super.modelId,
    required super.makeName,
    required super.categoryName,
    required super.categoryId,
    required super.imageUrls,
    required super.createdAt,
    required super.modifiedAt,
    required super.isinwishlist,
    super.latitude,
    super.longitude,
  });

  factory VehicleDetailsModel.fromJson(Map<String, dynamic> json) {
    return VehicleDetailsModel(
      id: json['id'],
      licensePlate: json['licensePlate'],
      color: json['color'],
      year: json['year'],
      dailyPrice: json['dailyPrice'].toDouble(),
      weeklyPrice: json['weeklyPrice'].toDouble(),
      mileage: json['mileage'],
      fuelType: json['fuelType'],
      transmission: json['transmission'],
      vehicleAvailabilityStatus: json['vehicleAvailabilityStatus'],
      hasAirConditioning: json['hasAirConditioning'],
      seats: json['seats'],
      vin: json['vin'],
      modelName: json['modelName'],
      modelId: json['modelId'],
      makeName: json['makeName'],
      categoryName: json['categoryName'],
      categoryId: json['categoryId'],
      imageUrls: List<String>.from(json['imageUrls']),
      createdAt: DateTime.parse(json['createdAt']),
      modifiedAt: DateTime.parse(json['modifiedAt']),
      isinwishlist: json['is_in_wishlist'] ?? true,
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
    );
  }
  // Dans vehicle_details_model.dart
  VehicleDetailsEntity toDetailsEntity() {
    return VehicleDetailsEntity(
      id: id,
      licensePlate: licensePlate,
      color: color,
      year: year,
      dailyPrice: dailyPrice,
      weeklyPrice: weeklyPrice,
      modelName: modelName,
      makeName: makeName,
      categoryName: categoryName,
      imageUrls: imageUrls,
      mileage: mileage,
      fuelType: fuelType,
      transmission: transmission,
      vehicleAvailabilityStatus: vehicleAvailabilityStatus,
      hasAirConditioning: hasAirConditioning,
      seats: seats,
      vin: vin,
      modelId: modelId,
      categoryId: categoryId,
      createdAt: createdAt,
      modifiedAt: modifiedAt,
      isInWishlist: isinwishlist,
      latitude: latitude,
      longitude: longitude,

    );
  }
}