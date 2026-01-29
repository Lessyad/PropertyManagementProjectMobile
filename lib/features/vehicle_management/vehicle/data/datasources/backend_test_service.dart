import 'dart:convert';
import 'package:http/http.dart' as http;

class BackendTestService {
  static const String baseUrl = 'http://192.168.100.13:5000/api';
  
  /// Tester la connectivité du backend
  static Future<bool> testConnection() async {
    try {
      print('🔗 Test de connexion vers: $baseUrl');
      
      final response = await http.get(
        Uri.parse('$baseUrl/health'),
        headers: {
          'Content-Type': 'application/json',
        },
      ).timeout(const Duration(seconds: 10));

      print('📡 Status Code: ${response.statusCode}');
      print('📄 Response: ${response.body}');
      
      return response.statusCode == 200;
    } catch (e) {
      print('❌ Erreur de connexion: $e');
      return false;
    }
  }
  
  /// Tester l'endpoint PayPal spécifiquement
  static Future<bool> testPayPalEndpoint(String authToken) async {
    try {
      print('🔗 Test de l\'endpoint PayPal: $baseUrl/payments/paypal/create');
      
      final response = await http.post(
        Uri.parse('$baseUrl/payments/paypal/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'amount': 100.0,
          'currency': 'USD',
          'orderId': 12345,
          'description': 'Test payment',
          'returnUrl': 'https://test.com/success',
          'cancelUrl': 'https://test.com/cancel',
        }),
      ).timeout(const Duration(seconds: 10));

      print('📡 PayPal Status Code: ${response.statusCode}');
      print('📄 PayPal Response: ${response.body}');
      
      return response.statusCode == 200 || response.statusCode == 400; // 400 = endpoint existe mais erreur de validation
    } catch (e) {
      print('❌ Erreur PayPal endpoint: $e');
      return false;
    }
  }
}
