
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../components/locations_search_component.dart';
import '../controller/map_services_cubit.dart';
import 'base_map_screen.dart';

class SearchableMapComponent extends StatelessWidget {
  final Function(LatLng) onLocationSelected;

  const SearchableMapComponent({
    super.key,
    required this.onLocationSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        BlocBuilder<MapServicesCubit, MapServicesState>(
          buildWhen: (previous, current) =>
              previous.selectedLocation != current.selectedLocation,
          builder: (context, state) {
            return CustomMap(
              points: state.selectedLocation != null
                  ? [state.selectedLocation!]
                  : [],
              onLocationSelected: (LatLng location) {
                context
                    .read<MapServicesCubit>()
                    .updateSelectedLocation(location);
                onLocationSelected(location);
              },
            );
          },
        ),
        /// text field and data list
        LocationsSearchComponent(
          onLocationSelected: onLocationSelected,
        ),
      ],
    );
  }
}
