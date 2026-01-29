part of 'map_services_cubit.dart';

class MapServicesState extends Equatable {
  const MapServicesState({
    this.selectedLocation,
    this.updateSelectedLocationState = RequestState.loaded ,
    this.searchQuery = '',
    this.suggestions = const [],
    this.getSuggestionsState = RequestState.initial,
    this.errorMessage,
    this.showSuggestionsList = false,
  });

  final RequestState updateSelectedLocationState ;
  final LatLng? selectedLocation;
  final String searchQuery;

  final List<LocationEntity> suggestions;
  final RequestState getSuggestionsState;
  final String? errorMessage;

  final bool showSuggestionsList;

  MapServicesState copyWith({
    LatLng? selectedLocation,
    String? searchQuery,
    List<LocationEntity>? suggestions,
    RequestState? getSuggestionsState,
    RequestState? updateSelectedLocationState,
    String? errorMessage,
    bool? showSuggestionsList,
  }) {
    return MapServicesState(
      selectedLocation: selectedLocation ?? this.selectedLocation,
      updateSelectedLocationState: updateSelectedLocationState ?? this.updateSelectedLocationState,
      searchQuery: searchQuery ?? this.searchQuery,
      suggestions: suggestions ?? this.suggestions,
      getSuggestionsState: getSuggestionsState ?? this.getSuggestionsState,
      errorMessage: errorMessage ?? this.errorMessage,
      showSuggestionsList: showSuggestionsList ?? this.showSuggestionsList,
    );
  }

  @override
  List<Object?> get props => [
        selectedLocation,
        searchQuery,
        suggestions,
        getSuggestionsState,
        errorMessage,
        showSuggestionsList,
    updateSelectedLocationState,
      ];
}
