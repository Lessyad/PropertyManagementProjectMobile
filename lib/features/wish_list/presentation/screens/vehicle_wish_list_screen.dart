import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/core/components/app_bar_component.dart';
import 'package:enmaa/core/components/card_listing_shimmer.dart';
import 'package:enmaa/core/screens/error_app_screen.dart';
import 'package:enmaa/core/screens/property_empty_screen.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import '../../../home_module/home_imports.dart';
import '../controller/vehicle_wish_list_cubit.dart';
import '../components/wish_list_vehicle_card.dart';

class VehicleWishListScreen extends StatefulWidget {
  const VehicleWishListScreen({super.key});

  @override
  State<VehicleWishListScreen> createState() => _VehicleWishListScreenState();
}

class _VehicleWishListScreenState extends State<VehicleWishListScreen> {
  @override
  void initState() {
    context.read<VehicleWishListCubit>().getVehicleWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: LocaleKeys.vehiclefavorites.tr(),
            showNotificationIcon: false,
            showLocationIcon: false,
            centerText: true,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<VehicleWishListCubit>().getVehicleWishList();
              },
              child: BlocBuilder<VehicleWishListCubit, VehicleWishListState>(
                buildWhen: (previous, current) =>
                previous.getVehicleWishListState !=
                    current.getVehicleWishListState,
                builder: (context, state) {
                  if (state.getVehicleWishListState.isLoaded) {
                    if (state.vehicleWishList.isEmpty) {
                      return EmptyScreen(
                        alertText1: LocaleKeys.emptyScreenNoVehicleFavorites.tr(),
                        alertText2: LocaleKeys.emptyScreenAddVehicleFavorites.tr(),
                        buttonText: LocaleKeys.emptyScreenExploreVehicles.tr(),
                        showActionButtonIcon: false,
                        onTap: () {
                          Navigator.pushNamed(context, '/vehicles');
                        },
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.vehicleWishList.length,
                      itemBuilder: (context, index) {
                        final wishListItem = state.vehicleWishList[index];
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: WishListVehicleCard(
                              wishListItem: wishListItem,
                              width: MediaQuery.of(context).size.width,
                              height: context.scale(290),
                            ));
                      },
                    );
                  } else if (state.getVehicleWishListState.isError) {
                    return ErrorAppScreen(
                      showActionButton: false,
                      showBackButton: false,
                    );
                  } else {
                    return CardShimmerList(
                      scrollDirection: Axis.vertical,
                      cardWidth: MediaQuery.of(context).size.width,
                      cardHeight: context.scale(290),
                    );
                  }
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}