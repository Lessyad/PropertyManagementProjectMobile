import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/entity/user_data_entity.dart';
import '../../../../../../core/errors/failure.dart';


abstract class BaseUserDataRepository {
  Future<Either<Failure,UserDataEntity>> getUserData();
  Future<Either<Failure,void>> updateUserData(Map<String,dynamic> updatedData);

}