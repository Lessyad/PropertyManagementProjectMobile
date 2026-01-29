import 'package:dartz/dartz.dart';

import '../../../../core/errors/failure.dart';
import '../entities/base_property_entity.dart';
import '../repository/base_real_estate_repository.dart';

class GetPropertiesUseCase {
  final BaseRealEstateRepository _baseRealEstateRepository;

  GetPropertiesUseCase(this._baseRealEstateRepository);

  Future<Either<Failure, List<PropertyEntity>>> call({
    Map<String, dynamic>? filters,
  }) async {
    return await _baseRealEstateRepository.getProperties(filters: filters);
  }
}