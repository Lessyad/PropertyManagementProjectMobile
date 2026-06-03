import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../core/components/currency_display_widget.dart';
import '../../../../../../core/components/custom_image.dart';
import '../../../../../../core/components/svg_image_component.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/services/dateformatter_service.dart';
import '../../../../../../core/translation/locale_keys.dart';
import '../../domain/entity/rental_history_entity.dart';

class RentalHistoryCard extends StatelessWidget {
  final RentalHistoryEntity rental;

  const RentalHistoryCard({
    super.key,
    required this.rental,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(16),
      ),
      padding: const EdgeInsets.all(12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: CustomNetworkImage(
              image: rental.propertyImage,
              width: context.scale(88),
              height: context.scale(88),
              fit: BoxFit.cover,
            ),
          ),
          SizedBox(width: context.scale(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Text(
                        _title(context),
                        style: getBoldStyle(
                          color: ColorManager.blackColor,
                          fontSize: FontSize.s15,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _StatusBadge(status: rental.dealStatus),
                  ],
                ),
                const SizedBox(height: 8),
                _IconText(
                  iconPath: AppAssets.locationIcon,
                  text: _location,
                  color: ColorManager.grey,
                ),
                const SizedBox(height: 6),
                _IconText(
                  iconPath: AppAssets.calendarIcon,
                  text: _period,
                  color: ColorManager.yellowColor,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Text(
                      '${LocaleKeys.totalAmount.tr()}: ',
                      style: getMediumStyle(
                        color: ColorManager.grey,
                        fontSize: FontSize.s12,
                      ),
                    ),
                    CurrencyDisplayWidget(
                      amount: rental.totalAmount,
                      textColor: ColorManager.blackColor,
                      fontSize: FontSize.s12,
                      fontWeight: FontWeight.w700,
                    ),
                    const Spacer(),
                    if (rental.userRole.isNotEmpty)
                      Text(
                        rental.userRole == 'owner' ? 'Owner' : 'Client',
                        style: getMediumStyle(
                          color: ColorManager.primaryColor,
                          fontSize: FontSize.s11,
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _title(BuildContext context) {
    final area = rental.propertyArea == 0
        ? ''
        : '${rental.propertyArea.toStringAsFixed(0)} ${LocaleKeys.areaUnit.tr()}';
    final title = rental.propertyTitle.isNotEmpty
        ? rental.propertyTitle
        : rental.propertyType;
    return [title, area].where((item) => item.isNotEmpty).join(' - ');
  }

  String get _location {
    return [
      rental.propertyCity,
      rental.propertyState,
      rental.propertyCountry,
    ].where((item) => item.isNotEmpty).join(' - ');
  }

  String get _period {
    final start = _formatDate(rental.startDate);
    final end = _formatDate(rental.endDate);
    if (start.isEmpty && end.isEmpty) return '-';
    return '$start - $end';
  }

  String _formatDate(String? value) {
    if (value == null || value.isEmpty) return '';
    return DateFormatterService.getFormattedDate(value);
  }
}

class _IconText extends StatelessWidget {
  final String iconPath;
  final String text;
  final Color color;

  const _IconText({
    required this.iconPath,
    required this.text,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgImageComponent(
          width: 16,
          height: 16,
          iconPath: iconPath,
          color: color,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: getRegularStyle(
              color: color,
              fontSize: FontSize.s12,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}

class _StatusBadge extends StatelessWidget {
  final String status;

  const _StatusBadge({required this.status});

  @override
  Widget build(BuildContext context) {
    final normalized = status.toLowerCase();
    final color = switch (normalized) {
      'completed' => ColorManager.greenColor,
      'cancelled' => ColorManager.redColor,
      'confirmed' => ColorManager.primaryColor,
      _ => ColorManager.yellowColor,
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: color.withOpacity(.12),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        status.isEmpty ? '-' : status,
        style: getBoldStyle(
          color: color,
          fontSize: FontSize.s10,
        ),
      ),
    );
  }
}
