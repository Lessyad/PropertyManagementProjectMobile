import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/api_constants.dart';
import '../../data/models/vehicle_deal_request.dart';

class VehicleDealDebug {
  static Future<void> debugRequest({
    required VehicleDealRequest request,
    required int userId,
    required bool isClientUser,
  }) async {
    try {
      print('🔍 DEBUG - Analyse de la requête:');
      print('  UserId: $userId');
      print('  IsClientUser: $isClientUser');
      print('  VehicleId: ${request.vehicleId}');
      print('  StartDate: ${request.startDate}');
      print('  EndDate: ${request.endDate}');
      print('  MainDriver: ${request.mainDriver.firstName} ${request.mainDriver.lastName}');
      print('  SecondDriverEnabled: ${request.secondDriverEnabled}');
      print('  PaymentMethod: ${request.paymentMethod}');
      
      // Vérifier les images
      if (request.mainDriver.idCardImage != null) {
        final file = request.mainDriver.idCardImage!;
        print('  MainDriver.IdCardImage: ${file.path}');
        print('  MainDriver.IdCardImage exists: ${await file.exists()}');
        if (await file.exists()) {
          print('  MainDriver.IdCardImage size: ${await file.length()} bytes');
        }
      }
      
      if (request.mainDriver.drivingLicenseImage != null) {
        final file = request.mainDriver.drivingLicenseImage!;
        print('  MainDriver.DrivingLicenseImage: ${file.path}');
        print('  MainDriver.DrivingLicenseImage exists: ${await file.exists()}');
        if (await file.exists()) {
          print('  MainDriver.DrivingLicenseImage size: ${await file.length()} bytes');
        }
      }
      
      // Test de l'URL
      final url = '${ApiConstants.baseUrl}Vehicles/deal/';
      print('  URL: $url');
      
      // Test de connectivité
      print('🔍 Test de connectivité...');
      final testResponse = await http.get(Uri.parse('${ApiConstants.baseUrl}Vehicles/')).timeout(
        const Duration(seconds: 10),
      );
      print('  Test response status: ${testResponse.statusCode}');
      
      // Test avec une requête multipart simple
      print('🔍 Test multipart simple...');
      final uri = Uri.parse(url);
      final request_multipart = http.MultipartRequest('POST', uri);
      
      // Ajouter seulement quelques champs pour tester
      request_multipart.fields['userId'] = userId.toString();
      request_multipart.fields['isClientUser'] = isClientUser.toString();
      request_multipart.fields['VehicleId'] = request.vehicleId.toString();
      
      print('  Multipart fields: ${request_multipart.fields}');
      print('  Multipart files: ${request_multipart.files.length}');
      
      // Test d'envoi sans images
      print('📤 Test d\'envoi sans images...');
      final streamedResponse = await request_multipart.send().timeout(
        const Duration(seconds: 15),
        onTimeout: () {
          print('❌ Timeout lors du test multipart');
          throw Exception('Timeout lors du test multipart');
        },
      );
      
      final response = await http.Response.fromStream(streamedResponse);
      print('  Test response status: ${response.statusCode}');
      print('  Test response body: ${response.body}');
      
    } catch (e) {
      print('❌ Erreur dans le debug: $e');
      print('❌ Stack trace: ${StackTrace.current}');
    }
  }
}
