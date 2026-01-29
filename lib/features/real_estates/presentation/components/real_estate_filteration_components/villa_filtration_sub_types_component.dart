import 'package:enmaa/core/extensions/property_sub_types/villa_type_extension.dart';
import 'package:enmaa/features/real_estates/presentation/controller/filter_properties_controller/filter_property_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/components/multi_selector_component.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/components/reusable_type_selector_component.dart';

class VillaFiltrationSubTypesComponent extends StatelessWidget {
  const VillaFiltrationSubTypesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final filtrationRealEstateCubit = context.read<FilterPropertyCubit>();

    return BlocBuilder<FilterPropertyCubit, FilterPropertyState>(
      buildWhen: (previous, current) =>
      previous.selectedVillaTypes != current.selectedVillaTypes,
      builder: (context, state) {
        final selectedVillaTypes = state.selectedVillaTypes;

        return MultiSelectTypeSelectorComponent<VillaType>(
          values: VillaType.values,
          selectedTypes: selectedVillaTypes,
          onToggle: (type) => filtrationRealEstateCubit.toggleVillaType(type),
          getIcon: _getVillaIcon,
          getLabel: (type) => type.toArabic,
          selectorWidth: 114,
        );
      },
    );
  }

  String _getVillaIcon(VillaType type) {
    switch (type) {
      case VillaType.standalone:
        return AppAssets.villaIcon;
      case VillaType.twinHouse:
        return AppAssets.townhouseIcon;
      case VillaType.townHouse:
        return AppAssets.residentialBuildingIcon;
    }
  }
}
