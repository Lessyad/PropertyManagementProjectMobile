import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/data/data_source/user_data_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/entity/user_data_entity.dart';
import 'package:enmaa/features/my_profile/modules/user_data_module/domain/repository/base_user_data_repository.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/data/data_source/user_electronic_remote_data_source.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/domain/entity/user_electronic_contract_entity.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/domain/repository/base_user_electronic_contracts_repository.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../../core/services/handle_api_request_service.dart';

class UserElectronicContractsRepository extends BaseUserElectronicContractsRepository {
  final BaseUserElectronicContractsDataSource baseUserElectronicContractsDataSource;

  UserElectronicContractsRepository({required this.baseUserElectronicContractsDataSource});



  @override
  Future<Either<Failure, List<UserElectronicContractEntity>>> getUserElectronicContracts(Map<String, dynamic> data) {
    return HandleRequestService.handleApiCall<List<UserElectronicContractEntity>>(() async {
      final result = await baseUserElectronicContractsDataSource.getUserElectronicContracts(data);
      return result;
    });
  }
}
