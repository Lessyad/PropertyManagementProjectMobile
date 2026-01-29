import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../core/components/reusable_type_selector_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/utils/enums.dart';
import '../../../home_module/home_imports.dart';
import '../controller/filter_properties_controller/filter_property_cubit.dart';

class PropertyTypeCategoryButtons extends StatelessWidget {
  const PropertyTypeCategoryButtons({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterPropertyCubit, FilterPropertyState>(
      buildWhen: (previous, current) =>
      previous.currentPropertyType != current.currentPropertyType,
      builder: (context, state) {
        final PropertyType? currentType = state.currentPropertyType;
        return TypeSelectorComponent<PropertyType>(
          selectorWidth: 82,
          values: PropertyType.values,
          currentType: currentType,
          onTap: (type) =>
              context.read<FilterPropertyCubit>().changePropertyType(type),
          getIcon: (type) {
            switch (type) {
              case PropertyType.apartment:
                return AppAssets.apartmentIcon;
              case PropertyType.villa:
                return AppAssets.villaIcon;
              case PropertyType.building:
                return AppAssets.residentialBuildingIcon;
              case PropertyType.land:
                return AppAssets.landIcon;
            }
          },
          getLabel: (type) {
            switch (type) {
              case PropertyType.apartment:
                return type.toArabic;
              case PropertyType.villa:
                return ' فيلا';
              case PropertyType.building:
                return ' عمارة';
              case PropertyType.land:
                return ' أرض';
            }
          },
        );
      },
    );
  }
}
