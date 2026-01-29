import 'package:dartz/dartz.dart';
import '../../../../core/errors/failure.dart';
import '../repository/base_vehicle_wish_list_repository.dart';

class AddVehicleToWishListUseCase {
  final BaseVehicleWishListRepository repository;

  AddVehicleToWishListUseCase(this.repository);

  Future<Either<Failure, bool>> call(int vehicleId) =>
      repository.addVehicleToWishList(vehicleId);
}