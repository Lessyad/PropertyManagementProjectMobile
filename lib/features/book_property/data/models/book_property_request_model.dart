import 'dart:io';
import 'package:dio/dio.dart';

class BookPropertyRequestModel {
  final int propertyId; // Changed from String to int
  final bool isUser;
  final String name;
  final String phoneNumber;
  final String idNumber;
  final DateTime dateOfBirth; // Changed from String to DateTime
  final DateTime idExpiryDate; // Changed from String to DateTime
  final String paymentMethod; // String: "wallet", "credit", "bankily", etc.
  final File idImage;
  final DateTime? startDate; // Added for rental properties
  final DateTime? endDate; // Added for rental properties
  /// Numéro de téléphone Bankily du client (requis si paymentMethod == "bankily")
  final String? clientBankilyPhoneNumber;
  /// Code secret Bankily (PassCode), distinct du numéro de téléphone
  final String? bankilyPassCode;

  BookPropertyRequestModel({
    required this.propertyId,
    required this.isUser,
    required this.name,
    required this.phoneNumber,
    required this.idNumber,
    required this.dateOfBirth,
    required this.idExpiryDate,
    required this.paymentMethod,
    required this.idImage,
    this.startDate,
    this.endDate,
    this.clientBankilyPhoneNumber,
    this.bankilyPassCode,
  });

  Future<FormData> toFormData() async {
    // Format dates to ISO 8601 format (yyyy-MM-ddTHH:mm:ss)
    String formatDate(DateTime date) {
      return date.toIso8601String();
    }

    return FormData.fromMap({
      'is_user': isUser,
      'property_id': propertyId,
      'date_of_birth': formatDate(dateOfBirth),
      'start_date': startDate != null ? formatDate(startDate!) : '',
      'name': name,
      'id_number': idNumber,
      'end_date': endDate != null ? formatDate(endDate!) : '',
      'id_expiry_date': formatDate(idExpiryDate),
      'id_image': await MultipartFile.fromFile(
        idImage.path,
        filename: idImage.path.split('/').last,
      ),
      'payment_method': paymentMethod,
      'phone_number': phoneNumber,
      if (clientBankilyPhoneNumber != null && clientBankilyPhoneNumber!.isNotEmpty)
        'client_bankily_phone_number': clientBankilyPhoneNumber,
      if (bankilyPassCode != null && bankilyPassCode!.isNotEmpty)
        'pass_code': bankilyPassCode,
    });
  }
}
