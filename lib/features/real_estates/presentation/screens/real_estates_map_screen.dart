import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/components/loading_overlay_component.dart';
import '../../../../core/utils/enums.dart';
import '../components/real_estate_map_components/country_selector_container.dart';
import '../controller/filter_properties_controller/filter_property_cubit.dart';
import '../controller/real_estate_cubit.dart';
import '../controller/map_controller_component.dart';
import '../components/real_estate_map_components/property_type_selector_component.dart';
import '../components/real_estate_map_components/map_floating_buttons_component.dart';
import '../components/real_estate_map_components/property_tab_bar_component.dart';
import '../components/real_estate_map_components/property_search_bar_component.dart';
import '../components/real_estate_map_components/properties_bottom_sheet_component.dart';
import '../components/real_estate_map_components/selected_property_card_component.dart';

class RealEstateMapScreen extends StatefulWidget {
  const RealEstateMapScreen({super.key});

  @override
  State<RealEstateMapScreen> createState() => _RealEstateMapScreenState();
}

class _RealEstateMapScreenState extends State<RealEstateMapScreen>
    with SingleTickerProviderStateMixin {
  late final MapControllerComponent _mapController;
  late final TabController _tabController;
  final DraggableScrollableController _sheetController =
      DraggableScrollableController();

  @override
  void initState() {
    super.initState();
    final currentOperationType =
        context.read<FilterPropertyCubit>().state.currentPropertyOperationType;

    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex:
          currentOperationType == PropertyOperationType.forSale ? 0 : 1,
    );

    _mapController = MapControllerComponent(
      context: context,
      onTabControllerCreated: (controller) {
        _tabController = controller;
      },
      tabController: _tabController,
    );

    _mapController.initialize();
    _tabController.addListener(_mapController.onTabChanged);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final state = context.read<RealEstateCubit>().state;
    _mapController.generateCustomMarkers(state.mapProperties);
  }

  @override
  void didUpdateWidget(covariant RealEstateMapScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final state = context.read<RealEstateCubit>().state;
    _mapController.generateCustomMarkers(state.mapProperties);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<FilterPropertyCubit, FilterPropertyState>(
      listener: (context, state) {
        _mapController.onFilterPropertyStateChanged(state);
      },
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: BlocConsumer<RealEstateCubit, RealEstateState>(
          listener: (context, state) {
            _mapController.onRealEstateStateChanged(state);
          },
          builder: (context, state) {
            return GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: _mapController.clearSelectedProperty,
              child: Stack(
                children: [
                  // Google Map with ListenableBuilder
                  ListenableBuilder(
                    listenable: _mapController,
                    builder: (context, child) {
                      return _mapController.buildGoogleMap(state.mapProperties);
                    },
                  ),

                  // Country Selector Container
                  Positioned(
                    top: context.scale(300),
                    left: context.scale(16),
                    child: CountrySelectorContainer(
                      selectedCountry: _mapController.selectedCountry,
                      onCountrySelected: _mapController.selectCountry,
                    ),
                  ),

                  // Search Bar
                  PropertySearchBarComponent(
                    onTap: () => _mapController
                        .openFilterBottomSheet(context.read<RealEstateCubit>()),
                  ),

                  // Tab Bar and Property Type Selector
                  Positioned(
                    top: context.scale(120),
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        PropertyTabBarComponent(tabController: _tabController),
                        PropertyTypeSelectorComponent(
                          onPropertyTypeChanged:
                              _mapController.onPropertyTypeChanged,
                        ),
                      ],
                    ),
                  ),

                  // Loading Indicator
                  if (!_mapController.isMapReady ||
                      state.getMapPropertiesState == RequestState.loading)
                    LoadingOverlayComponent(
                      opacity: 0,
                      text: 'جاري تحميل العقارات ...',
                    ),

                  // Map Control Buttons
                  ListenableBuilder(
                    listenable: _mapController,
                    builder: (context, child) {
                      return MapFloatingButtonsComponent(
                        toggleMapType: _mapController.toggleMapType,
                        centerOnCurrentLocation:
                            _mapController.centerOnCurrentLocation,
                        zoomIn: _mapController.zoomIn,
                        zoomOut: _mapController.zoomOut,
                        currentMapType: _mapController.currentMapType,
                      );
                    },
                  ),

                  // Properties Bottom Sheet
                  PropertiesBottomSheetComponent(
                    controller: _sheetController,
                    propertiesCount:
                        _mapController.getMarkersCount(state.mapProperties),
                  ),

                  // Selected Property Card
                  ListenableBuilder(
                    listenable: _mapController,
                    builder: (context, child) {
                      return _mapController.hasSelectedProperty
                          ? SelectedPropertyCardComponent(
                              property: _mapController.selectedProperty!,
                              screenOffset:
                                  _mapController.selectedPropertyScreenOffset!,
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _sheetController.dispose();
    _mapController.dispose();
    _tabController.removeListener(_mapController.onTabChanged);
    _tabController.dispose();
    super.dispose();
  }
}

// Country Selector Widget

