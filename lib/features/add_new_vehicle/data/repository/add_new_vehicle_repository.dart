import '../../domain/repository/base_add_new_vehicle_repository.dart';
import '../data_source/add_new_vehicle_remote_data_source.dart';
import '../models/vehicle_request_models.dart';

class AddNewVehicleRepository implements BaseAddNewVehicleRepository {
  final BaseAddNewVehicleDataSource dataSource;
  AddNewVehicleRepository({required this.dataSource});

  @override
  Future<void> createVehicle(CreateVehicleRequestModel body) {
    return dataSource.createVehicle(body);
  }

  @override
  Future<void> updateVehicle(int id, UpdateVehicleRequestModel body) {
    return dataSource.updateVehicle(id, body);
  }

  @override
  Future<void> deleteVehicle(int id) {
    return dataSource.deleteVehicle(id);
  }
}

// import 'package:dartz/dartz.dart';
// import '../../../../core/errors/failure.dart';
// import '../../../../core/services/handle_api_request_service.dart';
// import '../../domain/repository/base_add_new_vehicle_repository.dart';
//
// class AddNewVehicleRepository extends BaseAddNewVehicleRepository {
//   final BaseAddNewVehicleDataSource dataSource;
//
//   AddNewVehicleRepository({required this.dataSource});
//
//   @override
//   Future<Either<Failure, void>> addNewVehicle(CreateVehicleRequestModel vehicle) async {
//     return await HandleRequestService.handleApiCall<void>(() async {
//       await dataSource.addVehicle(vehicle);
//     });
//   }
//
//   @override
//   Future<Either<Failure, void>> updateVehicle(int vehicleId, UpdateVehicleRequestModel vehicle) async {
//     return await HandleRequestService.handleApiCall<void>(() async {
//       await dataSource.updateVehicle(vehicleId, vehicle);
//     });
//   }
// }