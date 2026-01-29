import 'package:enmaa/core/constants/api_constants.dart';
import 'package:enmaa/core/services/dio_service.dart';
import 'package:get/get.dart';

import '../models/api_response.dart';
import '../models/vehicle_details_model.dart';
import '../models/vehicle_filter_model.dart';
import '../models/vehicle_model.dart';
import '../../presentation/controller/global_rental_options_controller.dart';
import '../../presentation/controller/auth_helper.dart';

abstract class BaseVehicleRemoteDataSource {
  Future<ApiResponse<VehicleModel>> getVehicles({
    int pageNumber = 1,
    int pageSize = 10,
    VehicleFilterModel? filter,
  });

  Future<VehicleDetailsModel> getVehicleDetails(int id);
}

class VehicleRemoteDataSource implements BaseVehicleRemoteDataSource {
  final DioService dioService;

  VehicleRemoteDataSource({required this.dioService});

  @override
  Future<ApiResponse<VehicleModel>> getVehicles({
    int pageNumber = 1,
    int pageSize = 10,
    VehicleFilterModel? filter,
  }) async {
    // Vérifier si l'utilisateur est en mode invité
    final isAuthenticated = AuthHelper.isUserAuthenticated();
    final inGuestMode = !isAuthenticated;
    
    final queryParams = {
      'pageNumber': pageNumber,
      'pageSize': pageSize,
      'inGuestMode': inGuestMode,
      ...?filter?.toJson(),
    };
    
    // Debug: Afficher les paramètres de requête
    print('🚗 VehicleRemoteDataSource - Appel API:');
    print('  - URL: ${ApiConstants.vehicles}');
    print('  - Mode invité: $inGuestMode');
    print('  - Authentifié: $isAuthenticated');
    print('  - Paramètres: $queryParams');
    
    final response = await dioService.get(
      url: ApiConstants.vehicles,
      queryParameters: queryParams,
    );

    // Debug: Afficher la réponse du serveur
    print('📡 VehicleRemoteDataSource - Réponse serveur:');
    print('  - Status: ${response.statusCode}');
    print('  - Data: ${response.data}');
    
    final apiResponse = ApiResponse.fromJson(
      response.data,
          (json) => VehicleModel.fromJson(json),
    );
    
    // Extraire et mettre à jour les options globales
    _updateGlobalRentalOptions(response.data);
    
    print('📊 VehicleRemoteDataSource - Véhicules trouvés: ${apiResponse.items.length}');
    
    return apiResponse;
  }

  @override
  Future<VehicleDetailsModel> getVehicleDetails(int id) async {
    final response = await dioService.get(
      url: '${ApiConstants.vehicleDetails}$id',
    );

    return VehicleDetailsModel.fromJson(response.data);
  }

  // Méthode privée pour mettre à jour les options globales
  void _updateGlobalRentalOptions(Map<String, dynamic> responseData) {
    try {
      // Vérifier si le contrôleur existe
      if (Get.isRegistered<GlobalRentalOptionsController>()) {
        final optionsController = Get.find<GlobalRentalOptionsController>();
        optionsController.updateOptions(responseData);
        
        print('✅ Options globales mises à jour:');
        print('  - addChildsChairAmount: ${optionsController.addChildsChairAmount}');
        print('  - allRiskCarInsuranceAmount: ${optionsController.allRiskCarInsuranceAmount}');
        print('  - kilometerIllimitedPerDayAmount: ${optionsController.kilometerIllimitedPerDayAmount}');
        print('  - secondDriverAmount: ${optionsController.secondDriverAmount}');
      } else {
        print('⚠️ GlobalRentalOptionsController non enregistré');
      }
    } catch (e) {
      print('❌ Erreur lors de la mise à jour des options globales: $e');
    }
  }
}