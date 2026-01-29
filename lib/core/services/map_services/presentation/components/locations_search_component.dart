import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/services/map_services/presentation/components/location_item_component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../features/home_module/home_imports.dart';
import '../../../../components/app_text_field.dart';
import '../../../debouncer.dart';
import '../controller/map_services_cubit.dart';

class LocationsSearchComponent extends StatefulWidget {
  const LocationsSearchComponent({
    super.key,
    required this.onLocationSelected,
  });

  final Function(LatLng) onLocationSelected;

  @override
  State<LocationsSearchComponent> createState() =>
      _LocationsSearchComponentState();
}

class _LocationsSearchComponentState extends State<LocationsSearchComponent> {
  final TextEditingController _searchController = TextEditingController();
  late Debouncer _debouncer;

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: const Duration(seconds: 3));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          BlocBuilder<MapServicesCubit, MapServicesState>(
            buildWhen: (previous, current) =>
            previous.showSuggestionsList != current.showSuggestionsList,
            builder: (context, state) {
              return AppTextField(
                height: 40,
                controller: _searchController,
                hintText: 'أدخل الموقع الذي تبحث عنه',
                backgroundColor: Colors.white,
                borderRadius: 20,
                padding: EdgeInsets.zero,
                prefixIcon: Padding(
                  padding: const EdgeInsets.only(
                      left: 8, right: 12, top: 12, bottom: 12),
                  child: Icon(Icons.search_outlined),
                ),
                suffixIcon: Visibility(
                  visible: state.showSuggestionsList,
                  child: IconButton(
                    icon: Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      context.read<MapServicesCubit>().clearSearchQuery();
                    },
                  ),
                ),
                onChanged: (value) {
                  _debouncer.run(() {
                    context
                        .read<MapServicesCubit>()
                        .fetchLocationSuggestions(value);
                  });
                },
              );
            },
          ),
          BlocBuilder<MapServicesCubit, MapServicesState>(
            buildWhen: (previous, current) =>
            previous.showSuggestionsList != current.showSuggestionsList,
            builder: (context, state) {
              bool showSuggestionsList = state.showSuggestionsList;
              return Visibility(
                visible: showSuggestionsList,
                child: Container(
                  height: 100,
                  margin: const EdgeInsets.symmetric(horizontal: 8.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 8,
                        spreadRadius: 2,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: BlocBuilder<MapServicesCubit, MapServicesState>(
                    builder: (context, state) {
                      if (state.getSuggestionsState.isLoaded) {
                        return SingleChildScrollView(
                          child: ListView.builder(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: state.suggestions.length,
                            itemBuilder: (context, index) {
                              final suggestion = state.suggestions[index];
                              return LocationItemComponent(
                                  suggestion: suggestion,
                                  onLocationSelected: () {
                                    final latLng = LatLng(
                                      suggestion.latitude,
                                      suggestion.longitude,
                                    );
                                    _searchController.text =
                                        suggestion.locationName;
                                    context
                                        .read<MapServicesCubit>()
                                        .updateSelectedLocation(latLng);
                                    context
                                        .read<MapServicesCubit>()
                                        .changeVisibilityOfSuggestionsList();
                                    widget.onLocationSelected(latLng);
                                  });
                            },
                          ),
                        );
                      } else {
                        return Center(
                          child: CircularProgressIndicator(),
                        );
                      }
                    },
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}