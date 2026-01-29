import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';

import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../core/services/map_services/map_services_DI.dart';
import '../../../../../../core/services/map_services/presentation/controller/map_services_cubit.dart';
import '../../../../../../core/services/map_services/presentation/screens/show_lcaotion_component.dart';
import '../../../../../../core/services/service_locator.dart';
import '../../../../../home_module/home_imports.dart';

class VehicleDetailsLocation extends StatelessWidget {
  const VehicleDetailsLocation({super.key, required this.location});

  final LatLng location;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(height: context.scale(16)),
        SizedBox(
          height: context.scale(205),
          child: Stack(
            children: [
              BlocProvider(
                create: (context) {
                  MapServicesDi().setup();
                  return MapServicesCubit(
                    ServiceLocator.getIt(),
                  );
                },
                child: Positioned.fill(
                  child: ShowLocationScreen(
                    height: 205,
                    location: location,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
