import 'package:dartz/dartz.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/villa_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/domain/repository/base_add_new_real_estate_repository.dart';
import 'package:enmaa/features/book_property/domain/repository/base_book_property_repository.dart';
import '../../../../core/entites/amenity_entity.dart';
import '../../../../core/errors/failure.dart';
import '../entities/property_sale_details_entity.dart';

class GetPropertySaleDetailsUseCase {
  final BaseBookPropertyRepository _baseBookPropertyRepository ;

  GetPropertySaleDetailsUseCase(this._baseBookPropertyRepository);

  Future<Either<Failure, PropertySaleDetailsEntity>> call(String propertyID ) =>
      _baseBookPropertyRepository.getPropertySaleDetails(propertyID);
}