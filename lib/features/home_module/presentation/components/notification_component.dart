import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../core/translation/locale_keys.dart';

import '../../../../core/services/dateformatter_service.dart';
import '../../../wish_list/favorite_imports.dart';
import '../../domain/entities/notification_entity.dart';

class NotificationComponent extends StatelessWidget {
  final NotificationEntity notification;
  final bool isRead;
  final VoidCallback? onTap;
  
  const NotificationComponent({
    super.key,
    required this.notification,
    required this.isRead,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final String formattedDate = DateFormatterService.getFormattedDate(notification.createdAt);

    return Container(
      height: context.scale(104),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isRead ? ColorManager.whiteColor: ColorManager.primaryColor2,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,

            children: [
              Container(
                width: context.scale(32),
                height: context.scale(32),
                padding: EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.primaryColor,
                ),
                child: SvgImageComponent(iconPath: AppAssets.notificationIcon),
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  _translateNotificationMessage(notification.message),
                  maxLines: 2,
                  style: getSemiBoldStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
            ],
          ),
          Spacer(),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                formattedDate,
                style: getRegularStyle(
                  color: ColorManager.grey2,
                  fontSize: FontSize.s12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Traduit le message de notification en utilisant les codes de traduction
  /// Format: "code|param1|param2|param3" ou simplement "code"
  String _translateNotificationMessage(String message) {
    if (message.isEmpty) return message;
    
    // Vérifier si le message contient des paramètres (format: code|param1|param2)
    if (message.contains('|')) {
      final parts = message.split('|');
      final translationKey = parts[0];
      
      // Obtenir la traduction
      String translated = _getTranslation(translationKey);
      
      // Remplacer les placeholders avec les paramètres
      if (translationKey == 'property_notification_rented' || 
          translationKey == 'property_notification_sold') {
        if (parts.length > 1) {
          translated = translated.replaceAll('{propertyTitle}', parts[1]);
        }
      } else if (translationKey == 'vehicle_notification_rented') {
        if (parts.length > 3) {
          translated = translated.replaceAll('{vehicleModel}', parts[1]);
          translated = translated.replaceAll('{licensePlate}', parts[2]);
          translated = translated.replaceAll('{days}', parts[3]);
        }
      } else if (translationKey == 'property_error_image_not_associated') {
        if (parts.length > 2) {
          translated = translated.replaceAll('{imageId}', parts[1]);
          translated = translated.replaceAll('{propertyId}', parts[2]);
        }
      } else if (translationKey == 'property_error_invalid_amenities') {
        if (parts.length > 1) {
          translated = translated.replaceAll('{amenities}', parts[1]);
        }
      } else if (translationKey == 'vehicle_error_invalid_status_transition') {
        if (parts.length > 2) {
          translated = translated.replaceAll('{currentStatus}', parts[1]);
          translated = translated.replaceAll('{newStatus}', parts[2]);
        }
      } else if (translationKey == 'vehicle_error_image_exceeds_limit' ||
                 translationKey == 'vehicle_error_invalid_image_format') {
        if (parts.length > 1) {
          translated = translated.replaceAll('{fileName}', parts[1]);
        }
      }
      
      return translated;
    } else {
      // Pas de paramètres, traduire directement
      return _getTranslation(message);
    }
  }

  /// Obtient la traduction pour une clé donnée
  String _getTranslation(String key) {
    try {
      // Essayer de trouver la clé dans LocaleKeys
      switch (key) {
        case 'property_notification_rented':
          return LocaleKeys.propertyNotificationRented.tr();
        case 'property_notification_sold':
          return LocaleKeys.propertyNotificationSold.tr();
        case 'vehicle_notification_rented':
          return LocaleKeys.vehicleNotificationRented.tr();
        case 'property_error_not_found':
          return LocaleKeys.propertyErrorNotFound.tr();
        case 'property_error_cannot_update_pending_deals':
          return LocaleKeys.propertyErrorCannotUpdatePendingDeals.tr();
        case 'property_error_cannot_delete_pending_deals':
          return LocaleKeys.propertyErrorCannotDeletePendingDeals.tr();
        case 'property_error_not_owner':
          return LocaleKeys.propertyErrorNotOwner.tr();
        case 'property_error_image_not_found':
          return LocaleKeys.propertyErrorImageNotFound.tr();
        case 'property_error_cannot_delete_main_image':
          return LocaleKeys.propertyErrorCannotDeleteMainImage.tr();
        case 'property_error_image_not_associated':
          return LocaleKeys.propertyErrorImageNotAssociated.tr();
        case 'property_error_invalid_subtype':
          return LocaleKeys.propertyErrorInvalidSubtype.tr();
        case 'property_error_city_not_found':
          return LocaleKeys.propertyErrorCityNotFound.tr();
        case 'property_error_invalid_amenities':
          return LocaleKeys.propertyErrorInvalidAmenities.tr();
        case 'property_error_invalid_operation':
          return LocaleKeys.propertyErrorInvalidOperation.tr();
        case 'property_error_monthly_rent_required':
          return LocaleKeys.propertyErrorMonthlyRentRequired.tr();
        case 'property_error_monthly_rent_not_allowed':
          return LocaleKeys.propertyErrorMonthlyRentNotAllowed.tr();
        case 'property_error_user_not_found':
          return LocaleKeys.propertyErrorUserNotFound.tr();
        case 'vehicle_error_not_found':
          return LocaleKeys.vehicleErrorNotFound.tr();
        case 'vehicle_error_not_authorized':
          return LocaleKeys.vehicleErrorNotAuthorized.tr();
        case 'vehicle_error_user_id_required':
          return LocaleKeys.vehicleErrorUserIdRequired.tr();
        case 'vehicle_error_user_not_found':
          return LocaleKeys.vehicleErrorUserNotFound.tr();
        case 'vehicle_error_full_name_phone_required':
          return LocaleKeys.vehicleErrorFullNamePhoneRequired.tr();
        case 'vehicle_error_not_associated_with_partner':
          return LocaleKeys.vehicleErrorNotAssociatedWithPartner.tr();
        case 'vehicle_error_could_not_retrieve_after_creation':
          return LocaleKeys.vehicleErrorCouldNotRetrieveAfterCreation.tr();
        case 'vehicle_error_unauthorized_action':
          return LocaleKeys.vehicleErrorUnauthorizedAction.tr();
        case 'vehicle_error_invalid_status_transition':
          return LocaleKeys.vehicleErrorInvalidStatusTransition.tr();
        case 'vehicle_error_daily_price_must_be_positive':
          return LocaleKeys.vehicleErrorDailyPriceMustBePositive.tr();
        case 'vehicle_error_seats_must_be_between':
          return LocaleKeys.vehicleErrorSeatsMustBeBetween.tr();
        case 'vehicle_error_at_least_one_image_required':
          return LocaleKeys.vehicleErrorAtLeastOneImageRequired.tr();
        case 'vehicle_error_image_exceeds_limit':
          return LocaleKeys.vehicleErrorImageExceedsLimit.tr();
        case 'vehicle_error_invalid_image_format':
          return LocaleKeys.vehicleErrorInvalidImageFormat.tr();
        default:
          // Si la clé n'est pas trouvée, retourner le message original
          return key;
      }
    } catch (e) {
      // En cas d'erreur, retourner le message original
      return key;
    }
  }
}