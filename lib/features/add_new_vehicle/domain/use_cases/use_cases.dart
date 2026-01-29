import '../repository/base_add_new_vehicle_repository.dart';
import '../../data/models/vehicle_request_models.dart';

class CreateVehicleUseCase {
  final BaseAddNewVehicleRepository repo;
  CreateVehicleUseCase(this.repo);
  Future<void> call(CreateVehicleRequestModel body) => repo.createVehicle(body);
}

class UpdateVehicleUseCase {
  final BaseAddNewVehicleRepository repo;
  UpdateVehicleUseCase(this.repo);
  Future<void> call(int id, UpdateVehicleRequestModel body) => repo.updateVehicle(id, body);
}

class DeleteVehicleUseCase {
  final BaseAddNewVehicleRepository repo;
  DeleteVehicleUseCase(this.repo);
  Future<void> call(int id) => repo.deleteVehicle(id);
}


