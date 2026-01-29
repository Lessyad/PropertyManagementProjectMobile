import 'package:dartz/dartz.dart';
import 'package:enmaa/features/add_new_real_estate/data/data_source/add_new_real_estate_remote_data_source.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/building_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/land_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/villa_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/domain/repository/base_add_new_real_estate_repository.dart';
import 'package:enmaa/features/book_property/data/data_source/book_property_remote_data_source.dart';
import 'package:enmaa/features/book_property/domain/entities/book_property_response_entity.dart';
import 'package:enmaa/features/book_property/domain/entities/property_sale_details_entity.dart';
import 'package:enmaa/features/book_property/domain/repository/base_book_property_repository.dart';

import '../../../../core/entites/amenity_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/handle_api_request_service.dart';
import '../models/book_property_request_model.dart';

class BookPropertyRepository extends BaseBookPropertyRepository {
  final BaseBookPropertyRemoteDataSource baseBookPropertyRemoteDataSource;

  BookPropertyRepository({required this.baseBookPropertyRemoteDataSource});

  @override
  Future<Either<Failure, PropertySaleDetailsEntity>> getPropertySaleDetails(String propertyID) async{
    return await HandleRequestService.handleApiCall<PropertySaleDetailsEntity>(() async {
      return await baseBookPropertyRemoteDataSource.getPropertySaleDetails(propertyID);
    });
  }

  @override
  Future<Either<Failure, BookPropertyResponseEntity>> bookProperty(BookPropertyRequestModel data) async{
    return await HandleRequestService.handleApiCall<BookPropertyResponseEntity>(() async {
      return await baseBookPropertyRemoteDataSource.bookProperty(data);
    });
  }
}
