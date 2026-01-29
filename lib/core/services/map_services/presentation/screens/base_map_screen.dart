import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:latlong2/latlong.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../../../configuration/managers/color_manager.dart';
import '../../../get_location_permission.dart';
import '../controller/map_services_cubit.dart';


class CustomMap extends StatefulWidget {
  const CustomMap({
    super.key,
    required this.points,
    this.onLocationSelected,
    this.height = 180,
  });

  final List<LatLng> points;
  final Function(LatLng)? onLocationSelected;
  final double height ;
  @override
  State<CustomMap> createState() => _CustomMapState();
}

class _CustomMapState extends State<CustomMap> {
  final MapController _mapController = MapController();

  @override
  void didUpdateWidget(CustomMap oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.points.isNotEmpty) {
      _mapController.move(widget.points.first, 15);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          height: context.scale(widget.height),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: ColorManager.greyShade,
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 8,
                spreadRadius: 2,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: FlutterMap(
            mapController: _mapController,
            options: MapOptions(
              initialCenter: widget.points.isNotEmpty ? widget.points.first : LatLng(30.06, 31.25),
              initialZoom: 15,
              onTap: (tapPosition, latLng) {
                if (widget.onLocationSelected != null) {
                  widget.onLocationSelected!(latLng);
                }
              },
            ),
            children: [
              TileLayer(
                urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                subdomains: ['a', 'b', 'c'],
              ),
              BlocBuilder<MapServicesCubit, MapServicesState>(
                builder: (context, state) {
                  return Visibility(
                    visible: state.updateSelectedLocationState.isLoaded,
                    child: MarkerLayer(
                      markers: widget.points.map((point) {
                        return Marker(
                          width: 40.0,
                          height: 40.0,
                          point: point,
                          child: SvgImageComponent(iconPath: AppAssets.locationMarkerIcon),
                        );
                      }).toList(),
                    ),
                  );
                },
              ),
            ],
          ),
        ),

        PositionedDirectional(
          start: context.scale(16),
          bottom: context.scale(16),
          child: InkWell(
            onTap: () async {
              if (widget.onLocationSelected == null) {
                if (widget.points.isNotEmpty) {
                  _mapController.move(widget.points.first, 15);
                }
              } else {
                final position = await LocationServicePermissions.getCurrentLocation(context);

                if (position != null) {
                  final currentLocation = LatLng(position.latitude, position.longitude);

                  context.read<MapServicesCubit>().updateSelectedLocation(currentLocation);

                  _mapController.move(currentLocation, 15);

                  widget.onLocationSelected!(currentLocation);
                }
              }
            },
            child: SvgImageComponent(
              iconPath: AppAssets.currentLocationIcon,
              width: 32,
              height: 32,
            ),
          ),
        ),
      ],
    );
  }
}