import 'package:enmaa/features/my_profile/modules/contact_us_module/data/data_source/contact_us_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/data/repository/contact_us_repository.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/domain/repository/base_contact_us_repository.dart';
import 'package:enmaa/features/my_profile/modules/contact_us_module/domain/use_cases/send_contact_us_use_case.dart';
import '../../../../core/services/service_locator.dart';

class ContactUsDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {

    _registerRemoteDataSource();
    _registerRepositories();
    _registerUseCases();



  }


  void _registerRemoteDataSource() {
    if(sl.isRegistered<BaseContactUsRemoteData>()) return;
    sl.registerLazySingleton<BaseContactUsRemoteData>(
          () => ContactUsRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if(sl.isRegistered<BaseContactUsRepository>()) return;
    sl.registerLazySingleton<BaseContactUsRepository>(
          () => ContactUsRepository(baseContactUsRemoteData: sl()),
    );
  }

  void _registerUseCases() {
    if(sl.isRegistered<SendContactUsUseCase>()) return;
    sl.registerLazySingleton(
          () => SendContactUsUseCase(sl()),
    );



  }
}