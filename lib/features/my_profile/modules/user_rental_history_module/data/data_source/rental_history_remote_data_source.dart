import '../../../../../../core/constants/api_constants.dart';
import '../../../../../../core/services/dio_service.dart';
import '../models/rental_history_model.dart';

abstract class BaseRentalHistoryRemoteDataSource {
  Future<List<RentalHistoryModel>> getRentalHistory(Map<String, dynamic> data);
  Future<void> cancelRental(int rentalId);
}

class RentalHistoryRemoteDataSource extends BaseRentalHistoryRemoteDataSource {
  final DioService dioService;

  RentalHistoryRemoteDataSource({required this.dioService});

  @override
  Future<List<RentalHistoryModel>> getRentalHistory(
    Map<String, dynamic> data,
  ) async {
    final response = await dioService.get(
      url: ApiConstants.vehicleRentals,
      queryParameters: data,
    );

    final List<dynamic> items = response.data['items'] ?? [];
    return items.map((item) => RentalHistoryModel.fromVehicleJson(item)).toList();
  }

  @override
  Future<void> cancelRental(int rentalId) async {
    await dioService.patch(
      url: ApiConstants.cancelVehicleRental(rentalId),
    );
  }
}
