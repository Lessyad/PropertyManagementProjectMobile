import '../../../../core/services/service_locator.dart';
import 'data/data_source/rental_history_remote_data_source.dart';
import 'data/repository/rental_history_repository.dart';
import 'domain/repository/base_rental_history_repository.dart';
import 'domain/use_cases/cancel_rental_use_case.dart';
import 'domain/use_cases/get_rental_history_use_case.dart';

class UserRentalHistoryDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {
    _registerRemoteDataSource();
    _registerRepositories();
    _registerUseCases();
  }

  void _registerRemoteDataSource() {
    if (sl.isRegistered<BaseRentalHistoryRemoteDataSource>()) return;
    sl.registerLazySingleton<BaseRentalHistoryRemoteDataSource>(
      () => RentalHistoryRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if (sl.isRegistered<BaseRentalHistoryRepository>()) return;
    sl.registerLazySingleton<BaseRentalHistoryRepository>(
      () => RentalHistoryRepository(remoteDataSource: sl()),
    );
  }

  void _registerUseCases() {
    if (!sl.isRegistered<GetRentalHistoryUseCase>()) {
      sl.registerLazySingleton(() => GetRentalHistoryUseCase(sl()));
    }
    if (!sl.isRegistered<CancelRentalUseCase>()) {
      sl.registerLazySingleton(() => CancelRentalUseCase(sl()));
    }
  }
}
