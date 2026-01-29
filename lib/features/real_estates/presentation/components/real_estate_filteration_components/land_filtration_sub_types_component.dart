import 'package:enmaa/core/extensions/property_sub_types/land_type_extension.dart';
import 'package:enmaa/features/real_estates/presentation/controller/filter_properties_controller/filter_property_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/components/multi_selector_component.dart';

class LandFiltrationSubTypesComponent extends StatelessWidget {
  const LandFiltrationSubTypesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationRealEstateCubit = context.read<FilterPropertyCubit>();

    return BlocBuilder<FilterPropertyCubit, FilterPropertyState>(
      buildWhen: (previous, current) =>
      previous.selectedLandTypes != current.selectedLandTypes,
      builder: (context, state) {
        final selectedLandTypes = state.selectedLandTypes;

        return MultiSelectTypeSelectorComponent<LandType>(
          values: LandType.values,
          selectedTypes: selectedLandTypes,
          onToggle: (type) => filtrationRealEstateCubit.toggleLandType(type),
          getIcon: _getLandIcon,
          getLabel: (type) => type.toArabic,
          selectorWidth: 114,
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
