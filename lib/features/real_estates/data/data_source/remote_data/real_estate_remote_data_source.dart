import 'package:dio/dio.dart';
import 'package:enmaa/features/real_estates/data/models/apartment_model.dart';
import 'package:enmaa/features/real_estates/data/models/property_details_model.dart';
import 'package:enmaa/features/real_estates/data/models/property_model.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/dio_service.dart';
import '../../../domain/entities/property_details_entity.dart';

abstract class BaseRealEstateRemoteData {
  Future<List<PropertyEntity>> getProperties({Map<String, dynamic>? filters});
  Future<BasePropertyDetailsEntity> getPropertyDetails(String propertyId);
}

class RealEstateRemoteDataSource extends BaseRealEstateRemoteData {
  DioService dioService;

  RealEstateRemoteDataSource({required this.dioService});


  @override
   Future<List<PropertyEntity>> getProperties({Map<String, dynamic>? filters}) async {
    print('Filtres envoyés: $filters');
    final response = await dioService.get( 
      url: ApiConstants.properties,
      queryParameters: filters,
      // options: Options(contentType: 'multipart/form-data'),
    );
      print('Status code: ${response.statusCode}');
      print('Réponse brute: ${response.data}');

    List<dynamic> jsonResponse = response.data['results'] ?? [];
      print('JSON results: $jsonResponse');
    List<PropertyEntity> properties = jsonResponse.map((jsonItem) {
      try {
      return PropertyModel.fromJson(jsonItem);
    } catch (e, stack) {
      print('Erreur de parsing pour un item: $e');
      print('Item problématique: $jsonItem');
      print(stack);
      rethrow;
    }
    }).toList();

     print('Nombre de propriétés parsées: ${properties.length}');
    return properties;
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