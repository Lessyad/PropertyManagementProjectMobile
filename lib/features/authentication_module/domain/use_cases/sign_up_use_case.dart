import 'package:dartz/dartz.dart';
import 'package:enmaa/features/authentication_module/domain/repository/base_authentication_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/sign_up_request_model.dart';

class SignUpUseCase {
  final BaseAuthenticationRepository _baseAuthenticationRepository ;

  SignUpUseCase(this._baseAuthenticationRepository);

  Future<Either<Failure, String>> call(SignUpRequestModel signUpBody) =>
      _baseAuthenticationRepository.signUp(signUpBody);
}