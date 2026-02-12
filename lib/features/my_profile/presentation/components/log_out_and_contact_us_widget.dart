import 'package:enmaa/configuration/routers/route_names.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/components/button_app_component.dart';
import '../../../../core/components/custom_bottom_sheet.dart';
import '../../../../core/components/svg_image_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../../../main.dart';
import '../../../home_module/home_imports.dart';

class LogOutAndContactUsWidget extends StatelessWidget {
  const LogOutAndContactUsWidget({super.key});

  void _showLogoutConfirmationBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: ColorManager.greyShade,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return CustomBottomSheet(
          widget: LogoutComponent(
            onLogoutConfirmed: () {
              isAuth = false;
              // updateAuthState(false);
              SharedPreferencesService().clearCachedData();
              Navigator.pushReplacementNamed(context, RoutersNames.authenticationFlow);
            },
          ),
          headerText: '',
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Builder(
        builder: (BuildContext context) {
          final locale = context.locale;
          return Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            spacing: context.scale(20),
            children: [
              InkWell(
                onTap: () {
                  Navigator.pushNamed(context, RoutersNames.contactUsScreen);
                },
                child: Row(
                  children: [
                    SvgImageComponent(
                        width: 20, height: 20, iconPath: AppAssets.phoneIcon),
                    SizedBox(
                      width: context.scale(8),
                    ),
                    Text(
                      LocaleKeys.logOutAndContactUsContactUs.tr(),
                      style: getSemiBoldStyle(
                          color: ColorManager.blackColor, fontSize: FontSize.s16),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios),
                  ],
                ),
              ),
              InkWell(
                onTap: () async {
                  if (!isAuth) {
                    Navigator.pushNamed(context, RoutersNames.authenticationFlow);
                  } else {
                    _showLogoutConfirmationBottomSheet(context);
                  }
                },
                child: Row(
                  children: [
                    if (isAuth)
                      SvgImageComponent(
                          width: 20, height: 20, iconPath: AppAssets.logOutIcon),
                    if (!isAuth)
                      Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(3.1416),
                        child: SvgImageComponent(
                          width: 20,
                          height: 20,
                          iconPath: AppAssets.logOutIcon,
                        ),
                      ),
                    SizedBox(
                      width: context.scale(8),
                    ),
                    Text(
                      isAuth ? LocaleKeys.logOutAndContactUsLogOut.tr() : LocaleKeys.login.tr(),
                      style: getSemiBoldStyle(
                          color: ColorManager.blackColor, fontSize: FontSize.s16),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios),
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

class LogoutComponent extends StatelessWidget {
  final VoidCallback onLogoutConfirmed;

  const LogoutComponent({super.key, required this.onLogoutConfirmed});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SvgImageComponent(
          width: 80,
          height: 80,
          iconPath: AppAssets.logOutIcon,
          color: ColorManager.yellowColor,
        ),
        SizedBox(
          height: context.scale(20),
        ),
        Text(
          LocaleKeys.logOutConfirmation.tr(),
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s18,
          ),
        ),
        SizedBox(
          height: context.scale(4),
        ),
        Text(
          LocaleKeys.logOutWarning.tr(),
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          textAlign: TextAlign.center,
          style: getSemiBoldStyle(
            color: ColorManager.grey2,
            fontSize: FontSize.s14,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonAppComponent(
                width: 171,
                height: 46,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: ColorManager.grey3,
                  borderRadius: BorderRadius.circular(context.scale(24)),
                ),
                buttonContent: Center(
                  child: Text(
                    LocaleKeys.cancel.tr(),
                    style: getMediumStyle(
                      color: ColorManager.blackColor,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ButtonAppComponent(
                width: 171,
                height: 46,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  borderRadius: BorderRadius.circular(context.scale(24)),
                ),
                buttonContent: Center(
                  child: Text(
                    LocaleKeys.confirm.tr(),
                    style: getBoldStyle(
                      color: ColorManager.whiteColor,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
                onTap: () {
                  onLogoutConfirmed();
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}