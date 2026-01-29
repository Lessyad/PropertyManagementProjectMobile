import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../../features/home_module/home_imports.dart';
import '../constants/app_assets.dart';
import '../translation/locale_keys.dart';

class ReservedComponent extends StatelessWidget {
  const ReservedComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.scale(80),
      height: context.scale(28),

      decoration: BoxDecoration(
        color: Color(0xFF423E3E),
        borderRadius: BorderRadius.circular(context.scale(24)),
      ),

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [

          SvgImageComponent(
            iconPath: AppAssets.lockIcon,
            width: 12,
            height: 12,
          ),

          SizedBox(
            width: context.scale(4),
          ),

          Text(
            LocaleKeys.reserved.tr(),
            style: getSemiBoldStyle(
              color: ColorManager.whiteColor,
              fontSize: FontSize.s10,
            ),
          ),
        ],
      ),

    ) ;
  }
}
