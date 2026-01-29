import '../../../../../core/services/shared_preferences_service.dart';

class AuthHelper {
  /// Récupère l'ID utilisateur depuis l'authentification
  /// Retourne null si l'utilisateur n'est pas authentifié
  static int? getCurrentUserId() {
    return SharedPreferencesService().userId;
  }

  /// Vérifie si l'utilisateur est authentifié
  static bool isUserAuthenticated() {
    final userId = getCurrentUserId();
    final accessToken = SharedPreferencesService().accessToken;
    return userId != null && accessToken.isNotEmpty;
  }

  /// Récupère l'ID utilisateur avec vérification d'authentification
  /// Lance une exception si l'utilisateur n'est pas authentifié
  static int getAuthenticatedUserId() {
    final userId = getCurrentUserId();
    if (userId == null) {
      throw Exception('Utilisateur non authentifié. Veuillez vous reconnecter.');
    }
    return userId;
  }

  /// Récupère les informations de l'utilisateur authentifié
  static Map<String, dynamic> getAuthenticatedUserInfo() {
    if (!isUserAuthenticated()) {
      throw Exception('Utilisateur non authentifié. Veuillez vous reconnecter.');
    }

    return {
      'userId': getCurrentUserId(),
      'userName': SharedPreferencesService().userName,
      'userPhone': SharedPreferencesService().userPhone,
      'accessToken': SharedPreferencesService().accessToken,
    };
  }

  /// Récupère le token d'authentification
  static String getAuthToken() {
    final token = SharedPreferencesService().accessToken;
    if (token.isEmpty) {
      throw Exception('Token d\'authentification non trouvé. Veuillez vous reconnecter.');
    }
    return token;
  }

  /// Vérifie si le token d'authentification est valide
  static bool hasValidToken() {
    final token = SharedPreferencesService().accessToken;
    return token.isNotEmpty;
  }
}
