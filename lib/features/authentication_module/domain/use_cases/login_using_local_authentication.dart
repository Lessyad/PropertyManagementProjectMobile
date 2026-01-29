import 'package:dartz/dartz.dart';
import 'package:enmaa/features/authentication_module/domain/repository/base_authentication_repository.dart';
import '../../../../core/errors/failure.dart';

class LoginUsingLocalAuthentication {
  final BaseAuthenticationRepository _baseAuthenticationRepository ;

  LoginUsingLocalAuthentication(this._baseAuthenticationRepository);

  Future<Either<Failure, bool>> call( ) =>
      _baseAuthenticationRepository.loginUsingLocalAuthentication();
}