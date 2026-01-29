import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/components/button_app_component.dart';
import 'package:enmaa/core/components/app_text_field.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/components/app_bar_component.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../core/translation/locale_keys.dart';

class LocationPickerScreen extends StatefulWidget {
  final String title;
  final String? initialAddress;
  final LatLng? initialLocation;

  const LocationPickerScreen({
    super.key,
    required this.title,
    this.initialAddress,
    this.initialLocation,
  });

  @override
  State<LocationPickerScreen> createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  final MapController _mapController = MapController();
  final TextEditingController _addressController = TextEditingController();

  LatLng? _selectedLocation;
  String _selectedAddress = '';
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeLocation();
  }

  Future<void> _initializeLocation() async {
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.initialLocation != null) {
        _selectedLocation = widget.initialLocation!;
        _addressController.text = widget.initialAddress ?? '';
        _selectedAddress = widget.initialAddress ?? '';
      } else {
        // Obtenir la position actuelle
        final position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high,
        );
        _selectedLocation = LatLng(position.latitude, position.longitude);

        // Obtenir l'adresse
        await _getAddressFromLatLng(_selectedLocation!);
      }
    } catch (e) {
      // Position par défaut (Casablanca)
      _selectedLocation = LatLng(33.5731, -7.5898);
      _selectedAddress = LocaleKeys.casablancaMorocco.tr();
      _addressController.text = _selectedAddress;
    }

    setState(() {
      _isLoading = false;
    });
  }

  Future<void> _getAddressFromLatLng(LatLng location) async {
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String address = '';

        if (place.street != null && place.street!.isNotEmpty) {
          address += place.street!;
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.subLocality!;
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.locality!;
        }
        if (place.country != null && place.country!.isNotEmpty) {
          if (address.isNotEmpty) address += ', ';
          address += place.country!;
        }

        setState(() {
          _selectedAddress = address;
          _addressController.text = address;
        });
      }
    } catch (e) {
      setState(() {
        _selectedAddress = LocaleKeys.addressNotFound.tr();
        _addressController.text = LocaleKeys.addressNotFound.tr();
      });
    }
  }

  Future<void> _searchLocation() async {
    if (_addressController.text.trim().isEmpty) return;

    setState(() {
      _isLoading = true;
    });

    try {
      List<Location> locations = await locationFromAddress(_addressController.text);

      if (locations.isNotEmpty) {
        Location location = locations.first;
        LatLng newLocation = LatLng(location.latitude, location.longitude);

        setState(() {
          _selectedLocation = newLocation;
        });

        // Déplacer la carte vers la nouvelle position
        _mapController.move(newLocation, 15);

        // Obtenir l'adresse complète
        await _getAddressFromLatLng(newLocation);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.addressNotFound.tr()),
          backgroundColor: Colors.red,
        ),
      );
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: widget.title,
            showNotificationIcon: false,
            showLocationIcon: false,
            showBackIcon: true,
            centerText: true,
          ),

          Expanded(
            child: Column(
              children: [
                // Barre de recherche
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: AppTextField(
                          hintText: LocaleKeys.searchAddressHint.tr(),
                          controller: _addressController,
                          borderRadius: 20,
                          backgroundColor: ColorManager.whiteColor,
                          padding: EdgeInsets.zero,
                          suffixIcon: _isLoading
                              ? SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                              strokeWidth: 2,
                              valueColor: AlwaysStoppedAnimation<Color>(
                                ColorManager.primaryColor,
                              ),
                            ),
                          )
                              : Icon(
                            Icons.search,
                            color: ColorManager.primaryColor,
                          ),

                        ),
                      ),
                      SizedBox(width: 8),
                      ButtonAppComponent(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: ColorManager.primaryColor,
                          borderRadius: BorderRadius.circular(24),
                        ),
                        buttonContent: Icon(
                          Icons.my_location,
                          color: ColorManager.whiteColor,
                          size: 20,
                        ),
                        onTap: () async {
                          setState(() {
                            _isLoading = true;
                          });

                          try {
                            final position = await Geolocator.getCurrentPosition(
                              desiredAccuracy: LocationAccuracy.high,
                            );
                            LatLng newLocation = LatLng(
                              position.latitude,
                              position.longitude,
                            );

                            setState(() {
                              _selectedLocation = newLocation;
                            });

                            _mapController.move(newLocation, 15);
                            await _getAddressFromLatLng(newLocation);
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(LocaleKeys.cannotGetLocation.tr()),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }

                          setState(() {
                            _isLoading = false;
                          });
                        },
                      ),
                    ],
                  ),
                ),

                // Carte
                Expanded(
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 16),
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
                    child: _isLoading || _selectedLocation == null
                        ? Center(
                      child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation<Color>(
                          ColorManager.primaryColor,
                        ),
                      ),
                    )
                        : FlutterMap(
                      mapController: _mapController,
                      options: MapOptions(
                        initialCenter: _selectedLocation!,
                        initialZoom: 15,
                        onTap: (tapPosition, latLng) {
                          setState(() {
                            _selectedLocation = latLng;
                          });
                          _getAddressFromLatLng(latLng);
                        },
                      ),
                      children: [
                        TileLayer(
                          urlTemplate: "https://{s}.basemaps.cartocdn.com/light_all/{z}/{x}/{y}{r}.png",
                          subdomains: ['a', 'b', 'c'],
                        ),
                        MarkerLayer(
                          markers: [
                            Marker(
                              width: 40.0,
                              height: 40.0,
                              point: _selectedLocation!,
                              child: SvgImageComponent(
                                iconPath: AppAssets.locationMarkerIcon,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Boutons d'action
                Container(
                  padding: EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: ButtonAppComponent(
                          height: 48,
                          decoration: BoxDecoration(
                            color: ColorManager.whiteColor,
                            borderRadius: BorderRadius.circular(24),
                            border: Border.all(
                              color: ColorManager.primaryColor,
                              width: 1,
                            ),
                          ),
                          buttonContent: Text(
                            LocaleKeys.cancelButton.tr(),
                            style: getBoldStyle(
                              color: ColorManager.primaryColor,
                              fontSize: FontSize.s14,
                            ),
                          ),
                          onTap: () {
                            Navigator.of(context).pop();
                          },
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: ButtonAppComponent(
                          height: 48,
                          decoration: BoxDecoration(
                            color: ColorManager.primaryColor,
                            borderRadius: BorderRadius.circular(24),
                          ),
                          buttonContent: Text(
                            LocaleKeys.confirmButton.tr(),
                            style: getBoldStyle(
                              color: ColorManager.whiteColor,
                              fontSize: FontSize.s14,
                            ),
                          ),
                          onTap: () {
                            if (_selectedLocation != null) {
                              print('📍 CONFIRMATION - Envoi des coordonnées:');
                              print('   Lat: ${_selectedLocation!.latitude}');
                              print('   Lng: ${_selectedLocation!.longitude}');
                              Navigator.of(context).pop({
                                'location': _selectedLocation,
                                'address': _selectedAddress,
                                'latitude': _selectedLocation!.latitude.toString(),
                                'longitude': _selectedLocation!.longitude.toString(),
                              });
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _addressController.dispose();
    super.dispose();
  }
}