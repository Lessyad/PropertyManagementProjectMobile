import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../constants/app_assets.dart';
import '../extensions/context_extension.dart';
import '../translation/locale_keys.dart';
import 'svg_image_component.dart';

class MyPropertyBadge extends StatelessWidget {
  const MyPropertyBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scale(10),
        vertical: context.scale(8),
      ),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor.withValues(alpha: 0.55),
        borderRadius: BorderRadius.circular(context.scale(14)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: EdgeInsets.all(context.scale(6)),
            decoration: BoxDecoration(
              color: ColorManager.yellowColor,
              shape: BoxShape.circle,
            ),
            child: SvgImageComponent(
              iconPath: AppAssets.personIcon,
              width: 14,
              height: 14,
              color: ColorManager.whiteColor,
            ),
          ),
          SizedBox(width: context.scale(8)),
          Text(
            LocaleKeys.myProperty.tr(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: getSemiBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s11,
            ),
          ),
        ],
      ),
    );
  }
}
