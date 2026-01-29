import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:equatable/equatable.dart';
import 'package:latlong2/latlong.dart';
import 'package:enmaa/core/services/map_services/domain/entities/location_entity.dart';

import '../../../../errors/failure.dart';
import '../../domain/use_cases/get_suggested_location_use_case.dart';

part 'map_services_state.dart';
class MapServicesCubit extends Cubit<MapServicesState> {
  final GetSuggestedLocationUseCase getSuggestedLocationUseCase;

  MapServicesCubit(this.getSuggestedLocationUseCase) : super(const MapServicesState());

  /// **Update selected location (when user picks a location on the map)**
  void updateSelectedLocation(LatLng location) async{
    emit(state.copyWith(updateSelectedLocationState: RequestState.loading));
    await Future.delayed(const Duration(milliseconds: 100),);
    emit(state.copyWith(selectedLocation: location , updateSelectedLocationState: RequestState.loaded));
  }

  /// **Fetch location suggestions based on query**
  Future<void> fetchLocationSuggestions(String query) async {
    if (query.isEmpty) {
      emit(state.copyWith(suggestions: [], showSuggestionsList: false));
      return;
    }

    emit(state.copyWith(getSuggestionsState: RequestState.loading, showSuggestionsList: true));

    final Either<Failure, List<LocationEntity>> result = await getSuggestedLocationUseCase(query);

    result.fold(
          (failure) => emit(state.copyWith(getSuggestionsState: RequestState.error, errorMessage: failure.message)),
          (suggestions) => emit(state.copyWith(getSuggestionsState: RequestState.loaded, suggestions: suggestions)),
    );
  }

  /// **Toggle visibility of suggestions list**
  void changeVisibilityOfSuggestionsList() {
    emit(state.copyWith(showSuggestionsList: !state.showSuggestionsList));
  }

  /// **Clear search query and hide suggestions list**
  void clearSearchQuery() {
    emit(state.copyWith(searchQuery: '', showSuggestionsList: false, suggestions: []));
  }
}