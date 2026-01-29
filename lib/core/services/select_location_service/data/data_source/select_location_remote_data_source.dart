import 'dart:async';
import 'package:enmaa/core/constants/api_constants.dart';
import 'package:enmaa/core/services/dio_service.dart';
import 'package:enmaa/core/services/select_location_service/data/models/city_model.dart';
import 'package:enmaa/core/services/select_location_service/data/models/country_model.dart';
import 'package:enmaa/core/services/select_location_service/data/models/state_model.dart';

abstract class BaseSelectLocationRemoteDataSource {
  Future<List<CountryModel>> getCountries();
  Future<List<StateModel>> getStates(String countryId);
  Future<List<CityModel>> getCities(String stateId);
}

class SelectLocationRemoteDataSource extends BaseSelectLocationRemoteDataSource {
  final DioService dioService;

  SelectLocationRemoteDataSource({required this.dioService});

  @override
  Future<List<CountryModel>> getCountries() async {
    final response = await dioService.get(url: ApiConstants.countries);
    final List<dynamic> results = response.data['results'] ?? [];
    print('Status codee: ${response.statusCode}');
    print('Full response data: ${response.data}');
    List<CountryModel> countries =  results.map((json) {
      return CountryModel.fromJson(json);
    }).toList();

   return countries;
  }

  @override
  Future<List<StateModel>> getStates(String countryId) async {
    final response = await dioService.get(
      url: ApiConstants.states,
      queryParameters: {'countryId': countryId},  // ✅ Correction: countryId au lieu de country
    );
    
    // ✅ Le backend retourne directement un tableau quand countryId est fourni
    final List<dynamic> results = response.data is List 
        ? response.data 
        : (response.data['results'] ?? []);
    
    List<StateModel> states = results.map((json) {
      return StateModel.fromJson(json);
    }).toList();
    return states;
  }

  @override
  Future<List<CityModel>> getCities(String stateId) async {
    final response = await dioService.get(
      url: ApiConstants.cities,
      queryParameters: {'stateId': stateId},  // ✅ Correction: stateId au lieu de state
    );
    
    // ✅ Le backend retourne directement un tableau quand stateId est fourni
    final List<dynamic> results = response.data is List 
        ? response.data 
        : (response.data['results'] ?? []);
    
    List<CityModel> cities = results.map((json) {
      return CityModel.fromJson(json);
    }).toList();
    return cities;
  }
}
