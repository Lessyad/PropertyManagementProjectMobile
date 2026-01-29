import '../../data/models/vehicle_deal_request.dart';
import '../repositories/vehicle_deal_repository.dart';

class CreateVehicleDealUseCase {
  final VehicleDealRepository repository;

  CreateVehicleDealUseCase({required this.repository});

  Future<Map<String, dynamic>> call({
    required VehicleDealRequest request,
    required int userId,
    required bool isClientUser,
  }) async {
    return await repository.createVehicleDeal(
      request: request,
      userId: userId,
      isClientUser: isClientUser,
    );
  }
}
