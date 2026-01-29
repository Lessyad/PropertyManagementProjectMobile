import 'package:enmaa/core/services/service_locator.dart';
import 'data/data_source/vehicle_wish_list_remote_data_source.dart';
import 'data/repository/vehicle_wish_list_repository.dart';
import 'domain/repository/base_vehicle_wish_list_repository.dart';
import 'domain/use_cases/add_vehicle_to_wish_list_use_case.dart';
import 'domain/use_cases/check_vehicle_in_wish_list_use_case.dart';
import 'domain/use_cases/get_vehicles_wish_list_use_case.dart';
import 'domain/use_cases/remove_vehicle_from_wish_list_use_case.dart';
import 'presentation/controller/vehicle_wish_list_cubit.dart';

class VehicleWishListDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
    _registerCubit();
  }

  void _registerDataSources() {
    if (sl.isRegistered<BaseVehicleWishListDataSource>()) return;

    sl.registerLazySingleton<BaseVehicleWishListDataSource>(
          () => VehicleWishListRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if (sl.isRegistered<BaseVehicleWishListRepository>()) return;

    sl.registerLazySingleton<BaseVehicleWishListRepository>(
          () => VehicleWishListRepository(dataSource: sl()),
    );
  }

  void _registerUseCases() {
    sl.registerLazySingleton(() => GetVehiclesWishListUseCase(sl()));
    sl.registerLazySingleton(() => AddVehicleToWishListUseCase(sl()));
    sl.registerLazySingleton(() => RemoveVehicleFromWishListUseCase(sl()));
    sl.registerLazySingleton(() => CheckVehicleInWishListUseCase(sl()));
  }

  void _registerCubit() {
    sl.registerFactory(() => VehicleWishListCubit(
      sl(),
      sl(),
      sl(),
      sl(),
    ));
  }
}