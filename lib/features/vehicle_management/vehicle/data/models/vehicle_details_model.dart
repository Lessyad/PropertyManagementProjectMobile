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
    final base = VehicleModel.fromJson(json);
    return VehicleDetailsModel(
      id: base.id,
      licensePlate: base.licensePlate,
      color: base.color,
      year: base.year,
      dailyPrice: base.dailyPrice,
      weeklyPrice: base.weeklyPrice,
      mileage: base.mileage,
      fuelType: base.fuelType,
      transmission: base.transmission,
      vehicleAvailabilityStatus: base.vehicleAvailabilityStatus,
      hasAirConditioning: base.hasAirConditioning,
      seats: base.seats,
      vin: base.vin,
      modelName: base.modelName,
      modelId: base.modelId,
      makeName: base.makeName,
      categoryName: base.categoryName,
      categoryId: base.categoryId,
      imageUrls: base.imageUrls,
      createdAt: base.createdAt,
      modifiedAt: base.modifiedAt,
      isinwishlist: base.isinwishlist,
      latitude: base.latitude,
      longitude: base.longitude,
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