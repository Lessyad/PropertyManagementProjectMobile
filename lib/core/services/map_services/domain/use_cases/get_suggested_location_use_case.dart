import 'package:dartz/dartz.dart';
import 'package:enmaa/core/services/map_services/domain/entities/location_entity.dart';

import '../../../../errors/failure.dart';
import '../repository/base_map_services_repository.dart';

class GetSuggestedLocationUseCase {
  final BaseMapServicesRepository _baseMapServicesRepository;

  GetSuggestedLocationUseCase(this._baseMapServicesRepository);

  Future<Either<Failure, List<LocationEntity>>> call(String query) async {
    return _baseMapServicesRepository.getSuggestedLocation(query);
  }
}
