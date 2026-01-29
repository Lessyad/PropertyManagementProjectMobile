import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/routers/app_routers.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/wish_list/presentation/controller/wish_list_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/app_bar_component.dart';
import '../../../../core/components/card_listing_shimmer.dart';
import '../../../../core/screens/error_app_screen.dart';
import '../../../../core/screens/property_empty_screen.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../favorite_imports.dart';
import '../components/wish_list_property_card.dart';

class WishListScreen extends StatefulWidget {
  const WishListScreen({super.key});

  @override
  State<WishListScreen> createState() => _WishListScreenState();
}

class _WishListScreenState extends State<WishListScreen> {
  @override
  void initState() {
    context.read<WishListCubit>().getPropertyWishList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Column(
        children: [
          AppBarComponent(
            appBarTextMessage: LocaleKeys.favorites.tr(),
            showNotificationIcon: false,
            showLocationIcon: false,
            centerText: true,
          ),
          Expanded(
            child: RefreshIndicator(
              onRefresh: () async {
                context.read<WishListCubit>().getPropertyWishList();
              },
              child: BlocBuilder<WishListCubit, WishListState>(
                buildWhen: (previous, current) =>
                    previous.getPropertyWishListState !=
                    current.getPropertyWishListState,
                builder: (context, state) {
                  if (state.getPropertyWishListState.isLoaded) {
                    if (state.propertyWishList.isEmpty) {
                      return EmptyScreen(
                        alertText1: LocaleKeys.emptyScreenNoFavorites.tr(),
                        alertText2: LocaleKeys.emptyScreenAddFavorites.tr(),
                        buttonText: LocaleKeys.emptyScreenExploreOffers.tr(),
                        showActionButtonIcon: false,
                        onTap: () {
                          Navigator.pushNamed(
                              context, RoutersNames.layoutScreen,
                              arguments: 0);
                        },
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 8),
                      physics: const AlwaysScrollableScrollPhysics(),
                      itemCount: state.propertyWishList.length,
                      itemBuilder: (context, index) {
                        final wishListItem = state.propertyWishList[index];
                        return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: WishListPropertyCard(
                              wishListItem: wishListItem,
                              width: MediaQuery.of(context).size.width,
                              height: context.scale(290),
                            ));
                      },
                    );
                  } else if (state.getPropertyWishListState.isError) {
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
