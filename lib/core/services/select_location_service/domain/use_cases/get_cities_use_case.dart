import 'package:dartz/dartz.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/city_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/repository/base_select_location_repository.dart';
import '../../../../errors/failure.dart';

class GetCitiesUseCase {
  final BaseSelectLocationRepository _baseSelectLocationRepository ;

  GetCitiesUseCase(this._baseSelectLocationRepository);

  Future<Either<Failure, List<CityEntity>>> call(String stateId) =>
      _baseSelectLocationRepository.getCities(stateId);
}