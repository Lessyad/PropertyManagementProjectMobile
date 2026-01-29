import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/property_type_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/add_new_real_estate/add_new_real_estate_DI.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/screens/add_new_real_estate_main_information_screen.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../core/components/loading_overlay_component.dart';
import '../../../../core/services/select_location_service/presentation/controller/select_location_service_cubit.dart';
import '../components/add_new_real_estate_buttons.dart';
import 'add_new_real_estate_location_screen.dart';
import 'add_new_real_estate_price_screen.dart';

class AddNewRealEstateScreen extends StatefulWidget {
  const AddNewRealEstateScreen({super.key, this.propertyID});

  final String? propertyID;

  @override
  _AddNewRealEstateScreenState createState() => _AddNewRealEstateScreenState();
}

class _AddNewRealEstateScreenState extends State<AddNewRealEstateScreen> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) {
            AddNewRealEstateDi().setup();
            final cubit = AddNewRealEstateCubit(
              ServiceLocator.getIt(),
              ServiceLocator.getIt(),
              ServiceLocator.getIt(),
              ServiceLocator.getIt(),
              ServiceLocator.getIt(),
              ServiceLocator.getIt(),
              ServiceLocator.getIt(),
              ServiceLocator.getIt(),
              ServiceLocator.getIt(),
              ServiceLocator.getIt(),
            );

            // If propertyID is not null, fetch property details
            if (widget.propertyID != null) {
              cubit.fetchPropertyDetailsAndPopulateIt(widget.propertyID!);
            } else {
              // Fetch amenities initially for apartments
              cubit.getAmenities(PropertyType.apartment.toJsonId.toString());
            }

            return cubit;
          },
        ),
        BlocProvider(
          create: (context) {
            return SelectLocationServiceCubit.getOrCreate()..getCountries();
          },
        ),
      ],
      child: Scaffold(
        backgroundColor: ColorManager.greyShade,
        body: BlocListener<AddNewRealEstateCubit, AddNewRealEstateState>(
          listener: (context, state) {
            // Handle success for add
            if (state.addNewApartmentState.isLoaded && !state.addNewApartmentState.isLoading) {
              CustomSnackBar.show(
                context: context,
                message: LocaleKeys.propertyAddedSuccessfully.tr(),
                type: SnackBarType.success,
              );
              Navigator.pop(context);
            }

            // Handle success for update
            if ((state.updateApartmentState.isLoaded ||
                state.updateVillaState.isLoaded ||
                state.updateBuildingState.isLoaded ||
                state.updateLandState.isLoaded) &&
                !(state.updateApartmentState.isLoading ||
                    state.updateVillaState.isLoading ||
                    state.updateBuildingState.isLoading ||
                    state.updateLandState.isLoading)) {
              CustomSnackBar.show(
                context: context,
                message: LocaleKeys.propertyUpdatedSuccessfully.tr(),
                type: SnackBarType.success,
              );
              Navigator.pop(context);
            }

            if (state.getPropertyDetailsState.isLoaded && widget.propertyID != null) {
              final locationCubit = context.read<SelectLocationServiceCubit>();
              final propertyDetails = state.propertyDetailsEntity;
              if (propertyDetails != null) {
                WidgetsBinding.instance.addPostFrameCallback((_) async {
                  await locationCubit.setPropertyLocation(
                    countryName: propertyDetails.country ?? '',
                    stateName: propertyDetails.state ?? '',
                    cityName: propertyDetails.city ?? '',
                  );
                });
              }
            }
          },
          child: BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
            buildWhen: (previous, current) {
              return previous.addNewApartmentState != current.addNewApartmentState ||
                  previous.updateApartmentState != current.updateApartmentState ||
                  previous.updateVillaState != current.updateVillaState ||
                  previous.updateBuildingState != current.updateBuildingState ||
                  previous.updateLandState != current.updateLandState ||
                  previous.getPropertyDetailsState != current.getPropertyDetailsState;
            },
            builder: (context, state) {
              return Column(
                children: [
                  AppBarComponent(
                    appBarTextMessage: widget.propertyID != null ? LocaleKeys.editProperty.tr() : LocaleKeys.addProperty.tr(),
                    showNotificationIcon: false,
                    showLocationIcon: false,
                    showBackIcon: true,
                    centerText: true,
                  ),
                  Expanded(
                    child: Stack(
                      children: [
                        Column(
                          children: [
                            _buildPageIndicator(),
                            Expanded(
                              child: PageView(
                                physics: const NeverScrollableScrollPhysics(),
                                controller: _pageController,
                                onPageChanged: (index) {
                                  setState(() {
                                    _currentPage = index;
                                  });
                                },
                                children: const [
                                  AddNewRealEstateMainInformationScreen(),
                                  AddNewRealEstatePriceScreen(),
                                  AddNewRealEstateLocationScreen(),
                                ],
                              ),
                            ),
                            AddNewRealEstateButtons(
                              pageController: _pageController,
                              currentPage: _currentPage,
                              animationTime: const Duration(milliseconds: 500),
                            ),
                          ],
                        ),
                        if (state.addNewApartmentState.isLoading ||
                            state.updateApartmentState.isLoading ||
                            state.updateVillaState.isLoading ||
                            state.updateBuildingState.isLoading ||
                            state.updateLandState.isLoading)
                          LoadingOverlayComponent(
                            opacity: 0,
                            text: LocaleKeys.processingProperty.tr(),
                          ),
                        if (state.getPropertyDetailsState.isLoading)
                          LoadingOverlayComponent(
                            opacity: 0,
                            text: LocaleKeys.loadingPropertyData.tr(),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  final animationTime = const Duration(milliseconds: 500);

  Widget _buildPageIndicator() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(3, (index) {
          bool isActive = index <= _currentPage;
          return Expanded(
            child: Column(
              children: [
                Text(
                  index == 0
                      ? LocaleKeys.basicInformation.tr()
                      : index == 1
                      ? LocaleKeys.priceAndDescription.tr()
                      : LocaleKeys.locationAndFeatures.tr(),
                  style: getBoldStyle(
                    color: isActive ? ColorManager.primaryColor : ColorManager.blackColor,
                    fontSize: FontSize.s11,
                  ),
                  textAlign: TextAlign.center,
                  overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: context.scale(8)),
                AnimatedContainer(
                  duration: animationTime,
                  margin: const EdgeInsets.symmetric(horizontal: 4.0),
                  width: double.infinity,
                  height: context.scale(4),
                  decoration: BoxDecoration(
                    color: isActive ? ColorManager.primaryColor : const Color(0xFFD9D9D9),
                    borderRadius: BorderRadius.circular(2.0),
                  ),
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}