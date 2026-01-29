import 'package:dartz/dartz.dart';
import 'package:enmaa/features/authentication_module/data/models/reset_password_request_model.dart';
import 'package:enmaa/features/authentication_module/data/models/update_fcm_token_request_model.dart';
import 'package:enmaa/features/authentication_module/domain/entities/login_request_entity.dart';
import 'package:enmaa/features/authentication_module/domain/entities/otp_response_entity.dart';
import 'package:enmaa/features/authentication_module/domain/entities/sign_up_request_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/login_request_model.dart';
import '../../data/models/sign_up_request_model.dart';


abstract class BaseAuthenticationRepository {
  // use biometric authentication to open app
  Future<Either<Failure, bool>> loginUsingLocalAuthentication();

  Future<Either<Failure, String>> remoteLogin(LoginRequestModel loginBody);
  Future<Either<Failure, String>> signUp(SignUpRequestModel signUpBody);

  Future<Either<Failure, OTPResponseEntity>> sendOtp(String phoneNumber);
  Future<Either<Failure, bool>> verifyOtp(String otp, String phoneNumber);


  Future<Either<Failure, void>> resetPassword(ResetPasswordRequestModel resetPasswordBody);
  Future<Either<Failure, void>> updateFcmToken(UpdateFcmTokenRequestModel request);
}