import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_cities_use_case.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_countries_use_case.dart';
import 'package:enmaa/core/services/select_location_service/domain/use_cases/get_states_use_case.dart';
import 'package:enmaa/core/services/select_location_service/select_location_DI.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:equatable/equatable.dart';
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

    final country = state.countries.firstWhere(
      (c) => c.name == countryName,
    );

    changeSelectedCountry(country.name);

    if (stateName.isNotEmpty) {
      final stateEntity = state.states.firstWhere(
        (s) => s.name == stateName,
      );
      changeSelectedState(stateEntity.name);

      if (cityName.isNotEmpty) {
        final city = state.cities.firstWhere(
          (c) => c.name == cityName,
        );

        changeSelectedCity(city.name);
      }
    }
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

  @override
  Future<void> close() {
    _lastState = state;
    return super.close();
  }
}
