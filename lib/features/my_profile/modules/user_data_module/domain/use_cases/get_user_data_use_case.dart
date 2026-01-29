import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/entity/user_data_entity.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/repository/base_user_data_repository.dart';
import '../../../../../../core/errors/failure.dart';

class GetUserDataUseCase {
  final BaseUserDataRepository _baseUserDataRepository;

  GetUserDataUseCase(this._baseUserDataRepository);

  Future<Either<Failure, UserDataEntity>> call() async {
    return await _baseUserDataRepository.getUserData();
  }
}