import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import '../../data/datasources/vehicle_deal_remote_datasource.dart';
import '../../data/datasources/vehicle_deal_remote_datasource_alternative.dart';
import '../../data/datasources/vehicle_deal_json_datasource.dart';
import '../../data/repositories/vehicle_deal_repository_impl.dart';
import '../../domain/repositories/vehicle_deal_repository.dart';
import '../../domain/usecases/create_vehicle_deal_usecase.dart';
import 'vehicle_deal_controller.dart';

class VehicleDealDependencyInjection {
  static void init() {
    // Data sources
    Get.lazyPut<VehicleDealRemoteDataSource>(
      () => VehicleDealRemoteDataSourceImpl(client: http.Client()),
    );

    // Repositories
    Get.lazyPut<VehicleDealRepository>(
      () => VehicleDealRepositoryImpl(
        remoteDataSource: Get.find(),
      ),
    );

    // Use cases
    Get.lazyPut<CreateVehicleDealUseCase>(
      () => CreateVehicleDealUseCase(
        repository: Get.find(),
      ),
    );

    // Controllers
    Get.lazyPut<VehicleDealController>(
      () => VehicleDealController(
        createVehicleDealUseCase: Get.find(),
      ),
    );
  }
}
