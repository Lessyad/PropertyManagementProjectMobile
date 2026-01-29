part of 'filter_property_cubit.dart';

class FilterPropertyState extends Equatable {
   final PropertyOperationType currentPropertyOperationType;

  // For Sale tab filters
  final PropertyType? salePropertyType;
  final List<ApartmentType> saleApartmentTypes;
  final List<VillaType> saleVillaTypes;
  final List<BuildingType> saleBuildingTypes;
  final List<LandType> saleLandTypes;
  final List<FurnishingStatus> saleFurnishingStatuses;
  final List<LandLicenseStatus> saleLandLicenseStatuses;
  final String saleMinPriceValue;
  final String saleMaxPriceValue;
  final String saleMinAreaValue;
  final String saleMaxAreaValue;

  // For Rent tab filters
  final PropertyType? rentPropertyType;
  final List<ApartmentType> rentApartmentTypes;
  final List<VillaType> rentVillaTypes;
  final List<BuildingType> rentBuildingTypes;
  final List<LandType> rentLandTypes;
  final List<FurnishingStatus> rentFurnishingStatuses;
  final List<LandLicenseStatus> rentLandLicenseStatuses;
  final String rentMinPriceValue;
  final String rentMaxPriceValue;
  final String rentMinAreaValue;
  final String rentMaxAreaValue;
  final String rentMinNumberOfMonths;
  final String rentMaxNumberOfMonths;
  final bool rentAvailableForRenewal;

  const FilterPropertyState({
    this.currentPropertyOperationType = PropertyOperationType.forSale,

    // For Sale tab
    this.salePropertyType,
    this.saleApartmentTypes = const [],
    this.saleVillaTypes = const [],
    this.saleBuildingTypes = const [],
    this.saleLandTypes = const [],
    this.saleFurnishingStatuses = const [],
    this.saleLandLicenseStatuses = const [],
    this.saleMinPriceValue = AppConstants.minPrice,
    this.saleMaxPriceValue = AppConstants.maxPrice,
    this.saleMinAreaValue = AppConstants.minArea,
    this.saleMaxAreaValue = AppConstants.maxArea,

    // For Rent tab
    this.rentPropertyType,
    this.rentApartmentTypes = const [],
    this.rentVillaTypes = const [],
    this.rentBuildingTypes = const [],
    this.rentLandTypes = const [],
    this.rentFurnishingStatuses = const [],
    this.rentLandLicenseStatuses = const [],
    this.rentMinPriceValue = AppConstants.minPrice,
    this.rentMaxPriceValue = AppConstants.maxPrice,
    this.rentMinAreaValue = AppConstants.minArea,
    this.rentMaxAreaValue = AppConstants.maxArea,
    this.rentMinNumberOfMonths = AppConstants.minNumberOfMonths,
    this.rentMaxNumberOfMonths = AppConstants.maxNumberOfMonths,
    this.rentAvailableForRenewal = false,
  });

  // Helper getters to access the current tab's filters
  PropertyType? get currentPropertyType =>
      currentPropertyOperationType == PropertyOperationType.forSale
          ? salePropertyType
          : rentPropertyType;

  List<ApartmentType> get selectedApartmentTypes =>
      currentPropertyOperationType == PropertyOperationType.forSale
          ? saleApartmentTypes
          : rentApartmentTypes;

  List<VillaType> get selectedVillaTypes =>
      currentPropertyOperationType == PropertyOperationType.forSale
          ? saleVillaTypes
          : rentVillaTypes;

  List<BuildingType> get selectedBuildingTypes =>
      currentPropertyOperationType == PropertyOperationType.forSale
          ? saleBuildingTypes
          : rentBuildingTypes;

  List<LandType> get selectedLandTypes =>
      currentPropertyOperationType == PropertyOperationType.forSale
          ? saleLandTypes
          : rentLandTypes;

  List<FurnishingStatus> get selectedFurnishingStatuses =>
      currentPropertyOperationType == PropertyOperationType.forSale
          ? saleFurnishingStatuses
          : rentFurnishingStatuses;

  List<LandLicenseStatus> get selectedLandLicenseStatuses =>
      currentPropertyOperationType == PropertyOperationType.forSale
          ? saleLandLicenseStatuses
          : rentLandLicenseStatuses;

  String get minPriceValue =>
      currentPropertyOperationType == PropertyOperationType.forSale
          ? saleMinPriceValue
          : rentMinPriceValue;

  String get maxPriceValue =>
      currentPropertyOperationType == PropertyOperationType.forSale
          ? saleMaxPriceValue
          : rentMaxPriceValue;

  String get minAreaValue =>
      currentPropertyOperationType == PropertyOperationType.forSale
          ? saleMinAreaValue
          : rentMinAreaValue;

  String get maxAreaValue =>
      currentPropertyOperationType == PropertyOperationType.forSale
          ? saleMaxAreaValue
          : rentMaxAreaValue;

  bool get availableForRenewal => rentAvailableForRenewal;

  String get minNumberOfMonths => rentMinNumberOfMonths;

  String get maxNumberOfMonths => rentMaxNumberOfMonths;

  FilterPropertyState copyWith({
    PropertyOperationType? currentPropertyOperationType,

    // For Sale tab
    PropertyType? salePropertyType,
    List<ApartmentType>? saleApartmentTypes,
    List<VillaType>? saleVillaTypes,
    List<BuildingType>? saleBuildingTypes,
    List<LandType>? saleLandTypes,
    List<FurnishingStatus>? saleFurnishingStatuses,
    List<LandLicenseStatus>? saleLandLicenseStatuses,
    String? saleMinPriceValue,
    String? saleMaxPriceValue,
    String? saleMinAreaValue,
    String? saleMaxAreaValue,

    // For Rent tab
    PropertyType? rentPropertyType,
    List<ApartmentType>? rentApartmentTypes,
    List<VillaType>? rentVillaTypes,
    List<BuildingType>? rentBuildingTypes,
    List<LandType>? rentLandTypes,
    List<FurnishingStatus>? rentFurnishingStatuses,
    List<LandLicenseStatus>? rentLandLicenseStatuses,
    String? rentMinPriceValue,
    String? rentMaxPriceValue,
    String? rentMinAreaValue,
    String? rentMaxAreaValue,
    String? rentMinNumberOfMonths,
    String? rentMaxNumberOfMonths,
    bool? rentAvailableForRenewal,

    // Special flags
    bool? removeCurrentPropertyType,
  }) {
    return FilterPropertyState(
      currentPropertyOperationType: currentPropertyOperationType ?? this.currentPropertyOperationType,

      // For Sale tab
      salePropertyType: removeCurrentPropertyType == true ?
      null : (salePropertyType ?? this.salePropertyType),
      saleApartmentTypes: saleApartmentTypes ?? this.saleApartmentTypes,
      saleVillaTypes: saleVillaTypes ?? this.saleVillaTypes,
      saleBuildingTypes: saleBuildingTypes ?? this.saleBuildingTypes,
      saleLandTypes: saleLandTypes ?? this.saleLandTypes,
      saleFurnishingStatuses: saleFurnishingStatuses ?? this.saleFurnishingStatuses,
      saleLandLicenseStatuses: saleLandLicenseStatuses ?? this.saleLandLicenseStatuses,
      saleMinPriceValue: saleMinPriceValue ?? this.saleMinPriceValue,
      saleMaxPriceValue: saleMaxPriceValue ?? this.saleMaxPriceValue,
      saleMinAreaValue: saleMinAreaValue ?? this.saleMinAreaValue,
      saleMaxAreaValue: saleMaxAreaValue ?? this.saleMaxAreaValue,

      // For Rent tab
      rentPropertyType: removeCurrentPropertyType == true  ?
      null : (rentPropertyType ?? this.rentPropertyType),
      rentApartmentTypes: rentApartmentTypes ?? this.rentApartmentTypes,
      rentVillaTypes: rentVillaTypes ?? this.rentVillaTypes,
      rentBuildingTypes: rentBuildingTypes ?? this.rentBuildingTypes,
      rentLandTypes: rentLandTypes ?? this.rentLandTypes,
      rentFurnishingStatuses: rentFurnishingStatuses ?? this.rentFurnishingStatuses,
      rentLandLicenseStatuses: rentLandLicenseStatuses ?? this.rentLandLicenseStatuses,
      rentMinPriceValue: rentMinPriceValue ?? this.rentMinPriceValue,
      rentMaxPriceValue: rentMaxPriceValue ?? this.rentMaxPriceValue,
      rentMinAreaValue: rentMinAreaValue ?? this.rentMinAreaValue,
      rentMaxAreaValue: rentMaxAreaValue ?? this.rentMaxAreaValue,
      rentMinNumberOfMonths: rentMinNumberOfMonths ?? this.rentMinNumberOfMonths,
      rentMaxNumberOfMonths: rentMaxNumberOfMonths ?? this.rentMaxNumberOfMonths,
      rentAvailableForRenewal: rentAvailableForRenewal ?? this.rentAvailableForRenewal,
    );
  }

  @override
  List<Object?> get props => [
    currentPropertyOperationType,

    // For Sale tab
    salePropertyType,
    saleApartmentTypes,
    saleVillaTypes,
    saleBuildingTypes,
    saleLandTypes,
    saleFurnishingStatuses,
    saleLandLicenseStatuses,
    saleMinPriceValue,
    saleMaxPriceValue,
    saleMinAreaValue,
    saleMaxAreaValue,

    // For Rent tab
    rentPropertyType,
    rentApartmentTypes,
    rentVillaTypes,
    rentBuildingTypes,
    rentLandTypes,
    rentFurnishingStatuses,
    rentLandLicenseStatuses,
    rentMinPriceValue,
    rentMaxPriceValue,
    rentMinAreaValue,
    rentMaxAreaValue,
    rentMinNumberOfMonths,
    rentMaxNumberOfMonths,
    rentAvailableForRenewal,
  ];
}