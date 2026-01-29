import 'package:country_code_picker/country_code_picker.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:flutter/material.dart';
import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../constants/local_keys.dart';

class CustomCountryCodePicker extends StatelessWidget {
  final Function(CountryCode countryCode) onChanged;
  final String initialSelection;
  final List<String> favoriteCountries;

  final bool disableSelection;
  const CustomCountryCodePicker({
    super.key,
    this.disableSelection = false ,
    required this.onChanged,
    this.initialSelection = 'EG',
    this.favoriteCountries = const [
      '+20', 'EG', // Egypt
      '+966', 'SA', // Saudi Arabia
      '+222', 'MR', // Mauritania
      '+212', 'MA', // Morocco
      '+971', 'AE', // United Arab Emirates (UAE)
    ],
  });

  @override
  Widget build(BuildContext context) {
    String savedCountryCode = SharedPreferencesService()
        .getValue(LocalKeys.countryCodeISO) ?? 'EG';
    return CountryCodePicker(
      // onChanged: onChanged,
      onChanged: (countryCode) {
        // Sauvegarder à la fois le code ISO et le numéro
        SharedPreferencesService().storeValue(
            LocalKeys.countryCodeISO,
            countryCode.code ?? 'EG'
        );
        SharedPreferencesService().storeValue(
            LocalKeys.countryCodeNumber,
            countryCode.dialCode ?? '+20'
        );
        onChanged(countryCode);
      },
      // initialSelection: SharedPreferencesService().getValue(LocalKeys.countryCodeNumber) ?? '+20',
      initialSelection: savedCountryCode,
      favorite: favoriteCountries,
      showCountryOnly: false,
      showOnlyCountryWhenClosed: false,
      enabled: !disableSelection,
      alignLeft: false,
      showFlag: true,
      dialogSize: Size(
        context.screenWidth * 0.9,
        context.screenHeight * 0.7,
      ),
      padding: EdgeInsets.zero,
      textStyle: getRegularStyle(
        color: ColorManager.blackColor,
        fontSize: FontSize.s12,
      ),
      builder: (CountryCode? countryCode) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            if(!disableSelection)...[
              Icon(
                Icons.arrow_drop_down,
                color: ColorManager.grey,
              ),
              SizedBox(width: context.scale(8)),
            ],

            if (countryCode != null)
              Image.asset(
                countryCode.flagUri!,
                package: 'country_code_picker',
                width: context.scale(24),
                height: context.scale(16),
              ),
          ],
        );
      },
    );
  }
}