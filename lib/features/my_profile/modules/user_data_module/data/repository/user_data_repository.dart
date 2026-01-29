import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/data/data_source/user_data_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/entity/user_data_entity.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/repository/base_user_data_repository.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/services/handle_api_request_service.dart';

class UserDataRepository extends BaseUserDataRepository {
  final BaseUserDataRemoteDataSource baseUserDataRemoteDataSource;

  UserDataRepository({required this.baseUserDataRemoteDataSource});

  @override
  Future<Either<Failure, UserDataEntity>> getUserData() {
    return HandleRequestService.handleApiCall<UserDataEntity>(() async {
      final result = await baseUserDataRemoteDataSource.getUserData();
      return result;
    });
  }

  @override
  Future<Either<Failure, void>> updateUserData(Map<String, dynamic> updatedData) {
   return HandleRequestService.handleApiCall<void>(() async {
      final result = await baseUserDataRemoteDataSource.updateUserData(updatedData);
      return result;
    });
  }
}
