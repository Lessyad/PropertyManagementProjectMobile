import 'package:dartz/dartz.dart';
import 'package:enmaa/core/utils/enums.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../real_estates/domain/entities/base_property_entity.dart';
import '../repository/base_user_properties_repository.dart';

class DeletePropertyUseCase {
  final BaseUserPropertiesRepository _baseUserPropertiesRepository;

  DeletePropertyUseCase(this._baseUserPropertiesRepository);

  Future<Either<Failure, void>> call(String propertyId, PropertyType propertyType) async {
    return await _baseUserPropertiesRepository.deleteProperty(propertyId, propertyType);
  }
}