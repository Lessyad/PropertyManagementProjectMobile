import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/shared_preferences_service.dart';
import '../models/vehicle_deal_request.dart';

class VehicleDealJsonDataSource {
  final http.Client client;

  VehicleDealJsonDataSource({required this.client});

  Future<Map<String, dynamic>> createVehicleDeal({
    required VehicleDealRequest request,
    required int userId,
    required bool isClientUser,
  }) async {
    try {
      print('🚀 VehicleDeal JSON API Call:');
      print('  URL: ${ApiConstants.baseUrl}Vehicles/deal/');
      
      // Créer le payload JSON selon le format attendu par le backend
      final payload = {
        'VehicleId': request.vehicleId,
        'StartDate': request.startDate.toIso8601String(),
        'EndDate': request.endDate.toIso8601String(),
        'MainDriver': {
          'DocumentType': request.mainDriver.documentType,
          'FirstName': request.mainDriver.firstName,
          'LastName': request.mainDriver.lastName,
          'FamilyName': request.mainDriver.familyName,
          'PhoneNumber': request.mainDriver.phoneNumber,
          'IdNumber': request.mainDriver.idNumber,
          'BirthDate': request.mainDriver.birthDate.toIso8601String(),
          'IdExpiryDate': request.mainDriver.idExpiryDate.toIso8601String(),
          'DrivingLicenseNumber': request.mainDriver.drivingLicenseNumber,
          'DrivingLicenseIssueDate': request.mainDriver.drivingLicenseIssueDate.toIso8601String(),
        },
        'SecondDriverEnabled': request.secondDriverEnabled,
        'SecondDriver': request.secondDriverEnabled && request.secondDriver != null ? {
          'DocumentType': request.secondDriver!.documentType,
          'FirstName': request.secondDriver!.firstName,
          'LastName': request.secondDriver!.lastName,
          'FamilyName': request.secondDriver!.familyName,
          'PhoneNumber': request.secondDriver!.phoneNumber,
          'IdNumber': request.secondDriver!.idNumber,
          'BirthDate': request.secondDriver!.birthDate.toIso8601String(),
          'IdExpiryDate': request.secondDriver!.idExpiryDate.toIso8601String(),
          'DrivingLicenseNumber': request.secondDriver!.drivingLicenseNumber,
          'DrivingLicenseIssueDate': request.secondDriver!.drivingLicenseIssueDate.toIso8601String(),
        } : null,
        'PaymentMethod': request.paymentMethod,
        'Passcode': request.passcode,
        'BankilyPhoneNumber': request.bankilyPhoneNumber,
        'KilometerIllimitedPerDay': request.kilometerIllimitedPerDay,
        'AllRiskCarInsurance': request.allRiskCarInsurance,
        'AddChildsChair': request.addChildsChair,
        'PickupAreaId': request.pickupAreaId,
        'ReturnAreaId': request.returnAreaId,
      };

      print('📦 JSON Payload: ${json.encode(payload)}');

      // Récupérer le token d'authentification
      final token = await _getAuthToken();
      
      // Envoyer la requête JSON avec le token
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}Vehicles/deal/'),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: json.encode(payload),
      ).timeout(
        const Duration(seconds: 30),
        onTimeout: () {
          throw Exception('Timeout: La requête a pris trop de temps');
        },
      );

      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        return json.decode(response.body);
      } else {
        throw Exception('Failed to create vehicle deal: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('❌ Erreur dans JSON datasource: $e');
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
