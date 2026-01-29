import 'package:dartz/dartz.dart';
import 'package:enmaa/features/real_estates/domain/entities/property_details_entity.dart';
import 'package:enmaa/features/add_new_real_estate/domain/repository/base_add_new_real_estate_repository.dart';
import '../../../../core/errors/failure.dart';

class UpdateBuildingUseCase {
  final BaseAddNewRealEstateRepository _baseAddNewRealEstateRepository;

  UpdateBuildingUseCase(this._baseAddNewRealEstateRepository);

  Future<Either<Failure, void>> call({
    required String buildingId,
    required Map<String, dynamic> updatedFields,
  }) async {
    return await _baseAddNewRealEstateRepository.updateBuilding(
      buildingId: buildingId,
      updatedFields: updatedFields,
    );
  }
}