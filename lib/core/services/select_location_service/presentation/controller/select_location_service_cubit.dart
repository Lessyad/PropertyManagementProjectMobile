import 'package:dartz/dartz.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_cities_use_case.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_countries_use_case.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_states_use_case.dart';
import 'package:enmaa/core/services/select_location_service/select_location_DI.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import '../../../../errors/failure.dart';
import '../../domain/entities/country_entity.dart';
import '../../domain/entities/state_entity.dart';
import '../../domain/entities/city_entity.dart';

part 'select_location_service_state.dart';

class SelectLocationServiceCubit extends Cubit<SelectLocationServiceState> {
  static SelectLocationServiceState? _lastState;

  SelectLocationServiceCubit._(
    this._getCountriesUseCase,
    this._getStatesUseCase,
    this._getCitiesUseCase,
  ) : super(_lastState ?? const SelectLocationServiceState()) {
    if (_lastState != null) {
      emit(_lastState!); // Emit the saved state
    } else {
      removeSelectedData();
    }
  }

  final GetCountriesUseCase _getCountriesUseCase;
  final GetStatesUseCase _getStatesUseCase;
  final GetCitiesUseCase _getCitiesUseCase;

  /// **Ensure Singleton Instance**
  static void init(
    GetCountriesUseCase getCountriesUseCase,
    GetStatesUseCase getStatesUseCase,
    GetCitiesUseCase getCitiesUseCase,
  ) {
    if (!GetIt.I.isRegistered<SelectLocationServiceCubit>()) {
      GetIt.I.registerSingleton<SelectLocationServiceCubit>(
        SelectLocationServiceCubit._(
            getCountriesUseCase, getStatesUseCase, getCitiesUseCase),
      );
    }
  }

  /// **Ensure Reopening the Cubit if Closed**
  static SelectLocationServiceCubit getOrCreate() {
    if (!GetIt.I.isRegistered<SelectLocationServiceCubit>()) {
      SelectLocationDi().setup();
      init(
        GetIt.I<GetCountriesUseCase>(),
        GetIt.I<GetStatesUseCase>(),
        GetIt.I<GetCitiesUseCase>(),
      );
    }

    final cubit = GetIt.I<SelectLocationServiceCubit>();
    if (cubit.isClosed) {
      // Unregister the closed Cubit
      GetIt.I.unregister<SelectLocationServiceCubit>();

      // Recreate the Cubit and restore the last state
      final newCubit = SelectLocationServiceCubit._(
        GetIt.I<GetCountriesUseCase>(),
        GetIt.I<GetStatesUseCase>(),
        GetIt.I<GetCitiesUseCase>(),
      );

      // Register the new Cubit
      GetIt.I.registerSingleton<SelectLocationServiceCubit>(newCubit);
      return newCubit;
    }
    return cubit;
  }

  Future<void> setPropertyLocation({
    required String countryName,
    required String stateName,
    required String cityName,
  }) async {
    await getCountries();
    if (state.countries.isEmpty) return;

    final country = _findByName(state.countries, countryName);
    if (country == null) return;

    emit(state.copyWith(
      selectedCountry: country,
      selectedState: null,
      selectedCity: null,
      states: [],
      cities: [],
      clearSelectedState: true,
      clearSelectedCity: true,
    ));
    await getStates(country.id);

    if (stateName.isNotEmpty) {
      final stateEntity = _findByName(state.states, stateName);
      if (stateEntity == null) return;

      emit(state.copyWith(
        selectedState: stateEntity,
        selectedCity: null,
        cities: [],
        clearSelectedCity: true,
      ));
      await getCities(stateEntity.id);

      if (cityName.isNotEmpty) {
        final city = _findByName(state.cities, cityName);
        if (city == null) return;

        emit(state.copyWith(selectedCity: city));
      }
    }
  }

  Future<void> restorePropertyLocation({
    String countryId = '',
    String stateId = '',
    String cityId = '',
    String countryName = '',
    String stateName = '',
    String cityName = '',
  }) async {
    await getCountries();
    if (state.countries.isEmpty) return;

    CountryEntity? country = countryId.isNotEmpty
        ? _findById(state.countries, countryId)
        : _findByName(state.countries, countryName);
    StateEntity? stateEntity;

    if (country != null) {
      emit(state.copyWith(
        selectedCountry: country,
        selectedState: null,
        selectedCity: null,
        states: [],
        cities: [],
        clearSelectedState: true,
        clearSelectedCity: true,
      ));
      await getStates(country.id);
      stateEntity = stateId.isNotEmpty
          ? _findById(state.states, stateId)
          : _findByName(state.states, stateName);
    } else if (stateId.isNotEmpty || stateName.isNotEmpty) {
      for (final candidateCountry in state.countries) {
        await getStates(candidateCountry.id);
        final candidateState = stateId.isNotEmpty
            ? _findById(state.states, stateId)
            : _findByName(state.states, stateName);

        if (candidateState != null) {
          country = candidateCountry;
          stateEntity = candidateState;
          break;
        }
      }
    }

    if (country == null) return;

    emit(state.copyWith(
      selectedCountry: country,
      selectedState: stateEntity,
      selectedCity: null,
      clearSelectedCity: true,
    ));

    if (stateEntity == null) return;

    await getCities(stateEntity.id);

    final city = cityId.isNotEmpty
        ? _findById(state.cities, cityId)
        : _findByName(state.cities, cityName);
    if (city == null) return;

    emit(state.copyWith(selectedCity: city));
  }

  T? _findByName<T extends dynamic>(List<T> items, String name) {
    final normalizedName = _normalizeLocationName(name);
    for (final item in items) {
      final itemName =
          _normalizeLocationName((item as dynamic).name.toString());
      if (itemName == normalizedName) return item;
    }
    return null;
  }

  T? _findById<T extends dynamic>(List<T> items, String id) {
    final normalizedId = id.trim();
    for (final item in items) {
      if ((item as dynamic).id.toString().trim() == normalizedId) return item;
    }
    return null;
  }

  String _normalizeLocationName(String value) {
    return value.trim().toLowerCase();
  }

  /// **Get Countries**
  Future<void> getCountries() async {
    emit(state.copyWith(getCountriesState: RequestState.loading));

    if (state.countries.isNotEmpty) {
      emit(state.copyWith(getCountriesState: RequestState.loaded));
      return;
    }
    final Either<Failure, List<CountryEntity>> result =
        await _getCountriesUseCase();

    result.fold(
        (failure) => emit(state.copyWith(
              getCountriesState: RequestState.error,
              getCountriesError: failure.message,
            )), (countries) {
      emit(state.copyWith(
        countries: countries,
        getCountriesState: RequestState.loaded,
      ));
    });
  }

  /// **Get States for a Given Country**
  Future<void> getStates(String countryId) async {
    emit(state.copyWith(getStatesState: RequestState.loading));

    if (state.cachedStates.containsKey(countryId)) {
      emit(state.copyWith(
        states: state.cachedStates[countryId]!,
        getStatesState: RequestState.loaded,
      ));
      return;
    }

    final Either<Failure, List<StateEntity>> result =
        await _getStatesUseCase(countryId);

    result.fold(
        (failure) => emit(state.copyWith(
              getStatesState: RequestState.error,
              getStatesError: failure.message,
            )), (states) {
      final Map<String, List<StateEntity>> cachedStates =
          Map<String, List<StateEntity>>.from(state.cachedStates);

      cachedStates[countryId] = states;

      emit(state.copyWith(
        states: states,
        cachedStates: cachedStates,
        getStatesState: RequestState.loaded,
      ));
    });
  }

  /// **Get Cities for a Given State**
  Future<void> getCities(String stateId) async {
    emit(state.copyWith(getCitiesState: RequestState.loading));

    if (state.cachedCities.containsKey(stateId)) {
      emit(state.copyWith(
        cities: state.cachedCities[stateId]!,
        getCitiesState: RequestState.loaded,
      ));
      return;
    }

    final Either<Failure, List<CityEntity>> result =
        await _getCitiesUseCase(stateId);

    result.fold(
        (failure) => emit(state.copyWith(
              getCitiesState: RequestState.error,
              getCitiesError: failure.message,
            )), (cities) {
      final Map<String, List<CityEntity>> cachedCities =
          Map<String, List<CityEntity>>.from(state.cachedCities);
      cachedCities[stateId] = cities;

      emit(state.copyWith(
        cities: cities,
        cachedCities: cachedCities,
        getCitiesState: RequestState.loaded,
      ));
    });
  }

  void changeSelectedCountry(String countryName) {
    final country =
        state.countries.firstWhere((element) => element.name == countryName);
    getStates(country.id);
    emit(state.copyWith(
      selectedCountry: country,
      selectedState: null,
      selectedCity: null,
      cities: [],
      clearSelectedState: true,
      clearSelectedCity: true,
    ));
  }

  void changeSelectedState(String stateName) {
    final currentState =
        state.states.firstWhere((element) => element.name == stateName);
    getCities(currentState.id);
    emit(state.copyWith(
      selectedState: currentState,
      selectedCity: null,
      clearSelectedCity: true,
    ));
  }

  void changeSelectedCity(String cityName) {
    final currentCity =
        state.cities.firstWhere((element) => element.name == cityName);

    if (state.selectedCity != null && cityName == state.selectedCity!.name) {
      emit(state.copyWith(
        selectedCity: null,
        clearSelectedCity: true,
      ));
    }
    emit(state.copyWith(selectedCity: currentCity));
  }

  /// **Clear Selected Data**
  void removeSelectedData() {
    emit(state.copyWith(
      selectedCountry: null,
      selectedState: null,
      selectedCity: null,
      clearSelectedState: true,
      states: [],
      cities: [],
      clearSelectedCity: true,
      clearSelectedCountry: true,
    ));
  }

  /// Sets only the user's country (by ID), clears state and city.
  /// Use this for filter initialization so only country is pre-filled.
  void setUserCountryOnly(String countryId) {
    if (state.countries.isEmpty) return;
    try {
      final country = state.countries.firstWhere((c) => c.id == countryId);
      emit(state.copyWith(
        selectedCountry: country,
        selectedState: null,
        selectedCity: null,
        clearSelectedState: true,
        clearSelectedCity: true,
        states: [],
        cities: [],
      ));
    } catch (_) {
      // Country not found in loaded list — leave unchanged
    }
  }

  /// Restores country, state and city from saved IDs (e.g. from SharedPreferences).
  /// Call after getCountries() so that countries are loaded. Loads states/cities as needed.
  Future<void> restoreUserLocation({
    required String countryId,
    required String stateId,
    required String cityId,
  }) async {
    await getCountries();
    if (state.countries.isEmpty) return;
    CountryEntity country;
    try {
      country = state.countries.firstWhere((c) => c.id == countryId);
    } catch (_) {
      return;
    }
    emit(state.copyWith(
      selectedCountry: country,
      selectedState: null,
      selectedCity: null,
      states: [],
      cities: [],
      clearSelectedState: true,
      clearSelectedCity: true,
    ));
    await getStates(countryId);
    if (state.states.isEmpty) return;
    StateEntity stateEntity;
    try {
      stateEntity = state.states.firstWhere((s) => s.id == stateId);
    } catch (_) {
      return;
    }
    emit(state.copyWith(
      selectedState: stateEntity,
      selectedCity: null,
      cities: [],
      clearSelectedCity: true,
    ));
    await getCities(stateId);
    if (state.cities.isEmpty) return;
    CityEntity city;
    try {
      city = state.cities.firstWhere((c) => c.id == cityId);
    } catch (_) {
      return;
    }
    emit(state.copyWith(selectedCity: city));
  }

  @override
  Future<void> close() {
    _lastState = state;
    return super.close();
  }
}
