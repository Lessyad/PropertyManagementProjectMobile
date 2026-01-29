part of 'home_bloc.dart';

class HomeState extends Equatable {
  final RequestState bannersState;
  final RequestState appServicesState;
  final List<ImageEntity> banners;
  final List<AppServiceEntity> appServices;
  final String errorMessage;
  final Map<PropertyType, PropertyData> properties;
  final List<PropertyEntity> allProperties;
  final RequestState allPropertiesState;
  final String selectedCityName;
  final RequestState updateUserLocationState;
  final RequestState getNotificationsState;
  final List<NotificationEntity> notifications;
  final List<PropertyEntity> searchProperties;
  final RequestState searchPropertiesState;
  final String searchErrorMessage;
  final String searchQuery;

  const HomeState({
    this.bannersState = RequestState.initial,
    this.appServicesState = RequestState.initial,
    this.updateUserLocationState = RequestState.initial,
    this.banners = const [],
    this.appServices = const [],
    this.errorMessage = '',
    this.properties = const {},
    this.selectedCityName = '',
    this.notifications = const [],
    this.getNotificationsState = RequestState.initial,
    this.allProperties = const [],
    this.allPropertiesState = RequestState.initial,
    this.searchProperties = const [],
    this.searchPropertiesState = RequestState.initial,
    this.searchErrorMessage = '',
    this.searchQuery = '',
  });

  HomeState copyWith({
    RequestState? bannersState,
    RequestState? appServicesState,
    RequestState? updateUserLocationState,
    List<ImageEntity>? banners,
    List<AppServiceEntity>? appServices,
    String? errorMessage,
    Map<PropertyType, PropertyData>? properties,
    String? selectedCityName,
    RequestState? getNotificationsState,
    List<NotificationEntity>? notifications,
    List<PropertyEntity>? allProperties,
    RequestState? allPropertiesState,
    List<PropertyEntity>? searchProperties,
    RequestState? searchPropertiesState,
    String? searchErrorMessage,
    String? searchQuery,
  }) {
    return HomeState(
      bannersState: bannersState ?? this.bannersState,
      appServicesState: appServicesState ?? this.appServicesState,
      updateUserLocationState: updateUserLocationState ?? this.updateUserLocationState,
      banners: banners ?? this.banners,
      appServices: appServices ?? this.appServices,
      errorMessage: errorMessage ?? this.errorMessage,
      properties: properties ?? this.properties,
      selectedCityName: selectedCityName ?? this.selectedCityName,
      getNotificationsState: getNotificationsState ?? this.getNotificationsState,
      notifications: notifications ?? this.notifications,
      allProperties: allProperties ?? this.allProperties,
      allPropertiesState: allPropertiesState ?? this.allPropertiesState,
      searchProperties: searchProperties ?? this.searchProperties,
      searchPropertiesState: searchPropertiesState ?? this.searchPropertiesState,
      searchErrorMessage: searchErrorMessage ?? this.searchErrorMessage,
      searchQuery: searchQuery ?? this.searchQuery,
    );
  }

  @override
  List<Object?> get props => [
    bannersState,
    appServicesState,
    banners,
    appServices,
    errorMessage,
    properties,
    updateUserLocationState,
    selectedCityName,
    getNotificationsState,
    notifications,
    allProperties,
    allPropertiesState,
    searchProperties,
    searchPropertiesState,
    searchErrorMessage,
    searchQuery,
  ];
}

class PropertyData extends Equatable {
  final List<PropertyEntity> properties;
  final RequestState state;
  final String errorMessage;

  const PropertyData({
    this.properties = const [],
    this.state = RequestState.initial,
    this.errorMessage = '',
  });

  PropertyData copyWith({
    List<PropertyEntity>? properties,
    RequestState? state,
    String? errorMessage,
  }) {
    return PropertyData(
      properties: properties ?? this.properties,
      state: state ?? this.state,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [properties, state, errorMessage];
}