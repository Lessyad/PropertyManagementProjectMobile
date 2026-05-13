import 'dart:async';
import 'package:enmaa/core/services/change_user_language_function.dart';
import 'package:enmaa/core/services/dio_service.dart';
import 'package:enmaa/features/authentication_module/data/models/otp_response_model.dart';
import 'package:enmaa/features/authentication_module/data/models/reset_password_request_model.dart';
import 'package:enmaa/features/authentication_module/data/models/update_fcm_token_request_model.dart';
import 'package:enmaa/features/authentication_module/domain/entities/login_request_entity.dart';
import 'package:enmaa/features/authentication_module/domain/entities/sign_up_request_entity.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/constants/api_constants.dart';
import '../../../../../core/constants/json_keys.dart';
import '../../../../../core/services/shared_preferences_service.dart';
import '../../models/login_request_model.dart';
import '../../models/sign_up_request_model.dart';
import 'dart:developer' as dev;
import 'package:dio/dio.dart';

abstract class BaseAuthenticationRemoteDataSource {
  Future<String> remoteLogin(LoginRequestModel loginBody);
  Future<String> signUp(SignUpRequestModel signUpBody);
  Future<OTPResponseModel> sendOtp(String phoneNumber);
  Future<bool> verifyOtp(String otp, String phoneNumber);
  
  Future<void> resetPassword(ResetPasswordRequestModel resetPasswordBody);
  Future<void> updateFcmToken(UpdateFcmTokenRequestModel request);
}

class AuthenticationRemoteDataSource extends BaseAuthenticationRemoteDataSource {
  DioService dioService;

  AuthenticationRemoteDataSource({required this.dioService});


  @override
  Future<String> remoteLogin(LoginRequestModel loginBody) async {
    print('🔑 [LOGIN] Tentative de connexion pour: ${loginBody.phone}');
    print('🔑 [LOGIN] URL: ${ApiConstants.login}');
    print('🔑 [LOGIN] Data: ${loginBody.toJson()}');
    
    try {
      final response = await dioService.post(
        url: ApiConstants.login,
        data: loginBody.toJson(),
      );
      
      print('✅ [LOGIN] Connexion réussie! Status: ${response.statusCode}');
      print('✅ [LOGIN] Response: ${response.data}');

      final token = response.data['access'];
      final refreshToken = response.data['refresh'];
      final fullName = response.data['full_name'];
      final language = response.data['language'];
      final idUser = response.data['id_user']; // Nouveau champ ID utilisateur (clé corrigée)

      SharedPreferencesService().setUserPhone(loginBody.phone) ;
      SharedPreferencesService().setUserName(fullName) ;
      SharedPreferencesService().setAccessToken(token) ;
      SharedPreferencesService().setRefreshToken(refreshToken) ;
      
      // Stocker l'ID utilisateur
      if (idUser != null) {
        await SharedPreferencesService().storeValue('user_id', idUser);
        print('✅ ID utilisateur stocké: $idUser');
      }

      updateUserLanguage(SharedPreferencesService().language);

      if(response.data['city'] != null){
        final cityId = response.data['city']['id'];
        final cityName = response.data['city']['name'];
        final stateId = response.data['city']['state']['id'];
        final stateName = response.data['city']['state']['name'];
        final countryId = response.data['city']['state']['country']['id'];
        final countryName = response.data['city']['state']['country']['name'];

        await SharedPreferencesService().storeValue('city_id', cityId);
        await SharedPreferencesService().storeValue('city_name', cityName);
        await SharedPreferencesService().storeValue('state_id', stateId);
        await SharedPreferencesService().storeValue('state_name', stateName);
        await SharedPreferencesService().storeValue('country_id', countryId);
        await SharedPreferencesService().storeValue('country_name', countryName);
      }

      return token;
    } catch (e) {
      print('❌ [LOGIN] Erreur lors de la connexion: $e');
      rethrow;
    }
  }

  @override
  Future<OTPResponseModel> sendOtp(String phoneNumber) async {
    final t0 = DateTime.now();

    // ✅ validateStatus => true : on reçoit la Response même si c'est 400/500
    final res = await dioService.post(
      url: ApiConstants.sendOTP,
      data: { JsonKeys.phoneNumber: phoneNumber },
      options: Options(validateStatus: (_) => true),
    );

    final ms = DateTime.now().difference(t0).inMilliseconds;
    dev.log('[Remote.sendOtp] status=${res.statusCode} in ${ms}ms '
        'url=${res.requestOptions.uri} data=${res.data}',
        name: 'Auth');

    // Si ce n’est pas 2xx, tu peux lever toi-même une erreur explicite
    if ((res.statusCode ?? 500) >= 300) {
      throw DioException(
        requestOptions: res.requestOptions,
        response: res,
        type: DioExceptionType.badResponse,
        message: 'HTTP ${res.statusCode}',
      );
    }

    final map = Map<String, dynamic>.from(res.data as Map);
    return OTPResponseModel.fromJson(map);
  }

  @override
  Future<bool> verifyOtp(String otp , String phoneNumber) async{
    final response = await dioService.post(
        url: ApiConstants.verifyOTP,
        data: {
          JsonKeys.phoneNumber: phoneNumber,
          JsonKeys.code: otp,
        }
    );

    /// Vérifier si l'OTP est vérifié avec succès
    final message = response.data['message'] as String?;
    final isVerified = response.data['isVerified'] as bool?;
    
    if (isVerified == true || 
        message == 'OTP verified successfully.' || 
        message == 'OTP vérifié avec succès') {
      return true;
    }

    return false;
  }

  @override
  Future<String> signUp(SignUpRequestModel signUpBody) async{
    final response = await dioService.post(
        url: ApiConstants.signUp,
        data: signUpBody.toJson()
    );

    // Stocker les tokens d'accès et de rafraîchissement
    final accessToken = response.data['access'] as String? ?? '';
    final refreshToken = response.data['refresh'] as String? ?? '';
    
    SharedPreferencesService().setAccessToken(accessToken);
    SharedPreferencesService().setRefreshToken(refreshToken);
    
    // Stocker le nom complet
    final fullName = response.data['full_name'] as String? ?? '';
    SharedPreferencesService().setUserName(fullName);
    
    // Stocker l'ID utilisateur si disponible
    final userId = response.data['id_user'];
    if (userId != null) {
      await SharedPreferencesService().storeValue('user_id', userId);
      print('✅ ID utilisateur stocké lors de l\'inscription: $userId');
    }

    updateUserLanguage(SharedPreferencesService().language);

    return accessToken;
  }

  @override
  Future<void> resetPassword(ResetPasswordRequestModel resetPasswordBody)async {
    final response = await dioService.post(
        url: ApiConstants.resetPassword,
        data: resetPasswordBody.toJson()
    );


  }

  @override
  Future<void> updateFcmToken(UpdateFcmTokenRequestModel request) async {
    final t0 = DateTime.now();
    
    print('🚀 [REMOTE_DATA_SOURCE] Envoi de la requête FCM Token...');
    print('📍 [REMOTE_DATA_SOURCE] URL: ${ApiConstants.updateFcmToken}');
    print('📦 [REMOTE_DATA_SOURCE] Données: ${request.toJson()}');
    
    try {
      final response = await dioService.post(
        url: ApiConstants.updateFcmToken,
        data: request.toJson(),
        options: Options(validateStatus: (status) => status! < 500), // Accepter les 4xx pour voir la réponse
      );
      
      final ms = DateTime.now().difference(t0).inMilliseconds;
      
      if (response.statusCode == 200) {
        print('✅ [REMOTE_DATA_SOURCE] FCM Token mis à jour avec succès en ${ms}ms');
      } else {
        print('⚠️ [REMOTE_DATA_SOURCE] Réponse inattendue en ${ms}ms');
      }
      
      print('📊 [REMOTE_DATA_SOURCE] Status: ${response.statusCode}');
      print('📄 [REMOTE_DATA_SOURCE] Réponse: ${response.data}');
      
      // Si ce n'est pas 200, lever une erreur avec plus de détails
      if (response.statusCode != 200) {
        throw Exception('HTTP ${response.statusCode}: ${response.data}');
      }
      
    } catch (e) {
      final ms = DateTime.now().difference(t0).inMilliseconds;
      print('❌ [REMOTE_DATA_SOURCE] Erreur lors de la mise à jour du FCM Token en ${ms}ms');
      print('🔍 [REMOTE_DATA_SOURCE] Détails de l\'erreur: $e');
      rethrow;
    }
  }
}
