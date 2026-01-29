import 'package:http/http.dart' as http;
import '../../../../../core/constants/api_constants.dart';

class VehicleDealTest {
  static Future<void> testApiConnection() async {
    try {
      print('🧪 Test de connexion API...');
      
      // Test de l'URL de base
      final baseUrl = ApiConstants.baseUrl;
      print('📍 Base URL: $baseUrl');
      
      // Test de l'endpoint vehicles
      final vehiclesUrl = '${baseUrl}Vehicles/';
      print('📍 Vehicles URL: $vehiclesUrl');
      
      // Test de l'endpoint deal
      final dealUrl = '${baseUrl}Vehicles/deal/';
      print('📍 Deal URL: $dealUrl');
      
      // Test de connexion simple
      final response = await http.get(Uri.parse(vehiclesUrl));
      print('📡 Response Status: ${response.statusCode}');
      print('📡 Response Body: ${response.body}');
      
      if (response.statusCode == 200) {
        print('✅ Connexion API réussie');
      } else {
        print('❌ Problème de connexion API');
      }
    } catch (e) {
      print('❌ Erreur de test: $e');
    }
  }
}
