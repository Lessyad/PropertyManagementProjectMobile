import 'package:latlong2/latlong.dart';

import '../../../../../features/home_module/home_imports.dart';
import '../../domain/entities/location_entity.dart';
import '../controller/map_services_cubit.dart';

class LocationItemComponent extends StatelessWidget {
  const LocationItemComponent({super.key , required this.suggestion , required this.onLocationSelected});

  final LocationEntity suggestion;
  final Function onLocationSelected;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(suggestion.locationName),
      subtitle:
      Text(suggestion.locationAddress ?? ''),
      onTap:(){ onLocationSelected(); },
    );

  }
}
