import 'package:dartz/dartz.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/city_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/country_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/state_entity.dart';

import '../../../../errors/failure.dart';

abstract class BaseSelectLocationRepository {

  Future<Either<Failure, List<CountryEntity>>> getCountries();
  Future<Either<Failure, List<StateEntity>>> getStates(String countryId);
  Future<Either<Failure, List<CityEntity>>> getCities(String stateId);


}