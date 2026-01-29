import 'package:dartz/dartz.dart';
import 'package:enmaa/core/errors/failure.dart';

import '../entities/vehicle_details_entity.dart';
import '../repository/vehicle_repository.dart';


class GetVehicleDetailsUseCase {
  final VehicleRepository repository;

  GetVehicleDetailsUseCase(this.repository);

  Future<Either<Failure, VehicleDetailsEntity>> call(int id) {
    return repository.getVehicleDetails(id);
  }
}