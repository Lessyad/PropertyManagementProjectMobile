import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:enmaa/configuration/managers/drop_down_style_manager.dart';
import 'package:enmaa/core/components/button_app_component.dart';
import 'package:enmaa/core/components/custom_app_drop_down.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';

import '../../../../core/services/change_user_language_function.dart';

class LanguageBottomSheetComponent extends StatefulWidget {
  const LanguageBottomSheetComponent({super.key});

  @override
  State<LanguageBottomSheetComponent> createState() => _LanguageBottomSheetComponentState();
}

class _LanguageBottomSheetComponentState extends State<LanguageBottomSheetComponent> {
  Locale? _selectedLocale;
  final GlobalKey _dropdownKey = GlobalKey();
  bool _isDropdownOpen = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _selectedLocale = context.locale;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                LocaleKeys.languageSheetTitle.tr(),
                style: getBoldStyle(color: ColorManager.blackColor, fontSize: FontSize.s16),
              ),
              SizedBox(height: context.scale(8)),
              CustomDropdown<Locale>(
                key: _dropdownKey,
                items: [
                  const Locale('en'),
                  const Locale('ar'),
                  const Locale('fr'),
                ],
                menuMaxHeight: context.scale(90),
                decoration: DropdownStyles.getDropdownDecoration(),
                dropdownColor: ColorManager.whiteColor,
                value: _selectedLocale,
                onMenuStateChange: (isOpen) {
                  setState(() {
                    _isDropdownOpen = isOpen;
                  });
                },
                itemBuilder: (Locale locale) {
                  switch (locale.languageCode) {
                    case 'ar':
                      return Text(
                        LocaleKeys.arabic.tr(),
                        style: getBoldStyle(color: ColorManager.blackColor),
                      );
                    case 'fr':
                      return Text(
                        LocaleKeys.french.tr(),
                        style: getBoldStyle(color: ColorManager.blackColor),
                      );
                    default:
                      return Text(
                        LocaleKeys.english.tr(),
                        style: getBoldStyle(color: ColorManager.blackColor),
                      );
                  }
                },
                onChanged: (Locale? newLocale) {
                  setState(() {
                    _selectedLocale = newLocale;
                  });
                },
              ),
              SizedBox(height: context.scale(24)),
            ],
          ),
        ),
        Container(
          height: context.scale(88),
          padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
          decoration: BoxDecoration(
            color: ColorManager.whiteColor,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(context.scale(24)),
              topRight: Radius.circular(context.scale(24)),
            ),
          ),
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
                    LocaleKeys.languageSheetCancel.tr(),
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
                    LocaleKeys.languageSheetConfirm.tr(),
                    style: getBoldStyle(
                      color: ColorManager.whiteColor,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
                onTap: () async {
                  if (_selectedLocale != null) {
                    await SharedPreferencesService().setLanguage(_selectedLocale!.languageCode);
                    updateUserLanguage(_selectedLocale!.languageCode);
                    context.setLocale(_selectedLocale!);
                  }
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