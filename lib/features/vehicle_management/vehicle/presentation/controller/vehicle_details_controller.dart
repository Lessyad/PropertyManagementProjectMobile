import 'package:enmaa/core/errors/failure.dart';
import 'package:get/get.dart';
import '../../domain/entities/vehicle_details_entity.dart';
import '../../domain/use_cases/get_vehicle_details_usecase.dart';

class VehicleDetailsController extends GetxController {
  final GetVehicleDetailsUseCase getVehicleDetailsUseCase;

  VehicleDetailsController(this.getVehicleDetailsUseCase);

  final vehicleDetails = Rxn<VehicleDetailsEntity>();
  final isLoading = false.obs;
  final errorMessage = ''.obs;

  // Cache local pour éviter les appels répétés
  final _cache = <int, VehicleDetailsEntity>{};
  final _lastFetch = <int, DateTime>{};
  static const Duration _cacheExpiration = Duration(minutes: 5);

  void getVehicleDetails(int id) async {
    // Vérifier le cache d'abord
    final cachedDetails = _getCachedDetails(id);
    if (cachedDetails != null) {
      vehicleDetails.value = cachedDetails;
      return;
    }

    try {
      isLoading.value = true;
      errorMessage.value = '';

      final result = await getVehicleDetailsUseCase(id);

      result.fold(
            (failure) {
          errorMessage.value = _mapFailureToMessage(failure);
          isLoading.value = false;
        },
            (details) {
          vehicleDetails.value = details;
          _cacheDetails(id, details);
          isLoading.value = false;
        },
      );
    } catch (e) {
      errorMessage.value = 'Une erreur est survenue';
      isLoading.value = false;
    }
  }

  VehicleDetailsEntity? _getCachedDetails(int id) {
    final lastFetch = _lastFetch[id];
    if (lastFetch != null && 
        DateTime.now().difference(lastFetch) < _cacheExpiration) {
      return _cache[id];
    }
    return null;
  }

  void _cacheDetails(int id, VehicleDetailsEntity details) {
    _cache[id] = details;
    _lastFetch[id] = DateTime.now();
  }

  void clearCache() {
    _cache.clear();
    _lastFetch.clear();
  }

  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Erreur serveur';
      // case CacheFailure:
      //   return 'Erreur de cache';
      default:
        return 'Erreur inattendue';
    }
  }
}