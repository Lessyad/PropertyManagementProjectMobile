import 'package:dartz/dartz.dart';
import 'package:enmaa/core/entites/amenity_entity.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/building_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/land_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/villa_request_model.dart';
import 'package:enmaa/features/book_property/data/models/book_property_request_model.dart';
import 'package:enmaa/features/book_property/domain/entities/book_property_response_entity.dart';
import 'package:enmaa/features/book_property/domain/entities/property_sale_details_entity.dart';

import '../../../../core/errors/failure.dart';

abstract class BaseBookPropertyRepository {

  Future<Either<Failure, PropertySaleDetailsEntity>> getPropertySaleDetails(String propertyID);
  Future<Either<Failure, BookPropertyResponseEntity>> bookProperty(BookPropertyRequestModel data);


}