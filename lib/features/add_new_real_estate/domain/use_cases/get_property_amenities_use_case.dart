import 'package:dartz/dartz.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/villa_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/domain/repository/base_add_new_real_estate_repository.dart';
import '../../../../core/entites/amenity_entity.dart';
import '../../../../core/errors/failure.dart';

class GetPropertyAmenitiesUseCase {
  final BaseAddNewRealEstateRepository _baseAddNewRealEstateRepository ;

  GetPropertyAmenitiesUseCase(this._baseAddNewRealEstateRepository);

  Future<Either<Failure, List<AmenityEntity>>> call(String propertyType ) =>
      _baseAddNewRealEstateRepository.getPropertyAmenities(propertyType);
}