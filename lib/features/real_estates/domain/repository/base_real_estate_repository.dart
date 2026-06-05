import 'package:dartz/dartz.dart';
import 'package:enmaa/features/real_estates/data/models/paged_property_response.dart';
import 'package:enmaa/features/real_estates/domain/entities/property_details_entity.dart';

import '../../../../core/errors/failure.dart';


abstract class BaseRealEstateRepository {
  Future<Either<Failure, PagedPropertyResponse>> getProperties({
    Map<String, dynamic>? filters,
  });

  Future<Either<Failure, BasePropertyDetailsEntity>> getPropertyDetails(String propertyId);
}