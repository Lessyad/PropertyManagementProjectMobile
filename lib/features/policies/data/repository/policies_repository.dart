import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/handle_api_request_service.dart';
import '../../domain/entities/policy_entity.dart';
import '../../domain/repository/base_policies_repository.dart';
import '../data_source/policies_remote_data_source.dart';

class PoliciesRepository extends BasePoliciesRepository {
  final BasePoliciesDataSource dataSource;

  PoliciesRepository({required this.dataSource});

  @override
  Future<Either<Failure, List<PolicyEntity>>> getPolicies() {
    return HandleRequestService.handleApiCall<List<PolicyEntity>>(() async {
      return await dataSource.getPolicies();
    });
  }
}
