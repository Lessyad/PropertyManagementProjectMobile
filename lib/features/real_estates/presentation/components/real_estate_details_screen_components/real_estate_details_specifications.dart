import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/apartment_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/building_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/land_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/villa_type_extension.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/services/convert_string_to_enum.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/real_estates/domain/entities/apartment_details_entity.dart';
import 'package:enmaa/features/real_estates/domain/entities/builidng_details_entity.dart';
import 'package:enmaa/features/real_estates/domain/entities/land_details_entity.dart';
import 'package:enmaa/features/real_estates/domain/entities/property_details_entity.dart';
import 'package:enmaa/features/real_estates/domain/entities/villa_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/components/svg_image_component.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/translation/locale_keys.dart';

class RealEstateDetailsSpecifications extends StatelessWidget {
  const RealEstateDetailsSpecifications({
    super.key,
    required this.currentProperty,
  });

  final BasePropertyDetailsEntity currentProperty;

  @override
  Widget build(BuildContext context) {
    final isVilla = currentProperty is VillaDetailsEntity;
    final isApartment = currentProperty is ApartmentDetailsEntity;
    final isLand = currentProperty is LandDetailsEntity;
    final isBuilding = currentProperty is BuildingDetailsEntity;

    final villa = isVilla ? currentProperty as VillaDetailsEntity : null;
    final apartment = isApartment ? currentProperty as ApartmentDetailsEntity : null;
    final land = isLand ? currentProperty as LandDetailsEntity : null;
    final building = isBuilding ? currentProperty as BuildingDetailsEntity : null;

    final List<Map<String, String>> specifications = _getSpecifications(
      villa: villa,
      apartment: apartment,
      land: land,
      building: building,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.propertyDetailsLabel.tr(),
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: context.scale(16)),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          decoration: BoxDecoration(
            color: ColorManager.whiteColor,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: _buildSpecificationsGrid(specifications),
        ),
      ],
    );
  }

  List<Map<String, String>> _getSpecifications({
    VillaDetailsEntity? villa,
    ApartmentDetailsEntity? apartment,
    LandDetailsEntity? land,
    BuildingDetailsEntity? building,
  }) {
    if (villa != null) {
      return [
        {'icon': AppAssets.villaIcon, 'text': PropertyType.villa.toName},
        {'icon': AppAssets.independentPropertyIcon, 'text': getVillaType(villa.propertySubType).toName},
        {
          'icon': villa.isFurnished ? AppAssets.furnishedIcon : AppAssets.emptyIcon,
          'text': villa.isFurnished ? LocaleKeys.furnished.tr() : LocaleKeys.unfurnished.tr(),
        },
        {'icon': AppAssets.areaIcon, 'text': villa.area.toString()},
        {
          'icon': AppAssets.forSellIcon,
          'text': villa.operation == 'for_rent' ? LocaleKeys.forRent.tr() : LocaleKeys.forSale.tr(),
        },
        if (villa.operation == 'for_rent' && villa.monthlyRentPeriod != null && villa.monthlyRentPeriod!.isNotEmpty)
          {
            'icon': AppAssets.calendarIcon,
            'text': "${villa.monthlyRentPeriod} ${LocaleKeys.months.tr()}"
          },
        {'icon': AppAssets.landIcon, 'text': '${villa.numberOfFloors} ${LocaleKeys.floors.tr()}'},
        {'icon': AppAssets.bedIcon, 'text': villa.rooms.toString()},
        {'icon': AppAssets.bathIcon, 'text': villa.bathrooms.toString()},
      ];
    } else if (apartment != null) {
      return [
        {'icon': AppAssets.apartmentIcon, 'text': PropertyType.apartment.toName},
        {'icon': AppAssets.twinHouseIcon, 'text': getApartmentType(apartment.propertySubType).toName},
        {
          'icon': apartment.isFurnished ? AppAssets.furnishedIcon : AppAssets.emptyIcon,
          'text': apartment.isFurnished ? LocaleKeys.furnished.tr() : LocaleKeys.unfurnished.tr(),
        },
        {'icon': AppAssets.areaIcon, 'text': apartment.area.toString()},
        {
          'icon': AppAssets.forSellIcon,
          'text': apartment.operation == 'for_rent' ? LocaleKeys.forRent.tr() : LocaleKeys.forSale.tr(),
        },
        if (apartment.operation == 'for_rent' && apartment.monthlyRentPeriod != null && apartment.monthlyRentPeriod!.isNotEmpty)
          {
            'icon': AppAssets.calendarIcon,
            'text': "${apartment.monthlyRentPeriod} ${LocaleKeys.months.tr()}"
          },
        {'icon': AppAssets.landIcon, 'text': '${apartment.floor} ${LocaleKeys.floor.tr()}'},
        {'icon': AppAssets.bedIcon, 'text': apartment.rooms.toString()},
        {'icon': AppAssets.bathIcon, 'text': apartment.bathrooms.toString()},
      ];
    } else if (building != null) {
      return [
        {'icon': AppAssets.residentialBuildingIcon, 'text': PropertyType.building.toName},
        {'icon': AppAssets.twinHouseIcon, 'text': getBuildingType(building.propertySubType).toName},
        {'icon': AppAssets.areaIcon, 'text': building.area.toString()},
        {
          'icon': AppAssets.forSellIcon,
          'text': building.operation == 'for_rent' ? LocaleKeys.forRent.tr() : LocaleKeys.forSale.tr(),
        },
        if (building.operation == 'for_rent' && building.monthlyRentPeriod != null && building.monthlyRentPeriod!.isNotEmpty)
          {
            'icon': AppAssets.calendarIcon,
            'text': "${building.monthlyRentPeriod} ${LocaleKeys.months.tr()}"
          },
        {'icon': AppAssets.landIcon, 'text': '${building.numberOfFloors} ${LocaleKeys.floors.tr()}'},
        {'icon': AppAssets.apartmentIcon, 'text': building.numberOfApartmentsPerFloor.toString()},
      ];
    } else if (land != null) {
      return [
        {'icon': AppAssets.landIcon, 'text': PropertyType.land.toName},
        {'icon': AppAssets.independentPropertyIcon, 'text': getLandType(land.propertySubType).toName},
        {'icon': AppAssets.areaIcon, 'text': land.area.toString()},
        {
          'icon': AppAssets.forSellIcon,
          'text': land.operation == 'for_rent' ? LocaleKeys.forRent.tr() : LocaleKeys.forSale.tr(),
        },
        if (land.operation == 'for_rent' && land.monthlyRentPeriod != null && land.monthlyRentPeriod!.isNotEmpty)
          {
            'icon': AppAssets.calendarIcon,
            'text': "${land.monthlyRentPeriod} ${LocaleKeys.months.tr()}"
          },
        {
          'icon': AppAssets.readyForBuilding,
          'text': land.isLicensed ? LocaleKeys.readyForBuilding.tr() : LocaleKeys.notReadyForBuilding.tr(),
        },
      ];
    } else {
      return [];
    }
  }

  Widget _buildSpecificationsGrid(List<Map<String, String>> specifications) {
    return GridView.builder(
      shrinkWrap: true,
      padding: EdgeInsets.zero,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 0,
        childAspectRatio: 3.5,
      ),
      itemCount: specifications.length,
      itemBuilder: (context, index) {
        final item = specifications[index];
        return _buildItem(
          iconPath: item['icon'],
          text: item['text']!,
        );
      },
    );
  }

  Widget _buildItem({
    String? iconPath,
    Widget? iconWidget,
    required String text,
    Color? iconColor,
    TextStyle? textStyle,
  }) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        iconWidget ??
            SvgImageComponent(
              iconPath: iconPath!,
              width: 16,
              height: 16,
              color: iconColor,
            ),
        const SizedBox(width: 8),
        Text(
          text,
          style: textStyle ??
              getRegularStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s10,
              ),
        ),
      ],
    );
  }
}