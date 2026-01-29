import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/vehicle_model.dart';

abstract class BaseVehicleLocalDataSource {
  Future<void> cacheVehicles(List<VehicleModel> vehicles);
  Future<List<VehicleModel>> getCachedVehicles();
}

class VehicleLocalDataSource implements BaseVehicleLocalDataSource {
  static const String _cacheKey = 'cached_vehicles';

  @override
  Future<void> cacheVehicles(List<VehicleModel> vehicles) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final vehiclesJson = vehicles.map((vehicle) => {
        'id': vehicle.id,
        'licensePlate': vehicle.licensePlate,
        'color': vehicle.color,
        'year': vehicle.year,
        'dailyPrice': vehicle.dailyPrice,
        'weeklyPrice': vehicle.weeklyPrice,
        'mileage': vehicle.mileage,
        'fuelType': vehicle.fuelType,
        'transmission': vehicle.transmission,
        'hasAirConditioning': vehicle.hasAirConditioning,
        'seats': vehicle.seats,
        'vin': vehicle.vin,
        'modelName': vehicle.modelName,
        'modelId': vehicle.modelId,
        'makeName': vehicle.makeName,
        'categoryName': vehicle.categoryName,
        'categoryId': vehicle.categoryId,
        'imageUrls': vehicle.imageUrls,
        'createdAt': vehicle.createdAt.toIso8601String(),
        'modifiedAt': vehicle.modifiedAt.toIso8601String(),
      }).toList();
      
      await prefs.setString(_cacheKey, jsonEncode(vehiclesJson));
    } catch (e) {
      // En cas d'erreur, on ne fait rien pour ne pas bloquer l'application
      print('Erreur lors du cache des véhicules: $e');
    }
  }

  @override
  Future<List<VehicleModel>> getCachedVehicles() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final vehiclesJson = prefs.getString(_cacheKey);
      
      if (vehiclesJson == null) return [];
      
      final List<dynamic> vehiclesList = jsonDecode(vehiclesJson);
      return vehiclesList.map((json) => VehicleModel.fromJson(json)).toList();
    } catch (e) {
      print('Erreur lors de la récupération du cache: $e');
      return [];
    }
  }
}