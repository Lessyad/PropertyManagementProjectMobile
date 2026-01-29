import 'package:enmaa/features/my_profile/modules/user_data_module/data/data_source/user_data_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/data/repository/user_data_repository.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/repository/base_user_data_repository.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/use_cases/get_user_data_use_case.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/use_cases/update_user_data_use_case.dart';
import '../../../../core/services/service_locator.dart';

class UserDataDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {

    _registerRemoteDataSource();
    _registerRepositories();
    _registerUseCases();



  }


  void _registerRemoteDataSource() {
    if(sl.isRegistered<BaseUserDataRemoteDataSource>()) return;
    sl.registerLazySingleton<BaseUserDataRemoteDataSource>(
          () => UserDataRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if(sl.isRegistered<BaseUserDataRepository>()) return;
    sl.registerLazySingleton<BaseUserDataRepository>(
          () => UserDataRepository(baseUserDataRemoteDataSource: sl()),
    );
  }

  void _registerUseCases() {
    if(sl.isRegistered<GetUserDataUseCase>()) return;
    sl.registerLazySingleton(
          () => GetUserDataUseCase(sl()),
    );
    sl.registerLazySingleton(
          () => UpdateUserDataUseCase(sl()),
    );


  }
}