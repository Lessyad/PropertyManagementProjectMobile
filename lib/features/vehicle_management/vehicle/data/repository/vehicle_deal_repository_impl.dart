import 'package:dio/dio.dart';
import '../models/create_vehicle_deal_dto.dart';
import '../data_source/vehicle_deal_remote_data_source.dart';
import '../../../../../core/services/dio_service.dart';

abstract class VehicleDealRepository {
  Future<Map<String, dynamic>> createVehicleDeal(CreateVehicleDealDto dto);
}

class VehicleDealRepositoryImpl implements VehicleDealRepository {
  final VehicleDealRemoteDataSource _remoteDataSource;
  
  VehicleDealRepositoryImpl({VehicleDealRemoteDataSource? remoteDataSource}) 
    : _remoteDataSource = remoteDataSource ?? VehicleDealRemoteDataSource(dioService: DioService(dio: Dio()));

  @override
  Future<Map<String, dynamic>> createVehicleDeal(CreateVehicleDealDto dto) async {
    try {
      // Utiliser la méthode avec FormData pour correspondre au backend [FromForm]
      return await _remoteDataSource.createVehicleDeal(dto);
    } catch (e) {
      throw Exception('Erreur lors de la création du deal: $e');
    }
  }
}
