import 'package:dartz/dartz.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/domain/entity/user_electronic_contract_entity.dart';
import 'package:enmaa/features/my_profile/modules/user_electronic_contracts_module/domain/repository/base_user_electronic_contracts_repository.dart';
import '../../../../../../core/errors/failure.dart';

class GetUserElectronicContractsUseCase {
  final BaseUserElectronicContractsRepository _baseUserElectronicContractsRepository;

  GetUserElectronicContractsUseCase(this._baseUserElectronicContractsRepository);

  Future<Either<Failure, List<UserElectronicContractEntity>>> call(Map<String , dynamic > data) async {
    return await _baseUserElectronicContractsRepository.getUserElectronicContracts(data);
  }
}