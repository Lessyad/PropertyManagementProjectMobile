import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/domain/entity/user_electronic_contract_entity.dart';
import '../../../../../../core/errors/failure.dart';


abstract class BaseUserElectronicContractsRepository {
  Future<Either<Failure,List<UserElectronicContractEntity>>> getUserElectronicContracts(Map<String , dynamic > data);

}