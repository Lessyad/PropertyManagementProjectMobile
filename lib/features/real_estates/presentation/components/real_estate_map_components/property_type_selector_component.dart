import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/utils/enums.dart';
import '../../controller/filter_properties_controller/filter_property_cubit.dart';

class PropertyTypeSelectorComponent extends StatelessWidget {
  final Function(PropertyType?) onPropertyTypeChanged;

  const PropertyTypeSelectorComponent({
    Key? key,
    required this.onPropertyTypeChanged,
  }) : super(key: key);

  String _getPropertyTypeIcon(PropertyType type) {
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
  }

  String _getPropertyTypeLabel(PropertyType type) {
    switch (type) {
      case PropertyType.apartment:
        return type.toArabic;
      case PropertyType.villa:
        return 'فيلا';
      case PropertyType.building:
        return 'عمارة';
      case PropertyType.land:
        return 'أرض';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<FilterPropertyCubit, FilterPropertyState>(
      builder: (context, state) {
        final currentPropertyType =
            state.currentPropertyOperationType == PropertyOperationType.forSale
                ? state.salePropertyType
                : state.rentPropertyType;

        return Container(
          height: context.scale(50),
          padding: EdgeInsets.symmetric(horizontal: context.scale(8)),
          child: SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: context.scale(4)),
                  child: GestureDetector(
                    onTap: () {
                      if (currentPropertyType != null) {
                        onPropertyTypeChanged(null);
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: context.scale(12),
                        vertical: context.scale(8),
                      ),
                      decoration: BoxDecoration(
                        color: currentPropertyType == null
                            ? ColorManager.primaryColor
                            : ColorManager.greyShade,
                        borderRadius: BorderRadius.circular(context.scale(20)),
                      ),
                      child: Row(
                        children: [
                          SvgImageComponent(
                            iconPath: AppAssets.allIcon,
                            width: context.scale(20),
                            height: context.scale(20),
                            color: currentPropertyType == null
                                ? Colors.white
                                : ColorManager.blackColor,
                          ),
                          SizedBox(width: context.scale(8)),
                          Text(
                            'الكل',
                            style: TextStyle(
                              color: currentPropertyType == null
                                  ? Colors.white
                                  : ColorManager.blackColor,
                              fontSize: context.scale(12),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ...PropertyType.values.map((type) {
                  final isSelected = currentPropertyType == type;
                  return Padding(
                    padding: EdgeInsets.symmetric(horizontal: context.scale(4)),
                    child: GestureDetector(
                      onTap: () {
                        onPropertyTypeChanged(type);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.scale(12),
                          vertical: context.scale(8),
                        ),
                        decoration: BoxDecoration(
                          color: isSelected
                              ? ColorManager.primaryColor
                              : ColorManager.greyShade,
                          borderRadius:
                              BorderRadius.circular(context.scale(20)),
                        ),
                        child: Row(
                          children: [
                            SvgImageComponent(
                              iconPath: _getPropertyTypeIcon(type),
                              width: context.scale(20),
                              height: context.scale(20),
                              color: isSelected
                                  ? Colors.white
                                  : ColorManager.blackColor,
                            ),
                            SizedBox(width: context.scale(8)),
                            Text(
                              _getPropertyTypeLabel(type),
                              style: TextStyle(
                                color: isSelected
                                    ? Colors.white
                                    : ColorManager.blackColor,
                                fontSize: context.scale(12),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ],
            ),
          ),
        );
      },
    );
  }
}
