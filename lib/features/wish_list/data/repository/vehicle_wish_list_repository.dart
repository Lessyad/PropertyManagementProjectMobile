import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/handle_api_request_service.dart';
import '../../domain/entities/vehicle_wish_list_entity.dart';
import '../../domain/repository/base_vehicle_wish_list_repository.dart';
import '../data_source/vehicle_wish_list_remote_data_source.dart';


class VehicleWishListRepository extends BaseVehicleWishListRepository {
  final BaseVehicleWishListDataSource dataSource;

  VehicleWishListRepository({required this.dataSource});

  @override
  Future<Either<Failure, List<VehicleWishListEntity>>> getVehiclesWishList() async {
    return await HandleRequestService.handleApiCall<List<VehicleWishListEntity>>(() async {
      final models = await dataSource.getVehiclesWishList();
      return models.map((model) => model.toEntity()).toList();
    });
  }

  @override
  Future<Either<Failure, bool>> addVehicleToWishList(int vehicleId) async {
    return await HandleRequestService.handleApiCall<bool>(() async {
      return await dataSource.addVehicleToWishList(vehicleId);
    });
  }

  @override
  Future<Either<Failure, bool>> removeVehicleFromWishList(int vehicleId) async {
    return await HandleRequestService.handleApiCall<bool>(() async {
      return await dataSource.removeVehicleFromWishList(vehicleId);
    });
  }

  @override
  Future<Either<Failure, bool>> checkVehicleInWishList(int vehicleId) async {
    return await HandleRequestService.handleApiCall<bool>(() async {
      return await dataSource.checkVehicleInWishList(vehicleId);
    });
  }
}