import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/vehicle_wish_list_entity.dart';

abstract class BaseVehicleWishListRepository {
  Future<Either<Failure, List<VehicleWishListEntity>>> getVehiclesWishList();
  Future<Either<Failure, bool>> addVehicleToWishList(int vehicleId);
  Future<Either<Failure, bool>> removeVehicleFromWishList(int vehicleId);
  Future<Either<Failure, bool>> checkVehicleInWishList(int vehicleId);
}