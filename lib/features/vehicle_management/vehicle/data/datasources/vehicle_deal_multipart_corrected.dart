import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/services/shared_preferences_service.dart';
import '../models/vehicle_deal_request.dart';

class VehicleDealMultipartCorrected {
  final http.Client client;

  VehicleDealMultipartCorrected({required this.client});

  Future<Map<String, dynamic>> createVehicleDeal({
    required VehicleDealRequest request,
    required int userId,
    required bool isClientUser,
  }) async {
    try {
      print('🚀 VehicleDeal Multipart Corrected API Call:');
      print('  URL: ${ApiConstants.baseUrl}Vehicles/deal/');
      
      // Créer la requête multipart
      final uri = Uri.parse('${ApiConstants.baseUrl}Vehicles/deal/');
      final request_multipart = http.MultipartRequest('POST', uri);

      // Ajouter les paramètres de base
      request_multipart.fields['userId'] = userId.toString();
      request_multipart.fields['isClientUser'] = isClientUser.toString();
      request_multipart.fields['VehicleId'] = request.vehicleId.toString();
      request_multipart.fields['StartDate'] = request.startDate.toIso8601String();
      request_multipart.fields['EndDate'] = request.endDate.toIso8601String();

      // Ajouter les données du conducteur principal (format correct)
      request_multipart.fields['MainDriver.DocumentType'] = request.mainDriver.documentType;
      request_multipart.fields['MainDriver.FirstName'] = request.mainDriver.firstName;
      request_multipart.fields['MainDriver.LastName'] = request.mainDriver.lastName;
      request_multipart.fields['MainDriver.FamilyName'] = request.mainDriver.familyName;
      request_multipart.fields['MainDriver.PhoneNumber'] = request.mainDriver.phoneNumber;
      request_multipart.fields['MainDriver.IdNumber'] = request.mainDriver.idNumber;
      request_multipart.fields['MainDriver.BirthDate'] = request.mainDriver.birthDate.toIso8601String();
      request_multipart.fields['MainDriver.IdExpiryDate'] = request.mainDriver.idExpiryDate.toIso8601String();
      request_multipart.fields['MainDriver.DrivingLicenseNumber'] = request.mainDriver.drivingLicenseNumber;
      request_multipart.fields['MainDriver.DrivingLicenseIssueDate'] = request.mainDriver.drivingLicenseIssueDate.toIso8601String();

      // Ajouter les images du conducteur principal
      if (request.mainDriver.idCardImage != null) {
        try {
          final file = request.mainDriver.idCardImage!;
          // Lire les bytes du fichier même si exists() retourne false
          // car les fichiers du cache peuvent être supprimés mais les bytes peuvent encore être accessibles
          try {
            final bytes = await file.readAsBytes();
            if (bytes.isNotEmpty) {
              request_multipart.files.add(
                http.MultipartFile.fromBytes(
                  'MainDriver.IdCardImage',
                  bytes,
                  filename: 'id_card_${DateTime.now().millisecondsSinceEpoch}.jpg',
                ),
              );
              print('✅ MainDriver.IdCardImage ajoutée (${bytes.length} bytes): ${file.path}');
            } else {
              print('❌ MainDriver.IdCardImage est vide: ${file.path}');
              throw Exception('Le fichier IdCardImage est vide');
            }
          } catch (readError) {
            print('❌ Erreur lors de la lecture de MainDriver.IdCardImage: $readError');
            // Essayer avec fromPath comme fallback
            if (await file.exists()) {
              request_multipart.files.add(
                await http.MultipartFile.fromPath(
                  'MainDriver.IdCardImage',
                  file.path,
                ),
              );
              print('✅ MainDriver.IdCardImage ajoutée via fromPath: ${file.path}');
            } else {
              throw Exception('Impossible de lire le fichier IdCardImage: $readError');
            }
          }
        } catch (e) {
          print('❌ Erreur avec MainDriver.IdCardImage: $e');
          throw Exception('Erreur lors de l\'ajout de MainDriver.IdCardImage: $e');
        }
      } else {
        throw Exception('MainDriver.IdCardImage est requis mais est null');
      }

      if (request.mainDriver.drivingLicenseImage != null) {
        try {
          final file = request.mainDriver.drivingLicenseImage!;
          // Lire les bytes du fichier même si exists() retourne false
          try {
            final bytes = await file.readAsBytes();
            if (bytes.isNotEmpty) {
              request_multipart.files.add(
                http.MultipartFile.fromBytes(
                  'MainDriver.DrivingLicenseImage',
                  bytes,
                  filename: 'driving_license_${DateTime.now().millisecondsSinceEpoch}.jpg',
                ),
              );
              print('✅ MainDriver.DrivingLicenseImage ajoutée (${bytes.length} bytes): ${file.path}');
            } else {
              print('❌ MainDriver.DrivingLicenseImage est vide: ${file.path}');
              throw Exception('Le fichier DrivingLicenseImage est vide');
            }
          } catch (readError) {
            print('❌ Erreur lors de la lecture de MainDriver.DrivingLicenseImage: $readError');
            // Essayer avec fromPath comme fallback
            if (await file.exists()) {
              request_multipart.files.add(
                await http.MultipartFile.fromPath(
                  'MainDriver.DrivingLicenseImage',
                  file.path,
                ),
              );
              print('✅ MainDriver.DrivingLicenseImage ajoutée via fromPath: ${file.path}');
            } else {
              throw Exception('Impossible de lire le fichier DrivingLicenseImage: $readError');
            }
          }
        } catch (e) {
          print('❌ Erreur avec MainDriver.DrivingLicenseImage: $e');
          throw Exception('Erreur lors de l\'ajout de MainDriver.DrivingLicenseImage: $e');
        }
      } else {
        throw Exception('MainDriver.DrivingLicenseImage est requis mais est null');
      }

      // Ajouter les données du deuxième conducteur si activé
      request_multipart.fields['SecondDriverEnabled'] = request.secondDriverEnabled.toString();
      if (request.secondDriverEnabled && request.secondDriver != null) {
        request_multipart.fields['SecondDriver.DocumentType'] = request.secondDriver!.documentType;
        request_multipart.fields['SecondDriver.FirstName'] = request.secondDriver!.firstName;
        request_multipart.fields['SecondDriver.LastName'] = request.secondDriver!.lastName;
        request_multipart.fields['SecondDriver.FamilyName'] = request.secondDriver!.familyName;
        request_multipart.fields['SecondDriver.PhoneNumber'] = request.secondDriver!.phoneNumber;
        request_multipart.fields['SecondDriver.IdNumber'] = request.secondDriver!.idNumber;
        request_multipart.fields['SecondDriver.BirthDate'] = request.secondDriver!.birthDate.toIso8601String();
        request_multipart.fields['SecondDriver.IdExpiryDate'] = request.secondDriver!.idExpiryDate.toIso8601String();
        request_multipart.fields['SecondDriver.DrivingLicenseNumber'] = request.secondDriver!.drivingLicenseNumber;
        request_multipart.fields['SecondDriver.DrivingLicenseIssueDate'] = request.secondDriver!.drivingLicenseIssueDate.toIso8601String();

        // Ajouter les images du deuxième conducteur
        if (request.secondDriver!.idCardImage != null) {
          try {
            final file = request.secondDriver!.idCardImage!;
            try {
              final bytes = await file.readAsBytes();
              if (bytes.isNotEmpty) {
                request_multipart.files.add(
                  http.MultipartFile.fromBytes(
                    'SecondDriver.IdCardImage',
                    bytes,
                    filename: 'second_id_card_${DateTime.now().millisecondsSinceEpoch}.jpg',
                  ),
                );
                print('✅ SecondDriver.IdCardImage ajoutée (${bytes.length} bytes): ${file.path}');
              }
            } catch (readError) {
              if (await file.exists()) {
                request_multipart.files.add(
                  await http.MultipartFile.fromPath(
                    'SecondDriver.IdCardImage',
                    file.path,
                  ),
                );
                print('✅ SecondDriver.IdCardImage ajoutée via fromPath: ${file.path}');
              }
            }
          } catch (e) {
            print('❌ Erreur avec SecondDriver.IdCardImage: $e');
          }
        }

        if (request.secondDriver!.drivingLicenseImage != null) {
          try {
            final file = request.secondDriver!.drivingLicenseImage!;
            try {
              final bytes = await file.readAsBytes();
              if (bytes.isNotEmpty) {
                request_multipart.files.add(
                  http.MultipartFile.fromBytes(
                    'SecondDriver.DrivingLicenseImage',
                    bytes,
                    filename: 'second_driving_license_${DateTime.now().millisecondsSinceEpoch}.jpg',
                  ),
                );
                print('✅ SecondDriver.DrivingLicenseImage ajoutée (${bytes.length} bytes): ${file.path}');
              }
            } catch (readError) {
              if (await file.exists()) {
                request_multipart.files.add(
                  await http.MultipartFile.fromPath(
                    'SecondDriver.DrivingLicenseImage',
                    file.path,
                  ),
                );
                print('✅ SecondDriver.DrivingLicenseImage ajoutée via fromPath: ${file.path}');
              }
            }
          } catch (e) {
            print('❌ Erreur avec SecondDriver.DrivingLicenseImage: $e');
          }
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
      print('🚀 VehicleDeal Multipart Corrected:');
      print('  URL: ${uri.toString()}');
      print('  Fields: ${request_multipart.fields}');
      print('  Files: ${request_multipart.files.length}');

      // Ajouter des headers avec le token d'authentification
      request_multipart.headers.addAll({
        'Accept': 'application/json',
        'Authorization': 'Bearer ${await _getAuthToken()}',
      });

      print('📤 Envoi de la requête multipart corrigée...');
      
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
        print('❌ Failed to create vehicle deal: ${response.statusCode} - ${response.body}');
        // On propage le corps brut (JSON {errorCode, message}) tel quel, sans le
        // préfixer de texte libre, pour que ErrorHandlerService puisse le décoder.
        throw Exception(response.body);
      }
    } on Exception {
      rethrow;
    } catch (e) {
      print('❌ Erreur dans multipart corrigé: $e');
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
