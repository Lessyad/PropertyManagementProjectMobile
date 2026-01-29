import 'package:get_it/get_it.dart';
import '../../core/services/dio_service.dart';
import 'data/data_source/add_new_vehicle_remote_data_source.dart';
import 'data/repository/add_new_vehicle_repository.dart';
import 'domain/repository/base_add_new_vehicle_repository.dart';
import 'domain/use_cases/use_cases.dart';

class AddNewVehicleDi {
  void setup() {
    final getIt = GetIt.instance;

    if (!getIt.isRegistered<BaseAddNewVehicleDataSource>()) {
      getIt.registerLazySingleton<BaseAddNewVehicleDataSource>(
        () => AddNewVehicleRemoteDataSource(dioService: getIt<DioService>()),
      );
    }

    if (!getIt.isRegistered<BaseAddNewVehicleRepository>()) {
      getIt.registerLazySingleton<BaseAddNewVehicleRepository>(
        () => AddNewVehicleRepository(dataSource: getIt<BaseAddNewVehicleDataSource>()),
      );
    }

    if (!getIt.isRegistered<CreateVehicleUseCase>()) {
      getIt.registerLazySingleton<CreateVehicleUseCase>(
        () => CreateVehicleUseCase(getIt<BaseAddNewVehicleRepository>()),
      );
    }
    if (!getIt.isRegistered<UpdateVehicleUseCase>()) {
      getIt.registerLazySingleton<UpdateVehicleUseCase>(
        () => UpdateVehicleUseCase(getIt<BaseAddNewVehicleRepository>()),
      );
    }
    if (!getIt.isRegistered<DeleteVehicleUseCase>()) {
      getIt.registerLazySingleton<DeleteVehicleUseCase>(
        () => DeleteVehicleUseCase(getIt<BaseAddNewVehicleRepository>()),
      );
    }
  }
}