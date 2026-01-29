
import 'package:dartz/dartz.dart';
import 'package:enmaa/core/errors/failure.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/city_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/country_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/entities/state_entity.dart';
import 'package:enmaa/core/services/select_location_service/domain/repository/base_select_location_repository.dart';

import '../../../handle_api_request_service.dart';
import '../data_source/select_location_remote_data_source.dart';




class SelectLocationRepository extends BaseSelectLocationRepository {
  final BaseSelectLocationRemoteDataSource baseSelectLocationRemoteDataSource;

  SelectLocationRepository({ required this.baseSelectLocationRemoteDataSource });



  @override
  Future<Either<Failure, List<CityEntity>>> getCities(String stateId) async{
    return await HandleRequestService.handleApiCall<List<CityEntity>>(() async {
      final result = await baseSelectLocationRemoteDataSource.getCities(stateId);
      return result;
    });
  }

  @override
  Future<Either<Failure, List<CountryEntity>>> getCountries() async{
    return await HandleRequestService.handleApiCall<List<CountryEntity>>(() async {
      final result = await baseSelectLocationRemoteDataSource.getCountries();
      return result;
    });
  }

  @override
  Future<Either<Failure, List<StateEntity>>> getStates(String countryId)async {
    return await HandleRequestService.handleApiCall<List<StateEntity>>(() async {
      final result = await baseSelectLocationRemoteDataSource.getStates(countryId);
      return result;
    });
  }




}