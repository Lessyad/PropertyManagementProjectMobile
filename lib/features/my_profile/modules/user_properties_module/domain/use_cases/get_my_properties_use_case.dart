import 'package:dartz/dartz.dart';
import '../../../../../../core/errors/failure.dart';
import '../../../../../real_estates/domain/entities/base_property_entity.dart';
 import '../repository/base_user_properties_repository.dart';

class GetUserPropertiesUseCase {
  final BaseUserPropertiesRepository _baseUserPropertiesRepository;

  GetUserPropertiesUseCase(this._baseUserPropertiesRepository);

  Future<Either<Failure, List<PropertyEntity>>> call({
    Map<String, dynamic>? filters,
  }) async {
    return await _baseUserPropertiesRepository.getMyProperties(filters: filters);
  }
}