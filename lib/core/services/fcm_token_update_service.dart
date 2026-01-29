import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:enmaa/core/services/firebase_messaging_service.dart';
import 'package:enmaa/core/services/dio_service.dart';
import 'package:enmaa/core/constants/api_constants.dart';
import 'package:enmaa/features/authentication_module/data/models/update_fcm_token_request_model.dart';
import 'package:enmaa/features/authentication_module/domain/use_cases/update_fcm_token_use_case.dart';

class FcmTokenUpdateService {
  static final FcmTokenUpdateService _instance = FcmTokenUpdateService._internal();
  factory FcmTokenUpdateService() => _instance;
  FcmTokenUpdateService._internal();

  /// Met à jour le FCM token après l'authentification
  Future<void> updateFcmTokenAfterAuthentication() async {
    print('🔄 [SERVICE] ========================================');
    print('🔄 [SERVICE] DÉBUT DE LA MISE À JOUR DU FCM TOKEN');
    print('🔄 [SERVICE] ========================================');
    
    try {
      // Attendre un peu pour s'assurer que le token est stocké
      await Future.delayed(const Duration(milliseconds: 500));
      
      // Vérifier que l'utilisateur est connecté
      final accessToken = SharedPreferencesService().accessToken;
      if (accessToken.isEmpty) {
        print('❌ Token d\'accès non disponible');
        return;
      }
      print('🔑 Token d\'accès disponible: ${accessToken.length > 20 ? "${accessToken.substring(0, 20)}..." : accessToken}');
      
      // Récupérer le token FCM depuis Firebase
      print('📱 Récupération du token FCM depuis Firebase...');
      final fcmToken = await ServiceLocator.getIt<BaseFireBaseMessaging>().getFcmToken();
      
      if (fcmToken != null) {
        print('✅ Token FCM récupéré: ${fcmToken.length > 20 ? "${fcmToken.substring(0, 20)}..." : fcmToken}');
        
        // Récupérer l'ID utilisateur depuis SharedPreferences
        print('👤 Récupération de l\'ID utilisateur...');
        final userId = SharedPreferencesService().userId;
        
        if (userId != null) {
          print('✅ ID utilisateur récupéré: $userId');
          
          final request = UpdateFcmTokenRequestModel(
            userId: userId,
            fcmToken: fcmToken,
          );
          
          print('📤 Envoi de la requête au backend...');
          final updateFcmTokenUseCase = ServiceLocator.getIt<UpdateFcmTokenUseCase>();
          final result = await updateFcmTokenUseCase(request);
          
          result.fold(
            (failure) {
              print('❌ Échec de la mise à jour du FCM Token: ${failure.message}');
            },
            (_) {
              print('✅ FCM Token mis à jour avec succès pour l\'utilisateur ID: $userId');
              print('🔑 Token FCM: ${fcmToken.length > 20 ? "${fcmToken.substring(0, 20)}..." : fcmToken}');
            },
          );
        } else {
          print('❌ ID utilisateur non trouvé dans SharedPreferences');
        }
      } else {
        print('❌ Token FCM non disponible');
      }
    } catch (e) {
      print('❌ Erreur lors de la mise à jour du FCM token: $e');
      print('🔍 Stack trace: ${StackTrace.current}');
    }
  }

  /// Met à jour le FCM token manuellement
  Future<void> updateFcmTokenManually() async {
    await updateFcmTokenAfterAuthentication();
  }
}
