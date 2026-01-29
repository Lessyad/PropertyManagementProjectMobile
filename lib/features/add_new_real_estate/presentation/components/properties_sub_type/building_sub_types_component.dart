import 'package:enmaa/core/extensions/property_sub_types/building_type_extension.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/components/reusable_type_selector_component.dart';

class BuildingSubTypesComponent extends StatelessWidget {
  const BuildingSubTypesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final addNewRealEstateCubit = context.read<AddNewRealEstateCubit>();

    return BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
      builder: (context, state) {
        final currentBuildingType = state.currentBuildingType;

        return TypeSelectorComponent<BuildingType>(
          selectorWidth: 114,
          values: BuildingType.values,
          currentType: currentBuildingType,
          onTap: (type) => addNewRealEstateCubit.changeBuildingType(type),
          getIcon: _getBuildingIcon,
          getLabel: (type) => type.toArabic,
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
