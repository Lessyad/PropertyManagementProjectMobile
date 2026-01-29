import 'package:get/get.dart';
import '../../data/models/vehicle_deal_request.dart';
import '../../data/datasources/vehicle_deal_multipart_corrected.dart';
import '../../domain/entities/vehicle_entity.dart';

class VehicleDealMultipartController extends GetxController {
  final VehicleDealMultipartCorrected multipartDataSource;

  VehicleDealMultipartController({required this.multipartDataSource});

  // États de la requête
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;
  final dealResult = Rxn<Map<String, dynamic>>();

  // Méthode pour créer un deal de véhicule avec multipart corrigé
  Future<void> createVehicleDealMultipart({
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

      // Appeler le datasource multipart corrigé
      final result = await multipartDataSource.createVehicleDeal(
        request: request,
        userId: userId,
        isClientUser: isClientUser,
      );

      dealResult.value = result;
      isLoading.value = false;
    } catch (e) {
      print('❌ VehicleDealMultipartController Error: $e');
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
