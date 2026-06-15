import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_service.dart';
import '../models/policy_model.dart';

abstract class BasePoliciesDataSource {
  Future<List<PolicyModel>> getPolicies();
}

class PoliciesRemoteDataSource extends BasePoliciesDataSource {
  final DioService dioService;

  PoliciesRemoteDataSource({required this.dioService});

  @override
  Future<List<PolicyModel>> getPolicies() async {
    final response = await dioService.get(
      url: '${ApiConstants.policies}?pageSize=100',
    );
    final results = response.data['results'] as List<dynamic>;
    return results
        .map((json) => PolicyModel.fromJson(json as Map<String, dynamic>))
        .toList();
  }
}
