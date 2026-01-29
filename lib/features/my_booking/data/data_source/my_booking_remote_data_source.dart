import 'package:enmaa/features/real_estates/data/models/property_model.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/dio_service.dart';

abstract class BaseMyBookingRemoteData {
  Future<List<PropertyEntity>> getMyBookings({Map<String, dynamic>? filters});
}

class MyBookingRemoteDataSource extends BaseMyBookingRemoteData {
  DioService dioService;

  MyBookingRemoteDataSource({required this.dioService});


  @override
  Future<List<PropertyEntity>> getMyBookings({Map<String, dynamic>? filters}) async {
    final response = await dioService.get(
      url: ApiConstants.properties,
      queryParameters: filters,
    );

    List<dynamic> jsonResponse = response.data['results'] ?? [];

    List<PropertyEntity> properties = jsonResponse.map((jsonItem) {
      return PropertyModel.fromJson(jsonItem);
    }).toList();

    print('lengggg ${properties.length}');
    return properties;
  }



}