import 'package:dartz/dartz.dart';
import 'package:enmaa/features/real_estates/domain/entities/property_details_entity.dart';
import 'package:enmaa/features/add_new_real_estate/domain/repository/base_add_new_real_estate_repository.dart';
import '../../../../core/errors/failure.dart';

class UpdateApartmentUseCase {
  final BaseAddNewRealEstateRepository _baseAddNewRealEstateRepository;

  UpdateApartmentUseCase(this._baseAddNewRealEstateRepository);

  Future<Either<Failure, void>> call({
    required String apartmentId,
    required Map<String, dynamic> updatedFields,
  }) async {
    return await _baseAddNewRealEstateRepository.updateApartment(
      apartmentId: apartmentId,
      updatedFields: updatedFields,
    );
  }
}