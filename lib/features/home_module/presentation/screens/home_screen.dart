import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/features/home_module/presentation/components/categories_list.dart';
import 'package:enmaa/features/home_module/presentation/controller/home_bloc.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:enmaa/core/components/app_text_field.dart';
import 'package:visibility_detector/visibility_detector.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';

import '../../../../configuration/managers/value_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/card_listing_shimmer.dart';
import '../../../../core/utils/enums.dart';
import '../../../main_services_layout/app_services.dart';
import '../../../main_services_layout/main_service_layout_screen.dart';
// SUPPRIMER l'import du contrôleur véhicule si plus utilisé ailleurs
// import '../../../vehicle_management/vehicle/presentation/controller/vehicle_controller.dart';
import '../../home_imports.dart';
import '../components/real_state_card_component.dart';
import '../components/services_listing_widget.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  bool _isMounted = false;

  // SUPPRIMER la déclaration du contrôleur véhicule
  // final VehicleController vehicleController = Get.find<VehicleController>();

  @override
  void initState() {
    super.initState();
    _isMounted = true;
  }

  @override
  void dispose() {
    _isMounted = false;
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeBloc, HomeState>(
      builder: (context, state) {
        return Scaffold(
          backgroundColor: ColorManager.greyShade,
          body: Column(
            children: [
              AppBarComponent(
                appBarTextMessage: context.tr(LocaleKeys.homeAppBarMessage),
                homeBloc: context.read<HomeBloc>(),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context, rootNavigator: true).pushNamed(
                    RoutersNames.homeSearchScreen,
                    arguments: context.read<HomeBloc>(),
                  );
                },
                child: AppTextField(
                  hintText: context.tr(LocaleKeys.homeSearchHint),
                  prefixIcon: Icon(Icons.search, color: ColorManager.blackColor),
                  editable: false,
                ),
              ),
              Expanded(
                child: RefreshIndicator(
                  onRefresh: () async {
                    if (!_isMounted) return;
                    state.properties.forEach((propertyType, propertyData) {
                      if (propertyData.state != RequestState.initial && mounted) {
                        context.read<HomeBloc>().add(
                          FetchNearByProperties(
                            propertyType: propertyType,
                            location: '15',
                          ),
                        );
                      }
                    });
                    // SUPPRIMER l'appel au contrôleur véhicule
                    // vehicleController.getVehicles();
                  },
                  child: SingleChildScrollView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    child: Column(
                      children: [
                        ServicesList(
                          onServicePressed: (serviceName) {
                            if (appServiceScreens[serviceName] != null) {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => MainServicesScreen(serviceName: serviceName),
                                ),
                              );
                            } else {
                              CustomSnackBar.show(
                                context: context,
                                message: context.tr('${serviceName} ${LocaleKeys.homeServiceNotAvailable}'),
                                type: SnackBarType.error,
                              );
                            }
                          },
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          padding: EdgeInsets.zero,
                          physics: const NeverScrollableScrollPhysics(),
                          // MODIFIER: Réduire le nombre d'items de 5 à 4 (uniquement les propriétés)
                          itemCount: 4,
                          itemBuilder: (context, index) {
                            // SUPPRIMER toute la section véhicules (ancien index 4)

                            // Sections pour les propriétés (index 0-3)
                            final List<PropertyType> propertyTypes = [
                              PropertyType.apartment,
                              PropertyType.land,
                              PropertyType.building,
                              PropertyType.villa,
                            ];
                            final List<String> propertyTypeKeys = [
                              context.tr(LocaleKeys.homeApartments),
                              context.tr(LocaleKeys.homeLands),
                              context.tr(LocaleKeys.homeBuildings),
                              context.tr(LocaleKeys.homeVillas),
                            ];
                            final PropertyType propertyType = propertyTypes[index];

                            return Padding(
                              padding: EdgeInsets.only(top: context.scale(24)),
                              child: VisibilityDetector(
                                key: Key('property_section_${propertyType.toString()}'),
                                onVisibilityChanged: (info) {
                                  if (info.visibleFraction > 0.1 && mounted) {
                                    final propertyData = state.properties[propertyType];
                                    if (propertyData == null ||
                                        (propertyData.state != RequestState.loaded &&
                                            propertyData.state != RequestState.loading)) {
                                      context.read<HomeBloc>().add(
                                        FetchNearByProperties(
                                          propertyType: propertyType,
                                          location: '15',
                                        ),
                                      );
                                    }
                                  }
                                },
                                child: BlocBuilder<HomeBloc, HomeState>(
                                  buildWhen: (previous, current) {
                                    final previousData = previous.properties[propertyType];
                                    final currentData = current.properties[propertyType];
                                    return previousData != currentData;
                                  },
                                  builder: (context, state) {
                                    final propertyData = state.properties[propertyType];
                                    final requestState = propertyData?.state ?? RequestState.initial;

                                    switch (requestState) {
                                      case RequestState.loading:
                                      case RequestState.initial:
                                        return SizedBox(
                                          height: context.scale(241),
                                          child: CardShimmerList(
                                            scrollDirection: Axis.horizontal,
                                            cardWidth: context.scale(209),
                                            cardHeight: context.scale(241),
                                          ),
                                        );

                                      case RequestState.loaded:
                                        final properties = propertyData?.properties ?? [];

                                        if (properties.isEmpty) {
                                          return Center(
                                            child: Text(
                                              context.tr('${LocaleKeys.homeNoAvailable} ${propertyTypeKeys[index]}'),
                                              style: TextStyle(color: ColorManager.blackColor),
                                            ),
                                          );
                                        }

                                        return ServicesListingWidget(
                                          seeMoreAction: () {
                                            Navigator.of(context, rootNavigator: true).pushNamed(
                                              RoutersNames.seeAllPropertiesScreen,
                                              arguments: {
                                                'propertyType': propertyType,
                                                'appBarTextMessage': context.tr('${propertyTypeKeys[index]} '),
                                              },
                                            );
                                          },
                                          listingWidget: SizedBox(
                                            height: context.scale(241),
                                            child: ListView.builder(
                                              scrollDirection: Axis.horizontal,
                                              itemCount: properties.length,
                                              itemBuilder: (context, index) {
                                                final property = properties[index];
                                                return Padding(
                                                  padding: EdgeInsets.symmetric(
                                                      horizontal: context.scale(AppPadding.p8)),
                                                  child: RealStateCardComponent(
                                                    width: context.scale(209),
                                                    height: context.scale(241),
                                                    currentProperty: property,
                                                  ),
                                                );
                                              },
                                            ),
                                          ),
                                          title: context.tr('${propertyTypeKeys[index]} '),

                                        );


                                      case RequestState.error:
                                        return Center(
                                          child: Text(
                                            propertyData?.errorMessage ?? context.tr(LocaleKeys.homeErrorOccurred),
                                            style: TextStyle(color: Colors.red),
                                          ),
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
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}