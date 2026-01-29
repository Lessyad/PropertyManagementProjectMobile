import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/services/select_location_service/presentation/controller/select_location_service_cubit.dart';
import 'package:latlong2/latlong.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';

import '../../../../core/components/loading_overlay_component.dart';
import '../../../../core/services/map_services/map_services_DI.dart';
import '../../../../core/services/map_services/presentation/controller/map_services_cubit.dart';
import '../../../../core/services/map_services/presentation/screens/searchable_map_component.dart';
import '../../../../core/services/service_locator.dart';
import '../components/country_selector_component.dart';
import '../components/form_widget_component.dart';
import '../components/numbered_text_header_component.dart';
import '../components/select_amenities.dart';
import '../components/state_and_city_selector_component.dart';
import '../controller/add_new_real_estate_cubit.dart';

class AddNewRealEstateLocationScreen extends StatelessWidget {
  const AddNewRealEstateLocationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    var addNewRealEstateCubit = context.read<AddNewRealEstateCubit>();

    return BlocProvider(
      create: (context) {
        MapServicesDi().setup();
        var mapServicesCubit = MapServicesCubit(
          ServiceLocator.getIt(),
        );
        if(addNewRealEstateCubit.state.propertyDetailsEntity != null ){
          var propertyDetails = addNewRealEstateCubit.state.propertyDetailsEntity!;
          final latLng = LatLng(
            double.parse(propertyDetails.latitude.toString()),
            double.parse(propertyDetails.longitude.toString()),
          );
          mapServicesCubit.updateSelectedLocation(latLng);
        }

        return mapServicesCubit;
      },
      child: BlocBuilder<MapServicesCubit, MapServicesState>(
        builder: (context, state) {
          return Stack(
            children: [


              BlocBuilder<SelectLocationServiceCubit, SelectLocationServiceState>(
                buildWhen: (previous, current) =>
                previous.getCountriesState != current.getCountriesState ||
                    previous.getStatesState != current.getStatesState ||
                    previous.getCitiesState != current.getCitiesState,
                builder: (context, state) {
                  return Stack(
                    children: [
                      SingleChildScrollView(
                        padding: const EdgeInsets.all(16.0),
                        child: Form(
                          key: addNewRealEstateCubit.locationForm,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              NumberedTextHeaderComponent(
                                number: '3',
                                text: LocaleKeys.locationAndFeatures.tr(),
                              ),
                              SizedBox(height: context.scale(20)),

                              // Country Selector
                              const CountrySelectorComponent(),

                              // State and City Selector
                              const StateCitySelectorComponent(),

                              // Map Location
                              SearchableMapComponent(
                                onLocationSelected: (LatLng location) {
                                  addNewRealEstateCubit.changeSelectedLocation(location);
                                },
                              ),

                              SizedBox(height: context.scale(20)),

                              // Amenities
                              FormWidgetComponent(
                                label: LocaleKeys.nearbyServicesAndFacilities.tr(),
                                content: SelectAmenities(),
                              ),

                              // Payment Options
                              //const PaymentOptionsComponent(),
                            ],
                          ),
                        ),
                      ),
                      if (state.getCountriesState.isLoading ||
                          state.getStatesState.isLoading ||
                          state.getCitiesState.isLoading)
                        const LoadingOverlayComponent(opacity: 0),
                    ],
                  );
                },
              ),


            ],
          );
        },
      ),
    );
  }
}