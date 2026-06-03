import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../core/services/dio_service.dart';
import '../models/rental_history_model.dart';

abstract class BaseRentalHistoryRemoteDataSource {
  Future<List<RentalHistoryModel>> getRentalHistory(Map<String, dynamic> data);
}

class RentalHistoryRemoteDataSource extends BaseRentalHistoryRemoteDataSource {
  final DioService dioService;

  RentalHistoryRemoteDataSource({required this.dioService});

  @override
  Future<List<RentalHistoryModel>> getRentalHistory(
    Map<String, dynamic> data,
  ) async {
    final response = await dioService.get(
      url: ApiConstants.rentalHistory,
      queryParameters: data,
    );

    final List<dynamic> results = response.data['results'] ?? [];
    return results.map((item) => RentalHistoryModel.fromJson(item)).toList();
  }
}
