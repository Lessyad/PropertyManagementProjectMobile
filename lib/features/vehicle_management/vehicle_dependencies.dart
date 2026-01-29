import 'package:enmaa/core/services/dio_service.dart';
import 'package:get/get.dart';
import 'package:enmaa/features/vehicle_management/vehicle/data/data_source/vehicle_local_data_source.dart';
import 'package:enmaa/features/vehicle_management/vehicle/data/data_source/vehicle_remote_data_source.dart';
import 'package:enmaa/features/vehicle_management/vehicle/data/repository/vehicle_repository_impl.dart';
import 'package:enmaa/features/vehicle_management/vehicle/domain/repository/vehicle_repository.dart';
import 'package:enmaa/features/vehicle_management/vehicle/domain/use_cases/get_vehicle_details_usecase.dart';
import 'package:enmaa/features/vehicle_management/vehicle/domain/use_cases/get_vehicles_usecase.dart';
import 'package:enmaa/features/vehicle_management/vehicle/presentation/controller/vehicle_controller.dart';
import 'package:enmaa/features/vehicle_management/vehicle/presentation/controller/vehicle_details_controller.dart';
import 'package:enmaa/features/vehicle_management/vehicle/presentation/controller/global_rental_options_controller.dart';

// import '../../core/core_dependencies.dart';


class VehicleDependencies {
  static Future<void> init() async {
    // Ici, si tu as besoin de charger des données async, tu peux les await
    // Exemple : await Future.delayed(Duration(milliseconds: 50));

    // Data Sources
    Get.lazyPut<BaseVehicleRemoteDataSource>(
          () => VehicleRemoteDataSource(dioService: Get.find<DioService>()),
      fenix: true,
    );

    Get.lazyPut<BaseVehicleLocalDataSource>(
          () => VehicleLocalDataSource(),
      fenix: true,
    );

    // Repository
    Get.lazyPut<VehicleRepository>(
          () => VehicleRepositoryImpl(
        remoteDataSource: Get.find(),
        localDataSource: Get.find(),
      ),
      fenix: true,
    );

    // Use Cases
    Get.lazyPut(
          () => GetVehiclesUseCase(Get.find()),
      fenix: true,
    );

    Get.lazyPut(
          () => GetVehicleDetailsUseCase(Get.find()),
      fenix: true,
    );

    // Controllers
    Get.lazyPut(() => VehicleController(Get.find()), fenix: true);
    Get.lazyPut(
          () => VehicleDetailsController(Get.find()),
      fenix: true,
    );
    Get.lazyPut(() => GlobalRentalOptionsController(), fenix: true);
  }
}
