import 'package:dio/dio.dart';
import 'package:enmaa/core/constants/api_constants.dart';
import 'package:enmaa/core/services/dio_service.dart';

class VehicleRentalData {
  final int id;
  final String licensePlate;
  final String color;
  final int year;
  final double dailyPrice;
  final double weeklyPrice;
  final int mileage;
  final String fuelType;
  final String transmission;
  final bool hasAirConditioning;
  final int seats;
  final String vin;
  final String modelName;
  final int modelId;
  final String makeName;
  final String categoryName;
  final int categoryId;
  final List<String> imageUrls;
  final String vehicleAvailabilityStatus;
  final double? latitude;
  final double? longitude;
  final DateTime createdAt;
  final DateTime modifiedAt;
  final bool isInWishlist;

  VehicleRentalData({
    required this.id,
    required this.licensePlate,
    required this.color,
    required this.year,
    required this.dailyPrice,
    required this.weeklyPrice,
    required this.mileage,
    required this.fuelType,
    required this.transmission,
    required this.hasAirConditioning,
    required this.seats,
    required this.vin,
    required this.modelName,
    required this.modelId,
    required this.makeName,
    required this.categoryName,
    required this.categoryId,
    required this.imageUrls,
    required this.vehicleAvailabilityStatus,
    this.latitude,
    this.longitude,
    required this.createdAt,
    required this.modifiedAt,
    required this.isInWishlist,
  });

  factory VehicleRentalData.fromJson(Map<String, dynamic> json) {
    return VehicleRentalData(
      id: json['id'] ?? 0,
      licensePlate: json['licensePlate'] ?? '',
      color: json['color'] ?? '',
      year: json['year'] ?? 0,
      dailyPrice: (json['dailyPrice'] ?? 0).toDouble(),
      weeklyPrice: (json['weeklyPrice'] ?? 0).toDouble(),
      mileage: json['mileage'] ?? 0,
      fuelType: json['fuelType'] ?? '',
      transmission: json['transmission'] ?? '',
      hasAirConditioning: json['hasAirConditioning'] ?? false,
      seats: json['seats'] ?? 0,
      vin: json['vin'] ?? '',
      modelName: json['modelName'] ?? '',
      modelId: json['modelId'] ?? 0,
      makeName: json['makeName'] ?? '',
      categoryName: json['categoryName'] ?? '',
      categoryId: json['categoryId'] ?? 0,
      imageUrls: List<String>.from(json['imageUrls'] ?? []),
      vehicleAvailabilityStatus: json['vehicleAvailabilityStatus'] ?? '',
      latitude: json['latitude']?.toDouble(),
      longitude: json['longitude']?.toDouble(),
      createdAt: DateTime.parse(json['createdAt'] ?? DateTime.now().toIso8601String()),
      modifiedAt: DateTime.parse(json['modifiedAt'] ?? DateTime.now().toIso8601String()),
      isInWishlist: json['is_in_wishlist'] ?? false,
    );
  }

  // Méthode pour obtenir le nom complet du véhicule
  String get fullVehicleName => '$makeName $modelName $year';
  
  // Méthode pour obtenir la première image
  String get firstImage => imageUrls.isNotEmpty ? imageUrls.first : '';
  
  // Méthode pour calculer le prix total basé sur le nombre de jours
  double calculateTotalPrice(int numberOfDays) {
    if (numberOfDays >= 7) {
      // Si 7 jours ou plus, utiliser le prix hebdomadaire
      int weeks = (numberOfDays / 7).ceil();
      return weeklyPrice * weeks;
    } else {
      // Sinon utiliser le prix journalier
      return dailyPrice * numberOfDays;
    }
  }
}

class VehicleRentalService {
  final DioService dioService;

  VehicleRentalService({required this.dioService});

  Future<VehicleRentalData> getVehicleDetails(int vehicleId) async {
    try {
      final response = await dioService.get(
        url: '${ApiConstants.vehicleDetails}$vehicleId',
      );

      return VehicleRentalData.fromJson(response.data);
    } catch (e) {
      throw Exception('Erreur lors de la récupération des détails du véhicule: $e');
    }
  }

  // Méthode pour calculer le nombre de jours entre deux dates
  int calculateNumberOfDays(DateTime startDate, DateTime endDate) {
    return endDate.difference(startDate).inDays + 1; // +1 pour inclure le jour de début
  }
}
