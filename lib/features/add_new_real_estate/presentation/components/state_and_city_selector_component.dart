import 'package:easy_localization/easy_localization.dart'; // Ajouter cette importation
import 'package:enmaa/core/services/select_location_service/domain/entities/city_entity.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/services/select_location_service/presentation/controller/select_location_service_cubit.dart';
import 'package:enmaa/core/translation/locale_keys.dart'; // Ajouter cette importation

import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/components/custom_app_drop_down.dart';
import '../../../../configuration/managers/drop_down_style_manager.dart';
import '../../../../core/services/select_location_service/data/models/city_model.dart';
import 'form_widget_component.dart';

class StateCitySelectorComponent extends StatelessWidget {
  const StateCitySelectorComponent({super.key});

  @override
  Widget build(BuildContext context) {
    return FormWidgetComponent(
      label: LocaleKeys.selectStateAndCity.tr(), // ← Internationalisé
      content: Row(
        children: [
          // State Selector
          BlocBuilder<SelectLocationServiceCubit, SelectLocationServiceState>(
            buildWhen: (previous, current) =>
            previous.getStatesState != current.getStatesState ||
                previous.selectedState != current.selectedState || previous.states != current.states,
            builder: (context, state) {
              return Expanded(
                child: CustomDropdown<String>(
                  items: state.states.map((e) => e.name).toList(),
                  value: state.selectedState?.name,
                  onChanged: (value) {
                    context
                        .read<SelectLocationServiceCubit>()
                        .changeSelectedState(value!);
                  },
                  itemToString: (item) => item,
                  hint: Text(
                      LocaleKeys.state.tr(), // ← Internationalisé
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
              );
            },
          ),
          SizedBox(width: 10),
          // City Selector
          BlocBuilder<SelectLocationServiceCubit, SelectLocationServiceState>(
            buildWhen: (previous, current) =>
            previous.getCitiesState != current.getCitiesState ||
                previous.selectedCity != current.selectedCity || previous.cities != current.cities,
            builder: (context, state) {
              return Expanded(
                child: CustomDropdown<String>(
                  items: state.cities.map((e) => e.name).toList(),
                  value: state.selectedCity?.name,
                  onChanged: (value) {
                    context
                        .read<SelectLocationServiceCubit>()
                        .changeSelectedCity(value!);
                  },
                  itemToString: (item) => item,
                  hint: Text(
                      LocaleKeys.city.tr(), // ← Internationalisé
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
              );
            },
          ),
        ],
      ),
    );
  }
}