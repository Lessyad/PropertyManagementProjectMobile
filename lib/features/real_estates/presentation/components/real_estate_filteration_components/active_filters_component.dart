import 'package:enmaa/core/components/loading_overlay_component.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/services/select_location_service/presentation/controller/select_location_service_cubit.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../home_module/home_imports.dart';
import '../../controller/filter_properties_controller/filter_property_cubit.dart';
import 'package:enmaa/core/extensions/property_sub_types/apartment_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/building_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/land_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/villa_type_extension.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/translation/locale_keys.dart';
import 'filter_chip_component.dart';


class ActiveFiltersComponent extends StatelessWidget {
  const ActiveFiltersComponent({super.key , required this.selectLocationServiceCubit});

  final SelectLocationServiceCubit selectLocationServiceCubit ;
  @override
  Widget build(BuildContext context) {
    return BlocProvider.value(
  value: selectLocationServiceCubit,
  child: BlocBuilder<SelectLocationServiceCubit, SelectLocationServiceState>(
      builder: (context, locationState) {
        return BlocBuilder<FilterPropertyCubit, FilterPropertyState>(
          builder: (context, filterState) {
            List<String> activeFilters = [];
            bool isForSale = filterState.currentPropertyOperationType == PropertyOperationType.forSale;

            PropertyType? currentPropertyType = isForSale ? filterState.salePropertyType : filterState.rentPropertyType;
            if (currentPropertyType != null) {
              activeFilters.add(currentPropertyType.toArabic);
            }

            // Add furnishing status filters
            List<FurnishingStatus> furnishingStatuses = isForSale
                ? filterState.saleFurnishingStatuses
                : filterState.rentFurnishingStatuses;

            if (furnishingStatuses.isNotEmpty &&
                (currentPropertyType == PropertyType.apartment ||
                    currentPropertyType == PropertyType.villa ||
                    currentPropertyType == null)) {
              for (var status in furnishingStatuses) {
                activeFilters.add(status == FurnishingStatus.furnished ? LocaleKeys.filterFurnished.tr() : LocaleKeys.filterNotFurnished.tr());
              }
            }

            // Add land license status filters
            List<LandLicenseStatus> landLicenseStatuses = isForSale
                ? filterState.saleLandLicenseStatuses
                : filterState.rentLandLicenseStatuses;

            if (landLicenseStatuses.isNotEmpty &&
                currentPropertyType == PropertyType.land) {
              for (var status in landLicenseStatuses) {
                activeFilters.add(status == LandLicenseStatus.licensed ? LocaleKeys.filterReadyForBuilding.tr() : LocaleKeys.filterNeedsPermit.tr());
              }
            }

            // Add price range filter
            String minPrice = isForSale ? filterState.saleMinPriceValue : filterState.rentMinPriceValue;
            String maxPrice = isForSale ? filterState.saleMaxPriceValue : filterState.rentMaxPriceValue;
            String minPriceClean = minPrice.split('.').first;
            String maxPriceClean = maxPrice.split('.').first;
            if (minPriceClean != AppConstants.minPrice || maxPriceClean != AppConstants.maxPrice) {
              activeFilters.add('$minPriceClean - $maxPriceClean ${LocaleKeys.filterCurrencyEGP.tr()}');
            }

// Add area range filter
            String minArea = isForSale ? filterState.saleMinAreaValue : filterState.rentMinAreaValue;
            String maxArea = isForSale ? filterState.saleMaxAreaValue : filterState.rentMaxAreaValue;
            String minAreaClean = minArea.split('.').first;
            String maxAreaClean = maxArea.split('.').first;
            if (minAreaClean != AppConstants.minArea || maxAreaClean != AppConstants.maxArea) {
              activeFilters.add('$minAreaClean - $maxAreaClean ${LocaleKeys.filterSquareMeters.tr()}');
            }


            // Add rent-specific filters
            if (!isForSale) {
              if (filterState.rentMinNumberOfMonths != AppConstants.minNumberOfMonths || filterState.rentMaxNumberOfMonths != AppConstants.maxNumberOfMonths) {
                activeFilters.add('${filterState.rentMinNumberOfMonths} - ${filterState.rentMaxNumberOfMonths} ${LocaleKeys.filterMonth.tr()}');
              }

              if (filterState.rentAvailableForRenewal) {
                activeFilters.add(LocaleKeys.filterAvailableForRenewal.tr());
              }
            }

            // Add property sub-type filters
            if (currentPropertyType == PropertyType.apartment) {
              List<ApartmentType> apartmentTypes = isForSale
                  ? filterState.saleApartmentTypes
                  : filterState.rentApartmentTypes;

              for (var type in apartmentTypes) {
                activeFilters.add(type.toArabic);
              }
            } else if (currentPropertyType == PropertyType.villa) {
              List<VillaType> villaTypes = isForSale
                  ? filterState.saleVillaTypes
                  : filterState.rentVillaTypes;

              for (var type in villaTypes) {
                activeFilters.add(type.toArabic);
              }
            } else if (currentPropertyType == PropertyType.building) {
              List<BuildingType> buildingTypes = isForSale
                  ? filterState.saleBuildingTypes
                  : filterState.rentBuildingTypes;

              for (var type in buildingTypes) {
                activeFilters.add(type.toArabic);
              }
            } else if (currentPropertyType == PropertyType.land) {
              List<LandType> landTypes = isForSale
                  ? filterState.saleLandTypes
                  : filterState.rentLandTypes;

              for (var type in landTypes) {
                activeFilters.add(type.toArabic);
              }
            }

            // Add location filters (city, country, state)
            if (locationState.selectedCountry != null) {
              activeFilters.add(locationState.selectedCountry!.name);
            }
            if (locationState.selectedState != null) {
              activeFilters.add(locationState.selectedState!.name);
            }
            if (locationState.selectedCity != null) {
              activeFilters.add(locationState.selectedCity!.name);
            }

            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SizedBox(
                width: double.infinity,
                child: Visibility(
                  visible: activeFilters.isNotEmpty,
                  child: SingleChildScrollView(
                    padding: EdgeInsets.zero,
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: activeFilters.map((filter) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 6),
                          child: FilterChipComponent(label: filter),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            );
          },
        );
      },
    ),
);
  }
}