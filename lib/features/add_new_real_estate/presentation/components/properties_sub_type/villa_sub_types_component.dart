import 'package:enmaa/core/extensions/property_sub_types/villa_type_extension.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart';

import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../../core/components/reusable_type_selector_component.dart';

class VillaSubTypesComponent extends StatelessWidget {
  const VillaSubTypesComponent({super.key});

  @override
  Widget build(BuildContext context) {
    final addNewRealEstateCubit = context.read<AddNewRealEstateCubit>();

    return BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
      builder: (context, state) {
        final currentVillaType = state.currentVillaType;

        return TypeSelectorComponent<VillaType>(
          selectorWidth: 114,
          values: VillaType.values,
          currentType: currentVillaType,
          onTap: (type) => addNewRealEstateCubit.changeVillaType(type),
          getIcon: _getVillaIcon,
          getLabel: (type) => type.toArabic,
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
