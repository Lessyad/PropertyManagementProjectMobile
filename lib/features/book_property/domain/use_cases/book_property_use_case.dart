import 'package:dartz/dartz.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/villa_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/domain/repository/base_add_new_real_estate_repository.dart';
import 'package:enmaa/features/book_property/data/models/book_property_request_model.dart';
import 'package:enmaa/features/book_property/domain/entities/book_property_response_entity.dart';
import 'package:enmaa/features/book_property/domain/repository/base_book_property_repository.dart';
import '../../../../core/entites/amenity_entity.dart';
import '../../../../core/errors/failure.dart';
import '../entities/property_sale_details_entity.dart';

class BookPropertyUseCase {
  final BaseBookPropertyRepository _baseBookPropertyRepository ;

  BookPropertyUseCase(this._baseBookPropertyRepository);

  Future<Either<Failure, BookPropertyResponseEntity>> call(BookPropertyRequestModel data ) =>
      _baseBookPropertyRepository.bookProperty(data);
}