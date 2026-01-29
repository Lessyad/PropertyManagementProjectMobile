import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../entities/vehicle_wish_list_entity.dart';
import '../repository/base_vehicle_wish_list_repository.dart';

class GetVehiclesWishListUseCase {
  final BaseVehicleWishListRepository repository;

  GetVehiclesWishListUseCase(this.repository);

  Future<Either<Failure, List<VehicleWishListEntity>>> call() =>
      repository.getVehiclesWishList();
}