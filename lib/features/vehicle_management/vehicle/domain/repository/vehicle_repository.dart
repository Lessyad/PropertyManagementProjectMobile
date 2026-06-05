import 'package:dartz/dartz.dart';
import 'package:enmaa/core/errors/failure.dart';

import '../../data/models/vehicle_filter_model.dart';
import '../entities/vehicle_details_entity.dart';
import '../entities/paged_vehicles.dart';


abstract class VehicleRepository {
  Future<Either<Failure, PagedVehicles>> getVehicles({
    int pageNumber = 1,
    int pageSize = 10,
    VehicleFilterModel? filter,
  });

  Future<Either<Failure, VehicleDetailsEntity>> getVehicleDetails(int id);
}