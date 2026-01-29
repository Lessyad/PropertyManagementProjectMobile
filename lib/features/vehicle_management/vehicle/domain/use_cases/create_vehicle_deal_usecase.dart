import '../../data/models/create_vehicle_deal_dto.dart';
import '../../data/repository/vehicle_deal_repository_impl.dart';

class CreateVehicleDealUseCase {
  final VehicleDealRepository _repository;

  CreateVehicleDealUseCase({VehicleDealRepository? repository})
      : _repository = repository ?? VehicleDealRepositoryImpl();

  Future<Map<String, dynamic>> execute(CreateVehicleDealDto dto) async {
    try {
      return await _repository.createVehicleDeal(dto);
    } catch (e) {
      throw Exception('Erreur lors de l\'exécution du use case: $e');
    }
  }
}
