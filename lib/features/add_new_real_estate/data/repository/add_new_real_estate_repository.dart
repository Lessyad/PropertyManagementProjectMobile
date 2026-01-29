import 'package:dartz/dartz.dart';
import 'package:enmaa/features/add_new_real_estate/data/data_source/add_new_real_estate_remote_data_source.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/building_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/land_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/villa_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/domain/repository/base_add_new_real_estate_repository.dart';
import 'package:enmaa/features/real_estates/domain/entities/property_details_entity.dart';

import '../../../../core/entites/amenity_entity.dart';
import '../../../../core/errors/failure.dart';
import '../../../../core/services/handle_api_request_service.dart';

class AddNewRealEstateRepository extends BaseAddNewRealEstateRepository {
  final BaseAddNewRealEstateDataSource baseAddNewRealEstateDataSource;

  AddNewRealEstateRepository({required this.baseAddNewRealEstateDataSource});

  @override
  Future<Either<Failure, void>> addNewApartment(ApartmentRequestModel apartment) async {
    return await HandleRequestService.handleApiCall<void>(() async {
      await baseAddNewRealEstateDataSource.addApartment(apartment);
    });
  }

  @override
  Future<Either<Failure, void>> addNewVilla(VillaRequestModel villa) async {
    return await HandleRequestService.handleApiCall<void>(() async {
      await baseAddNewRealEstateDataSource.addVilla(villa);
    });
  }

  @override
  Future<Either<Failure, void>> addNewBuilding(BuildingRequestModel building) async {
    return await HandleRequestService.handleApiCall<void>(() async {
      await baseAddNewRealEstateDataSource.addBuilding(building);
    });
  }

  @override
  Future<Either<Failure, void>> addNewLand(LandRequestModel land) async {
    return await HandleRequestService.handleApiCall<void>(() async {
      await baseAddNewRealEstateDataSource.addLand(land);
    });
  }

  @override
  Future<Either<Failure, List<AmenityEntity>>> getPropertyAmenities(String propertyType) async {
    return await HandleRequestService.handleApiCall<List<AmenityEntity>>(() async {
      return await baseAddNewRealEstateDataSource.getPropertyAmenities(propertyType);
    });
  }

  @override
  Future<Either<Failure, void>> updateApartment({
    required String apartmentId,
    required Map<String, dynamic> updatedFields,
  }) async {
    return await HandleRequestService.handleApiCall<void>(() async {
      return await baseAddNewRealEstateDataSource.updateApartment(apartmentId, updatedFields);
    });
  }

  @override
  Future<Either<Failure, void>> updateVilla({
    required String villaId,
    required Map<String, dynamic> updatedFields,
  }) async {
    return await HandleRequestService.handleApiCall<void>(() async {
      return await baseAddNewRealEstateDataSource.updateVilla(villaId, updatedFields);
    });
  }

  @override
  Future<Either<Failure, void>> updateBuilding({
    required String buildingId,
    required Map<String, dynamic> updatedFields,
  }) async {
    return await HandleRequestService.handleApiCall<void>(() async {
      return await baseAddNewRealEstateDataSource.updateBuilding(buildingId, updatedFields);
    });
  }

  @override
  Future<Either<Failure, void>> updateLand({
    required String landId,
    required Map<String, dynamic> updatedFields,
  }) async {
    return await HandleRequestService.handleApiCall<void>(() async {
      return await baseAddNewRealEstateDataSource.updateLand(landId, updatedFields);
    });
  }
}