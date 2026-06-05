import 'package:dio/dio.dart';
import 'package:enmaa/features/real_estates/data/models/apartment_model.dart';
import 'package:enmaa/features/real_estates/data/models/paged_property_response.dart';
import 'package:enmaa/features/real_estates/data/models/property_details_model.dart';
import 'package:enmaa/features/real_estates/data/models/property_model.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/dio_service.dart';
import '../../../domain/entities/property_details_entity.dart';

abstract class BaseRealEstateRemoteData {
  Future<PagedPropertyResponse> getProperties({Map<String, dynamic>? filters});
  Future<BasePropertyDetailsEntity> getPropertyDetails(String propertyId);
}

class RealEstateRemoteDataSource extends BaseRealEstateRemoteData {
  DioService dioService;

  RealEstateRemoteDataSource({required this.dioService});

  @override
  Future<PagedPropertyResponse> getProperties({Map<String, dynamic>? filters}) async {
    print('Filtres envoyés: $filters');
    final response = await dioService.get(
      url: ApiConstants.properties,
      queryParameters: filters,
    );
    print('Status code: ${response.statusCode}');

    final int totalCount = response.data['count'] as int? ?? 0;
    final List<dynamic> jsonResponse = response.data['results'] ?? [];
    print('JSON results count: ${jsonResponse.length}, total: $totalCount');

    final List<PropertyEntity> properties = jsonResponse.map((jsonItem) {
      try {
        return PropertyModel.fromJson(jsonItem);
      } catch (e, stack) {
        print('Erreur de parsing pour un item: $e');
        print(stack);
        rethrow;
      }
    }).toList();

    print('Nombre de propriétés parsées: ${properties.length}');
    return PagedPropertyResponse(items: properties, totalCount: totalCount);
  }

  @override
  Future<BasePropertyDetailsEntity> getPropertyDetails(String propertyId) async{
    final response = await dioService.get(
      url: '${ApiConstants.properties}$propertyId',
    );
    // print('Réponse backend: ${response.data}');
    return PropertyDetailsModel.fromJson(response.data);
  }

}