import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/shared_preferences_service.dart';
import '../models/vehicle_deal_request.dart';

abstract class VehicleDealRemoteDataSource {
  Future<Map<String, dynamic>> createVehicleDeal({
    required VehicleDealRequest request,
    required int userId,
    required bool isClientUser,
  });
}

class VehicleDealRemoteDataSourceImpl implements VehicleDealRemoteDataSource {
  final http.Client client;

  VehicleDealRemoteDataSourceImpl({required this.client});

  @override
  Future<Map<String, dynamic>> createVehicleDeal({
    required VehicleDealRequest request,
    required int userId,
    required bool isClientUser,
  }) async {
    try {
      // Créer la requête multipart
      final uri = Uri.parse('${ApiConstants.baseUrl}Vehicles/deal/');
      final request_multipart = http.MultipartRequest('POST', uri);

      // Ajouter les paramètres de base
      request_multipart.fields['userId'] = userId.toString();
      request_multipart.fields['isClientUser'] = isClientUser.toString();
      request_multipart.fields['VehicleId'] = request.vehicleId.toString();
      request_multipart.fields['StartDate'] = request.startDate.toIso8601String();
      request_multipart.fields['EndDate'] = request.endDate.toIso8601String();

      // Ajouter les données du conducteur principal (format correct pour le backend)
      request_multipart.fields['MainDriver[DocumentType]'] = request.mainDriver.documentType;
      request_multipart.fields['MainDriver[FirstName]'] = request.mainDriver.firstName;
      request_multipart.fields['MainDriver[LastName]'] = request.mainDriver.lastName;
      request_multipart.fields['MainDriver[FamilyName]'] = request.mainDriver.familyName;
      request_multipart.fields['MainDriver[PhoneNumber]'] = request.mainDriver.phoneNumber;
      request_multipart.fields['MainDriver[IdNumber]'] = request.mainDriver.idNumber;
      request_multipart.fields['MainDriver[BirthDate]'] = request.mainDriver.birthDate.toIso8601String();
      request_multipart.fields['MainDriver[IdExpiryDate]'] = request.mainDriver.idExpiryDate.toIso8601String();
      request_multipart.fields['MainDriver[DrivingLicenseNumber]'] = request.mainDriver.drivingLicenseNumber;
      request_multipart.fields['MainDriver[DrivingLicenseIssueDate]'] = request.mainDriver.drivingLicenseIssueDate.toIso8601String();

      // Ajouter les images du conducteur principal
      if (request.mainDriver.idCardImage != null) {
        try {
          final file = request.mainDriver.idCardImage!;
          if (await file.exists()) {
            request_multipart.files.add(
              await http.MultipartFile.fromPath(
                'MainDriver[IdCardImage]',
                file.path,
              ),
            );
            print('✅ MainDriver.IdCardImage ajoutée: ${file.path}');
          } else {
            print('❌ MainDriver.IdCardImage n\'existe pas: ${file.path}');
          }
        } catch (e) {
          print('❌ Erreur avec MainDriver.IdCardImage: $e');
        }
      }

      if (request.mainDriver.drivingLicenseImage != null) {
        try {
          final file = request.mainDriver.drivingLicenseImage!;
          if (await file.exists()) {
            request_multipart.files.add(
              await http.MultipartFile.fromPath(
                'MainDriver[DrivingLicenseImage]',
                file.path,
              ),
            );
            print('✅ MainDriver.DrivingLicenseImage ajoutée: ${file.path}');
          } else {
            print('❌ MainDriver.DrivingLicenseImage n\'existe pas: ${file.path}');
          }
        } catch (e) {
          print('❌ Erreur avec MainDriver.DrivingLicenseImage: $e');
        }
      }

      // Ajouter les données du deuxième conducteur si activé
      request_multipart.fields['SecondDriverEnabled'] = request.secondDriverEnabled.toString();
      if (request.secondDriverEnabled && request.secondDriver != null) {
        request_multipart.fields['SecondDriver[DocumentType]'] = request.secondDriver!.documentType;
        request_multipart.fields['SecondDriver[FirstName]'] = request.secondDriver!.firstName;
        request_multipart.fields['SecondDriver[LastName]'] = request.secondDriver!.lastName;
        request_multipart.fields['SecondDriver[FamilyName]'] = request.secondDriver!.familyName;
        request_multipart.fields['SecondDriver[PhoneNumber]'] = request.secondDriver!.phoneNumber;
        request_multipart.fields['SecondDriver[IdNumber]'] = request.secondDriver!.idNumber;
        request_multipart.fields['SecondDriver[BirthDate]'] = request.secondDriver!.birthDate.toIso8601String();
        request_multipart.fields['SecondDriver[IdExpiryDate]'] = request.secondDriver!.idExpiryDate.toIso8601String();
        request_multipart.fields['SecondDriver[DrivingLicenseNumber]'] = request.secondDriver!.drivingLicenseNumber;
        request_multipart.fields['SecondDriver[DrivingLicenseIssueDate]'] = request.secondDriver!.drivingLicenseIssueDate.toIso8601String();

        // Ajouter les images du deuxième conducteur
        if (request.secondDriver!.idCardImage != null) {
          request_multipart.files.add(
            await http.MultipartFile.fromPath(
              'SecondDriver[IdCardImage]',
              request.secondDriver!.idCardImage!.path,
            ),
          );
        }

        if (request.secondDriver!.drivingLicenseImage != null) {
          request_multipart.files.add(
            await http.MultipartFile.fromPath(
              'SecondDriver[DrivingLicenseImage]',
              request.secondDriver!.drivingLicenseImage!.path,
            ),
          );
        }
      }

      // Ajouter les options de paiement et de location
      request_multipart.fields['PaymentMethod'] = request.paymentMethod;
      if (request.passcode != null) {
        request_multipart.fields['Passcode'] = request.passcode!;
      }
      if (request.bankilyPhoneNumber != null) {
        request_multipart.fields['BankilyPhoneNumber'] = request.bankilyPhoneNumber!;
      }
      request_multipart.fields['KilometerIllimitedPerDay'] = request.kilometerIllimitedPerDay.toString();
      request_multipart.fields['AllRiskCarInsurance'] = request.allRiskCarInsurance.toString();
      request_multipart.fields['AddChildsChair'] = request.addChildsChair.toString();
      request_multipart.fields['PickupAreaId'] = request.pickupAreaId.toString();
      request_multipart.fields['ReturnAreaId'] = request.returnAreaId.toString();

      // Debug: Afficher l'URL et les paramètres
      print('🚀 VehicleDeal API Call:');
      print('  URL: ${uri.toString()}');
      print('  Fields: ${request_multipart.fields}');
      print('  Files: ${request_multipart.files.length}');

      // Récupérer le token d'authentification
      final token = await _getAuthToken();
      
      // Ajouter des headers avec le token d'authentification
      request_multipart.headers.addAll({
        'Content-Type': 'multipart/form-data',
        'Accept': 'application/json',
        'Authorization': 'Bearer $token',
      });

      print('📤 Envoi de la requête...');
      
      // Envoyer la requête avec timeout
      final streamedResponse = await request_multipart.send().timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Timeout: La requête a pris trop de temps');
        },
      );
      
      print('📡 Requête envoyée, récupération de la réponse...');
      final response = await http.Response.fromStream(streamedResponse);

      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create vehicle deal: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      throw Exception('Error creating vehicle deal: $e');
    }
  }

  /// Récupère le token d'authentification depuis SharedPreferences
  Future<String> _getAuthToken() async {
    final token = SharedPreferencesService().accessToken;
    if (token.isEmpty) {
      throw Exception('Token d\'authentification non trouvé. Veuillez vous reconnecter.');
    }
    print('🔑 Token d\'authentification récupéré: ${token.substring(0, 20)}...');
    return token;
  }
}
