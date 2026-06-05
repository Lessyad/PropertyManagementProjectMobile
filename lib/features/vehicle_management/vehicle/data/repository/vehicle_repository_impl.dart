import 'package:dartz/dartz.dart';
import 'package:enmaa/core/errors/failure.dart';

import '../../domain/entities/paged_vehicles.dart';
import '../../domain/entities/vehicle_details_entity.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/repository/vehicle_repository.dart';
import '../data_source/vehicle_local_data_source.dart';
import '../data_source/vehicle_remote_data_source.dart';
import '../models/api_response.dart';
import '../models/vehicle_details_model.dart';
import '../models/vehicle_filter_model.dart';
import '../models/vehicle_model.dart';

class VehicleRepositoryImpl implements VehicleRepository {
  final BaseVehicleRemoteDataSource remoteDataSource;
  final BaseVehicleLocalDataSource localDataSource;

  VehicleRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, PagedVehicles>> getVehicles({
    int pageNumber = 1,
    int pageSize = 10,
    VehicleFilterModel? filter,
  }) async {
    try {
      final ApiResponse<VehicleModel> response = await remoteDataSource.getVehicles(
        pageNumber: pageNumber,
        pageSize: pageSize,
        filter: filter,
      );

      final List<VehicleEntity> entities = response.items
          .map((model) => model.toEntity())
          .toList();

      await localDataSource.cacheVehicles(response.items);

      return Right(PagedVehicles(
        items: entities,
        totalCount: response.totalCount,
        totalPages: response.totalPages,
        pageIndex: response.pageIndex,
        pageSize: response.pageSize,
        hasNextPage: response.hasNextPage,
        hasPreviousPage: response.hasPreviousPage,
      ));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, VehicleDetailsEntity>> getVehicleDetails(int id) async {
    try {
      final VehicleDetailsModel model = await remoteDataSource.getVehicleDetails(id);

      // Utiliser la méthode toDetailsEntity() du modèle pour une meilleure cohérence
      final VehicleDetailsEntity entity = model.toDetailsEntity();

      return Right(entity);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}