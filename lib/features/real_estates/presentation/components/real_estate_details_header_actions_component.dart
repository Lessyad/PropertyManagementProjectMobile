import 'package:enmaa/core/components/need_to_login_component.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/features/real_estates/domain/entities/apartment_details_entity.dart';
import 'package:enmaa/features/real_estates/domain/entities/villa_details_entity.dart'; // Add this
import 'package:enmaa/features/real_estates/domain/entities/land_details_entity.dart'; // Add this
import 'package:enmaa/features/real_estates/presentation/controller/real_estate_cubit.dart';
import 'package:enmaa/features/wish_list/presentation/controller/wish_list_cubit.dart';
import 'package:enmaa/main.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/utils/enums.dart';

import '../../../../core/components/circular_icon_button.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../home_module/home_imports.dart';
import '../../../home_module/presentation/controller/home_bloc.dart';
import '../../domain/entities/builidng_details_entity.dart';

class RealEstateDetailsHeaderActionsComponent extends StatelessWidget {
  const RealEstateDetailsHeaderActionsComponent({super.key});

  final double containerSize = 40;
  final double iconSize = 20;

  PropertyType getPropertyType(BuildContext context) {
    final state = context.read<RealEstateCubit>().state;
    if (state.getPropertyDetailsState.isLoaded) {
      final propertyDetails = state.propertyDetails;
      if (propertyDetails is ApartmentDetailsEntity) {
        return PropertyType.apartment;
      } else if (propertyDetails is VillaDetailsEntity) {
        return PropertyType.villa;
      } else if (propertyDetails is LandDetailsEntity) {
        return PropertyType.land;
      } else if (propertyDetails is BuildingDetailsEntity) {
        return PropertyType.building;
      }
    }
    return PropertyType.apartment;
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        CircularIconButton(
          iconPath: AppAssets.backIcon,
          containerSize: context.scale(containerSize),
          iconSize: iconSize,
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        Row(
          children: [
            Visibility(
              visible: false,
              child: CircularIconButton(
                iconPath: AppAssets.shareIcon,
                containerSize: context.scale(containerSize),
                iconSize: context.scale(iconSize),
                onPressed: () {},
              ),
            ),
            SizedBox(width: context.scale(16)),
            BlocBuilder<RealEstateCubit, RealEstateState>(
              builder: (context, state) {
                bool isInWishlist = state.getPropertyDetailsState.isLoaded &&
                    state.propertyDetails!.isInWishlist;

                PropertyType propertyType = getPropertyType(context);


                return CircularIconButton(
                  iconPath: isInWishlist
                      ? AppAssets.selectedHeartIcon
                      : AppAssets.heartIcon,
                  containerSize: context.scale(containerSize),
                  iconSize: context.scale(iconSize),
                  onPressed: () {
                    if (isAuth) {
                      if (state.getPropertyDetailsState.isLoaded) {
                        final propertyId = state.propertyDetails!.id.toString();
                        if (isInWishlist) {
                          context.read<RealEstateCubit>().removePropertyFromWishList(propertyId);
                          context.read<WishListCubit>().removePropertyFromWishList(propertyId);
                          ServiceLocator.getIt<HomeBloc>().add(RemovePropertyFromWishlist(
                            propertyId: propertyId,
                            propertyType: propertyType,
                          ));
                        } else {
                          context.read<RealEstateCubit>().addPropertyToWishList(propertyId);
                          context.read<WishListCubit>().addPropertyToWishList(propertyId);
                          ServiceLocator.getIt<HomeBloc>().add(AddPropertyToWishlist(
                            propertyId: propertyId,
                            propertyType: propertyType,
                          ));
                        }
                      } else {

                      }
                    } else {
                      LoginBottomSheet.show();
                    }
                  },
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}