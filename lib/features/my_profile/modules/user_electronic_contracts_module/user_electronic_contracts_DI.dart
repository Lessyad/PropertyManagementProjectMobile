import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/data/data_source/user_electronic_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/data/repository/user_electronic_contracts_repository.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/domain/repository/base_user_electronic_contracts_repository.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/domain/use_cases/get_user_electronic_contracts_use_case.dart';
import '../../../../core/services/service_locator.dart';

class UserElectronicContractsDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {

    _registerRemoteDataSource();
    _registerRepositories();
    _registerUseCases();



  }


  void _registerRemoteDataSource() {
    if(sl.isRegistered<BaseUserElectronicContractsDataSource>()) return;
    sl.registerLazySingleton<BaseUserElectronicContractsDataSource>(
          () => UserElectronicRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if(sl.isRegistered<BaseUserElectronicContractsRepository>()) return;
    sl.registerLazySingleton<BaseUserElectronicContractsRepository>(
          () => UserElectronicContractsRepository(baseUserElectronicContractsDataSource: sl()),
    );
  }

  void _registerUseCases() {
    if(sl.isRegistered<GetUserElectronicContractsUseCase>()) return;
    sl.registerLazySingleton(
          () => GetUserElectronicContractsUseCase(sl()),
    );



  }
}