import 'dart:async';
import 'package:dio/dio.dart';
import 'package:enmaa/core/models/amenity_model.dart';
import 'package:enmaa/core/services/dio_service.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/apartment_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/building_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/land_request_model.dart';
import 'package:enmaa/features/add_new_real_estate/data/models/villa_request_model.dart';
import 'package:enmaa/features/real_estates/data/models/apartment_details_model.dart';
import 'package:enmaa/features/real_estates/data/models/building_drtails_model.dart';
import 'package:enmaa/features/real_estates/data/models/land_details_model.dart';
import 'package:enmaa/features/real_estates/data/models/villa_details_model.dart';
import '../../../../../core/constants/api_constants.dart';
import '../../../../core/constants/json_keys.dart';
import '../../../../core/entites/amenity_entity.dart';
import '../models/property_request_model.dart';

abstract class BaseAddNewRealEstateDataSource {
  Future<void> addApartment(ApartmentRequestModel apartment);
  Future<void> addVilla(VillaRequestModel villa);
  Future<void> addBuilding(BuildingRequestModel building);
  Future<void> addLand(LandRequestModel land);

  // Nouvelles méthodes pour l'upload direct d'images (avec URLs)
  Future<void> addApartmentWithImageUrls(Map<String, dynamic> apartmentData);
  Future<void> addVillaWithImageUrls(Map<String, dynamic> villaData);
  Future<void> addBuildingWithImageUrls(Map<String, dynamic> buildingData);
  Future<void> addLandWithImageUrls(Map<String, dynamic> landData);

  Future<void> updateApartment(String apartmentId, Map<String, dynamic> updatedFields);
  Future<void> updateVilla(String villaId, Map<String, dynamic> updatedFields);
  Future<void> updateBuilding(String buildingId, Map<String, dynamic> updatedFields);
  Future<void> updateLand(String landId, Map<String, dynamic> updatedFields);

  Future<List<AmenityModel>> getPropertyAmenities(String propertyType);
}

class AddNewRealEstateRemoteDataSource extends BaseAddNewRealEstateDataSource {
  final DioService dioService;

    AddNewRealEstateRemoteDataSource({required this.dioService});

  @override
  Future<void> addApartment(ApartmentRequestModel apartment) async {

    final formData = await apartment.toJson();
       // final formData = await apartment.toFormData();
    await dioService.post(
      url: ApiConstants.apartment,
      data: formData,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  double _parseArea(String area) {
    final value = double.tryParse(area.replaceAll(',', '.')) ?? 1.0;
    return value.clamp(1.0, double.maxFinite);
  }
  @override
  Future<void> addVilla(VillaRequestModel villa) async {
    // final formData = await villa.toFormData();
    final formData = await villa.toJson();
    await dioService.post(
      url: ApiConstants.villa,
      data: formData,
      // options: Options(contentType: 'multipart/form-data')
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  @override
  Future<void> addBuilding(BuildingRequestModel building) async {
    // final formData = await building.toFormData();
    final formData = await building.toJson();
    await dioService.post(
      url: ApiConstants.building,
      data: formData,
      // options: Options(contentType: 'multipart/form-data'),
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  @override
  Future<void> addLand(LandRequestModel land) async {
    // final formData = await land.toFormData();
        final formData = await land.toJson();
    await dioService.post(
      url: ApiConstants.land,
      data: formData,
      // options: Options(contentType: 'multipart/form-data'),
      options: Options(contentType: Headers.jsonContentType),
    );

  }

  // === NOUVELLES MÉTHODES POUR UPLOAD DIRECT D'IMAGES ===
  
  @override
  Future<void> addApartmentWithImageUrls(Map<String, dynamic> apartmentData) async {
    await dioService.post(
      url: ApiConstants.apartment,
      data: apartmentData,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  @override
  Future<void> addVillaWithImageUrls(Map<String, dynamic> villaData) async {
    await dioService.post(
      url: ApiConstants.villa,
      data: villaData,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  @override
  Future<void> addBuildingWithImageUrls(Map<String, dynamic> buildingData) async {
    await dioService.post(
      url: ApiConstants.building,
      data: buildingData,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  @override
  Future<void> addLandWithImageUrls(Map<String, dynamic> landData) async {
    await dioService.post(
      url: ApiConstants.land,
      data: landData,
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  @override
  Future<void> updateApartment(String apartmentId, Map<String, dynamic> updatedFields) async {
    final formData = await _prepareFormData(updatedFields);
    final response = await dioService.patch(
      url: '${ApiConstants.apartment}$apartmentId/',
      data: formData,
      // options: Options(contentType: 'multipart/form-data'),SSS
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  @override
  Future<void> updateVilla(String villaId, Map<String, dynamic> updatedFields) async {
    final formData = await _prepareFormData(updatedFields);
    final response = await dioService.patch(
      url: '${ApiConstants.villa}$villaId/',
      data: formData,
      // options: Options(contentType: 'multipart/form-data'),
      options: Options(contentType: Headers.jsonContentType),
    );
  }

  @override
  Future<void> updateBuilding(String buildingId, Map<String, dynamic> updatedFields) async {
    final formData = await _prepareFormData(updatedFields);
    final response = await dioService.patch(
      url: '${ApiConstants.building}$buildingId/',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<void> updateLand(String landId, Map<String, dynamic> updatedFields) async {
    final formData = await _prepareFormData(updatedFields);
    final response = await dioService.patch(
      url: '${ApiConstants.land}$landId/',
      data: formData,
      options: Options(contentType: 'multipart/form-data'),
    );
  }

  @override
  Future<List<AmenityModel>> getPropertyAmenities(String propertyType) async {
    final response = await dioService.get(
      url: ApiConstants.amenities,
      queryParameters: {
        'property_type_ids': propertyType,
      },
    );
    final List<dynamic> data = response.data['results'];
    return data.map((json) => AmenityModel.fromJson(json)).toList();
  }

  Future<FormData> _prepareFormData(Map<String, dynamic> updatedFields) async {
    final formData = FormData();

    for (var entry in updatedFields.entries) {
      if (entry.key == 'images' && entry.value is List) {
        final images = entry.value as List<PropertyImage>;

        for (int i = 0; i < images.length; i++) {
          final image = images[i];
          final filePath = image.filePath;

          final multipartFile = await MultipartFile.fromFile(
            filePath,
            filename: filePath.split('/').last,
          );
          formData.files.add(MapEntry('images', multipartFile));

          formData.fields.add(
            MapEntry(
              'images[$i].is_main',
              image.isMain?.toString() ?? 'false',
            ),
          );
        }
      } else if (entry.key == 'amenities' && entry.value is List) {
        final amenities = entry.value as List<dynamic>;

        for (var amenity in amenities) {
          formData.fields.add(MapEntry('amenities', amenity.toString()));
        }
      } else {
        formData.fields.add(MapEntry(entry.key, entry.value.toString()));
      }
    }

    return formData;
  }

}