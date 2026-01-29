import 'package:dartz/dartz.dart';
import 'package:enmaa/core/services/map_services/domain/entities/location_entity.dart';

import '../../../../errors/failure.dart';

abstract class BaseMapServicesRepository {

  Future<Either<Failure, List<LocationEntity>>> getSuggestedLocation(String location);

}