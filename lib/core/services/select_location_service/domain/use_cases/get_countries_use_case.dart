import 'package:dartz/dartz.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/country_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/repository/base_select_location_repository.dart';
import '../../../../errors/failure.dart';

class GetCountriesUseCase {
  final BaseSelectLocationRepository _baseSelectLocationRepository ;

  GetCountriesUseCase(this._baseSelectLocationRepository);

  Future<Either<Failure, List<CountryEntity>>> call() =>
      _baseSelectLocationRepository.getCountries();
}