import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repository/base_vehicle_wish_list_repository.dart';

class RemoveVehicleFromWishListUseCase {
  final BaseVehicleWishListRepository repository;

  RemoveVehicleFromWishListUseCase(this.repository);

  Future<Either<Failure, void>> call(int vehicleId) =>
      repository.removeVehicleFromWishList(vehicleId);
}