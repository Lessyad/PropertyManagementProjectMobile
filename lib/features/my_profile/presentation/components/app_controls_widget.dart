import 'package:dio/dio.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/custom_app_switch.dart';
import '../../../../core/components/custom_bottom_sheet.dart';
import '../../../../core/components/custom_snack_bar.dart';
import '../../../../core/components/need_to_login_component.dart';
import '../../../../core/constants/api_constants.dart';
import '../../../../core/services/dio_service.dart';
import '../../../../core/services/handle_api_request_service.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../main.dart';
import '../../../home_module/home_imports.dart';
import 'package:flutter/material.dart';
import 'language_bottom_sheet_component.dart';

class AppControlsWidget extends StatefulWidget {
  const AppControlsWidget({super.key});

  @override
  State<AppControlsWidget> createState() => _AppControlsWidgetState();
}

class _AppControlsWidgetState extends State<AppControlsWidget> {
  bool isDarkModeEnabled = false;
  bool areNotificationsEnabled = SharedPreferencesService().getValue('notifications_enabled') ?? true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.scale(280),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildItem(
                  iconPath: AppAssets.localizationIcon,
                  text: LocaleKeys.appControlsLanguage.tr(),
                  onTap: () {
                    showModalBottomSheet(
                      context: context,
                      backgroundColor: ColorManager.greyShade,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(25),
                        ),
                      ),
                      builder: (__) {
                        return CustomBottomSheet(
                          widget: LanguageBottomSheetComponent(),
                          padding: EdgeInsets.zero,
                          iconPath: AppAssets.localizationIcon,
                          headerText: LocaleKeys.appControlsLanguage.tr(),
                        );
                      },
                    );
                  },
                ),
                _buildItem(
                  iconPath: AppAssets.keyIcon,
                  text: LocaleKeys.changePassword.tr(),
                  onTap: () async {
                    if (isAuth) {
                      Navigator.pushNamed(context, RoutersNames.changePasswordScreen);
                    } else {
                      LoginBottomSheet.show();
                    }
                  },
                ),
                _buildItem(
                  iconPath: AppAssets.privacyIcon,
                  text: LocaleKeys.appControlsTerms.tr(),
                  onTap: () async {
                    final Uri url = Uri.parse('https://www.musabholding.com/');
                    if (await canLaunchUrl(url)) {
                      await launchUrl(url, mode: LaunchMode.externalApplication);
                    } else {
                      CustomSnackBar.show(
                        message: LocaleKeys.appControlsLinkError.tr(),
                        type: SnackBarType.error,
                      );
                    }
                  },
                ),
                // _buildSwitchItem(
                //   iconPath: AppAssets.themeIcon,
                //   text: LocaleKeys.appControlsDarkMode.tr(),
                //   value: isDarkModeEnabled,
                //   onChanged: (value) {
                //     // setState(() {
                //     //   isDarkModeEnabled = value;
                //     // });
                //   },
                // ),
                _buildSwitchItem(
                  iconPath: AppAssets.notificationIcon,
                  text: LocaleKeys.appControlsNotifications.tr(),
                  value: areNotificationsEnabled,
                  onChanged: (value) {
                    setState(() {
                      areNotificationsEnabled = value;
                    });
                    _updateNotificationAvailability(context, value);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildItem({
    required String iconPath,
    required String text,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: context.scale(48),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            SvgImageComponent(
              width: 20,
              height: 20,
              iconPath: iconPath,
              color: ColorManager.grey,
            ),
            SizedBox(width: context.scale(8)),
            Expanded(
              child: Text(
                text,
                style: getBoldStyle(
                  color: ColorManager.blackColor,
                  fontSize: FontSize.s16,
                ),
              ),
            ),
            const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required String iconPath,
    required String text,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return SizedBox(
      height: context.scale(48),
      child: Row(
        children: [
          SvgImageComponent(
            width: 20,
            height: 20,
            iconPath: iconPath,
            color: ColorManager.grey,
          ),
          SizedBox(width: context.scale(8)),
          Expanded(
            child: Text(
              text,
              style: getBoldStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s16,
              ),
            ),
          ),
          CustomAppSwitch(
            value: value,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }

  Future<void> _updateNotificationAvailability(BuildContext context, bool notificationAvailability) async {
    SharedPreferencesService().storeValue('notifications_enabled', notificationAvailability);

    final dio = ServiceLocator.getIt<DioService>();

    final result = await HandleRequestService.handleApiCall<void>(
          () async {
        final response = await dio.patch(
          url: ApiConstants.user,
          data: FormData.fromMap({
            "notifications_enabled": notificationAvailability,
          }),
          options: Options(contentType: 'multipart/form-data'),
        );
      },
    );

    result.fold(
          (failure) {
        SharedPreferencesService().storeValue('notifications_enabled', false);
        areNotificationsEnabled = false;
        setState(() {});
        CustomSnackBar.show(
          message: failure.message,
          type: SnackBarType.error,
        );
      },
          (_) {},
    );
  }
}