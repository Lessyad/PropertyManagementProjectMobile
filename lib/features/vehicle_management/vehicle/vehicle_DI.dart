import 'package:get/get.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'data/data_source/vehicle_remote_data_source.dart';
import 'data/data_source/vehicle_local_data_source.dart';
import 'data/repository/vehicle_repository_impl.dart';
import 'domain/repository/vehicle_repository.dart';
import 'domain/use_cases/get_vehicles_usecase.dart';
import 'domain/use_cases/get_vehicle_details_usecase.dart';
import 'presentation/controller/vehicle_controller.dart';
import 'presentation/controller/vehicle_details_controller.dart';
import 'presentation/controller/global_rental_options_controller.dart';

class VehicleDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {
    _registerRemoteDataSource();
    _registerRepositories();
    _registerUseCases();
    _registerControllers();
  }

  void _registerRemoteDataSource() {
    sl.registerLazySingleton<BaseVehicleRemoteDataSource>(
      () => VehicleRemoteDataSource(dioService: sl()),
    );
    
    sl.registerLazySingleton<BaseVehicleLocalDataSource>(
      () => VehicleLocalDataSource(),
    );
  }

  void _registerRepositories() {
    sl.registerLazySingleton<VehicleRepository>(
      () => VehicleRepositoryImpl(
        remoteDataSource: sl(),
        localDataSource: sl(),
      ),
    );
  }

  void _registerUseCases() {
    sl.registerLazySingleton(() => GetVehiclesUseCase(sl()));
    sl.registerLazySingleton(() => GetVehicleDetailsUseCase(sl()));
  }

  void _registerControllers() {
    // Enregistrer les contrôleurs avec GetX
    Get.lazyPut<VehicleController>(() => VehicleController(sl()));
    Get.lazyPut<VehicleDetailsController>(() => VehicleDetailsController(sl()));
    
    // Enregistrer le contrôleur des options globales avec lazyPut pour qu'il soit disponible globalement
    Get.lazyPut<GlobalRentalOptionsController>(() => GlobalRentalOptionsController());
  }
}
