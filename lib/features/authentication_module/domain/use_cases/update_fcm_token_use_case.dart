import 'package:dartz/dartz.dart';
import 'package:enmaa/features/authentication_module/domain/repository/base_authentication_repository.dart';
import '../../../../core/errors/failure.dart';
import '../../data/models/update_fcm_token_request_model.dart';

class UpdateFcmTokenUseCase {
  final BaseAuthenticationRepository _baseAuthenticationRepository;

  UpdateFcmTokenUseCase(this._baseAuthenticationRepository);

  Future<Either<Failure, void>> call(UpdateFcmTokenRequestModel request) =>
      _baseAuthenticationRepository.updateFcmToken(request);
}




