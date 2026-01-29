import 'package:equatable/equatable.dart';

class VehicleWishListEntity extends Equatable {
  final int id;
  final int vehicleId;
  final String vehicleModel;
  final String vehicleBrand;
  final double dailyPrice;
  final List<String> imageUrl;
  final DateTime addedDate;
  final String? notes;
  final bool isAvailable;
  final int year;
  final String fuelType;
  final String transmission;
  final int seats;

  const VehicleWishListEntity({
    required this.id,
    required this.vehicleId,
    required this.vehicleModel,
    required this.vehicleBrand,
    required this.dailyPrice,
    required this.imageUrl,
    required this.addedDate,
    this.notes,
    required this.isAvailable,
    required this.year,
    required this.fuelType,
    required this.transmission,
    required this.seats,
  });

  // Getter pour la première image (couverture)
  String get coverImage => imageUrl.isNotEmpty ? imageUrl.first : '';

  @override
  List<Object?> get props => [
    id,
    vehicleId,
    vehicleModel,
    vehicleBrand,
    dailyPrice,
    imageUrl,
    addedDate,
    notes,
    isAvailable,
    year,
    fuelType,
    transmission,
    seats,
  ];
}