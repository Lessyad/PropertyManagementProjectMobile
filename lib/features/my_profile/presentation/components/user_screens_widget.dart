import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/main.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/need_to_login_component.dart';
import '../../../home_module/home_imports.dart';

class UserScreensWidget extends StatelessWidget {
  const UserScreensWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.scale(112),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Builder(
        builder: (context) {
          final locale = context.locale;
          return Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    InkWell(
                      onTap: () {
                        if (isAuth) {
                          Navigator.pushNamed(context, RoutersNames.userAppointmentsScreen);
                        } else {
                          LoginBottomSheet.show();
                        }
                      },
                      child: Row(
                        children: [
                          SvgImageComponent(
                            width: 20,
                            height: 20,
                            iconPath: AppAssets.myAppointmentIcon,
                            color: ColorManager.grey,
                          ),
                          SizedBox(width: context.scale(8)),
                          Text(
                            LocaleKeys.userScreensAppointments.tr(),
                            style: getBoldStyle(
                                color: ColorManager.blackColor, fontSize: FontSize.s16),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        if (isAuth) {
                          Navigator.pushNamed(context, RoutersNames.userElectronicContracts);
                        } else {
                          LoginBottomSheet.show();
                        }
                      },
                      child: Row(
                        children: [
                          SvgImageComponent(
                            width: 20,
                            height: 20,
                            iconPath: AppAssets.electronicContractIcon,
                            color: ColorManager.grey,
                          ),
                          SizedBox(width: context.scale(8)),
                          Text(
                            LocaleKeys.userScreensElectronicContracts.tr(),
                            style: getBoldStyle(
                                color: ColorManager.blackColor, fontSize: FontSize.s16),
                          ),
                          Spacer(),
                          Icon(Icons.arrow_forward_ios),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}