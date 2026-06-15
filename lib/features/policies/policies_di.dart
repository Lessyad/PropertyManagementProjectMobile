import 'package:enmaa/features/policies/data/data_source/policies_remote_data_source.dart';
import 'package:enmaa/features/policies/data/repository/policies_repository.dart';
import 'package:enmaa/features/policies/domain/repository/base_policies_repository.dart';
import 'package:enmaa/features/policies/domain/use_cases/get_policies_use_case.dart';
import '../../core/services/service_locator.dart';

class PoliciesDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {
    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
  }

  void _registerDataSources() {
    if (sl.isRegistered<BasePoliciesDataSource>()) return;
    sl.registerLazySingleton<BasePoliciesDataSource>(
        () => PoliciesRemoteDataSource(dioService: sl()));
  }

  void _registerRepositories() {
    if (sl.isRegistered<BasePoliciesRepository>()) return;
    sl.registerLazySingleton<BasePoliciesRepository>(
        () => PoliciesRepository(dataSource: sl()));
  }

  void _registerUseCases() {
    if (sl.isRegistered<GetPoliciesUseCase>()) return;
    sl.registerLazySingleton<GetPoliciesUseCase>(
        () => GetPoliciesUseCase(sl()));
  }
}
