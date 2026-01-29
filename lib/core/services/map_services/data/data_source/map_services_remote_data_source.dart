import 'dart:async';
import 'package:dio/dio.dart';
import 'package:enmaa/core/constants/api_constants.dart';
import 'package:enmaa/core/services/dio_service.dart';
import 'package:enmaa/core/services/map_services/data/models/location_model.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';

abstract class BaseMapServicesRemoteDataSource {
  Future<List<LocationModel>> getSuggestedLocations(String query);
}

class MapServicesRemoteDataSource extends BaseMapServicesRemoteDataSource {
  final DioService dioService;

  MapServicesRemoteDataSource({required this.dioService});

  @override
  Future<List<LocationModel>> getSuggestedLocations(String query) async {
    final response = await dioService.get(
      url: 'https://nominatim.openstreetmap.org/search',
      queryParameters: {
        'format': 'json',
        'q': query,
        'limit': 20,
        'addressdetails': 1,
      },
      options: Options(
        headers: {
          'User-Agent': '${SharedPreferencesService().userName} (${SharedPreferencesService().userPhone})',
        },
      ),
    );

    final List<dynamic> results = response.data ?? [];

    return results.map((json) {
      return LocationModel.fromJson(json);
    }).toList();
  }
}
