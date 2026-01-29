import 'package:enmaa/core/services/select_location_service/data/data_source/select_location_remote_data_source.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_cities_use_case.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_countries_use_case.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_states_use_case.dart';

import '../service_locator.dart';
import 'data/repository/select_location_repository.dart';
import 'domain/repository/base_select_location_repository.dart';

class SelectLocationDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
  }

  void _registerDataSources() {
    sl.registerLazySingleton<BaseSelectLocationRemoteDataSource>(
      () => SelectLocationRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    sl.registerLazySingleton<BaseSelectLocationRepository>(
      () => SelectLocationRepository(baseSelectLocationRemoteDataSource: sl()),
    );
  }

  void _registerUseCases() {
    sl.registerLazySingleton(
      () => GetCountriesUseCase(sl()),
    );

    sl.registerLazySingleton(
      () => GetCitiesUseCase(sl()),
    );
    sl.registerLazySingleton(
      () => GetStatesUseCase(sl()),
    );
  }
}
