import '../../data/models/vehicle_request_models.dart';

abstract class BaseAddNewVehicleRepository {
  Future<void> createVehicle(CreateVehicleRequestModel body);
  Future<void> updateVehicle(int id, UpdateVehicleRequestModel body);
  Future<void> deleteVehicle(int id);
}

// import 'package:dartz/dartz.dart';
// import '../../../../core/errors/failure.dart';
//
// abstract class BaseAddNewVehicleRepository {
//   Future<Either<Failure, void>> addNewVehicle(CreateVehicleRequestModel vehicle);
//   Future<Either<Failure, void>> updateVehicle(int vehicleId, UpdateVehicleRequestModel vehicle);
// }