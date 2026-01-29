import 'package:dartz/dartz.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/villa_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/domain/repository/base_add_new_real_estate_repository.dart';
import 'package:enmaa/features/preview_property/data/models/add_new_preview_time_request_model.dart';
import 'package:enmaa/features/preview_property/domain/entities/day_and_hours_entity.dart';
import 'package:enmaa/features/preview_property/domain/repository/base_preview_property_repository.dart';
import '../../../../core/entites/amenity_entity.dart';
import '../../../../core/errors/failure.dart';

class AddNewPreviewTimeUseCase {
  final BasePreviewPropertyRepository _basePreviewPropertyRepository ;

  AddNewPreviewTimeUseCase(this._basePreviewPropertyRepository);

  Future<Either<Failure, void>> call(AddNewPreviewRequestModel data ) =>
      _basePreviewPropertyRepository.addPreviewTimeForSpecificProperty( data);
}