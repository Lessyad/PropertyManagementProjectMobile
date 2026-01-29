import 'package:bloc/bloc.dart';
import 'package:enmaa/core/extensions/operation_type_property_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/apartment_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/building_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/land_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/villa_type_extension.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:equatable/equatable.dart';

import '../../../../../core/components/property_form_controller.dart';
import '../../../../../core/constants/app_constants.dart';
import '../../../../../core/constants/json_keys.dart';
import '../../../../../core/constants/local_keys.dart';
import '../../../../../core/services/select_location_service/presentation/controller/select_location_service_cubit.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/utils/enums.dart';
import '../../../../home_module/home_imports.dart';

part 'filter_property_state.dart';

class FilterPropertyCubit extends Cubit<FilterPropertyState> {
  FilterPropertyCubit() : super(FilterPropertyState());

  final PropertyFormController formController = PropertyFormController();
  final formKey = GlobalKey<FormState>();
  final TextEditingController minMonthsController = TextEditingController(text: AppConstants.minNumberOfMonths);
  final TextEditingController maxMonthsController = TextEditingController(text: AppConstants.maxNumberOfMonths);


  void changePropertyOperationType(PropertyOperationType propertyOperationType) {
    emit(state.copyWith(currentPropertyOperationType: propertyOperationType));
  }

  void changePropertyType(PropertyType? propertyType) {
    if (state.currentPropertyOperationType == PropertyOperationType.forSale) {
      if (propertyType == null || state.salePropertyType == propertyType) {
        emit(state.copyWith(removeCurrentPropertyType: true));
      } else {
        emit(state.copyWith(salePropertyType: propertyType));
      }
    } else {
      if (propertyType == null || state.rentPropertyType == propertyType) {
        emit(state.copyWith(removeCurrentPropertyType: true));
      } else {
        emit(state.copyWith(rentPropertyType: propertyType));
      }
    }
  }

  void toggleApartmentType(ApartmentType apartmentType) {
    if (state.currentPropertyOperationType == PropertyOperationType.forSale) {
      List<ApartmentType> updatedTypes = List.from(state.saleApartmentTypes);

      if (updatedTypes.contains(apartmentType)) {
        updatedTypes.remove(apartmentType);
      } else {
        updatedTypes.add(apartmentType);
      }

      emit(state.copyWith(saleApartmentTypes: updatedTypes));
    } else {
      List<ApartmentType> updatedTypes = List.from(state.rentApartmentTypes);

      if (updatedTypes.contains(apartmentType)) {
        updatedTypes.remove(apartmentType);
      } else {
        updatedTypes.add(apartmentType);
      }

      emit(state.copyWith(rentApartmentTypes: updatedTypes));
    }
  }

  void toggleVillaType(VillaType villaType) {
    if (state.currentPropertyOperationType == PropertyOperationType.forSale) {
      List<VillaType> updatedTypes = List.from(state.saleVillaTypes);

      if (updatedTypes.contains(villaType)) {
        updatedTypes.remove(villaType);
      } else {
        updatedTypes.add(villaType);
      }

      emit(state.copyWith(saleVillaTypes: updatedTypes));
    } else {
      List<VillaType> updatedTypes = List.from(state.rentVillaTypes);

      if (updatedTypes.contains(villaType)) {
        updatedTypes.remove(villaType);
      } else {
        updatedTypes.add(villaType);
      }

      emit(state.copyWith(rentVillaTypes: updatedTypes));
    }
  }

  void toggleBuildingType(BuildingType buildingType) {
    if (state.currentPropertyOperationType == PropertyOperationType.forSale) {
      List<BuildingType> updatedTypes = List.from(state.saleBuildingTypes);

      if (updatedTypes.contains(buildingType)) {
        updatedTypes.remove(buildingType);
      } else {
        updatedTypes.add(buildingType);
      }

      emit(state.copyWith(saleBuildingTypes: updatedTypes));
    } else {
      List<BuildingType> updatedTypes = List.from(state.rentBuildingTypes);

      if (updatedTypes.contains(buildingType)) {
        updatedTypes.remove(buildingType);
      } else {
        updatedTypes.add(buildingType);
      }

      emit(state.copyWith(rentBuildingTypes: updatedTypes));
    }
  }

  void toggleLandType(LandType landType) {
    if (state.currentPropertyOperationType == PropertyOperationType.forSale) {
      List<LandType> updatedTypes = List.from(state.saleLandTypes);

      if (updatedTypes.contains(landType)) {
        updatedTypes.remove(landType);
      } else {
        updatedTypes.add(landType);
      }

      emit(state.copyWith(saleLandTypes: updatedTypes));
    } else {
      List<LandType> updatedTypes = List.from(state.rentLandTypes);

      if (updatedTypes.contains(landType)) {
        updatedTypes.remove(landType);
      } else {
        updatedTypes.add(landType);
      }

      emit(state.copyWith(rentLandTypes: updatedTypes));
    }
  }

  void changeAvailabilityForRenewal() {
    emit(state.copyWith(rentAvailableForRenewal: !state.rentAvailableForRenewal));
  }

  void toggleFurnishingStatus(FurnishingStatus furnishingStatus) {
    if (state.currentPropertyOperationType == PropertyOperationType.forSale) {
      List<FurnishingStatus> updatedStatuses = List.from(state.saleFurnishingStatuses);

      if (updatedStatuses.contains(furnishingStatus)) {
        updatedStatuses.remove(furnishingStatus);
      } else {
        updatedStatuses.add(furnishingStatus);
      }

      emit(state.copyWith(saleFurnishingStatuses: updatedStatuses));
    } else {
      List<FurnishingStatus> updatedStatuses = List.from(state.rentFurnishingStatuses);

      if (updatedStatuses.contains(furnishingStatus)) {
        updatedStatuses.remove(furnishingStatus);
      } else {
        updatedStatuses.add(furnishingStatus);
      }

      emit(state.copyWith(rentFurnishingStatuses: updatedStatuses));
    }
  }

  void updatePriceRange(double min, double max) {
    if (state.currentPropertyOperationType == PropertyOperationType.forSale) {
      emit(state.copyWith(
        saleMinPriceValue: min.toString(),
        saleMaxPriceValue: max.toString(),
      ));
    } else {
      emit(state.copyWith(
        rentMinPriceValue: min.toString(),
        rentMaxPriceValue: max.toString(),
      ));
    }
  }

  void updateAreaRange(double min, double max) {
    if (state.currentPropertyOperationType == PropertyOperationType.forSale) {
      emit(state.copyWith(
        saleMinAreaValue: min.toString(),
        saleMaxAreaValue: max.toString(),
      ));
    } else {
      emit(state.copyWith(
        rentMinAreaValue: min.toString(),
        rentMaxAreaValue: max.toString(),
      ));
    }
  }

  void updateMinNumberOfMonths(String value) {
    emit(state.copyWith(rentMinNumberOfMonths: value));
  }

  void updateMaxNumberOfMonths(String value) {
    emit(state.copyWith(rentMaxNumberOfMonths: value));
  }

  void toggleLandLicenseStatus(LandLicenseStatus licenseStatus) {
    if (state.currentPropertyOperationType == PropertyOperationType.forSale) {
      final updatedStatuses = List<LandLicenseStatus>.from(state.saleLandLicenseStatuses);

      if (updatedStatuses.contains(licenseStatus)) {
        updatedStatuses.remove(licenseStatus);
      } else {
        updatedStatuses.add(licenseStatus);
      }

      emit(state.copyWith(saleLandLicenseStatuses: updatedStatuses));
    } else {
      final updatedStatuses = List<LandLicenseStatus>.from(state.rentLandLicenseStatuses);

      if (updatedStatuses.contains(licenseStatus)) {
        updatedStatuses.remove(licenseStatus);
      } else {
        updatedStatuses.add(licenseStatus);
      }

      emit(state.copyWith(rentLandLicenseStatuses: updatedStatuses));
    }
  }

  Map<String, dynamic> prepareDataForApi() {
    final locationCubit = SelectLocationServiceCubit.getOrCreate();
    final formController = this.formController;
    final isForSale = state.currentPropertyOperationType == PropertyOperationType.forSale;

    // Get the correct property type and filters based on operation type
    final propertyType = isForSale ? state.salePropertyType : state.rentPropertyType;
    final minPriceValue = isForSale ? state.saleMinPriceValue : state.rentMinPriceValue;
    final maxPriceValue = isForSale ? state.saleMaxPriceValue : state.rentMaxPriceValue;
    final minAreaValue = isForSale ? state.saleMinAreaValue : state.rentMinAreaValue;
    final maxAreaValue = isForSale ? state.saleMaxAreaValue : state.rentMaxAreaValue;
    final furnishingStatuses = isForSale ? state.saleFurnishingStatuses : state.rentFurnishingStatuses;
    final landLicenseStatuses = isForSale ? state.saleLandLicenseStatuses : state.rentLandLicenseStatuses;

    final Map<String, dynamic> data = {
      JsonKeys.operation: isForSale ? 'for_sale' : 'for_rent',
      JsonKeys.priceMin: minPriceValue,
      JsonKeys.priceMax: maxPriceValue,
      JsonKeys.areaMin: minAreaValue,
      JsonKeys.areaMax: maxAreaValue,
    };

    // Add monthly rent period if operation is for rent
    if (!isForSale) {
      data[JsonKeys.monthlyRentPeriodMin] = state.rentMinNumberOfMonths;
      data[JsonKeys.monthlyRentPeriodMax] = state.rentMaxNumberOfMonths;
    }

    // Add location data if selected
    if (locationCubit.state.selectedCountry != null) {
      data[JsonKeys.country] = locationCubit.state.selectedCountry!.id;
    }
    if (locationCubit.state.selectedState != null) {
      data[JsonKeys.state] = locationCubit.state.selectedState!.id;
    }
    if (locationCubit.state.selectedCity != null) {
      data[JsonKeys.city] = locationCubit.state.selectedCity!.id;
    }

    // Add property type if selected
    if (propertyType != null) {
      data[JsonKeys.propertyTypeName] = propertyType.toEnglish;
    }

    // Add property-specific filters
    if (propertyType == PropertyType.apartment) {
      data['apartment_rooms'] =
          formController.getController(LocalKeys.apartmentRoomsController).text;
      data['apartment_bath_rooms'] =
          formController.getController(LocalKeys.apartmentBathRoomsController).text;

      if (furnishingStatuses.length == 1) {
        bool isFurnished = furnishingStatuses.contains(FurnishingStatus.furnished);
        data['apartment_is_furnitured'] = isFurnished;
      }
    } else if (propertyType == PropertyType.villa) {
      data['villa_rooms'] =
          formController.getController(LocalKeys.villaRoomsController).text;
      data['villa_bath_rooms'] =
          formController.getController(LocalKeys.villaBathRoomsController).text;
      data['villa_number_of_floors'] =
          formController.getController(LocalKeys.villaFloorsController).text;

      if (furnishingStatuses.length == 1) {
        bool isFurnished = furnishingStatuses.contains(FurnishingStatus.furnished);
        data['villa_is_furnitured'] = isFurnished;
      }
    } else if (propertyType == PropertyType.building) {
      data['building_number_of_floors'] =
          formController.getController(LocalKeys.buildingFloorsController).text;
      data['number_of_apartments'] =
          formController.getController(LocalKeys.buildingApartmentsPerFloorController).text;
    } else if (propertyType == PropertyType.land) {
      if (landLicenseStatuses.length == 1) {
        data[JsonKeys.isLicensed] = landLicenseStatuses.contains(LandLicenseStatus.licensed);
      }
    } else {
      // For villa and apartment (when property type is not specified)
      if (furnishingStatuses.isNotEmpty) {
        if (furnishingStatuses.length != 2) {
          bool isFurnished = furnishingStatuses.contains(FurnishingStatus.furnished);
          data[JsonKeys.isFurnitured] = isFurnished;
        }
      }
    }

    // Add selected sub-types
    if (isForSale) {
      if (state.saleApartmentTypes.isNotEmpty && propertyType == PropertyType.apartment) {
        data[JsonKeys.propertySubType] = state.saleApartmentTypes.map((type) => type.toId).join(',');
      }
      if (state.saleVillaTypes.isNotEmpty && propertyType == PropertyType.villa) {
        data[JsonKeys.propertySubType] = state.saleVillaTypes.map((type) => type.toId).join(',');
      }
      if (state.saleBuildingTypes.isNotEmpty && propertyType == PropertyType.building) {
        data[JsonKeys.propertySubType] = state.saleBuildingTypes.map((type) => type.toId).join(',');
      }
      if (state.saleLandTypes.isNotEmpty && propertyType == PropertyType.land) {
        data[JsonKeys.propertySubType] = state.saleLandTypes.map((type) => type.toId).join(',');
      }
    } else {
      if (state.rentApartmentTypes.isNotEmpty && propertyType == PropertyType.apartment) {
        data[JsonKeys.propertySubType] = state.rentApartmentTypes.map((type) => type.toId).join(',');
      }
      if (state.rentVillaTypes.isNotEmpty && propertyType == PropertyType.villa) {
        data[JsonKeys.propertySubType] = state.rentVillaTypes.map((type) => type.toId).join(',');
      }
      if (state.rentBuildingTypes.isNotEmpty && propertyType == PropertyType.building) {
        data[JsonKeys.propertySubType] = state.rentBuildingTypes.map((type) => type.toId).join(',');
      }
      if (state.rentLandTypes.isNotEmpty && propertyType == PropertyType.land) {
        data[JsonKeys.propertySubType] = state.rentLandTypes.map((type) => type.toId).join(',');
      }
    }

    // Remove null or empty values
    data.removeWhere((key, value) =>
    value == null || value == '' || (value is List && value.isEmpty));

    return data;
  }

  void resetFilters() {
    // Reset location data
    ServiceLocator.getIt<SelectLocationServiceCubit>().removeSelectedData();



    // Reset form controller data for the current property type
    if (state.currentPropertyType == PropertyType.apartment) {
      formController.getController(LocalKeys.apartmentFloorsController).clear();
      formController.getController(LocalKeys.apartmentBathRoomsController).clear();
      formController.getController(LocalKeys.apartmentRoomsController).clear();
    } else if (state.currentPropertyType == PropertyType.villa) {
      formController.getController(LocalKeys.villaRoomsController).clear();
      formController.getController(LocalKeys.villaBathRoomsController).clear();
      formController.getController(LocalKeys.villaFloorsController).clear();
    } else if (state.currentPropertyType == PropertyType.building) {
      formController.getController(LocalKeys.buildingFloorsController).clear();
      formController.getController(LocalKeys.buildingApartmentsPerFloorController).clear();
    }

    // Reset state filters based on current operation type
    if (state.currentPropertyOperationType == PropertyOperationType.forSale) {
      emit(state.copyWith(
        salePropertyType: null,
        saleApartmentTypes: [],
        saleVillaTypes: [],
        saleBuildingTypes: [],
        saleLandTypes: [],
        saleFurnishingStatuses: [],
        saleLandLicenseStatuses: [],
        saleMinPriceValue: AppConstants.minPrice,
        saleMaxPriceValue: AppConstants.maxPrice,
        saleMinAreaValue: AppConstants.minArea,
        saleMaxAreaValue: AppConstants.maxArea,
      ));
    } else {

      minMonthsController.text = AppConstants.minNumberOfMonths;
      maxMonthsController.text = AppConstants.maxNumberOfMonths;

      emit(state.copyWith(
        rentPropertyType: null,
        rentApartmentTypes: [],
        rentVillaTypes: [],
        rentBuildingTypes: [],
        rentLandTypes: [],
        rentFurnishingStatuses: [],
        rentLandLicenseStatuses: [],
        rentMinPriceValue: AppConstants.minPrice,
        rentMaxPriceValue: AppConstants.maxPrice,
        rentMinAreaValue: AppConstants.minArea,
        rentMaxAreaValue: AppConstants.maxArea,
        rentMinNumberOfMonths: AppConstants.minNumberOfMonths,
        rentMaxNumberOfMonths: AppConstants.maxNumberOfMonths,
        rentAvailableForRenewal: false,
      ));
    }
  }

  // Add a method to reset all filters (both tabs)
  void resetAllFilters() {
    ServiceLocator.getIt<SelectLocationServiceCubit>().removeSelectedData();
    emit(FilterPropertyState());
  }
}
