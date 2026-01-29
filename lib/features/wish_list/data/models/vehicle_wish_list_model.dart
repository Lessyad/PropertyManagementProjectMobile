
import '../../domain/entities/vehicle_wish_list_entity.dart';

class VehicleWishListModel extends VehicleWishListEntity {
  const VehicleWishListModel({
    required super.id,
    required super.vehicleId,
    required super.vehicleModel,
    required super.vehicleBrand,
    required super.dailyPrice,
    required super.imageUrl,
    required super.addedDate,
    required super.notes,
    required super.isAvailable,
    required super.year,
    required super.fuelType,
    required super.transmission,
    required super.seats,
  });

  factory VehicleWishListModel.fromJson(Map<String, dynamic> json) {
    return VehicleWishListModel(
      id: json['id'],
      vehicleId: json['vehicleId'],
      vehicleModel: json['vehicleModel'] ?? '',
      vehicleBrand: json['vehicleBrand'] ?? '',
      dailyPrice: (json['dailyPrice'] ?? 0).toDouble(),
      imageUrl: List<String>.from(json['imageUrl'] ?? []),
      addedDate: DateTime.parse(json['addedDate']),
      notes: json['notes'],
      isAvailable: json['isAvailable'] ?? false,
      year: json['year'] ?? 0,
      fuelType: json['fuelType'] ?? '',
      transmission: json['transmission'] ?? '',
      seats: json['seats'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'vehicleModel': vehicleModel,
      'vehicleBrand': vehicleBrand,
      'dailyPrice': dailyPrice,
      'imageUrl': imageUrl,
      'addedDate': addedDate.toIso8601String(),
      'notes': notes,
      'isAvailable': isAvailable,
      'year': year,
      'fuelType': fuelType,
      'transmission': transmission,
      'seats': seats,
    };
  }

  VehicleWishListEntity toEntity() {
    return VehicleWishListEntity(
      id: id,
      vehicleId: vehicleId,
      vehicleModel: vehicleModel,
      vehicleBrand: vehicleBrand,
      dailyPrice: dailyPrice,
      imageUrl: imageUrl,
      addedDate: addedDate,
      notes: notes,
      isAvailable: isAvailable,
      year: year,
      fuelType: fuelType,
      transmission: transmission,
      seats: seats,
    );
  }

  static VehicleWishListModel fromEntity(VehicleWishListEntity entity) {
    return VehicleWishListModel(
      id: entity.id,
      vehicleId: entity.vehicleId,
      vehicleModel: entity.vehicleModel,
      vehicleBrand: entity.vehicleBrand,
      dailyPrice: entity.dailyPrice,
      imageUrl: entity.imageUrl,
      addedDate: entity.addedDate,
      notes: entity.notes,
      isAvailable: entity.isAvailable,
      year: entity.year,
      fuelType: entity.fuelType,
      transmission: entity.transmission,
      seats: entity.seats,
    );
  }
}