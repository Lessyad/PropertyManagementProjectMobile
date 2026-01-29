import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repository/base_vehicle_wish_list_repository.dart';

class CheckVehicleInWishListUseCase {
  final BaseVehicleWishListRepository repository;

  CheckVehicleInWishListUseCase(this.repository);

  Future<Either<Failure, bool>> call(int vehicleId) =>
      repository.checkVehicleInWishList(vehicleId);
}