import '../../data/models/vehicle_deal_request.dart';

abstract class VehicleDealRepository {
  Future<Map<String, dynamic>> createVehicleDeal({
    required VehicleDealRequest request,
    required int userId,
    required bool isClientUser,
  });
}
