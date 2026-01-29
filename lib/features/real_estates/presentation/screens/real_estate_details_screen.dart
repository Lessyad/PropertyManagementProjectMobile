import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/entites/image_entity.dart';
import 'package:enmaa/core/screens/error_app_screen.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/real_estates/presentation/controller/real_estate_cubit.dart';
import 'package:enmaa/features/real_estates/presentation/screens/real_estate_details_loading_screen.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:latlong2/latlong.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../core/services/service_locator.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../domain/entities/property_details_entity.dart';
import '../components/real_estate_details_screen_components/real_estate_details_amenities.dart';
import '../components/real_estate_details_screen_components/real_estate_details_banner.dart';
import '../components/real_estate_details_screen_components/real_estate_details_description.dart';
import '../components/real_estate_details_screen_components/real_estate_details_header.dart';
import '../components/real_estate_details_screen_components/real_estate_details_location.dart';
import '../components/real_estate_details_screen_components/real_estate_details_screen_footer.dart';
import '../components/real_estate_details_screen_components/real_estate_details_specifications.dart';

class RealEstateDetailsScreen extends StatefulWidget {
  const RealEstateDetailsScreen({super.key , required this.propertyId});

  final String propertyId;
  @override
  State<RealEstateDetailsScreen> createState() =>
      _RealEstateDetailsScreenState();
}

class _RealEstateDetailsScreenState extends State<RealEstateDetailsScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: BlocProvider.value(
        value: ServiceLocator.getIt<RealEstateCubit>()
          ..fetchPropertyDetails(widget.propertyId),
        child: BlocBuilder<RealEstateCubit, RealEstateState>(
          builder: (context, state) {
            switch (state.getPropertyDetailsState) {
              case RequestState.initial:
              case RequestState.loading:
              return RealEstateDetailsLoadingScreen () ;
              case RequestState.loaded:

                BasePropertyDetailsEntity currentProperty = state.propertyDetails!;
                List<ImageEntity> banners = List.from(currentProperty.images)
                  ..sort((a, b) => b.isMain ? 1 : -1);

                return Stack(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(bottom: context.scale(46)),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RealEstateDetailsBanner(banners: banners),
                          Expanded(
                            child: Padding(
                              padding: EdgeInsets.all(context.scale(8)),
                              child: SingleChildScrollView(
                                child: SafeArea(
                                  top: false,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      RealEstateDetailsHeader(
                                        realEstateDetailsStatus: currentProperty.status,
                                        realEstateDetailsTitle:
                                        currentProperty.title,
                                        realEstateDetailsPrice:
                                        currentProperty.price.toString(),
                                        realEstateDetailsLocation:
                                            '${currentProperty.city}, ${currentProperty.state}',
                                      ),
                                      SizedBox(height: context.scale(24)),
                                      RealEstateDetailsDescription(
                                          description: currentProperty.description,
                                          ),
                                      SizedBox(height: context.scale(24)),
                                      RealEstateDetailsSpecifications(
                                        currentProperty: currentProperty ,
                                       ),
                                      SizedBox(height: context.scale(20)),
                                      Text(
                                        LocaleKeys.locationAndNearbyAreas.tr(),
                                        style: getBoldStyle(
                                          color: ColorManager.blackColor,
                                          fontSize: FontSize.s12,
                                        ),
                                      ),
                                      RealEstateDetailsLocation(
                                        location: LatLng(
                                          currentProperty.latitude,
                                          currentProperty.longitude,
                                        ),
                                      ),
                                      SizedBox(height: context.scale(20)),
                                      RealEstateDetailsAmenities(
                                        amenities: currentProperty.amenities,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                            height: context.scale(35),
                          )
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: context.scale(0),
                      left: context.scale(0),
                      right: context.scale(0),
                      child: RealEstateDetailsScreenFooter(
                        actionIsDimmed: currentProperty.isOwner || currentProperty.status != 'available' || currentProperty.status == 'reserved' || currentProperty.status == 'rented',
                        propertyId: widget.propertyId,
                        officePhoneNUmber: currentProperty.officePhoneNumber,
                        operation: currentProperty.operation, // 🆕 Passer operation
                        monthlyRentPeriod: currentProperty.monthlyRentPeriod, // 🆕 Passer monthlyRentPeriod
                      ),
                    ),
                  ],
                );
              case RequestState.error:
                return ErrorAppScreen();
            }
          },
        ),
      ),
    );
  }
}
