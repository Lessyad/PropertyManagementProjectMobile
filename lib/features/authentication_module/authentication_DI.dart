import 'package:enmaa/features/authentication_module/data/data_source/local_data/authentication_local_data_source.dart';
import 'package:enmaa/features/authentication_module/domain/repository/base_authentication_repository.dart';
import 'package:enmaa/features/authentication_module/domain/use_cases/remote_login_use_case.dart';
import 'package:enmaa/features/authentication_module/domain/use_cases/send_otp_use_case.dart';
import 'package:enmaa/features/authentication_module/domain/use_cases/sign_up_use_case.dart';
import 'package:enmaa/features/authentication_module/domain/use_cases/update_fcm_token_use_case.dart';
import 'package:enmaa/features/authentication_module/domain/use_cases/verify_otp_use_case.dart';
import 'package:enmaa/features/authentication_module/presentation/controller/biometric_bloc.dart';
import 'package:enmaa/features/authentication_module/presentation/controller/remote_authentication_bloc/remote_authentication_cubit.dart';
import '../../core/services/bio_metric_service.dart';
import '../../core/services/service_locator.dart';
import 'data/data_source/remote_data/authentication_remote_data_source.dart';
import 'data/repository/authentication_repository.dart';
import 'domain/use_cases/login_using_local_authentication.dart';
import 'domain/use_cases/reset_password_use_case.dart';

class AuthenticationDi {
  final sl = ServiceLocator.getIt;

  Future<void> setup() async {

    _registerDataSources();
    _registerRepositories();
    _registerUseCases();
    _registerBlocs();


  }


  void _registerDataSources() {

    /// todo :separate the data sources to local and remote
    sl.registerLazySingleton<BaseAuthenticationLocalDataSource>(
          () => AuthenticationLocalDataSource(),
    );

    sl.registerLazySingleton<BaseAuthenticationRemoteDataSource>(
          () => AuthenticationRemoteDataSource(dioService: sl()),
    );
  }

  void _registerRepositories() {
    sl.registerLazySingleton<BaseAuthenticationRepository>(
          () => AuthenticationRepository(baseAuthenticationRemoteDataSource: sl(), baseAuthenticationLocalDataSource: sl()),
    );
  }

  void _registerUseCases() {
    sl.registerLazySingleton(
          () => LoginUsingLocalAuthentication (sl()),
    );

    sl.registerLazySingleton(
          () => RemoteLoginUseCase (sl()),
    );
    sl.registerLazySingleton(
          () => SendOtpUseCase(sl()),
    );
    sl.registerLazySingleton(
          () => VerifyOtpUseCase(sl()),
    );
    sl.registerLazySingleton(
          () => SignUpUseCase(sl()),
    );
    sl.registerLazySingleton(
          () => ResetPasswordUseCase(sl()),
    );
    sl.registerLazySingleton(
          () => UpdateFcmTokenUseCase(sl()),
    );
  }
  void _registerBlocs() {

    sl.registerLazySingleton<BiometricService>(
          () => BiometricService(

      ),
    );

    sl.registerLazySingleton<BiometricBloc>(
          () => BiometricBloc(
        sl<LoginUsingLocalAuthentication>(),
        sl<BiometricService>(),
      ),
    );

    sl.registerLazySingleton<RemoteAuthenticationCubit>(
          () => RemoteAuthenticationCubit(
        sl<RemoteLoginUseCase>(),
        sl<SendOtpUseCase>(),
        sl<VerifyOtpUseCase>(),
        sl<SignUpUseCase>(),
        sl<ResetPasswordUseCase>(),
      ),
    );

  }
}