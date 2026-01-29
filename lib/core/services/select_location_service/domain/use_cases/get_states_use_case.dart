import 'package:dartz/dartz.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/state_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/repository/base_select_location_repository.dart';
import '../../../../errors/failure.dart';

class GetStatesUseCase {
  final BaseSelectLocationRepository _baseSelectLocationRepository ;

  GetStatesUseCase(this._baseSelectLocationRepository);

  Future<Either<Failure, List<StateEntity>>> call(String countryId) =>
      _baseSelectLocationRepository.getStates(countryId);
}