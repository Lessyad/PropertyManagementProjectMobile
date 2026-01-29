import 'package:dartz/dartz.dart';
import 'package:enmaa/features/real_estates/domain/entities/property_details_entity.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';

import '../../../../core/errors/failure.dart';


abstract class BaseRealEstateRepository {
  Future<Either<Failure, List<PropertyEntity>>> getProperties({
    Map<String, dynamic>? filters,
  });  Future<Either<Failure, BasePropertyDetailsEntity>> getPropertyDetails(String propertyId);
}