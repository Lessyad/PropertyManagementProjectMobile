import 'package:dartz/dartz.dart';
 import 'package:enmaa/features/my_profile/modules/user_data_module/domain/repository/base_user_data_repository.dart';
import '../../../../../../core/errors/failure.dart';

class UpdateUserDataUseCase {
  final BaseUserDataRepository _baseUserDataRepository;

  UpdateUserDataUseCase(this._baseUserDataRepository);

  Future<Either<Failure, void>> call(Map<String , dynamic> updatedData) async {
    return await _baseUserDataRepository.updateUserData(updatedData);
  }
}