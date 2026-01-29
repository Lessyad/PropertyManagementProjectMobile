import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:dio/dio.dart';
import '../components/custom_snack_bar.dart';
import '../translation/locale_keys.dart';
import 'dart:convert';

/// Service pour gérer les erreurs du backend et afficher les messages traduits
class ErrorHandlerService {
  /// Mappe les codes d'erreur du backend vers les clés de traduction et retourne le message traduit
  static String _getErrorTranslationFromCode(String? errorCode) {
    if (errorCode == null) return LocaleKeys.somethingWentWrong.tr();

    switch (errorCode.toUpperCase()) {
      case 'USER_NOT_AUTHENTICATED':
        return LocaleKeys.errorUserNotAuthenticated.tr();
      case 'MAIN_DRIVER_REQUIRED':
        return LocaleKeys.errorMainDriverRequired.tr();
      case 'SECOND_DRIVER_REQUIRED':
        return LocaleKeys.errorSecondDriverRequired.tr();
      case 'INVALID_RENTAL_DURATION':
        return LocaleKeys.errorInvalidRentalDuration.tr();
      case 'INSUFFICIENT_DEPOSIT':
        return LocaleKeys.errorInsufficientDeposit.tr();
      case 'CANNOT_RENT_OWN_VEHICLE':
        return LocaleKeys.errorCannotRentOwnVehicle.tr();
      case 'VEHICLE_NOT_AVAILABLE':
        return LocaleKeys.errorVehicleNotAvailable.tr();
      case 'VEHICLE_NOT_FOUND':
        return LocaleKeys.errorVehicleNotFound.tr();
      case 'NO_PARTNER_ASSOCIATED':
        return LocaleKeys.errorNoPartnerAssociated.tr();
      case 'PARTNER_NOT_FOUND':
        return LocaleKeys.errorPartnerNotFound.tr();
      case 'PARTNER_INFO_INCOMPLETE':
        return LocaleKeys.errorPartnerInfoIncomplete.tr();
      case 'CONFIG_MISSING':
        return LocaleKeys.errorConfigMissing.tr();
      case 'IMAGE_REQUIRED':
        return LocaleKeys.errorImageRequired.tr();
      case 'IMAGE_TOO_LARGE':
        return LocaleKeys.errorImageTooLarge.tr();
      case 'INVALID_IMAGE_FORMAT':
        return LocaleKeys.errorInvalidImageFormat.tr();
      case 'DAILY_PRICE_INVALID':
        return LocaleKeys.errorDailyPriceInvalid.tr();
      case 'SEATS_INVALID':
        return LocaleKeys.errorSeatsInvalid.tr();
      case 'UNAUTHORIZED_ACTION':
        return LocaleKeys.errorUnauthorizedAction.tr();
      case 'PROPERTY_NOT_FOUND':
        return LocaleKeys.errorPropertyNotFound.tr();
      case 'CITY_NOT_FOUND':
        return LocaleKeys.errorCityNotFound.tr();
      case 'INVALID_PROPERTY_SUBTYPE':
        return LocaleKeys.errorInvalidPropertySubtype.tr();
      case 'VIEWING_DATE_PAST':
        return LocaleKeys.errorViewingDatePast.tr();
      case 'USER_NOT_FOUND':
        return LocaleKeys.errorUserNotFound.tr();
      case 'INTERNAL_SERVER_ERROR':
        return LocaleKeys.internalServerError.tr();
      default:
        return LocaleKeys.somethingWentWrong.tr();
    }
  }

  /// Mappe les messages d'erreur du backend vers les clés de traduction et retourne le message traduit
  static String _getErrorTranslationFromMessage(String? errorMessage) {
    if (errorMessage == null) {
      return LocaleKeys.somethingWentWrong.tr();
    }

    final message = errorMessage.toLowerCase();

    // Erreurs de location de véhicule
    if (message.contains('cannot rent your own vehicle') ||
        message.contains('ne peut pas louer votre propre véhicule')) {
      return LocaleKeys.errorCannotRentOwnVehicle.tr();
    }
    if (message.contains('vehicle not available') ||
        message.contains('véhicule non disponible')) {
      return LocaleKeys.errorVehicleNotAvailable.tr();
    }
    if (message.contains('no partner associated') ||
        message.contains('aucun partenaire associé')) {
      return LocaleKeys.errorNoPartnerAssociated.tr();
    }
    if (message.contains('partner') && message.contains('incomplete')) {
      return LocaleKeys.errorPartnerInfoIncomplete.tr();
    }
    if (message.contains('durée de location') ||
        message.contains('rental duration') ||
        message.contains('must be positive')) {
      return LocaleKeys.errorInvalidRentalDuration.tr();
    }
    if (message.contains('dépôt requis') ||
        message.contains('deposit') ||
        message.contains('insufficient')) {
      return LocaleKeys.errorInsufficientDeposit.tr();
    }
    if (message.contains('main driver') ||
        message.contains('conducteur principal')) {
      return LocaleKeys.errorMainDriverRequired.tr();
    }
    if (message.contains('second driver') ||
        message.contains('deuxième conducteur')) {
      return LocaleKeys.errorSecondDriverRequired.tr();
    }
    if (message.contains('not authenticated') ||
        message.contains('non authentifié')) {
      return LocaleKeys.errorUserNotAuthenticated.tr();
    }
    if (message.contains('vehicle not found') ||
        message.contains('véhicule introuvable')) {
      return LocaleKeys.errorVehicleNotFound.tr();
    }
    if (message.contains('partner not found') ||
        message.contains('partenaire introuvable')) {
      return LocaleKeys.errorPartnerNotFound.tr();
    }
    if (message.contains('config missing') ||
        message.contains('configuration manquante')) {
      return LocaleKeys.errorConfigMissing.tr();
    }
    if (message.contains('image required') ||
        message.contains('image requis')) {
      return LocaleKeys.errorImageRequired.tr();
    }
    if (message.contains('exceeds') && message.contains('mb')) {
      return LocaleKeys.errorImageTooLarge.tr();
    }
    if (message.contains('invalid image format') ||
        message.contains('format d\'image invalide')) {
      return LocaleKeys.errorInvalidImageFormat.tr();
    }
    if (message.contains('daily price') ||
        message.contains('prix journalier')) {
      return LocaleKeys.errorDailyPriceInvalid.tr();
    }
    if (message.contains('seats') || message.contains('places')) {
      return LocaleKeys.errorSeatsInvalid.tr();
    }
    if (message.contains('unauthorized') ||
        message.contains('non autorisé')) {
      return LocaleKeys.errorUnauthorizedAction.tr();
    }
    if (message.contains('property not found') ||
        message.contains('propriété introuvable')) {
      return LocaleKeys.errorPropertyNotFound.tr();
    }
    if (message.contains('city not found') ||
        message.contains('ville introuvable')) {
      return LocaleKeys.errorCityNotFound.tr();
    }
    if (message.contains('invalid property subtype') ||
        message.contains('sous-type de propriété invalide')) {
      return LocaleKeys.errorInvalidPropertySubtype.tr();
    }
    if (message.contains('viewing date') && message.contains('past')) {
      return LocaleKeys.errorViewingDatePast.tr();
    }
    if (message.contains('user not found') ||
        message.contains('utilisateur introuvable')) {
      return LocaleKeys.errorUserNotFound.tr();
    }
    
    // Erreurs PropertyDealService
    if (message.contains('cannot deal with your own property') ||
        message.contains('ne peut pas traiter avec votre propre propriété') ||
        message.contains('cannot deal with your own')) {
      return LocaleKeys.errorCannotDealOwnProperty.tr();
    }
    if (message.contains('property is not available') ||
        message.contains('propriété n\'est pas disponible') ||
        message.contains('not available for rent or sell')) {
      return LocaleKeys.errorPropertyNotAvailable.tr();
    }
    if (message.contains('dates de début et fin sont obligatoires') ||
        message.contains('start and end dates are required') ||
        message.contains('dates are required')) {
      return LocaleKeys.errorRentalDatesRequired.tr();
    }
    if (message.contains('date de fin doit être postérieure') ||
        message.contains('end date must be after start date') ||
        message.contains('end date must be after')) {
      return LocaleKeys.errorEndDateAfterStartDate.tr();
    }
    if (message.contains('date de début ne peut pas être dans le passé') ||
        message.contains('start date cannot be in the past') ||
        message.contains('cannot be in the past')) {
      return LocaleKeys.errorStartDateNotPast.tr();
    }
    if (message.contains('durée minimale de location') ||
        message.contains('minimum rental duration') ||
        message.contains('minimum duration')) {
      return LocaleKeys.errorMinimumRentalDuration.tr();
    }
    if (message.contains('n\'est pas disponible pour les dates sélectionnées') ||
        message.contains('not available for the selected dates') ||
        message.contains('not available for selected dates')) {
      return LocaleKeys.errorPropertyNotAvailableForDates.tr();
    }
    if (message.contains('dates ne sont pas applicables pour un achat') ||
        message.contains('dates are not applicable for purchase') ||
        message.contains('not applicable for purchase')) {
      return LocaleKeys.errorDatesNotApplicableForSale.tr();
    }
    
    // Erreurs d'authentification spécifiques
    if (message.contains('identifiants invalides') ||
        message.contains('invalid credentials') ||
        message.contains('identifiant') && message.contains('invalide') ||
        message.contains('mot de passe') && message.contains('incorrect') ||
        message.contains('password') && message.contains('incorrect')) {
      return LocaleKeys.errorInvalidCredentials.tr();
    }
    if (message.contains('utilisateur avec ce numéro existe déjà') ||
        message.contains('user with this phone number already exists') ||
        message.contains('numéro de téléphone existe déjà')) {
      return LocaleKeys.errorPhoneNumberAlreadyExists.tr();
    }
    if (message.contains('code otp') && (message.contains('invalide') || message.contains('incorrect'))) {
      return LocaleKeys.errorInvalidOtp.tr();
    }
    if (message.contains('token') && (message.contains('expiré') || message.contains('expired'))) {
      return LocaleKeys.errorTokenExpired.tr();
    }

    // Erreurs HTTP standard
    if (message.contains('bad request')) {
      return LocaleKeys.badRequest.tr();
    }
    if (message.contains('unauthorized')) {
      return LocaleKeys.unauthorized.tr();
    }
    if (message.contains('forbidden')) {
      return LocaleKeys.forbidden.tr();
    }
    if (message.contains('not found')) {
      return LocaleKeys.notFound.tr();
    }
    if (message.contains('internal server error') ||
        message.contains('erreur interne')) {
      return LocaleKeys.internalServerError.tr();
    }
    if (message.contains('timeout')) {
      return LocaleKeys.connectionTimeout.tr();
    }
    if (message.contains('no internet') ||
        message.contains('pas de connexion')) {
      return LocaleKeys.noInternet.tr();
    }

    // Par défaut
    return LocaleKeys.somethingWentWrong.tr();
  }

  /// Extrait le message d'erreur et le code depuis la réponse HTTP ou DioException
  static Map<String, String?> _extractErrorInfo(dynamic errorResponse) {
    if (errorResponse == null) return {'message': null, 'code': null};

    try {
      // Gérer DioException directement
      if (errorResponse is DioException) {
        return _extractFromDioException(errorResponse);
      }
      
      // Gérer les strings qui contiennent DioException (pour les logs)
      if (errorResponse.toString().contains('DioException') || 
          errorResponse.toString().contains('DioError')) {
        return _extractFromDioExceptionString(errorResponse);
      }

      Map<String, dynamic>? json;
      
      // Si c'est une String, essayer de la parser en JSON
      if (errorResponse is String) {
        try {
          json = jsonDecode(errorResponse);
        } catch (e) {
          // Si ce n'est pas du JSON, retourner la string directement
          return {'message': errorResponse, 'code': null};
        }
      } else if (errorResponse is Map) {
        json = Map<String, dynamic>.from(errorResponse);
      } else {
        return {'message': errorResponse.toString(), 'code': null};
      }

      // Priorité d'extraction : details > message > error > detail
      // Le champ "details" est souvent utilisé par le backend pour les messages spécifiques
      final errorMessage = json?['details'] ??  // Priorité 1 : details (ex: "Identifiants invalides")
                           json?['Details'] ??
                           json?['message'] ?? 
                           json?['Message'] ?? 
                           json?['error'] ?? 
                           json?['Error'] ?? 
                           json?['detail'] ?? 
                           json?['Detail'] ??
                           json?['errorMessage'] ??
                           json?['ErrorMessage'] ??
                           null;

      // Extraire le code d'erreur
      final errorCode = json?['errorCode'] ?? 
                       json?['ErrorCode'] ?? 
                       json?['error_code'] ?? 
                       json?['code'] ??
                       json?['Code'];

      return {'message': errorMessage?.toString(), 'code': errorCode?.toString()};
    } catch (e) {
      return {'message': errorResponse.toString(), 'code': null};
    }
  }

  /// Extrait les informations d'erreur depuis une DioException réelle
  static Map<String, String?> _extractFromDioException(DioException dioException) {
    try {
      // Accéder directement à response.data si disponible
      if (dioException.response?.data != null) {
        final responseData = dioException.response!.data;
        
        // Si c'est un Map, extraire directement
        if (responseData is Map<String, dynamic>) {
          final errorMessage = responseData['details'] ??  // Priorité 1
                               responseData['Details'] ??
                               responseData['message'] ??
                               responseData['Message'] ??
                               responseData['error'] ??
                               responseData['Error'] ??
                               responseData['detail'] ??
                               responseData['Detail'] ??
                               null;
          
          final errorCode = responseData['errorCode'] ??
                           responseData['ErrorCode'] ??
                           responseData['code'] ??
                           responseData['Code'];
          
          if (errorMessage != null) {
            return {'message': errorMessage.toString(), 'code': errorCode?.toString()};
          }
        }
        
        // Si c'est une String, essayer de la parser
        if (responseData is String) {
          try {
            final json = jsonDecode(responseData);
            if (json is Map<String, dynamic>) {
              final errorMessage = json['details'] ??
                                   json['Details'] ??
                                   json['message'] ??
                                   json['Message'] ??
                                   null;
              if (errorMessage != null) {
                return {'message': errorMessage.toString(), 'code': null};
              }
            }
          } catch (e) {
            // Si ce n'est pas du JSON, utiliser la string directement
            return {'message': responseData, 'code': null};
          }
        }
      }
      
      // Si response.message existe, l'utiliser
      if (dioException.response?.statusMessage != null) {
        return {'message': dioException.response!.statusMessage, 'code': null};
      }
      
      // Fallback vers le message de l'exception
      if (dioException.message != null) {
        return {'message': dioException.message!, 'code': null};
      }
    } catch (e) {
      // Ignorer les erreurs d'extraction
    }

    return {'message': dioException.toString(), 'code': null};
  }

  /// Extrait les informations d'erreur depuis une string qui contient DioException
  static Map<String, String?> _extractFromDioExceptionString(dynamic dioExceptionString) {
    try {
      final errorString = dioExceptionString.toString();
      
      // Chercher le pattern JSON dans la string (ex: {"details": "Identifiants invalides"})
      final jsonMatch = RegExp(r'\{[^}]*"details"[^}]*\}').firstMatch(errorString);
      if (jsonMatch != null) {
        try {
          final json = jsonDecode(jsonMatch.group(0)!);
          final details = json['details']?.toString();
          if (details != null && details.isNotEmpty) {
            return {'message': details, 'code': null};
          }
        } catch (e) {
          // Ignorer si le parsing échoue
        }
      }

      // Chercher directement "details": "message"
      final detailsMatch = RegExp(r'"details"\s*:\s*"([^"]+)"').firstMatch(errorString);
      if (detailsMatch != null) {
        return {'message': detailsMatch.group(1), 'code': null};
      }

      // Chercher "message": "texte"
      final messageMatch = RegExp(r'"message"\s*:\s*"([^"]+)"').firstMatch(errorString);
      if (messageMatch != null) {
        return {'message': messageMatch.group(1), 'code': null};
      }
    } catch (e) {
      // Ignorer les erreurs d'extraction
    }

    return {'message': dioExceptionString.toString(), 'code': null};
  }

  /// Affiche un message d'erreur avec snackBar
  /// Priorise les messages spécifiques du backend sur les messages génériques
  static void showError({
    BuildContext? context,
    dynamic errorResponse,
    String? customMessage,
    Duration duration = const Duration(seconds: 4),
  }) {
    String message;
    
    if (customMessage != null) {
      message = customMessage;
    } else {
      final errorInfo = _extractErrorInfo(errorResponse);
      final errorCode = errorInfo['code'];
      final errorMessage = errorInfo['message'];
      
      // Si on a un message spécifique du backend, on essaie de le traduire
      // Sinon on utilise le code d'erreur ou un message générique
      if (errorMessage != null && errorMessage.isNotEmpty && 
          !errorMessage.toLowerCase().contains('internal server error') &&
          !errorMessage.toLowerCase().contains('erreur interne')) {
        // Essayer de traduire le message spécifique
        final translatedMessage = _getErrorTranslationFromMessage(errorMessage);
        
        // Si la traduction retourne un message différent (pas le message par défaut),
        // on l'utilise. Sinon, on affiche le message original du backend
        if (translatedMessage != LocaleKeys.somethingWentWrong.tr() ||
            errorMessage.length < 50) { // Si le message est court, c'est probablement un message spécifique
          message = translatedMessage;
        } else {
          // Afficher le message original du backend s'il est spécifique
          message = errorMessage;
        }
      } else if (errorCode != null && errorCode.isNotEmpty) {
        // Utiliser le code d'erreur pour la traduction
        message = _getErrorTranslationFromCode(errorCode);
      } else {
        // Fallback vers un message générique
        message = LocaleKeys.somethingWentWrong.tr();
      }
    }

    CustomSnackBar.show(
      context: context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
    );
  }

  /// Affiche un message de succès avec snackBar
  /// Utilise LocaleKeys directement, par exemple: LocaleKeys.successPaymentCompleted.tr()
  static void showSuccess({
    BuildContext? context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    CustomSnackBar.show(
      context: context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
    );
  }

  /// Affiche un message de succès personnalisé
  static void showSuccessMessage({
    BuildContext? context,
    required String message,
    Duration duration = const Duration(seconds: 3),
  }) {
    CustomSnackBar.show(
      context: context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
    );
  }
}

