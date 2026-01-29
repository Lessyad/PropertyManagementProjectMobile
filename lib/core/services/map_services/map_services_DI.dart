import 'package:enmaa/core/services/map_services/domain/use_cases/get_suggested_location_use_case.dart';
import 'package:enmaa/core/services/select_location_service/data/data_source/select_location_remote_data_source.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_cities_use_case.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_countries_use_case.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_states_use_case.dart';

import '../service_locator.dart';
import 'data/data_source/map_services_remote_data_source.dart';
import 'data/repository/map_services_repository.dart';
 import 'domain/repository/base_map_services_repository.dart';

class MapServicesDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
  }

  void _registerDataSources() {
    if(sl.isRegistered<BaseMapServicesRemoteDataSource>()) return;
    sl.registerLazySingleton<BaseMapServicesRemoteDataSource>(
          () => MapServicesRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if(sl.isRegistered<BaseMapServicesRepository>()) return;
    sl.registerLazySingleton<BaseMapServicesRepository>(
          () => MapServicesRepository(baseMapServicesRemoteDataSource: sl()),
    );
  }

  void _registerUseCases() {
    if(sl.isRegistered<GetSuggestedLocationUseCase>()) return;
    sl.registerLazySingleton(
          () => GetSuggestedLocationUseCase(sl()),
    );


  }
}
