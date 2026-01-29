import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class PayPalPaymentService {
  static const String baseUrl = 'https://inmaapi-gkgxdtc0c6ded3bk.spaincentral-01.azurewebsites.net/api/'; // URL cohérente avec api_constants.dart
  
  /// Créer un paiement PayPal pour les viewing requests et propriétés
  static Future<PayPalPaymentResponse> createPayment({
    required double amount,
    required String currency,
    required String orderId,
    required String description,
    required String returnUrl,
    required String cancelUrl,
    required String authToken,
  }) async {
    try {
      print('🔗 [PayPalPaymentService] Tentative de connexion à: $baseUrl/payments/paypal/create');
      print('💰 [PayPalPaymentService] Montant: $amount $currency');
      print('🔑 [PayPalPaymentService] Token: ${authToken.substring(0, 10)}...');
      
      final response = await http.post(
        Uri.parse('$baseUrl/payments/paypal/create'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'amount': amount,
          'currency': currency,
          'orderId': orderId,
          'description': description,
          'returnUrl': returnUrl,
          'cancelUrl': cancelUrl,
        }),
      );

      print('📡 [PayPalPaymentService] Status Code: ${response.statusCode}');
      print('📄 [PayPalPaymentService] Response Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PayPalPaymentResponse.fromJson(data);
      } else {
        throw Exception('Erreur HTTP ${response.statusCode}: ${response.body}');
      }
    } catch (e) {
      print('❌ [PayPalPaymentService] Erreur PayPal: $e');
      throw Exception('Erreur de connexion PayPal: $e');
    }
  }

  /// Exécuter un paiement PayPal approuvé
  static Future<PayPalExecuteResponse> executePayment({
    required String paymentId,
    required String payerId,
    required String authToken,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/payments/paypal/execute'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'paymentId': paymentId,
          'payerId': payerId,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PayPalExecuteResponse.fromJson(data);
      } else {
        throw Exception('Erreur lors de l\'exécution du paiement PayPal: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Obtenir les détails d'un paiement PayPal
  static Future<PayPalPaymentDetails> getPaymentDetails({
    required String paymentId,
    required String authToken,
  }) async {
    try {
      final response = await http.get(
        Uri.parse('$baseUrl/payments/paypal/payment/$paymentId'),
        headers: {
          'Authorization': 'Bearer $authToken',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        return PayPalPaymentDetails.fromJson(data);
      } else {
        throw Exception('Erreur lors de la récupération des détails: ${response.body}');
      }
    } catch (e) {
      throw Exception('Erreur de connexion: $e');
    }
  }

  /// Ouvrir PayPal dans le navigateur
  static Future<bool> openPayPalInBrowser(String approvalUrl) async {
    try {
      final Uri paypalUrl = Uri.parse(approvalUrl);
      
      if (await canLaunchUrl(paypalUrl)) {
        await launchUrl(paypalUrl, mode: LaunchMode.externalApplication);
        return true;
      } else {
        throw Exception('Impossible d\'ouvrir PayPal');
      }
    } catch (e) {
      print('❌ [PayPalPaymentService] Erreur lors de l\'ouverture de PayPal: $e');
      return false;
    }
  }
}

class PayPalPaymentResponse {
  final bool success;
  final String? paymentId;
  final String? approvalUrl;
  final String? status;
  final String? errorMessage;

  PayPalPaymentResponse({
    required this.success,
    this.paymentId,
    this.approvalUrl,
    this.status,
    this.errorMessage,
  });

  factory PayPalPaymentResponse.fromJson(Map<String, dynamic> json) {
    return PayPalPaymentResponse(
      success: json['success'] ?? false,
      paymentId: json['paymentId'],
      approvalUrl: json['approvalUrl'],
      status: json['status'],
      errorMessage: json['error'],
    );
  }
}

class PayPalExecuteResponse {
  final bool success;
  final String? transactionId;
  final double? amount;
  final String? currency;
  final String? status;
  final DateTime? completedDate;
  final String? errorMessage;

  PayPalExecuteResponse({
    required this.success,
    this.transactionId,
    this.amount,
    this.currency,
    this.status,
    this.completedDate,
    this.errorMessage,
  });

  factory PayPalExecuteResponse.fromJson(Map<String, dynamic> json) {
    return PayPalExecuteResponse(
      success: json['success'] ?? false,
      transactionId: json['transactionId'],
      amount: json['amount']?.toDouble(),
      currency: json['currency'],
      status: json['status'],
      completedDate: json['completedDate'] != null 
          ? DateTime.parse(json['completedDate']) 
          : null,
      errorMessage: json['error'],
    );
  }
}

class PayPalPaymentDetails {
  final bool success;
  final String? paymentId;
  final String? status;
  final String? errorMessage;

  PayPalPaymentDetails({
    required this.success,
    this.paymentId,
    this.status,
    this.errorMessage,
  });

  factory PayPalPaymentDetails.fromJson(Map<String, dynamic> json) {
    return PayPalPaymentDetails(
      success: json['success'] ?? false,
      paymentId: json['paymentId'],
      status: json['status'],
      errorMessage: json['error'],
    );
  }
}
