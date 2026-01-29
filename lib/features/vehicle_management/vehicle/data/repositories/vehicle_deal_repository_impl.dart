import '../datasources/vehicle_deal_remote_datasource.dart';
import '../../domain/repositories/vehicle_deal_repository.dart';
import '../models/vehicle_deal_request.dart';

class VehicleDealRepositoryImpl implements VehicleDealRepository {
  final VehicleDealRemoteDataSource remoteDataSource;

  VehicleDealRepositoryImpl({required this.remoteDataSource});

  @override
  Future<Map<String, dynamic>> createVehicleDeal({
    required VehicleDealRequest request,
    required int userId,
    required bool isClientUser,
  }) async {
    return await remoteDataSource.createVehicleDeal(
      request: request,
      userId: userId,
      isClientUser: isClientUser,
    );
  }
}
