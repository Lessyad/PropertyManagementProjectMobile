import 'package:enmaa/core/extensions/property_sub_types/land_type_extension.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/components/reusable_type_selector_component.dart';

class LandSubTypesComponent extends StatelessWidget {
  const LandSubTypesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final addNewRealEstateCubit = context.read<AddNewRealEstateCubit>();

    return BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
      builder: (context, state) {
        final currentLandType = state.currentLandType;

        return TypeSelectorComponent<LandType>(
          selectorWidth: 114,
          values: LandType.values,
          currentType: currentLandType,
          onTap: (type) => addNewRealEstateCubit.changeLandType(type),
          getIcon: _getLandIcon,
          getLabel: (type) => type.toArabic,
        );
      },
    );
  }

  String _getLandIcon(LandType type) {
    switch (type) {
      case LandType.freehold:
        return AppAssets.freeholdLandIcon;
      case LandType.agricultural:
        return AppAssets.agricultureLandIcon;
      case LandType.industrial:
        return AppAssets.industrialLandIcon;
    }
  }
}
