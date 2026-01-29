import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/apartment_type_extension.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:enmaa/features/real_estates/presentation/controller/filter_properties_controller/filter_property_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/components/multi_selector_component.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/components/reusable_type_selector_component.dart';
import '../../../../add_new_real_estate/presentation/components/form_widget_component.dart';

class ApartmentFiltrationSubTypesComponent extends StatelessWidget {
  const ApartmentFiltrationSubTypesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationRealEstateCubit = context.read<FilterPropertyCubit>();

    return Column(
      children: [
        BlocBuilder<FilterPropertyCubit, FilterPropertyState>(
          buildWhen: (previous, current) =>
          previous.selectedApartmentTypes != current.selectedApartmentTypes,
          builder: (context, state) {
            final selectedApartmentTypes = state.selectedApartmentTypes;

            return MultiSelectTypeSelectorComponent<ApartmentType>(
              values: ApartmentType.values,
              selectedTypes: selectedApartmentTypes,
              onToggle: (type) => filtrationRealEstateCubit.toggleApartmentType(type),
              getIcon: _getApartmentIcon,
              getLabel: _getApartmentLabel,
              selectorWidth: 114,
            );
          },
        ),


      ],
    );
  }

  String _getApartmentIcon(ApartmentType type) {
    switch (type) {
      case ApartmentType.duplex:
        return AppAssets.townhouseIcon;
      case ApartmentType.penthouse:
        return AppAssets.villaIcon;
      case ApartmentType.studio:
        return AppAssets.residentialBuildingIcon;
    }
  }

  String _getApartmentLabel(ApartmentType type) {
    switch (type) {
      case ApartmentType.duplex:
        return ' دوبلكس';
      case ApartmentType.penthouse:
        return ' بنتهاوس';
      case ApartmentType.studio:
        return ' ستوديو';
    }
  }


}