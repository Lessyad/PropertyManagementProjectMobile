import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/policy_entity.dart';

abstract class BasePoliciesRepository {
  Future<Either<Failure, List<PolicyEntity>>> getPolicies();
}
