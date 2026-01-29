import 'dart:async';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/components/custom_bottom_sheet.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/services/debouncer.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:enmaa/core/utils/enums.dart';
import '../../../../core/services/shared_preferences_service.dart';
import '../../domain/entities/base_property_entity.dart';
import '../components/real_estate_map_components/map_markers_component.dart';
import '../controller/real_estate_cubit.dart';
import '../controller/filter_properties_controller/filter_property_cubit.dart';
import '../screens/real_estate_filter_screen.dart';

class MapControllerComponent extends ChangeNotifier {
  final BuildContext context;
  final Function(TabController) onTabControllerCreated;
  final SharedPreferencesService _prefsService;
  TabController tabController;
  GoogleMapController? _mapController;

  GoogleMapController get mapController => _mapController!;

  LatLng currentLocation = const LatLng(30.0444, 31.2357); // Cairo (Egypt capital)
  bool _isMapReady = false;
  late Debouncer _debouncer;
  double lastZoom = 14.0;
  LatLng? _lastFetchedCenter;
  double _lastSavedZoom = 14.0;
  MapType _currentMapType = MapType.normal;

  PropertyEntity? _selectedProperty;
  Offset? _selectedPropertyScreenOffset;
  Map<int, BitmapDescriptor> _customMarkers = {};
  Set<Polygon> _polygons = {};

  // Country selection properties
  String _selectedCountry = 'Egypt';
  LatLngBounds? _countryBounds;
  bool changeCountry = false;

  // Constants for map type and country storage keys
  static const String _mapTypeKey = 'last_map_type';
  static const String _countryKey = 'last_country';
  static const String _latKey = 'last_lat';
  static const String _lngKey = 'last_lng';
  static const String _zoomKey = 'last_zoom';

  MapControllerComponent({
    required this.context,
    required this.onTabControllerCreated,
    required this.tabController,
    SharedPreferencesService? prefsService,
  }) : _prefsService = prefsService ?? SharedPreferencesService() {
    _debouncer = Debouncer(delay: const Duration(milliseconds: 800)); // Increased for performance
  }

  void initialize() {
    _loadLastLocation();
    _loadLastMapType();
    _loadLastCountry();
    _setCountryBounds(_selectedCountry);
  }

  // Getters for the main widget
  bool get isMapReady => _isMapReady;
  PropertyEntity? get selectedProperty => _selectedProperty;
  Offset? get selectedPropertyScreenOffset => _selectedPropertyScreenOffset;
  bool get hasSelectedProperty =>
      _selectedProperty != null && _selectedPropertyScreenOffset != null;
  MapType get currentMapType => _currentMapType;
  String get selectedCountry => _selectedCountry;

  int getMarkersCount(List<PropertyEntity> properties) {
    return properties.length;
  }

  // Map lifecycle methods
  Future<void> _loadLastLocation() async {
    final lat = _prefsService.getValue(_latKey, defaultValue: null) as double?;
    final lng = _prefsService.getValue(_lngKey, defaultValue: null) as double?;
    final zoom = _prefsService.getValue(_zoomKey, defaultValue: null) as double?;

    if (lat != null && lng != null && zoom != null) {
      currentLocation = LatLng(lat, lng);
      lastZoom = zoom;
      _lastSavedZoom = zoom;
      _isMapReady = true;

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentLocation, lastZoom),
        );
      }
      fetchPropertiesForBounds(zoom: lastZoom, center: currentLocation);
    } else {
      currentLocation = _getCountryCapital(_selectedCountry);
      lastZoom = getCountryMinZoom(_selectedCountry);
      _lastSavedZoom = lastZoom;
      _isMapReady = true;

      if (_mapController != null) {
        _mapController!.animateCamera(
          CameraUpdate.newLatLngZoom(currentLocation, lastZoom),
        );
      }
      fetchPropertiesForBounds(
        zoom: lastZoom,
        center: currentLocation,
        initialBounds: _getInitialBounds(_selectedCountry),
      );
    }
  }

  Future<void> _saveLocation(LatLng center, double zoom) async {
    await _prefsService.storeValue(_latKey, center.latitude);
    await _prefsService.storeValue(_lngKey, center.longitude);
    await _prefsService.storeValue(_zoomKey, zoom);
  }

  // Map data fetching
  void fetchPropertiesForBounds({
    required double zoom,
    required LatLng center,
    LatLngBounds? initialBounds,
    Map<String, dynamic>? additionalFilters,
  }) async {
    if (_mapController == null || !_isMapReady) return;



    LatLngBounds reducedBounds;

    if (initialBounds != null) {
      reducedBounds = initialBounds;
    } else {
      final bounds = await _mapController!.getVisibleRegion();
      final ne = bounds.northeast;
      final sw = bounds.southwest;

      const reductionFactor = 0.3;
      final centerLat = (ne.latitude + sw.latitude) / 2;
      final centerLng = (ne.longitude + sw.longitude) / 2;
      final latSpan = (ne.latitude - sw.latitude) * reductionFactor;
      final lngSpan = (ne.longitude - sw.longitude) * reductionFactor;

      final reducedNe = LatLng(
        centerLat + latSpan / 2,
        centerLng + lngSpan / 2,
      );
      final reducedSw = LatLng(
        centerLat - latSpan / 2,
        centerLng - lngSpan / 2,
      );

      final clippedNe = LatLng(
        reducedNe.latitude.clamp(
          _countryBounds!.southwest.latitude,
          _countryBounds!.northeast.latitude,
        ),
        reducedNe.longitude.clamp(
          _countryBounds!.southwest.longitude,
          _countryBounds!.northeast.longitude,
        ),
      );
      final clippedSw = LatLng(
        reducedSw.latitude.clamp(
          _countryBounds!.southwest.latitude,
          _countryBounds!.northeast.latitude,
        ),
        reducedSw.longitude.clamp(
          _countryBounds!.southwest.longitude,
          _countryBounds!.northeast.longitude,
        ),
      );

      reducedBounds = LatLngBounds(
        northeast: LatLng(
          clippedNe.latitude > clippedSw.latitude
              ? clippedNe.latitude
              : clippedSw.latitude,
          clippedNe.longitude > clippedSw.longitude
              ? clippedNe.longitude
              : clippedSw.longitude,
        ),
        southwest: LatLng(
          clippedNe.latitude > clippedSw.latitude
              ? clippedSw.latitude
              : clippedNe.latitude,
          clippedNe.longitude > clippedSw.longitude
              ? clippedSw.longitude
              : clippedNe.longitude,
        ),
      );
    }

    final rectangleNeLat = reducedBounds.northeast.latitude;
    final rectangleNeLng = reducedBounds.northeast.longitude;
    final rectangleSwLat = reducedBounds.southwest.latitude;
    final rectangleSwLng = reducedBounds.southwest.longitude;

    _updateBoundsPolygon(reducedBounds);

    final operationType =
        context.read<FilterPropertyCubit>().state.currentPropertyOperationType;
    final filterData = additionalFilters ??
        context.read<FilterPropertyCubit>().prepareDataForApi();

    context.read<RealEstateCubit>().fetchMapProperties(
      neLat: rectangleNeLat,
      neLng: rectangleNeLng,
      swLat: rectangleSwLat,
      swLng: rectangleSwLng,
      operationType: operationType,
      filters: filterData,
    );

    _lastFetchedCenter = center;
    lastZoom = zoom;
    await _saveLocation(center, zoom);
  }

  void _updateBoundsPolygon(LatLngBounds reducedBounds) {
    _polygons.clear();
    _polygons.add(
      Polygon(
        polygonId: const PolygonId('reduced_bounds'),
        points: [
          LatLng(reducedBounds.northeast.latitude,
              reducedBounds.northeast.longitude),
          LatLng(reducedBounds.northeast.latitude,
              reducedBounds.southwest.longitude),
          LatLng(reducedBounds.southwest.latitude,
              reducedBounds.southwest.longitude),
          LatLng(reducedBounds.southwest.latitude,
              reducedBounds.northeast.longitude),
        ],
        strokeColor: ColorManager.grey2.withOpacity(0.8),
        strokeWidth: 3,
        fillColor: Colors.blue.withOpacity(0.1),
        zIndex: 1,
      ),
    );
    notifyListeners();
  }

  // Get initial bounds for a country
  LatLngBounds _getInitialBounds(String country) {
    final center = _getCountryCapital(country);
    double latSpan;
    double lngSpan;

    switch (country) {
      case 'Egypt':
      case 'Morocco':
        latSpan = 3.0;  // Increased from 2.0
        lngSpan = 3.0;  // Increased from 2.0
        break;
      case 'Saudi Arabia':
      case 'Mauritania':
        latSpan = 5.0;  // Increased from 4.0
        lngSpan = 5.0;  // Increased from 4.0
        break;
      default:
        latSpan = 3.0;
        lngSpan = 3.0;
    }

    final ne = LatLng(
      center.latitude + latSpan / 2,
      center.longitude + lngSpan / 2,
    );
    final sw = LatLng(
      center.latitude - latSpan / 2,
      center.longitude - lngSpan / 2,
    );

    final clippedNe = LatLng(
      ne.latitude.clamp(
        _countryBounds!.southwest.latitude,
        _countryBounds!.northeast.latitude,
      ),
      ne.longitude.clamp(
        _countryBounds!.southwest.longitude,
        _countryBounds!.northeast.longitude,
      ),
    );
    final clippedSw = LatLng(
      sw.latitude.clamp(
        _countryBounds!.southwest.latitude,
        _countryBounds!.northeast.latitude,
      ),
      sw.longitude.clamp(
        _countryBounds!.southwest.longitude,
        _countryBounds!.northeast.longitude,
      ),
    );

    return LatLngBounds(
      northeast: LatLng(
        clippedNe.latitude > clippedSw.latitude
            ? clippedNe.latitude
            : clippedSw.latitude,
        clippedNe.longitude > clippedSw.longitude
            ? clippedNe.longitude
            : clippedSw.longitude,
      ),
      southwest: LatLng(
        clippedNe.latitude > clippedSw.latitude
            ? clippedSw.latitude
            : clippedNe.latitude,
        clippedNe.longitude > clippedSw.longitude
            ? clippedSw.longitude
            : clippedNe.longitude,
      ),
    );
  }

  // Marker creation methods
  Future<void> generateCustomMarkers(List<PropertyEntity> properties) async {
    if (properties.isEmpty) {
      print('No properties to generate markers for');
      return;
    }

    print('Generating markers for ${properties.length} properties');
    final newMarkers = <int, BitmapDescriptor>{};
    for (var property in properties) {
      if (!_customMarkers.containsKey(property.id)) {
        try {
          newMarkers[property.id] = await mapPriceMarkerComponent(property.price, context);
          print('Generated marker for property ID: ${property.id}');
        } catch (e) {
          print('Error generating marker for property ID: ${property.id}: $e');
        }
      }
    }

    _customMarkers.addAll(newMarkers);
    print('Total markers in _customMarkers: ${_customMarkers.length}');
    notifyListeners();
  }

  // Control methods
  void toggleMapType() {
    _currentMapType = _currentMapType == MapType.normal ? MapType.satellite : MapType.normal;
    _saveMapType(_currentMapType);
    notifyListeners();
  }

  Future<void> centerOnCurrentLocation() async {
    currentLocation = _getCountryCapital(_selectedCountry);
    lastZoom = getCountryMinZoom(_selectedCountry);
    _isMapReady = true;

    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.newLatLngZoom(currentLocation, lastZoom),
      );
    }
    fetchPropertiesForBounds(
      zoom: lastZoom,
      center: currentLocation,
      initialBounds: _getInitialBounds(_selectedCountry),
    );
  }

  void zoomIn() async {
    if (_mapController != null) {
      await _mapController!.animateCamera(
        CameraUpdate.zoomIn(),
        duration: const Duration(milliseconds: 200),
      );
      // Fetching will be handled by onCameraIdle
    }
  }

  void zoomOut() async {
    if (_mapController != null) {
      final currentZoom = await _mapController!.getZoomLevel();
      double minZoom = getCountryMinZoom(_selectedCountry);
      if (currentZoom > minZoom) {
        await _mapController!.animateCamera(
          CameraUpdate.zoomOut(),
          duration: const Duration(milliseconds: 200),
        );
        // Fetching will be handled by onCameraIdle
      }
    }
  }

  void onTabChanged() {
    if (tabController.indexIsChanging ||
        tabController.index != tabController.previousIndex) {
      final operationType = tabController.index == 0
          ? PropertyOperationType.forSale
          : PropertyOperationType.forRent;

      context.read<FilterPropertyCubit>().changePropertyOperationType(operationType);

      fetchPropertiesForBounds(zoom: lastZoom, center: currentLocation);
    }
  }

  void onPropertyTypeChanged(PropertyType? type) {
    context.read<FilterPropertyCubit>().changePropertyType(type);
    fetchPropertiesForBounds(zoom: lastZoom, center: currentLocation);
  }

  // Country selection methods
  void selectCountry(String country) async {
    if (_selectedCountry == country) return;
    changeCountry = true;

    _selectedCountry = country;
    await _saveCountry(country);
    _setCountryBounds(country);

    currentLocation = _getCountryCapital(country);
    final targetZoom = getCountryMinZoom(country);

    // Clear any previous selection
    clearSelectedProperty();

    if (_mapController != null) {
      try {
        // First ensure the camera moves to the new location
        await _mapController!.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: currentLocation,
              zoom: targetZoom,
            ),
          ),
        );

        // Add a small delay to ensure the camera movement completes
        await Future.delayed(const Duration(milliseconds: 500));

        fetchPropertiesForBounds(
          zoom: targetZoom,
          center: currentLocation,
          initialBounds: _getInitialBounds(country),
        );
        changeCountry = false;
      } catch (e) {
        print('Error moving camera: $e');
        fetchPropertiesForBounds(
          zoom: targetZoom,
          center: currentLocation,
          initialBounds: _getInitialBounds(country),
        );
      }
    } else {
      lastZoom = targetZoom;
      fetchPropertiesForBounds(
        zoom: targetZoom,
        center: currentLocation,
        initialBounds: _getInitialBounds(country),
      );
    }

    notifyListeners();
  }

  LatLng _getCountryCapital(String country) {
    switch (country) {
      case 'Egypt':
        return const LatLng(30.0444, 31.2357); // Cairo
      case 'Saudi Arabia':
        return const LatLng(24.7136, 46.6753); // Riyadh
      case 'Mauritania':
        return const LatLng(18.0735, -15.9785); // Nouakchott
      case 'Morocco':
        return const LatLng(34.0209, -6.8416); // Rabat
      default:
        return const LatLng(30.0444, 31.2357); // Default to Cairo
    }
  }

  double getCountryMinZoom(String country) {
    switch (country) {
      case 'Egypt':
      case 'Morocco':
        return 6.0;
      case 'Saudi Arabia':
      case 'Mauritania':
        return 5.0;
      default:
        return 6.0;
    }
  }

  void _setCountryBounds(String country) {
    switch (country) {
      case 'Egypt':
        _countryBounds = LatLngBounds(
          southwest: LatLng(22.0, 24.7),
          northeast: LatLng(31.7, 36.9),
        );
        break;
      case 'Saudi Arabia':
        _countryBounds = LatLngBounds(
          southwest: LatLng(16.0, 34.5),
          northeast: LatLng(32.2, 55.7),
        );
        break;
      case 'Mauritania':
        _countryBounds = LatLngBounds(
          southwest: LatLng(14.7, -17.1),
          northeast: LatLng(27.3, -4.8),
        );
        break;
      case 'Morocco':
        _countryBounds = LatLngBounds(
          southwest: LatLng(27.7, -13.2),
          northeast: LatLng(35.9, -1.0),
        );
        break;
      default:
        _countryBounds = LatLngBounds(
          southwest: LatLng(22.0, 24.7),
          northeast: LatLng(31.7, 36.9),
        );
    }
  }

  Future<void> _loadLastCountry() async {
    final country = _prefsService.getValue(_countryKey, defaultValue: null) as String?;
    if (country != null) {
      _selectedCountry = country;
      _setCountryBounds(country);
      notifyListeners();
    }
  }

  Future<void> _saveCountry(String country) async {
    await _prefsService.storeValue(_countryKey, country);
  }

  // Callbacks for interactions
  void _onMarkerTap(PropertyEntity property) async {
    if (_mapController == null) return;
    final screenCoordinate = await _mapController!.getScreenCoordinate(
      LatLng(property.latitude, property.longitude),
    );
    final devicePixelRatio = MediaQuery.of(context).devicePixelRatio;
    _selectedProperty = property;
    _selectedPropertyScreenOffset = Offset(
      screenCoordinate.x / devicePixelRatio,
      screenCoordinate.y / devicePixelRatio,
    );
    notifyListeners();
  }

  void clearSelectedProperty() {
    _selectedProperty = null;
    _selectedPropertyScreenOffset = null;
    notifyListeners();
  }

  double _calculateDistance(LatLng a, LatLng b) {
    return ((a.latitude - b.latitude).abs() + (a.longitude - b.longitude).abs());
  }

  Widget buildGoogleMap(List<PropertyEntity> properties) {
    return GoogleMap(
      initialCameraPosition: CameraPosition(
        target: _getCountryCapital(_selectedCountry),
        zoom: getCountryMinZoom(_selectedCountry),
      ),
      mapType: _currentMapType,
      myLocationEnabled: false,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: true,
      minMaxZoomPreference: MinMaxZoomPreference(
        getCountryMinZoom(_selectedCountry),
        18.0,
      ),
      cameraTargetBounds: _countryBounds != null
          ? CameraTargetBounds(_countryBounds!)
          : CameraTargetBounds.unbounded,
      markers: buildMapMarkers(properties, _onMarkerTap, _customMarkers),
      polygons: _polygons,
      onMapCreated: (GoogleMapController controller) async {
        _mapController = controller;
        if (_isMapReady && _countryBounds != null) {
          await controller.moveCamera(
            CameraUpdate.newCameraPosition(
              CameraPosition(
                target: currentLocation,
                zoom: getCountryMinZoom(_selectedCountry),
              ),
            ),
          );
          fetchPropertiesForBounds(
            zoom: getCountryMinZoom(_selectedCountry),
            center: currentLocation,
            initialBounds: _getInitialBounds(_selectedCountry),
          );
        }
      },
      onCameraIdle: () async {
        if (_mapController == null || !_isMapReady || changeCountry) return;

        final bounds = await _mapController!.getVisibleRegion();
        final ne = bounds.northeast;
        final sw = bounds.southwest;

        const reductionFactor = 0.6;
        final centerLat = (ne.latitude + sw.latitude) / 2;
        final centerLng = (ne.longitude + sw.longitude) / 2;
        final latSpan = (ne.latitude - sw.latitude) * reductionFactor;
        final lngSpan = (ne.longitude - sw.longitude) * reductionFactor;

        final reducedNe = LatLng(
          centerLat + latSpan / 2,
          centerLng + lngSpan / 2,
        );
        final reducedSw = LatLng(
          centerLat - latSpan / 2,
          centerLng - lngSpan / 2,
        );

        final clippedNe = LatLng(
          reducedNe.latitude.clamp(
            _countryBounds!.southwest.latitude,
            _countryBounds!.northeast.latitude,
          ),
          reducedNe.longitude.clamp(
            _countryBounds!.southwest.longitude,
            _countryBounds!.northeast.longitude,
          ),
        );
        final clippedSw = LatLng(
          reducedSw.latitude.clamp(
            _countryBounds!.southwest.latitude,
            _countryBounds!.northeast.latitude,
          ),
          reducedSw.longitude.clamp(
            _countryBounds!.southwest.longitude,
            _countryBounds!.northeast.longitude,
          ),
        );

        final reducedBounds = LatLngBounds(
          northeast: LatLng(
            clippedNe.latitude > clippedSw.latitude
                ? clippedNe.latitude
                : clippedSw.latitude,
            clippedNe.longitude > clippedSw.longitude
                ? clippedNe.longitude
                : clippedSw.longitude,
          ),
          southwest: LatLng(
            clippedNe.latitude > clippedSw.latitude
                ? clippedSw.latitude
                : clippedNe.latitude,
            clippedNe.longitude > clippedSw.longitude
                ? clippedSw.longitude
                : clippedNe.longitude,
          ),
        );

        if (_lastFetchedCenter != null) {
          final distance = _calculateDistance(_lastFetchedCenter!, LatLng(centerLng, centerLat));
          if (distance < 0.1 ) {
            print('Skipping fetchPropertiesForBounds: minor change');
            return;
          }
        }

        _debouncer.run(() {
          fetchPropertiesForBounds(
            zoom: lastZoom,
            center:  LatLng(centerLng, centerLat),
            initialBounds: reducedBounds,
          );
        });
      },
      onTap: (_) => clearSelectedProperty(),
    );
  }

  void openFilterBottomSheet(RealEstateCubit cubit) {
    final rootContext = Navigator.of(context, rootNavigator: true).context;
    showModalBottomSheet(
      context: rootContext,
      backgroundColor: ColorManager.greyShade,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return CustomBottomSheet(
          widget: BlocProvider.value(
            value: cubit,
            child: RealEstateFilterScreen(
              hideLocationFields: true,
              mapController: this,
            ),
          ),
          headerText: LocaleKeys.filter.tr(),
        );
      },
    );
  }

  // State change handlers
  void onFilterPropertyStateChanged(FilterPropertyState state) {
    final newIndex =
    state.currentPropertyOperationType == PropertyOperationType.forSale ? 0 : 1;
    if (tabController.index != newIndex) {
      tabController.removeListener(onTabChanged);
      tabController.index = newIndex;
      tabController.addListener(onTabChanged);
      fetchPropertiesForBounds(zoom: lastZoom, center: currentLocation);
    }
  }

  void onRealEstateStateChanged(RealEstateState state) {
    if (state.getMapPropertiesState == RequestState.error) {
      CustomSnackBar.show(message: state.getMapPropertiesError);
    }

    generateCustomMarkers(state.mapProperties);
  }

  Future<void> _loadLastMapType() async {
    final mapTypeIndex = _prefsService.getValue(_mapTypeKey, defaultValue: null) as int?;
    if (mapTypeIndex != null) {
      _currentMapType = MapType.values[mapTypeIndex];
      notifyListeners();
    }
  }

  Future<void> _saveMapType(MapType type) async {
    await _prefsService.storeValue(_mapTypeKey, type.index);
  }

  @override
  void dispose() {
    super.dispose();
    _debouncer.dispose();
    _mapController?.dispose();
  }
}