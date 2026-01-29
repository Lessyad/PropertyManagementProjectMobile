import 'package:dartz/dartz.dart';
import 'package:enmaa/features/home_module/domain/entities/banner_entity.dart';
import '../../../../core/errors/failure.dart';
import '../repository/base_home_repository.dart';

class UpdateUserLocationUseCase {
  final BaseHomeRepository _baseHomeRepository;

  UpdateUserLocationUseCase(this._baseHomeRepository);

  Future<Either<Failure, void>> call( String cityID) =>
      _baseHomeRepository.updateUserLocation(cityID);
}