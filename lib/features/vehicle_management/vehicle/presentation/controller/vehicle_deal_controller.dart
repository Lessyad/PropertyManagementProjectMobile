import 'package:get/get.dart';
import '../../data/models/vehicle_deal_request.dart';
import '../../domain/usecases/create_vehicle_deal_usecase.dart';
import '../../domain/entities/vehicle_entity.dart';

class VehicleDealController extends GetxController {
  final CreateVehicleDealUseCase createVehicleDealUseCase;

  VehicleDealController({required this.createVehicleDealUseCase});

  // États de la requête
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;
  final dealResult = Rxn<Map<String, dynamic>>();

  // Méthode pour créer un deal de véhicule
  Future<void> createVehicleDeal({
    required VehicleEntity vehicle,
    required DateTime startDate,
    required DateTime endDate,
    required MainDriverData mainDriver,
    bool secondDriverEnabled = false,
    SecondDriverData? secondDriver,
    required String paymentMethod,
    String? passcode,
    String? bankilyPhoneNumber,
    bool kilometerIllimitedPerDay = false,
    bool allRiskCarInsurance = false,
    bool addChildsChair = false,
    required int pickupAreaId,
    required int returnAreaId,
    required int userId,
    bool isClientUser = true,
  }) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      errorMessage.value = '';

      // Créer la requête
      final request = VehicleDealRequest(
        vehicleId: vehicle.id,
        startDate: startDate,
        endDate: endDate,
        mainDriver: mainDriver,
        secondDriverEnabled: secondDriverEnabled,
        secondDriver: secondDriver,
        paymentMethod: paymentMethod,
        passcode: passcode,
        bankilyPhoneNumber: bankilyPhoneNumber,
        kilometerIllimitedPerDay: kilometerIllimitedPerDay,
        allRiskCarInsurance: allRiskCarInsurance,
        addChildsChair: addChildsChair,
        pickupAreaId: pickupAreaId,
        returnAreaId: returnAreaId,
      );

      // Appeler le use case
      final result = await createVehicleDealUseCase(
        request: request,
        userId: userId,
        isClientUser: isClientUser,
      );

      dealResult.value = result;
      isLoading.value = false;
    } catch (e) {
      print('❌ VehicleDealController Error: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      isLoading.value = false;
    }
  }

  // Méthode pour réinitialiser l'état
  void resetState() {
    isLoading.value = false;
    hasError.value = false;
    errorMessage.value = '';
    dealResult.value = null;
  }
}
