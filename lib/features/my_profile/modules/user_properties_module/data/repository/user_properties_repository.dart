import 'package:dartz/dartz.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/data/data_source/user_properties_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/user_properties_module/domain/repository/base_user_properties_repository.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/services/handle_api_request_service.dart';


class UserPropertiesRepository extends BaseUserPropertiesRepository {
  final BaseUserPropertiesRemoteData baseUserPropertiesRemoteData;

  UserPropertiesRepository({required this.baseUserPropertiesRemoteData});



  @override
  Future<Either<Failure, List<PropertyEntity>>> getMyProperties({Map<String, dynamic>? filters}) async{
    return HandleRequestService.handleApiCall<List<PropertyEntity>>(() async {
      final result = await baseUserPropertiesRemoteData.getUserProperties(filters: filters);
      return result;
    });
  }

  @override
  Future<Either<Failure, void>> deleteProperty(String propertyID, PropertyType propertyType) {
    return HandleRequestService.handleApiCall<void>(() async {
      await baseUserPropertiesRemoteData.deleteProperty(propertyID, propertyType);
    });
  }


}