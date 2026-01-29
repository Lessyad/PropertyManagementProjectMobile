import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/api_constants.dart';

class VehicleDealSimpleTest {
  static Future<void> testSimpleRequest() async {
    try {
      print('🧪 Test de requête simple...');
      
      final url = '${ApiConstants.baseUrl}Vehicles/deal/';
      print('📍 URL: $url');
      
      // Créer un payload JSON simple
      final payload = {
        'userId': 5,
        'isClientUser': true,
        'VehicleId': 1010,
        'StartDate': '2025-10-04T00:00:00.000Z',
        'EndDate': '2025-10-05T00:00:00.000Z',
        'MainDriver': {
          'DocumentType': 'identity',
          'FirstName': 'test1234',
          'LastName': 'ffft',
          'FamilyName': 'test1234',
          'PhoneNumber': '22458893',
          'IdNumber': 'test1234',
          'BirthDate': '2025-10-06T00:00:00.000Z',
          'IdExpiryDate': '2025-10-09T00:00:00.000Z',
          'DrivingLicenseNumber': '12345678',
          'DrivingLicenseIssueDate': '2025-10-03T00:00:00.000Z',
        },
        'SecondDriverEnabled': false,
        'PaymentMethod': 'bankily',
        'Passcode': '',
        'BankilyPhoneNumber': '224588',
        'KilometerIllimitedPerDay': false,
        'AllRiskCarInsurance': false,
        'AddChildsChair': false,
        'PickupAreaId': 15,
        'ReturnAreaId': 15,
      };
      
      print('📤 Envoi de la requête JSON...');
      print('📦 Payload: ${json.encode(payload)}');
      
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
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
        print('✅ Requête simple réussie');
      } else {
        print('❌ Requête simple échouée: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Erreur dans le test simple: $e');
    }
  }
}
