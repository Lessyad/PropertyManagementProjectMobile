import 'package:enmaa/features/my_profile/modules/user_appointments/data/data_source/user_appointments_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/data/repository/user_appointments_repository.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/domain/repository/base_user_appointments_repository.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/domain/use_cases/cancel_appointment_use_case.dart';
import 'package:enmaa/features/my_profile/modules/user_appointments/domain/use_cases/get_user_appointments_use_case.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/data/data_source/user_properties_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/data/repository/user_properties_repository.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/domain/repository/base_user_properties_repository.dart';
import '../../../../core/services/service_locator.dart';
import 'domain/use_cases/update_appointment_use_case.dart';

class UserAppointmentsDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {

    _registerRemoteDataSource();
    _registerRepositories();
    _registerUseCases();



  }


  void _registerRemoteDataSource() {
    if(sl.isRegistered<BaseUserAppointmentsRemoteData>()) return;
    sl.registerLazySingleton<BaseUserAppointmentsRemoteData>(
          () => UserAppointmentsRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    if(sl.isRegistered<BaseUserAppointmentsRepository>()) return;
    sl.registerLazySingleton<BaseUserAppointmentsRepository>(
          () => UserAppointmentsRepository(baseUserAppointmentsRemoteData: sl()),
    );
  }

  void _registerUseCases() {
    if(sl.isRegistered<GetUserAppointmentsUseCase>()) return;
    sl.registerLazySingleton(
          () => GetUserAppointmentsUseCase(sl()),
    );
    sl.registerLazySingleton(
          () => CancelAppointmentUseCase(sl()),
    );
    sl.registerLazySingleton(
          () => UpdateAppointmentUseCase(sl()),
    );


  }
}