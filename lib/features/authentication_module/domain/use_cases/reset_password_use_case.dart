import 'package:dartz/dartz.dart';
import 'package:enmaa/features/authentication_module/data/models/reset_password_request_model.dart';
import 'package:enmaa/features/authentication_module/domain/entities/login_request_entity.dart';
import 'package:enmaa/features/authentication_module/domain/repository/base_authentication_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/login_request_model.dart';

class ResetPasswordUseCase {
  final BaseAuthenticationRepository _baseAuthenticationRepository ;

  ResetPasswordUseCase(this._baseAuthenticationRepository);

  Future<Either<Failure, void>> call(ResetPasswordRequestModel resetPasswordBody) =>
      _baseAuthenticationRepository.resetPassword(resetPasswordBody);
}