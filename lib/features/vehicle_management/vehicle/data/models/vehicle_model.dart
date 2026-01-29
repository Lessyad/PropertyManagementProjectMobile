import '../../domain/entities/vehicle_entity.dart';

class VehicleModel {
  final int id;
  final String licensePlate;
  final String color;
  final int year;
  final double dailyPrice;
  final double weeklyPrice;
  final int mileage;
  final String fuelType;
  final String transmission;
  final String vehicleAvailabilityStatus;
  final bool hasAirConditioning;
  final int seats;
  final String vin;
  final String modelName;
  final int modelId;
  final String makeName;
  final String categoryName;
  final int categoryId;
  final List<String> imageUrls;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool isinwishlist;
  final double? latitude;
  final double? longitude;

  VehicleModel({
    required this.id,
    required this.licensePlate,
    required this.color,
    required this.year,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.mileage,
    required this.fuelType,
    required this.transmission,
    required this.vehicleAvailabilityStatus,
    required this.hasAirConditioning,
    required this.seats,
    required this.vin,
    required this.modelName,
    required this.modelId,
    required this.makeName,
    required this.categoryName,
    required this.categoryId,
    required this.imageUrls,
    required this.createdAt,
    required this.modifiedAt,
    required this.isinwishlist,
    this.latitude,
    this.longitude,
  });

  factory VehicleModel.fromJson(Map<String, dynamic> json) {
    return VehicleModel(
      id: json['id'],
      licensePlate: json['licensePlate'],
      color: json['color'],
      year: json['year'],
      dailyPrice: json['dailyPrice'].toDouble(),
      weeklyPrice: json['weeklyPrice'].toDouble(),
      mileage: json['mileage'],
      vehicleAvailabilityStatus: json['vehicleAvailabilityStatus'],
      fuelType: json['fuelType'],
      transmission: json['transmission'],
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
  // Dans vehicle_model.dart
  VehicleEntity toEntity() {
    return VehicleEntity(
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
      seats: seats,
      hasAirConditioning: hasAirConditioning,
      isInWishlist: isinwishlist,
      latitude: latitude,
      longitude: longitude,
    );
  }
}