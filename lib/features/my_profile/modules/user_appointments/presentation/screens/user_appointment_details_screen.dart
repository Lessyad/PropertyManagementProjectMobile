import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/constants/api_constants.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/services/convert_string_to_enum.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:flutter/material.dart';

import '../../domain/entities/appointment_entity.dart';

class UserAppointmentDetailsScreen extends StatelessWidget {
  final AppointmentEntity appointment;

  const UserAppointmentDetailsScreen({
    super.key,
    required this.appointment,
  });

  String get _title {
    if (appointment.propertyTitle.isNotEmpty) {
      return appointment.propertyTitle;
    }

    final type = getPropertyType(appointment.propertyType.toLowerCase()).toName;
    return "${LocaleKeys.preview.tr()} $type ${appointment.propertyArea} m2";
  }

  String get _propertyImageUrl {
    final image = appointment.propertyImage.trim();
    if (image.isEmpty || image.startsWith('http')) {
      return image;
    }

    final base = ApiConstants.baseUrl.replaceAll(RegExp(r'/api/.*'), '');
    final path = image.startsWith('/') ? image : '/$image';
    return '$base$path';
  }

  String get _sentToName {
    if (appointment.partnerName.isNotEmpty) {
      return appointment.partnerName;
    }
    return appointment.ownerName;
  }

  String get _sentToPhone {
    if (appointment.partnerPhone.isNotEmpty) {
      return appointment.partnerPhone;
    }
    return appointment.ownerPhone;
  }

  String get _formattedDate {
    if (appointment.date.isEmpty) {
      return '-';
    }

    final parsedDate = DateTime.tryParse(appointment.date);
    if (parsedDate == null) {
      return appointment.date;
    }

    return DateFormat('yyyy-MM-dd').format(parsedDate);
  }

  String get _formattedTime {
    if (appointment.time.isEmpty) {
      return '-';
    }

    final parts = appointment.time.split(':');
    if (parts.length >= 2) {
      return '${parts[0]}:${parts[1]}';
    }

    return appointment.time;
  }

  Color get _statusColor {
    switch (appointment.orderStatus) {
      case 'accepted':
        return ColorManager.greenColor;
      case 'cancelled':
        return ColorManager.redColor;
      default:
        return ColorManager.yellowColor;
    }
  }

  String get _statusText {
    switch (appointment.orderStatus) {
      case 'accepted':
        return 'Termine';
      case 'cancelled':
        return LocaleKeys.previewCancelled.tr();
      default:
        return 'A venir';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: LocaleKeys.myAppointments.tr(),
            showNotificationIcon: false,
            showLocationIcon: false,
            centerText: true,
            showBackIcon: true,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _AppointmentImage(imageUrl: _propertyImageUrl),
                        const SizedBox(height: 14),
                        Text(
                          _title,
                          style: getBoldStyle(
                            color: ColorManager.blackColor,
                            fontSize: FontSize.s18,
                          ),
                        ),
                        const SizedBox(height: 14),
                        _StatusBadge(
                          color: _statusColor,
                          text: _statusText,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: ColorManager.whiteColor,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Column(
                      children: [
                        _DetailRow(
                          iconPath: AppAssets.calendarIcon,
                          title: 'Date',
                          value: _formattedDate,
                          color: ColorManager.yellowColor,
                        ),
                        _DetailRow(
                          iconPath: AppAssets.clockIcon,
                          title: 'Heure',
                          value: _formattedTime,
                          color: ColorManager.yellowColor,
                        ),
                        _DetailRow(
                          iconPath: AppAssets.locationIcon,
                          title: 'Adresse',
                          value:
                              '${appointment.propertyCity} - ${appointment.propertyState} - ${appointment.propertyCountry}',
                        ),
                        _DetailRow(
                          iconPath: AppAssets.personIcon,
                          title: 'Demandeur',
                          value: appointment.clientName.isEmpty
                              ? '-'
                              : appointment.clientName,
                        ),
                        _DetailRow(
                          iconPath: AppAssets.envelopeIcon,
                          title: 'Envoye a',
                          value: _sentToName.isEmpty ? '-' : _sentToName,
                        ),
                        _DetailRow(
                          iconPath: AppAssets.phoneIcon,
                          title: 'Telephone',
                          value: _sentToPhone.isEmpty ? '-' : _sentToPhone,
                        ),
                        _DetailRow(
                          iconPath: AppAssets.myPropertiesIcon,
                          title: 'Sur quoi',
                          value: _title,
                        ),
                        _DetailRow(
                          iconPath: AppAssets.homeIcon,
                          title: 'Type de bien',
                          value: getPropertyType(
                            appointment.propertyType.toLowerCase(),
                          ).toName,
                        ),
                        _DetailRow(
                          iconPath: AppAssets.homeIcon,
                          title: 'Surface',
                          value: '${appointment.propertyArea} m2',
                        ),
                        _DetailRow(
                          iconPath: AppAssets.myAppointmentIcon,
                          title: 'Rendez-vous',
                          value: '#${appointment.id}',
                          showDivider: false,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentImage extends StatelessWidget {
  final String imageUrl;

  const _AppointmentImage({
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        width: double.infinity,
        height: 170,
        child: imageUrl.isEmpty
            ? const _ImagePlaceholder()
            : Image.network(
                imageUrl,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _ImagePlaceholder(),
              ),
      ),
    );
  }
}

class _ImagePlaceholder extends StatelessWidget {
  const _ImagePlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: ColorManager.grey3,
      alignment: Alignment.center,
      child: Icon(
        Icons.home_work_outlined,
        color: ColorManager.grey2,
        size: 44,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final Color color;
  final String text;

  const _StatusBadge({
    required this.color,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.12),
        borderRadius: BorderRadius.circular(18),
      ),
      child: Text(
        text,
        style: getBoldStyle(
          color: color,
          fontSize: FontSize.s14,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  final String iconPath;
  final String title;
  final String value;
  final Color? color;
  final bool showDivider;

  const _DetailRow({
    required this.iconPath,
    required this.title,
    required this.value,
    this.color,
    this.showDivider = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgImageComponent(
              width: 22,
              height: 22,
              iconPath: iconPath,
              color: color,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: getRegularStyle(
                      color: ColorManager.grey2,
                      fontSize: FontSize.s13,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: getBoldStyle(
                      color: ColorManager.blackColor,
                      fontSize: FontSize.s15,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        if (showDivider)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Divider(
              height: 1,
              color: ColorManager.grey3,
            ),
          ),
      ],
    );
  }
}
