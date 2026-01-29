import 'package:dartz/dartz.dart';
import 'package:enmaa/features/real_estates/domain/entities/property_details_entity.dart';
import 'package:enmaa/features/real_estates/domain/repository/base_real_estate_repository.dart';
import '../../../../core/errors/failure.dart';

class GetPropertyDetailsUseCase {
  final BaseRealEstateRepository _baseRealEstateRepository;

  GetPropertyDetailsUseCase(this._baseRealEstateRepository);

  Future<Either<Failure, BasePropertyDetailsEntity>> call(String propertyId ) =>
      _baseRealEstateRepository.getPropertyDetails(propertyId);
}