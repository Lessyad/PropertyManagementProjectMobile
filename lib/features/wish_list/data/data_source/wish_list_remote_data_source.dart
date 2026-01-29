import 'dart:async';
import 'package:dio/dio.dart';
import 'package:enmaa/core/services/dio_service.dart';


import '../../../../../core/constants/api_constants.dart';
 import '../models/property_wish_list_model.dart';


abstract class BaseWishListDataSource {



  Future<List<PropertyWishListModel>> getPropertiesWishList( );
  Future<void> removePropertyFromWishList(String propertyId );
  Future<PropertyWishListModel> addPropertyToWishList(String propertyId );

}

class WishListRemoteDataSource extends BaseWishListDataSource {
  DioService dioService;

  WishListRemoteDataSource({required this.dioService});

  @override
  Future<List<PropertyWishListModel>> getPropertiesWishList() async {
    final Response response = await dioService.get(
      url: ApiConstants.wishList,
    );

    final propertyWishList = response.data;

    List<PropertyWishListModel> data = [] ;

    for (var item in propertyWishList) {
      data.add(PropertyWishListModel.fromJson(item));
    }

    return data ;
  }

  @override
  Future<void> removePropertyFromWishList(String propertyId) async{
      await dioService.delete(
      url: '${ApiConstants.wishList}remove/',
      queryParameters: {
        'type': 'property',
        'object_id': propertyId,
      },
    );

  }

  @override
  Future<PropertyWishListModel> addPropertyToWishList(String propertyId) async {
    final Response response = await dioService.post(
      url: ApiConstants.wishList,
      // data: FormData.fromMap({
      //   'type': 'property',
      //   'object_id': propertyId,
      // }),

      data : ({
            'type': 'property',
            'object_id': propertyId,
          }),
    );

    return PropertyWishListModel.fromJson(response.data);
  }




}
