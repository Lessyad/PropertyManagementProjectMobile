
import 'package:dartz/dartz.dart';
import 'package:enmaa/features/authentication_module/data/data_source/local_data/authentication_local_data_source.dart';
import 'package:enmaa/features/authentication_module/data/data_source/remote_data/authentication_remote_data_source.dart';
import 'package:enmaa/features/authentication_module/data/models/reset_password_request_model.dart';
import 'package:enmaa/features/authentication_module/data/models/update_fcm_token_request_model.dart';
import 'package:enmaa/features/authentication_module/domain/entities/login_request_entity.dart';
import 'package:enmaa/features/authentication_module/domain/repository/base_authentication_repository.dart';

import '../../../../core/errors/failure.dart';
import '../../../../core/services/handle_api_request_service.dart';
import '../../domain/entities/sign_up_request_entity.dart';
import '../models/login_request_model.dart';
import '../models/otp_response_model.dart';
import '../models/sign_up_request_model.dart';



class AuthenticationRepository extends BaseAuthenticationRepository {
  final BaseAuthenticationRemoteDataSource baseAuthenticationRemoteDataSource;
  final BaseAuthenticationLocalDataSource baseAuthenticationLocalDataSource;

  AuthenticationRepository({ required this.baseAuthenticationRemoteDataSource , required this.baseAuthenticationLocalDataSource});


  @override
  Future<Either<Failure, bool>> loginUsingLocalAuthentication() async{
    return await HandleRequestService.handleLocalCall<bool>(() async {
      final result = await baseAuthenticationLocalDataSource.loginUsingLocalAuthentication();
      return result;
    });
  }

  @override
  Future<Either<Failure, String>> remoteLogin(LoginRequestModel loginBody) async{
    return await HandleRequestService.handleApiCall<String>(() async {
      final result = await baseAuthenticationRemoteDataSource.remoteLogin(loginBody);
      return result;
    });
  }

  @override
  Future<Either<Failure, OTPResponseModel>> sendOtp(String phoneNumber)async {
    return await HandleRequestService.handleApiCall<OTPResponseModel>(() async {
      final result = await baseAuthenticationRemoteDataSource.sendOtp(phoneNumber);
      return result;
    });
  }

  @override
  Future<Either<Failure, bool>> verifyOtp(String otp , String phoneNumber)async {
    return await HandleRequestService.handleApiCall<bool>(() async {
      final result = await baseAuthenticationRemoteDataSource.verifyOtp(otp , phoneNumber);
      return result;
    });
  }

  @override
  Future<Either<Failure, String>> signUp(SignUpRequestModel signUpBody) async{
    return await HandleRequestService.handleApiCall<String>(() async {
      final result = await baseAuthenticationRemoteDataSource.signUp(signUpBody);
      return result;
    });
  }

  @override
  Future<Either<Failure, void>> resetPassword(ResetPasswordRequestModel resetPasswordBody) {
    return HandleRequestService.handleApiCall<void>(() async {
      final result = await baseAuthenticationRemoteDataSource.resetPassword(resetPasswordBody);
      return result;
    });
  }

  @override
  Future<Either<Failure, void>> updateFcmToken(UpdateFcmTokenRequestModel request) {
    return HandleRequestService.handleApiCall<void>(() async {
      final result = await baseAuthenticationRemoteDataSource.updateFcmToken(request);
      return result;
    });
  }



}