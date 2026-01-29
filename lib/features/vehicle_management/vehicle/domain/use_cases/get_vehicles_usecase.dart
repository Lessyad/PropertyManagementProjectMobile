import 'package:dartz/dartz.dart';
import 'package:enmaa/core/errors/failure.dart';

import '../../data/models/vehicle_filter_model.dart';
import '../entities/vehicle_entity.dart';
import '../repository/vehicle_repository.dart';


class GetVehiclesUseCase {
  final VehicleRepository repository;

  GetVehiclesUseCase(this.repository);

  Future<Either<Failure, List<VehicleEntity>>> call({
    int pageNumber = 1,
    int pageSize = 10,
    VehicleFilterModel? filter,
  }) {
    return repository.getVehicles(
      pageNumber: pageNumber,
      pageSize: pageSize,
      filter: filter,
    );
  }
}