import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

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
    final formattedDate = _formatDate(notification.createdAt);
    final message = _displayMessage(notification);
    final backgroundColor =
        isRead ? ColorManager.whiteColor : ColorManager.primaryColor2;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        constraints: BoxConstraints(minHeight: context.scale(92)),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: isRead
                ? ColorManager.grey3.withValues(alpha: .45)
                : ColorManager.primaryColor.withValues(alpha: .08),
          ),
          boxShadow: [
            BoxShadow(
              color: ColorManager.blackColor.withValues(alpha: .04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    message,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                    style: getSemiBoldStyle(
                      color: ColorManager.blackColor,
                      fontSize: FontSize.s13,
                    ).copyWith(height: 1.35),
                  ),
                  const SizedBox(height: 12),
                  Align(
                    alignment: AlignmentDirectional.centerEnd,
                    child: Text(
                      formattedDate,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: getRegularStyle(
                        color: ColorManager.grey2,
                        fontSize: FontSize.s11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (!isRead) ...[
              const SizedBox(width: 8),
              Container(
                width: context.scale(8),
                height: context.scale(8),
                margin: const EdgeInsets.only(top: 4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: ColorManager.yellowColor,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  String _formatDate(String value) {
    try {
      return DateFormatterService.getFormattedDate(value);
    } catch (_) {
      return value;
    }
  }

  String _displayMessage(NotificationEntity notification) {
    final message = notification.message.trim();
    final title = notification.title.trim();

    if (message.isNotEmpty && !_isOnlyRawKey(message, title)) {
      return _translateNotificationMessage(message);
    }

    if (title.isNotEmpty) {
      return _translateNotificationMessage(title);
    }

    return message;
  }

  bool _isOnlyRawKey(String message, String title) {
    return message == title && _isKnownTranslationKey(message);
  }

  String _translateNotificationMessage(String value) {
    if (value.isEmpty) return value;

    final parts = value.split('|').map((part) => part.trim()).toList();
    final key = parts.first;

    if (!_isKnownTranslationKey(key)) {
      return value;
    }

    var translated = key.tr();
    if (translated == key) {
      translated = _fallbackTranslation(key);
    }
    translated = _replacePropertyPlaceholders(translated, key, parts);
    translated = _replaceVehiclePlaceholders(translated, key, parts);
    translated = _replaceWithdrawalPlaceholders(translated, key, parts);
    translated = _replaceErrorPlaceholders(translated, key, parts);

    return translated
        .replaceAll(RegExp(r'\s+-\s+\{licensePlate\}'), '')
        .replaceAll(RegExp(r'\s+pour\s+\{days\}\s+jours'), '')
        .replaceAll(RegExp(r'\s+for\s+\{days\}\s+days'), '')
        .replaceAll(RegExp(r'\s+لمدة\s+\{days\}\s+أيام'), '')
        .replaceAll(RegExp(r'\{[^}]+\}'), '')
        .replaceAll(RegExp(r'\s{2,}'), ' ')
        .trim();
  }

  String _replacePropertyPlaceholders(
    String translated,
    String key,
    List<String> parts,
  ) {
    if (!_propertyKeys.contains(key) || parts.length < 2) return translated;
    return translated.replaceAll('{propertyTitle}', parts[1]);
  }

  String _replaceVehiclePlaceholders(
    String translated,
    String key,
    List<String> parts,
  ) {
    if (!_vehicleKeys.contains(key)) return translated;

    final vehicleInfo = _parseVehicleInfo(parts);
    return translated
        .replaceAll('{vehicleModel}', vehicleInfo.model)
        .replaceAll('{licensePlate}', vehicleInfo.licensePlate)
        .replaceAll('{days}', vehicleInfo.days);
  }

  String _replaceWithdrawalPlaceholders(
    String translated,
    String key,
    List<String> parts,
  ) {
    if (!_withdrawalKeys.contains(key) || parts.length < 2) return translated;
    return translated.replaceAll('{amount}', parts[1]);
  }

  String _replaceErrorPlaceholders(
    String translated,
    String key,
    List<String> parts,
  ) {
    if (key == 'property_error_image_not_associated' && parts.length > 2) {
      return translated
          .replaceAll('{imageId}', parts[1])
          .replaceAll('{propertyId}', parts[2]);
    }

    if (key == 'property_error_invalid_amenities' && parts.length > 1) {
      return translated.replaceAll('{amenities}', parts[1]);
    }

    if (key == 'vehicle_error_invalid_status_transition' && parts.length > 2) {
      return translated
          .replaceAll('{currentStatus}', parts[1])
          .replaceAll('{newStatus}', parts[2]);
    }

    if ((key == 'vehicle_error_image_exceeds_limit' ||
            key == 'vehicle_error_invalid_image_format') &&
        parts.length > 1) {
      return translated.replaceAll('{fileName}', parts[1]);
    }

    return translated;
  }

  _VehicleNotificationInfo _parseVehicleInfo(List<String> parts) {
    if (parts.length >= 4) {
      return _VehicleNotificationInfo(parts[1], parts[2], parts[3]);
    }

    if (parts.length == 3) {
      return _VehicleNotificationInfo(parts[1], parts[2], '');
    }

    if (parts.length == 2) {
      final combined = parts[1];
      final separatorIndex = combined.indexOf(' - ');
      if (separatorIndex > -1) {
        return _VehicleNotificationInfo(
          combined.substring(0, separatorIndex).trim(),
          combined.substring(separatorIndex + 3).trim(),
          '',
        );
      }
      return _VehicleNotificationInfo(combined, '', '');
    }

    return const _VehicleNotificationInfo('', '', '');
  }

  bool _isKnownTranslationKey(String key) => _knownTranslationKeys.contains(key);

  String _fallbackTranslation(String key) {
    return switch (key) {
      'property_notification_rented' =>
        'La propriété {propertyTitle} a été louée',
      'property_notification_sold' =>
        'La propriété {propertyTitle} a été vendue',
      'vehicle_notification_rented' =>
        'Le véhicule {vehicleModel} - {licensePlate} a été loué pour {days} jours',
      'vehicle_notification_booked' =>
        'Votre réservation pour {vehicleModel} - {licensePlate} est confirmée pour {days} jours',
      'vehicle_notification_cancelled' =>
        'Votre location pour {vehicleModel} - {licensePlate} a été annulée',
      'vehicle_notification_client_cancelled' =>
        'Le client a annulé la location du {vehicleModel} - {licensePlate}',
      'withdrawal_notification_created' =>
        'Votre demande de retrait de {amount} MRU a été soumise',
      'withdrawal_notification_approved' =>
        'Votre retrait de {amount} MRU a été approuvé',
      'withdrawal_notification_rejected' =>
        'Votre demande de retrait de {amount} MRU a été rejetée',
      _ => key,
    };
  }

  static const Set<String> _propertyKeys = {
    'property_notification_rented',
    'property_notification_sold',
  };

  static const Set<String> _vehicleKeys = {
    'vehicle_notification_rented',
    'vehicle_notification_booked',
    'vehicle_notification_cancelled',
    'vehicle_notification_client_cancelled',
  };

  static const Set<String> _withdrawalKeys = {
    'withdrawal_notification_created',
    'withdrawal_notification_approved',
    'withdrawal_notification_rejected',
  };

  static const Set<String> _errorKeys = {
    'property_error_image_not_associated',
    'property_error_invalid_amenities',
    'vehicle_error_invalid_status_transition',
    'vehicle_error_image_exceeds_limit',
    'vehicle_error_invalid_image_format',
  };

  static const Set<String> _knownTranslationKeys = {
    ..._propertyKeys,
    ..._vehicleKeys,
    ..._withdrawalKeys,
    ..._errorKeys,
    'property_error_not_found',
    'property_error_cannot_update_pending_deals',
    'property_error_cannot_delete_pending_deals',
    'property_error_not_owner',
    'property_error_image_not_found',
    'property_error_cannot_delete_main_image',
    'property_error_invalid_subtype',
    'property_error_city_not_found',
    'property_error_invalid_operation',
    'property_error_monthly_rent_required',
    'property_error_monthly_rent_not_allowed',
    'property_error_user_not_found',
    'vehicle_error_not_found',
    'vehicle_error_not_authorized',
    'vehicle_error_user_id_required',
    'vehicle_error_user_not_found',
    'vehicle_error_full_name_phone_required',
    'vehicle_error_not_associated_with_partner',
    'vehicle_error_could_not_retrieve_after_creation',
    'vehicle_error_unauthorized_action',
    'vehicle_error_daily_price_must_be_positive',
    'vehicle_error_seats_must_be_between',
    'vehicle_error_at_least_one_image_required',
  };
}

class _VehicleNotificationInfo {
  const _VehicleNotificationInfo(this.model, this.licensePlate, this.days);

  final String model;
  final String licensePlate;
  final String days;
}
