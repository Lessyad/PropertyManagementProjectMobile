import 'package:dartz/dartz.dart';
import 'package:enmaa/features/authentication_module/domain/entities/login_request_entity.dart';
import 'package:enmaa/features/authentication_module/domain/repository/base_authentication_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/login_request_model.dart';

class RemoteLoginUseCase {
  final BaseAuthenticationRepository _baseAuthenticationRepository ;

  RemoteLoginUseCase(this._baseAuthenticationRepository);

  Future<Either<Failure, String>> call(LoginRequestModel loginBody) =>
      _baseAuthenticationRepository.remoteLogin(loginBody);
}