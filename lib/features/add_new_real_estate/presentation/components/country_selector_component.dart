import 'package:easy_localization/easy_localization.dart'; // Ajouter cette importation
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/services/select_location_service/presentation/controller/select_location_service_cubit.dart';
import 'package:enmaa/core/translation/locale_keys.dart'; // Ajouter cette importation

import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/components/custom_app_drop_down.dart';
import '../../../../configuration/managers/drop_down_style_manager.dart';
import 'form_widget_component.dart';

class CountrySelectorComponent extends StatelessWidget {
  const CountrySelectorComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SelectLocationServiceCubit, SelectLocationServiceState>(
      buildWhen: (previous, current) =>
      previous.getCountriesState != current.getCountriesState ||
          previous.selectedCountry != current.selectedCountry ,
      builder: (context, state) {
        return FormWidgetComponent(
          label: LocaleKeys.selectCountry.tr(), // ← Internationalisé
          content: Row(
            children: [
              Expanded(
                child: CustomDropdown<String>(
                  items: state.countries.map((e) => e.name).toList(),
                  value: state.selectedCountry?.name,
                  onChanged: (value) {
                    context
                        .read<SelectLocationServiceCubit>()
                        .changeSelectedCountry(value!);
                  },
                  itemToString: (item) => item,
                  hint: Text(
                      LocaleKeys.country.tr(), // ← Internationalisé
                      style: TextStyle(fontSize: FontSize.s12)
                  ),
                  icon: Icon(Icons.keyboard_arrow_down, color: ColorManager.greyShade),
                  decoration: DropdownStyles.getDropdownDecoration(),
                  dropdownColor: ColorManager.whiteColor,
                  menuMaxHeight: 200,
                  style: getMediumStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s14,
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}