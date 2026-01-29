import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/configuration/routers/app_routers.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/need_to_login_component.dart';
import '../../../../core/components/svg_image_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../home_module/home_imports.dart';

class ManageMyPropertiesWidget extends StatelessWidget {
  const ManageMyPropertiesWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        if (isAuth) {
          Navigator.pushNamed(context, RoutersNames.myPropertiesScreen);
        } else {
          LoginBottomSheet.show();
        }
      },
      child: Container(
        width: double.infinity,
        height: context.scale(108),
        decoration: BoxDecoration(
          color: ColorManager.whiteColor,
          borderRadius: BorderRadius.circular(20),
        ),
        padding: const EdgeInsets.all(16),
        child: Builder(
          builder: (BuildContext context) {
            final locale = context.locale;
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text(
                        LocaleKeys.managePropertiesTitle.tr(),
                        style: getBoldStyle(
                            color: ColorManager.primaryColor, fontSize: FontSize.s18),
                      ),
                      Text(
                        LocaleKeys.managePropertiesDescription.tr(),
                        style: getSemiBoldStyle(
                            color: ColorManager.blackColor, fontSize: FontSize.s14),
                      ),
                    ],
                  ),
                ),
                SvgImageComponent(
                  iconPath: AppAssets.myPropertiesIcon,
                  width: context.scale(90),
                  height: context.scale(64),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}