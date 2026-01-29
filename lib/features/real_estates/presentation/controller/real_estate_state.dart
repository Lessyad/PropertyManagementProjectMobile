part of 'real_estate_cubit.dart';

class RealEstateState extends Equatable {
  const RealEstateState({
    // Common pagination parameters
    this.limit = 10,

    // Sale properties (Tab 1)
    this.getPropertiesSaleState = RequestState.initial,
    this.saleProperties = const [],
    this.getPropertiesSaleError = '',
    this.saleOffset = 0,
    this.hasMoreSaleProperties = true,
    this.saleTabLoaded = false,

    // Rent properties (Tab 2)
    this.getPropertiesRentState = RequestState.initial,
    this.rentProperties = const [],
    this.getPropertiesRentError = '',
    this.rentOffset = 0,
    this.hasMoreRentProperties = true,
    this.rentTabLoaded = false,

    // Backward compatibility
    this.getPropertiesState = RequestState.initial,
    this.getPropertiesError = '',
    this.properties = const [],

    // Property details
    this.getPropertyDetailsState = RequestState.initial,
    this.getPropertyDetailsError = '',
    this.propertyDetails,

    // Map properties
    this.getMapPropertiesState = RequestState.initial,
    this.mapProperties = const [],
    this.getMapPropertiesError = '',
  });

  // Common pagination parameters
  final int limit;

  // Sale properties (Tab 1)
  final RequestState getPropertiesSaleState;
  final List<PropertyEntity> saleProperties;
  final String getPropertiesSaleError;
  final int saleOffset;
  final bool hasMoreSaleProperties;
  final bool saleTabLoaded;

  // Rent properties (Tab 2)
  final RequestState getPropertiesRentState;
  final List<PropertyEntity> rentProperties;
  final String getPropertiesRentError;
  final int rentOffset;
  final bool hasMoreRentProperties;
  final bool rentTabLoaded;

  // Backward compatibility
  final RequestState getPropertiesState;
  final List<PropertyEntity> properties;
  final String getPropertiesError;

  // Property details
  final RequestState getPropertyDetailsState;
  final BasePropertyDetailsEntity? propertyDetails;
  final String getPropertyDetailsError;

  // Map properties
  final RequestState getMapPropertiesState;
  final List<PropertyEntity> mapProperties;
  final String getMapPropertiesError;

  RealEstateState copyWith({
    int? limit,

    // Sale properties
    RequestState? getPropertiesSaleState,
    List<PropertyEntity>? saleProperties,
    String? getPropertiesSaleError,
    int? saleOffset,
    bool? hasMoreSaleProperties,
    bool? saleTabLoaded,

    // Rent properties
    RequestState? getPropertiesRentState,
    List<PropertyEntity>? rentProperties,
    String? getPropertiesRentError,
    int? rentOffset,
    bool? hasMoreRentProperties,
    bool? rentTabLoaded,

    // Backward compatibility
    RequestState? getPropertiesState,
    List<PropertyEntity>? properties,
    String? getPropertiesError,

    // Property details
    RequestState? getPropertyDetailsState,
    BasePropertyDetailsEntity? propertyDetails,
    String? getPropertyDetailsError,

    // Map properties
    RequestState? getMapPropertiesState,
    List<PropertyEntity>? mapProperties,
    String? getMapPropertiesError,
  }) {
    return RealEstateState(
      limit: limit ?? this.limit,

      // Sale properties
      getPropertiesSaleState: getPropertiesSaleState ?? this.getPropertiesSaleState,
      saleProperties: saleProperties ?? this.saleProperties,
      getPropertiesSaleError: getPropertiesSaleError ?? this.getPropertiesSaleError,
      saleOffset: saleOffset ?? this.saleOffset,
      hasMoreSaleProperties: hasMoreSaleProperties ?? this.hasMoreSaleProperties,
      saleTabLoaded: saleTabLoaded ?? this.saleTabLoaded,

      // Rent properties
      getPropertiesRentState: getPropertiesRentState ?? this.getPropertiesRentState,
      rentProperties: rentProperties ?? this.rentProperties,
      getPropertiesRentError: getPropertiesRentError ?? this.getPropertiesRentError,
      rentOffset: rentOffset ?? this.rentOffset,
      hasMoreRentProperties: hasMoreRentProperties ?? this.hasMoreRentProperties,
      rentTabLoaded: rentTabLoaded ?? this.rentTabLoaded,

      // Backward compatibility
      getPropertiesState: getPropertiesState ?? this.getPropertiesState,
      properties: properties ?? this.properties,
      getPropertiesError: getPropertiesError ?? this.getPropertiesError,

      // Property details
      getPropertyDetailsState: getPropertyDetailsState ?? this.getPropertyDetailsState,
      propertyDetails: propertyDetails ?? this.propertyDetails,
      getPropertyDetailsError: getPropertyDetailsError ?? this.getPropertyDetailsError,

      // Map properties
      getMapPropertiesState: getMapPropertiesState ?? this.getMapPropertiesState,
      mapProperties: mapProperties ?? this.mapProperties,
      getMapPropertiesError: getMapPropertiesError ?? this.getMapPropertiesError,
    );
  }

  @override
  List<Object?> get props => [
    limit,

    // Sale properties
    getPropertiesSaleState,
    saleProperties,
    getPropertiesSaleError,
    saleOffset,
    hasMoreSaleProperties,
    saleTabLoaded,

    // Rent properties
    getPropertiesRentState,
    rentProperties,
    getPropertiesRentError,
    rentOffset,
    hasMoreRentProperties,
    rentTabLoaded,

    // Backward compatibility
    getPropertiesState,
    properties,
    getPropertiesError,

    // Property details
    getPropertyDetailsState,
    propertyDetails,
    getPropertyDetailsError,

    // Map properties
    getMapPropertiesState,
    mapProperties,
    getMapPropertiesError,
  ];
}