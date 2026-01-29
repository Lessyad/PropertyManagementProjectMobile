import 'dart:async';
import 'package:dio/dio.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/services/dio_service.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/building_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/land_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/villa_request_model.dart';
import 'package:enmaa/features/book_property/data/models/property_sale_details_model.dart';
import 'package:enmaa/features/book_property/domain/entities/book_property_response_entity.dart';


import '../../../../../core/constants/api_constants.dart';
import '../../../../core/entites/amenity_entity.dart';
import '../models/book_property_request_model.dart';
import '../models/book_property_response_model.dart';


abstract class BaseBookPropertyRemoteDataSource {


  Future<PropertySaleDetailsModel> getPropertySaleDetails(String propertyId);
  Future<BookPropertyResponseModel> bookProperty(BookPropertyRequestModel data);

}

class BookPropertyRemoteDataSource extends BaseBookPropertyRemoteDataSource {
  DioService dioService;

  BookPropertyRemoteDataSource({required this.dioService});





  @override
  Future<PropertySaleDetailsModel> getPropertySaleDetails(String propertyId) async{

    final response = await dioService.get(
      url: '${ApiConstants.propertyOrderDetails}/$propertyId/' ,
    );


    return PropertySaleDetailsModel.fromJson(response.data) ;



  }

  @override
  Future<BookPropertyResponseModel> bookProperty(BookPropertyRequestModel data) async {


    final formData = await data.toFormData();
    final response = await dioService.post(
      url: '${ApiConstants.deals}create',
      data: formData,
      options: Options(contentType: 'multipart/form-data',receiveTimeout: const Duration(minutes: 5), // Augmenté temporairement
        sendTimeout: const Duration(minutes: 5),),
    );

    return BookPropertyResponseModel.fromJson(response.data);
  }




}
