  import 'dart:io';

import 'package:dio/dio.dart';
  import 'package:enmaa/core/services/dio_service.dart';
  import '../../../../../core/constants/api_constants.dart';
  import '../models/create_vehicle_deal_dto.dart';

  abstract class BaseVehicleDealRemoteDataSource {
    Future<Map<String, dynamic>> createVehicleDeal(CreateVehicleDealDto dto);
  }

  class VehicleDealRemoteDataSource extends BaseVehicleDealRemoteDataSource {
    final DioService dioService;

    VehicleDealRemoteDataSource({required this.dioService});

    @override
    Future<Map<String, dynamic>> createVehicleDeal(CreateVehicleDealDto dto) async {
      try {
        print('Creating vehicle deal with data: ${dto.toJson()}');

        // Créer FormData
        final formData = FormData();

        // Ajouter tous les champs texte
        final formFields = dto.toFormData();
        formFields.forEach((key, value) {
          formData.fields.add(MapEntry(key, value));
        });

        // Ajouter le fichier image
        final imageFile = File(dto.idCardImage);
        if (await imageFile.exists()) {
          formData.files.add(MapEntry(
            'IdCardImage',
            await MultipartFile.fromFile(
              dto.idCardImage,
              filename: 'id_card_${DateTime.now().millisecondsSinceEpoch}.jpg',
            ),
          ),
          );
          formData.files.add(MapEntry(
            'DrivingLicenseImage', // ← Nom du champ attendu par le backend
            await MultipartFile.fromFile(
              dto.driveLicenseImage, // ← Chemin du fichier permis
              filename: 'driving_license.jpg',
            ),
          ));
        } else {
          throw Exception('ID image file does not exist: ${dto.idCardImage}');
        }

        // Ajouter PassCode si fourni
        if (dto.passCode != null && dto.passCode!.isNotEmpty) {
          formData.fields.add(MapEntry('PassCode', dto.passCode!));
        }

        print('Sending request to: ${ApiConstants.VehicleDeals}');

        final response = await dioService.post(
          url: ApiConstants.VehicleDeals,
          data: formData,
          options: Options(
            contentType: 'multipart/form-data',
            headers: {'Accept': 'application/json'},
          ),
        );

        print('Response received: ${response.statusCode}');
        print('Response data: ${response.data}');

        if (response.statusCode == 200 || response.statusCode == 201) {
          return response.data;
        } else {
          throw Exception('Error creating deal: ${response.statusCode} - ${response.statusMessage}');
        }
      } on DioException catch (e) {
        print('DioError: ${e.message}');
        if (e.response != null) {
          print('Response data: ${e.response?.data}');
          print('Response headers: ${e.response?.headers}');
          throw Exception('API Error: ${e.response?.statusCode} - ${e.response?.statusMessage}');
        } else {
          throw Exception('Connection Error: ${e.message}');
        }
      } catch (e) {
        print('Unexpected error: $e');
        throw Exception('Unexpected error: $e');
      }
    }
  }
