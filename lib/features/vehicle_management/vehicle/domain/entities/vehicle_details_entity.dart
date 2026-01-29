import 'package:enmaa/features/vehicle_management/vehicle/domain/entities/vehicle_entity.dart';

class VehicleDetailsEntity extends VehicleEntity {
  // final int mileage;
  // final String fuelType;
  // final String transmission;
  final bool hasAirConditioning;
  final int seats;
  final String vin;
  final int modelId;
  final int categoryId;
  final DateTime createdAt;
  final DateTime modifiedAt;


  VehicleDetailsEntity({
    required super.id,
    required super.licensePlate,
    required super.color,
    required super.year,
    required super.dailyPrice,
    required super.weeklyPrice,
    required super.modelName,
    required super.makeName,
    required super.categoryName,
    required super.imageUrls,
    required super.mileage,
    required super.fuelType,
    required super.transmission,
    required super.vehicleAvailabilityStatus,
    required super.isInWishlist,
    super.latitude,
    super.longitude,

    required this.hasAirConditioning,
    required this.seats,
    required this.vin,
    required this.modelId,
    required this.categoryId,
    required this.createdAt,
    required this.modifiedAt,
  });
}