import 'package:enmaa/core/extensions/property_sub_types/building_type_extension.dart';
import 'package:enmaa/features/real_estates/presentation/controller/filter_properties_controller/filter_property_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/components/multi_selector_component.dart';

class BuildingFiltrationSubTypesComponent extends StatelessWidget {
  const BuildingFiltrationSubTypesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationRealEstateCubit = context.read<FilterPropertyCubit>();

    return BlocBuilder<FilterPropertyCubit, FilterPropertyState>(
      buildWhen: (previous, current) =>
      previous.selectedBuildingTypes != current.selectedBuildingTypes,
      builder: (context, state) {
        final selectedBuildingTypes = state.selectedBuildingTypes;

        return MultiSelectTypeSelectorComponent<BuildingType>(
          values: BuildingType.values,
          selectedTypes: selectedBuildingTypes,
          onToggle: (type) => filtrationRealEstateCubit.toggleBuildingType(type),
          getIcon: _getBuildingIcon,
          getLabel: (type) => type.toArabic,
          selectorWidth: 114,
        );
      },
    );
  }

  String _getBuildingIcon(BuildingType type) {
    switch (type) {
      case BuildingType.residential:
        return AppAssets.residentialBuildingIcon2;
      case BuildingType.commercial:
        return AppAssets.commercialBuildingIcon;
      case BuildingType.mixedUse:
        return AppAssets.mixedUseBuildingIcon;
    }
  }
}