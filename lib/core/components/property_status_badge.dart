import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../extensions/context_extension.dart';
import '../translation/locale_keys.dart';

class PropertyStatusBadge extends StatelessWidget {
  const PropertyStatusBadge({
    super.key,
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    final normalizedStatus = status.trim().toLowerCase();
    final label = _statusLabel(normalizedStatus);

    if (label == null) {
      return const SizedBox.shrink();
    }

    return Container(
      constraints: BoxConstraints(minWidth: context.scale(64)),
      height: context.scale(26),
      padding: EdgeInsets.symmetric(horizontal: context.scale(10)),
      decoration: BoxDecoration(
        color: _statusColor(normalizedStatus),
        borderRadius: BorderRadius.circular(context.scale(18)),
      ),
      alignment: Alignment.center,
      child: Text(
        label,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: getSemiBoldStyle(
          color: ColorManager.whiteColor,
          fontSize: FontSize.s10,
        ),
      ),
    );
  }

  String? _statusLabel(String status) {
    return switch (status) {
      'reserved' || 'booked' => LocaleKeys.reserved.tr(),
      'rented' => LocaleKeys.rented.tr(),
      'sold' => LocaleKeys.sold.tr(),
      _ => null,
    };
  }

  Color _statusColor(String status) {
    return switch (status) {
      'sold' => ColorManager.redColor,
      'rented' => ColorManager.greenColor,
      _ => ColorManager.grey,
    };
  }
}
