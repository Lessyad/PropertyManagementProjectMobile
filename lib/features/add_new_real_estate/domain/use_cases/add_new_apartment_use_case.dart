import 'package:dartz/dartz.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/domain/repository/base_add_new_real_estate_repository.dart';
import '../../../../core/errors/failure.dart';

class AddNewApartmentUseCase {
  final BaseAddNewRealEstateRepository _baseAddNewRealEstateRepository ;

  AddNewApartmentUseCase(this._baseAddNewRealEstateRepository);

  Future<Either<Failure, void>> call(ApartmentRequestModel apartment) =>
      _baseAddNewRealEstateRepository.addNewApartment(apartment);
}