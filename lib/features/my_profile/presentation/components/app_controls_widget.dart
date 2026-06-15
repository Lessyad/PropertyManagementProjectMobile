import 'package:dio/dio.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/services/auth_service.dart';
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
import '../../../home_module/home_imports.dart';
import 'package:flutter/material.dart';
import 'language_bottom_sheet_component.dart';
import 'remove_account_widget.dart';

class AppControlsWidget extends StatefulWidget {
  const AppControlsWidget({super.key});

  @override
  State<AppControlsWidget> createState() => _AppControlsWidgetState();
}

class _AppControlsWidgetState extends State<AppControlsWidget> {
  bool isDarkModeEnabled = false;
  bool areSettingsExpanded = false;
  bool areNotificationsEnabled =
      SharedPreferencesService().getValue('notifications_enabled') ?? true;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(20),
      ),
      padding: const EdgeInsets.all(16),
      child: AnimatedSize(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeInOut,
        child: Column(
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
              iconPath: AppAssets.privacyIcon,
              text: LocaleKeys.appControlsTerms.tr(),
              onTap: () {
                Navigator.pushNamed(context, RoutersNames.policiesContentScreen);
              },
            ),
            _buildItem(
              iconPath: AppAssets.themeIcon,
              leading: Icon(
                Icons.settings_outlined,
                size: 20,
                color: ColorManager.grey,
              ),
              text: _settingsLabel(context),
              onTap: () {
                setState(() {
                  areSettingsExpanded = !areSettingsExpanded;
                });
              },
              trailing: AnimatedRotation(
                turns: areSettingsExpanded ? 0.25 : 0,
                duration: const Duration(milliseconds: 180),
                child: const Icon(Icons.arrow_forward_ios),
              ),
            ),
            if (areSettingsExpanded) ...[
              const Divider(height: 12),
              _buildItem(
                iconPath: AppAssets.keyIcon,
                text: LocaleKeys.changePassword.tr(),
                onTap: () async {
                  if (AuthService.authStateNotifier.value) {
                    Navigator.pushNamed(
                        context, RoutersNames.changePasswordScreen);
                  } else {
                    LoginBottomSheet.show();
                  }
                },
              ),
              _buildSwitchItem(
                iconPath: AppAssets.notificationIcon,
                text: LocaleKeys.appControlsNotifications.tr(),
                value: areNotificationsEnabled,
                onChanged: (value) {
                  if (!AuthService.authStateNotifier.value) {
                    LoginBottomSheet.show();
                    return;
                  }
                  setState(() {
                    areNotificationsEnabled = value;
                  });
                  _updateNotificationAvailability(value);
                },
              ),
              _buildDeleteAccountItem(),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildItem({
    required String iconPath,
    required String text,
    required VoidCallback onTap,
    Widget? leading,
    Widget? trailing,
    Color? textColor,
  }) {
    return SizedBox(
      height: context.scale(48),
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            leading ??
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
                  color: textColor ?? ColorManager.blackColor,
                  fontSize: FontSize.s16,
                ),
              ),
            ),
            trailing ?? const Icon(Icons.arrow_forward_ios),
          ],
        ),
      ),
    );
  }

  String _settingsLabel(BuildContext context) {
    switch (context.locale.languageCode) {
      case 'fr':
        return 'Paramètres';
      case 'ar':
        return 'الإعدادات';
      default:
        return 'Settings';
    }
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

  Widget _buildDeleteAccountItem() {
    return ValueListenableBuilder<bool>(
      valueListenable: AuthService.authStateNotifier,
      builder: (context, isLoggedIn, _) {
        if (!isLoggedIn) return const SizedBox.shrink();

        return _buildItem(
          iconPath: AppAssets.trashIcon,
          text: LocaleKeys.removeAccountTitle.tr(),
          textColor: ColorManager.redColor,
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
                  widget: DeleteAccountComponent(
                    onDeleteConfirmed: () => _deleteAccount(context),
                  ),
                  headerText: '',
                );
              },
            );
          },
        );
      },
    );
  }

  Future<void> _deleteAccount(BuildContext context) async {
    final dio = ServiceLocator.getIt<DioService>();

    final result = await HandleRequestService.handleApiCall<void>(
      () async {
        await dio.delete(
          url: ApiConstants.user,
        );
      },
    );

    if (!mounted) return;

    result.fold(
      (failure) {
        CustomSnackBar.show(
          message: failure.message,
          type: SnackBarType.error,
        );
      },
      (_) {
        SharedPreferencesService().clearCachedData();
        CustomSnackBar.show(
          message: LocaleKeys.removeAccountSuccessMessage.tr(),
          type: SnackBarType.success,
        );
        Navigator.pushReplacementNamed(
            context, RoutersNames.authenticationFlow);
      },
    );
  }

  Future<void> _updateNotificationAvailability(bool newValue) async {
    final bool previousValue = !newValue;

    await SharedPreferencesService()
        .storeValue('notifications_enabled', newValue);

    final dio = ServiceLocator.getIt<DioService>();

    final result = await HandleRequestService.handleApiCall<void>(
      () async {
        await dio.patch(
          url: ApiConstants.user,
          data: {"notifications_enabled": newValue},
          options: Options(contentType: 'application/json'),
        );
      },
    );

    if (!mounted) return;

    result.fold(
      (failure) async {
        // Revert to the previous state on API error
        await SharedPreferencesService()
            .storeValue('notifications_enabled', previousValue);
        setState(() => areNotificationsEnabled = previousValue);
        CustomSnackBar.show(
          message: failure.message,
          type: SnackBarType.error,
        );
      },
      (_) {
        CustomSnackBar.show(
          message: LocaleKeys.successOperationCompleted.tr(),
          type: SnackBarType.success,
        );
      },
    );
  }
}
