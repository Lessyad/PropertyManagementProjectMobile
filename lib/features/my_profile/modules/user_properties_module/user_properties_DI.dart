import 'package:enmaa/features/my_profile/modules/user_properties_module/data/data_source/user_properties_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/data/repository/user_properties_repository.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/domain/repository/base_user_properties_repository.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/domain/use_cases/delete_property_use_case.dart';
import '../../../../core/services/service_locator.dart';
import 'domain/use_cases/get_my_properties_use_case.dart';

class UserPropertiesDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {

    _registerRemoteDataSource();
    _registerRepositories();
    _registerUseCases();



  }


  void _registerRemoteDataSource() {
    if(sl.isRegistered<BaseUserPropertiesRemoteData>()) return;
    sl.registerLazySingleton<BaseUserPropertiesRemoteData>(
          () => UserPropertiesRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if(sl.isRegistered<BaseUserPropertiesRepository>()) return;
    sl.registerLazySingleton<BaseUserPropertiesRepository>(
          () => UserPropertiesRepository(baseUserPropertiesRemoteData: sl()),
    );
  }

  void _registerUseCases() {
    if(sl.isRegistered<GetUserPropertiesUseCase>()) return;
    sl.registerLazySingleton(
          () => GetUserPropertiesUseCase(sl()),
    );
    sl.registerLazySingleton(
          () => DeletePropertyUseCase(sl()),
    );


  }
}