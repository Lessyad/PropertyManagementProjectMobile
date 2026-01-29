import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/components/need_to_login_component.dart';
import 'package:enmaa/core/extensions/furnished_status_extension.dart';
import 'package:enmaa/core/extensions/land_license_status_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/apartment_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/building_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/land_type_extension.dart';
import 'package:enmaa/core/extensions/property_sub_types/villa_type_extension.dart';
import 'package:enmaa/core/services/convert_string_to_enum.dart';
import 'package:enmaa/features/real_estates/domain/entities/apartment_entity.dart';
import 'package:enmaa/features/real_estates/domain/entities/base_property_entity.dart';
import 'package:enmaa/features/real_estates/domain/entities/villa_entity.dart';
import 'package:enmaa/main.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/routers/route_names.dart';
import '../../../../core/components/circular_icon_button.dart';
import '../../../../core/components/custom_image.dart';
import '../../../../core/components/reserved_component.dart';
import '../../../../core/components/svg_image_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../../core/utils/enums.dart';
import '../../../real_estates/domain/entities/building_entity.dart';
import '../../../real_estates/domain/entities/land_entity.dart';
import '../../../real_estates/presentation/controller/real_estate_cubit.dart';
import '../../../wish_list/presentation/controller/wish_list_cubit.dart';
import '../../home_imports.dart';
import '../controller/home_bloc.dart';
import '../screens/home_screen.dart';

class RealStateCardComponent extends StatelessWidget {
  final double width;
  final double height;
  final Function? onTap;
  final PropertyEntity currentProperty;
  final bool showWishlistButton;
  final Widget? cardActions;

  const RealStateCardComponent({
    super.key,
    required this.width,
    required this.height,
    required this.currentProperty,
    this.onTap,
    this.showWishlistButton = true,
    this.cardActions,

  });

  @override
  Widget build(BuildContext context) {
    bool isScreenWidth = width == MediaQuery.of(context).size.width;

    return Container(
      width: width,
      // height: height,
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(context.scale(12)),
      ),
      child: Stack(
        children: [
          InkWell(
            onTap: () {
              Navigator.of(context, rootNavigator: true).pushNamed(
                RoutersNames.realEstateDetailsScreen,
                arguments: currentProperty.id,
              );
            },
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(context.scale(12)),
                    topRight: Radius.circular(context.scale(12)),
                  ),
                  child: CustomNetworkImage(
                    height: context.scale(isScreenWidth ? 172 : 128),
                    width: width,
                    image: currentProperty.image,
                  ),
                ),
                Flexible(
                  child: Padding(
                    padding: EdgeInsets.all(context.scale(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Flexible(
                              child: Text(
                                currentProperty.title,
                                style: getBoldStyle(
                                  color: ColorManager.blackColor,
                                  fontSize: FontSize.s12,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ),
                            if (isScreenWidth)
                              Visibility(
                                 visible: currentProperty.status == 'reserved' || currentProperty.status == 'rented',
                                child: ReservedComponent(),
                              )
                          ],
                        ),
                        SizedBox(height: context.scale(6)),
                        _buildLocationRow(context),
                        SizedBox(height: context.scale(6)),
                        _buildDetailsRow(context),
                        SizedBox(height: context.scale(6)),
                        _buildPriceRow(context),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (showWishlistButton)
            PositionedDirectional(
              top: context.scale(8),
              end: context.scale(8),
              child: Builder(
                builder: (context) {
                  bool isInWishlist = currentProperty.isInWishlist;
                  final bool isHomeScreen = context.findAncestorWidgetOfExactType<HomeScreen>() != null;

                  return CircularIconButton(
                    iconPath: isInWishlist
                        ? AppAssets.selectedHeartIcon
                        : AppAssets.heartIcon,
                    containerSize: context.scale(40),
                    iconSize: context.scale(20),
                    onPressed: () {
                      if (isAuth) {
                        String propertyId = currentProperty.id.toString();

                        if (isHomeScreen) {
                          if (isInWishlist) {
                            context.read<HomeBloc>().add(
                              RemovePropertyFromWishlist(
                                propertyId: propertyId,
                                propertyType: getPropertyType(currentProperty.propertyType),
                              ),
                            );
                            context.read<RealEstateCubit>().removePropertyFromWishList(propertyId);
                            context.read<WishListCubit>().removePropertyFromWishList(propertyId);
                          } else {
                            context.read<HomeBloc>().add(
                              AddPropertyToWishlist(
                                propertyId: propertyId,
                                propertyType: getPropertyType(currentProperty.propertyType),
                              ),
                            );
                            context.read<RealEstateCubit>().addPropertyToWishList(propertyId);
                            context.read<WishListCubit>().addPropertyToWishList(propertyId);
                          }
                        } else {
                          final realEstateState = context.read<RealEstateCubit>().state;
                          final PropertyOperationType operationType =
                          currentProperty.operation == 'for_sale'
                              ? PropertyOperationType.forSale
                              : PropertyOperationType.forRent;

                          final bool isLoaded = operationType == PropertyOperationType.forSale
                              ? realEstateState.getPropertiesSaleState == RequestState.loaded
                              : realEstateState.getPropertiesRentState == RequestState.loaded;

                          if (isLoaded) {
                            if (isInWishlist) {
                              context.read<RealEstateCubit>().removePropertyFromWishList(propertyId);
                              context.read<WishListCubit>().removePropertyFromWishList(propertyId);
                              context.read<HomeBloc>().add(
                                RemovePropertyFromWishlist(
                                  propertyId: propertyId,
                                  propertyType: getPropertyType(currentProperty.propertyType),
                                ),
                              );
                            } else {
                              context.read<RealEstateCubit>().addPropertyToWishList(propertyId);
                              context.read<WishListCubit>().addPropertyToWishList(propertyId);
                              context.read<HomeBloc>().add(
                                AddPropertyToWishlist(
                                  propertyId: propertyId,
                                  propertyType: getPropertyType(currentProperty.propertyType),
                                ),
                              );
                            }
                          } else {
                            if (isInWishlist) {
                              context.read<HomeBloc>().add(
                                RemovePropertyFromWishlist(
                                  propertyId: propertyId,
                                  propertyType: getPropertyType(currentProperty.propertyType),
                                ),
                              );
                              context.read<WishListCubit>().removePropertyFromWishList(propertyId);
                            } else {
                              context.read<HomeBloc>().add(
                                AddPropertyToWishlist(
                                  propertyId: propertyId,
                                  propertyType: getPropertyType(currentProperty.propertyType),
                                ),
                              );
                              context.read<WishListCubit>().addPropertyToWishList(propertyId);
                            }
                          }
                        }
                      } else {
                        LoginBottomSheet.show();
                      }
                    },
                  );
                },
              ),
            ),
          if (!showWishlistButton && cardActions != null)
            PositionedDirectional(
              top: context.scale(8),
              end: context.scale(8),
              child: cardActions!,
            ),
        ],
      ),
    );
  }

  Widget _buildLocationRow(BuildContext context) {
    return Row(
      children: [
        SvgImageComponent(
          iconPath: AppAssets.locationIcon,
          width: 12,
          height: 12,
        ),
        SizedBox(width: context.scale(4)),
        Expanded(
          child: Text(
            '${currentProperty.state.name} - ${currentProperty.city.name}',
            overflow: TextOverflow.ellipsis,
            style: getLightStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s11,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildDetailsRow(BuildContext context) {
    bool isScreenWidth = width == MediaQuery.of(context).size.width;

    if (currentProperty.propertyType == 'apartment') {
      var floor = (currentProperty as ApartmentEntity).floor;
      var rooms = (currentProperty as ApartmentEntity).rooms;
      var bathrooms = (currentProperty as ApartmentEntity).bathrooms;
      FurnishingStatus isFurnishing = (currentProperty as ApartmentEntity).isFurnished == true
          ? FurnishingStatus.furnished
          : FurnishingStatus.notFurnished;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDetailItem(context, AppAssets.areaIcon, currentProperty.area.toString()),
            _buildVerticalDivider(context),
            if (isScreenWidth)
              _buildDetailItem(
                context,
                isFurnishing.isFurnished ? AppAssets.furnishedIcon : AppAssets.emptyIcon,
                isFurnishing.toArabic.tr(),
              ),
            if (isScreenWidth) _buildVerticalDivider(context),
            if (isScreenWidth)
              _buildDetailItem(
                context,
                AppAssets.landIcon,
                '${LocaleKeys.floorLabel.tr()} $floor',
              ),
            if (isScreenWidth) _buildVerticalDivider(context),
            _buildDetailItem(context, AppAssets.bedIcon, rooms.toString()),
            _buildVerticalDivider(context),
            _buildDetailItem(context, AppAssets.bathIcon, bathrooms.toString()),
          ],
        ),
      );


    } else if (currentProperty.propertyType == 'land') {
      LandLicenseStatus landLicenseStatus = (currentProperty as LandEntity).isLicensed == true
          ? LandLicenseStatus.licensed
          : LandLicenseStatus.notLicensed;
      return Row(
        children: [
          _buildDetailItem(context, AppAssets.areaIcon, currentProperty.area.toString()),
          _buildVerticalDivider(context),
          _buildDetailItem(context, AppAssets.readyForBuilding, landLicenseStatus.toName()),
        ],
      );
    } else if (currentProperty.propertyType == 'villa') {
      var floor = (currentProperty as VillaEntity).floors;
      var rooms = (currentProperty as VillaEntity).rooms;
      var bathrooms = (currentProperty as VillaEntity).bathrooms;
      FurnishingStatus isFurnishing = (currentProperty as VillaEntity).isFurnished == true
          ? FurnishingStatus.furnished
          : FurnishingStatus.notFurnished;

      return Row(
        children: [
          _buildDetailItem(context, AppAssets.areaIcon, currentProperty.area.toString()),
          _buildVerticalDivider(context),
          if (isScreenWidth)
            _buildDetailItem(context, isFurnishing.isFurnished ? AppAssets.furnishedIcon : AppAssets.emptyIcon, isFurnishing.toArabic.tr()),
          if (isScreenWidth) _buildVerticalDivider(context),
          if (isScreenWidth)
            _buildDetailItem(context, AppAssets.landIcon, '${LocaleKeys.floorsLabel.tr()} $floor'),
          if (isScreenWidth) _buildVerticalDivider(context),
          _buildDetailItem(context, AppAssets.bedIcon, rooms.toString()),
          _buildVerticalDivider(context),
          _buildDetailItem(context, AppAssets.bathIcon, bathrooms.toString()),
        ],
      );
    } else {
      var numberOfFloors = (currentProperty as BuildingEntity).totalFloors;
      var apartmentPerFloor = (currentProperty as BuildingEntity).apartmentPerFloor;
      return Row(
        children: [
          _buildDetailItem(context, AppAssets.areaIcon, currentProperty.area.toString()),
          _buildVerticalDivider(context),
          if (isScreenWidth)
            _buildDetailItem(context, AppAssets.landIcon, '${LocaleKeys.floorsLabel.tr()} $numberOfFloors'),
          if (isScreenWidth) _buildVerticalDivider(context),
          _buildDetailItem(context, AppAssets.apartmentIcon, '${LocaleKeys.apartmentPerFloorLabel.tr()} $apartmentPerFloor'),
        ],
      );
    }
  }

  Widget _buildDetailItem(BuildContext context, String iconPath, String text) {
    return Row(
      children: [
        SvgImageComponent(
          iconPath: iconPath,
          width: 12,
          height: 12,
        ),
        SizedBox(width: context.scale(4)),
        Text(
          text,
          overflow: TextOverflow.ellipsis,
          style: getBoldStyle(color: ColorManager.blackColor, fontSize: FontSize.s10),
        ),
        SizedBox(width: context.scale(5)),
      ],
    );
  }

  Widget _buildVerticalDivider(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: context.scale(8)),
      child: Container(
        width: 1,
        height: 12,
        color: Colors.grey,
      ),
    );
  }

  Widget _buildPriceRow(BuildContext context) {
    bool isScreenWidth = MediaQuery.of(context).size.width == width;

    String currentSubType = '';
    if (currentProperty.propertyType == 'apartment') {
      currentSubType = getApartmentType(currentProperty.propertySubType).toName;
    } else if (currentProperty.propertyType == 'villa') {
      currentSubType = getVillaType(currentProperty.propertySubType).toName;
    } else if (currentProperty.propertyType == 'building') {
      currentSubType = getBuildingType(currentProperty.propertySubType).toName;
    } else if (currentProperty.propertyType == 'land') {
      currentSubType = getLandType(currentProperty.propertySubType).toName;
    }

    return isScreenWidth
        ? Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: context.scale(8),
              height: context.scale(8),
              decoration: BoxDecoration(
                color: ColorManager.yellowColor,
                shape: BoxShape.circle,
              ),
            ),
            SizedBox(width: context.scale(4)),
            Text(
              currentSubType,
              style: getBoldStyle(
                color: ColorManager.yellowColor,
                fontSize: FontSize.s12,
              ),
            ),
          ],
        ),
        RichText(
          overflow: TextOverflow.ellipsis,
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.startingFrom.tr(),
                style: getRegularStyle(
                  color: ColorManager.primaryColor,
                  fontSize: FontSize.s10,
                ),
              ),
              TextSpan(
                text: currentProperty.price,
                style: getBoldStyle(
                  color: ColorManager.primaryColor,
                  fontSize: 5,
                ),
              ),
            ],
          ),
        ),
      ],
    )
        : RichText(
      overflow: TextOverflow.ellipsis,
      text: TextSpan(
        children: [
          TextSpan(
            text: LocaleKeys.startingFrom.tr(),
            style: getRegularStyle(
              color: ColorManager.primaryColor,
              fontSize: FontSize.s10,
            ),
          ),
          TextSpan(
            text: currentProperty.price,
            style: getBoldStyle(
              color: ColorManager.primaryColor,
              fontSize: FontSize.s10,
            ),
          ),
        ],
      ),
    );
  }
}