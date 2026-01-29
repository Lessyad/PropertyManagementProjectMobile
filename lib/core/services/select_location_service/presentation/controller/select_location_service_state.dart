part of 'select_location_service_cubit.dart';

class SelectLocationServiceState extends Equatable {
  const SelectLocationServiceState({
    this.countries = const [],
    this.states = const [],
    this.cities = const [],
    this.getCountriesState = RequestState.initial,
    this.getStatesState = RequestState.initial,
    this.getCitiesState = RequestState.initial,
    this.getCountriesError = '',
    this.getStatesError = '',
    this.getCitiesError = '',
    this.selectedCountry,
    this.selectedState,
    this.selectedCity,
    this.cachedCountries = const {},
    this.cachedStates = const {},
    this.cachedCities = const {},
  });

  final Map<String , List<CountryEntity>> cachedCountries;
  final Map<String , List<StateEntity>> cachedStates;
  final Map<String , List<CityEntity>> cachedCities;

  final List<CountryEntity> countries;
  final List<StateEntity> states;
  final List<CityEntity> cities;

  final RequestState getCountriesState;
  final RequestState getStatesState;
  final RequestState getCitiesState;

  final String getCountriesError;
  final String getStatesError;
  final String getCitiesError;

  final CountryEntity? selectedCountry ;
  final StateEntity? selectedState;
  final CityEntity? selectedCity;

  SelectLocationServiceState copyWith({
    List<CountryEntity>? countries,
    List<StateEntity>? states,
    List<CityEntity>? cities,
    RequestState? getCountriesState,
    RequestState? getStatesState,
    RequestState? getCitiesState,
    String? getCountriesError,
    String? getStatesError,
    String? getCitiesError,
    CountryEntity? selectedCountry,
    StateEntity? selectedState,
    CityEntity? selectedCity,

    Map<String , List<CountryEntity>>? cachedCountries,
    Map<String , List<StateEntity>>? cachedStates,
    Map<String , List<CityEntity>>? cachedCities,

    // Add these flags to explicitly set null values
    bool clearSelectedState = false,
    bool clearSelectedCity = false,
    bool clearSelectedCountry = false,
  }) {
    return SelectLocationServiceState(
      countries: countries ?? this.countries,
      states: states ?? this.states,
      cities: cities ?? this.cities,
      getCountriesState: getCountriesState ?? this.getCountriesState,
      getStatesState: getStatesState ?? this.getStatesState,
      getCitiesState: getCitiesState ?? this.getCitiesState,
      getCountriesError: getCountriesError ?? this.getCountriesError,
      getStatesError: getStatesError ?? this.getStatesError,
      getCitiesError: getCitiesError ?? this.getCitiesError,

      cachedCountries: cachedCountries ?? this.cachedCountries,
      cachedStates: cachedStates ?? this.cachedStates,
      cachedCities: cachedCities ?? this.cachedCities,


      // Use the flag to explicitly set to null
      selectedState: clearSelectedState ? null : (selectedState ?? this.selectedState),
      selectedCity: clearSelectedCity ? null : (selectedCity ?? this.selectedCity),
      selectedCountry: clearSelectedCountry ? null : (selectedCountry ?? this.selectedCountry),

    );
  }

  @override
  List<Object?> get props => [
    countries,
    states,
    cities,
    getCountriesState,
    getStatesState,
    getCitiesState,
    getCountriesError,
    getStatesError,
    getCitiesError,
    selectedCountry,
    selectedState,
    selectedCity,
    cachedCountries,
    cachedStates,
    cachedCities,

  ];
}
