import 'package:dartz/dartz.dart';
import 'package:enmaa/features/authentication_module/domain/entities/login_request_entity.dart';
import 'package:enmaa/features/authentication_module/domain/repository/base_authentication_repository.dart';
import '../../../../core/errors/failure.dart';

class VerifyOtpUseCase {
  final BaseAuthenticationRepository _baseAuthenticationRepository ;

  VerifyOtpUseCase(this._baseAuthenticationRepository);

  Future<Either<Failure, bool>> call(String otp, String phoneNumber) =>
      _baseAuthenticationRepository.verifyOtp(otp , phoneNumber);
}