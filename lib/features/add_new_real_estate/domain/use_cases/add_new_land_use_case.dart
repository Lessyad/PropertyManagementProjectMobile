import 'package:dartz/dartz.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/land_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/villa_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/domain/repository/base_add_new_real_estate_repository.dart';
import '../../../../core/errors/failure.dart';

class AddNewLandUseCase {
  final BaseAddNewRealEstateRepository _baseAddNewRealEstateRepository ;

  AddNewLandUseCase(this._baseAddNewRealEstateRepository);

  Future<Either<Failure, void>> call(LandRequestModel land) =>
      _baseAddNewRealEstateRepository.addNewLand(land);
}