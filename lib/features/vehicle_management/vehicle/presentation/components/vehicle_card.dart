import 'package:cached_network_image/cached_network_image.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../../../core/components/circular_icon_button.dart';
import '../../../../../core/components/need_to_login_component.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../main.dart';
import '../../../../home_module/presentation/controller/home_bloc.dart';
import '../../../../wish_list/presentation/controller/vehicle_wish_list_cubit.dart';

import '../../domain/entities/vehicle_entity.dart';

class VehicleCard extends StatefulWidget {
  final VehicleEntity vehicle;
  final VoidCallback onTap;
  final bool isHomeScreen;

  const VehicleCard({
    Key? key,
    required this.vehicle,
    required this.onTap,
    this.isHomeScreen = false,
  }) : super(key: key);

  @override
  State<VehicleCard> createState() => _VehicleCardState();
}

class _VehicleCardState extends State<VehicleCard> {
  StreamSubscription<bool>? _authSubscription;
  var authStateStream;

  @override
  void initState() {
    super.initState();
    _authSubscription = authStateStream.listen((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isInWishlist = context.watch<VehicleWishListCubit>()
        .state.vehicleWishList.any((item) => item.vehicleId == widget.vehicle.id);

    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        onTap: widget.onTap,
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          children: [
            // Image du véhicule
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(12)),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: CachedNetworkImage(
                  imageUrl: widget.vehicle.imageUrls.isNotEmpty
                      ? widget.vehicle.imageUrls.first
                      : 'https://via.placeholder.com/300',
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                  const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),

            // Contenu texte
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: const BorderRadius.only(
                    bottomLeft: Radius.circular(12),
                    bottomRight: Radius.circular(12),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${widget.vehicle.makeName} ${widget.vehicle.modelName}',
                      style: Theme.of(context).textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      widget.vehicle.licensePlate,
                      style: Theme.of(context).textTheme.bodySmall,
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.vehicle.dailyPrice} DH/jour',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          widget.vehicle.categoryName,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

            // Bouton favori
            Positioned(
              top: 20,
              right: 20,
              child: CircularIconButton(
                iconPath: isInWishlist
                    ? AppAssets.selectedHeartIcon
                    : AppAssets.heartIcon,
                containerSize: context.scale(40),
                iconSize: context.scale(20),
                onPressed: () {
                  if (isAuth) {
                    _handleWishlistToggle(context, isInWishlist, widget.isHomeScreen);
                  } else {
                    LoginBottomSheet.show();
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _handleWishlistToggle(BuildContext context, bool isInWishlist, bool isHomeScreen) {
    // final vehicleId = widget.vehicle.id;
    // final wishlistCubit = context.read<VehicleWishListCubit>();
    // final homeBloc = context.read<HomeBloc>();
    //
    // if (isInWishlist) {
    //   // Supprimer des favoris
    //   wishlistCubit.removeVehicleFromWishList(vehicleId);
    //   homeBloc.add(RemoveVehicleFromWishlist(vehicleId: vehicleId.toString()));
    // } else {
    //   // Ajouter aux favoris
    //   wishlistCubit.addVehicleToWishList(vehicleId);
    //   homeBloc.add(AddVehicleToWishlist(vehicleId: vehicleId.toString()));
    // }
  }
}