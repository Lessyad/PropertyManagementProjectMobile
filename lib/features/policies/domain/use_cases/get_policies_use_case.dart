import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/policy_entity.dart';
import '../repository/base_policies_repository.dart';

class GetPoliciesUseCase {
  final BasePoliciesRepository _repository;

  GetPoliciesUseCase(this._repository);

  Future<Either<Failure, List<PolicyEntity>>> call() =>
      _repository.getPolicies();
}
