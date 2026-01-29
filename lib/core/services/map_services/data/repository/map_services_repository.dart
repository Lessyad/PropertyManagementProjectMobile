import 'package:dartz/dartz.dart';
import 'package:enmaa/core/errors/failure.dart';
import 'package:enmaa/core/services/map_services/data/data_source/map_services_remote_data_source.dart';
import 'package:enmaa/core/services/map_services/domain/entities/location_entity.dart';
import 'package:enmaa/core/services/map_services/domain/repository/base_map_services_repository.dart';

import '../../../handle_api_request_service.dart';

class MapServicesRepository extends BaseMapServicesRepository {
  final BaseMapServicesRemoteDataSource baseMapServicesRemoteDataSource;

  MapServicesRepository({required this.baseMapServicesRemoteDataSource});


  @override
  Future<Either<Failure, List<LocationEntity>>> getSuggestedLocation(String location)async {
    return await HandleRequestService.handleApiCall<List<LocationEntity>>(() async {
      final result = await baseMapServicesRemoteDataSource.getSuggestedLocations(location);
      return result;
    });
  }
}