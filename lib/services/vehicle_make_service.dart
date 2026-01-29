// Créez vehicle_make_service.dart
import 'package:dio/dio.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_service.dart';
import '../features/add_new_vehicle/data/models/vehicle_make_model.dart';


class VehicleMakeService {
  final DioService dioService;

  VehicleMakeService({required this.dioService});

  Future<List<VehicleMake>> getMakesWithModels() async {
    try {
      final response = await dioService.get(url: ApiConstants.vehicleMakes);
      final List<dynamic> data = response.data;

      // Log pour déboguer
      print('✅ Données reçues de l\'API:');
      print(data);

      final makes = data.map((json) {
        print('🔄 Parsing JSON: $json');
        final make = VehicleMake.fromJson(json);
        print('✅ Make parsé: ${make.name} avec ${make.models.length} modèles');
        return make;
      }).toList();

      print('✅ Total makes chargés: ${makes.length}');
      return makes;

    } catch (e) {
      print('❌ Erreur lors du chargement des marques: $e');
      throw Exception('Failed to load makes: $e');
    }
  }
}

// class VehicleMakeService {
//   final DioService dioService;
//
//   VehicleMakeService({required this.dioService});
//
//   Future<List<VehicleMake>> getMakes() async {
//     try {
//       final response = await dioService.get(url: ApiConstants.vehicleMakes);
//       final List<dynamic> data = response.data;
//       return data.map((json) => VehicleMake.fromJson(json)).toList();
//     } catch (e) {
//       throw Exception('Failed to load makes: $e');
//     }
//   }
//
//   Future<List<VehicleModel>> getModelsByMakeId(int makeId) async {
//     try {
//       final response = await dioService.get(
//           url: '${ApiConstants.vehicleMakes}/$makeId/models'
//       );
//       final List<dynamic> data = response.data;
//       return data.map((json) => VehicleModel.fromJson(json)).toList();
//     } catch (e) {
//       throw Exception('Failed to load models: $e');
//     }
//   }
// }