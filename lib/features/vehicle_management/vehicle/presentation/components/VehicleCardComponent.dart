import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/features/vehicle_management/vehicle/domain/entities/vehicle_details_entity.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../main.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../wish_list/presentation/controller/vehicle_wish_list_cubit.dart';
import '../../domain/entities/vehicle_entity.dart';
import 'package:enmaa/configuration/routers/route_names.dart';

class VehicleCardComponent extends StatefulWidget {
  final VehicleEntity vehicle;
  final VehicleDetailsEntity? vehicleDetailsEntity;
  final double width;
  final double height;
  final VoidCallback? onTap;
  final bool showWishlistButton;
  final bool isInWishlist;
  final VoidCallback? onWishlistPressed;
  const VehicleCardComponent({
    required this.vehicle,
    this.vehicleDetailsEntity,
    required this.width,
    required this.height,
    this.onTap,
    this.showWishlistButton = true,
    this.isInWishlist = false,
    this.onWishlistPressed,
    Key? key,
  }) : super(key: key);

  @override
  State<VehicleCardComponent> createState() => _VehicleCardComponentState();
}

class _VehicleCardComponentState extends State<VehicleCardComponent> {
  bool _isFavorite = false;
  bool _isProcessing = false;
  StreamSubscription<bool>? _authSubscription;

  @override
  void initState() {
    super.initState();
    _updateFavoriteState();
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }

  // CORRECTION : Méthode pour mettre à jour l'état favorite
  void _updateFavoriteState() {
    final newFavoriteState = widget.isInWishlist || widget.vehicle.isInWishlist;
    if (_isFavorite != newFavoriteState) {
      setState(() {
        _isFavorite = newFavoriteState;
      });
    }
  }

  @override
  void didUpdateWidget(covariant VehicleCardComponent oldWidget) {
    super.didUpdateWidget(oldWidget);

    // CORRECTION : Vérification plus robuste des changements
    final oldFav = oldWidget.isInWishlist || oldWidget.vehicle.isInWishlist;
    final newFav = widget.isInWishlist || widget.vehicle.isInWishlist;

    if (oldFav != newFav || oldWidget.vehicle.id != widget.vehicle.id) {
      _updateFavoriteState();
    }
  }
  Future<void> _handleWishlistTap() async {
    if (!isAuth) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(LocaleKeys.loginRequiredForFavorites.tr()),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    if (_isProcessing) return;

    // VÉRIFIER SI LE CUBIT EST DISPONIBLE
    final vehicleWishListCubit = context.read<VehicleWishListCubit>();

    setState(() {
      _isProcessing = true;
      _isFavorite = !_isFavorite;
    });

    try {
      if (_isFavorite) {
        await vehicleWishListCubit.addVehicleToWishList(widget.vehicle.id);
      } else {
        await vehicleWishListCubit.removeVehicleFromWishList(widget.vehicle.id);
      }
    } catch (e) {
      // Revert en cas d'erreur
      if (mounted) {
        setState(() {
          _isFavorite = !_isFavorite;
        });
      }
      print('Error in wishlist operation: $e');
    } finally {
      if (mounted) {
        setState(() {
          _isProcessing = false;
        });
      }
    }
  }
  // Future<void> _handleWishlistTap() async {
  //   if (!isAuth) {
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(
  //         content: Text(LocaleKeys.loginRequiredForFavorites.tr()),
  //         duration: const Duration(seconds: 2),
  //       ),
  //     );
  //     return;
  //   }
  //   if (_isProcessing) return;
  //
  //   // CORRECTION : Mise à jour immédiate de l'UI
  //   setState(() {
  //     _isProcessing = true;
  //     _isFavorite = !_isFavorite;
  //   });
  //
  //   try {
  //     if (widget.onWishlistPressed != null) {
  //       widget.onWishlistPressed!();
  //     } else {
  //       final vehicleWishListCubit = context.read<VehicleWishListCubit>();
  //       if (_isFavorite) {
  //         await vehicleWishListCubit.addVehicleToWishList(widget.vehicle.id);
  //       } else {
  //         await vehicleWishListCubit.removeVehicleFromWishList(widget.vehicle.id);
  //       }
  //
  //       // CORRECTION : Écouter les changements du Cubit
  //       if (mounted) {
  //         // Forcer la reconstruction si nécessaire
  //         setState(() {});
  //       }
  //     }
  //   } catch (e) {
  //     // CORRECTION : Revert en cas d'erreur
  //     if (mounted) {
  //       setState(() {
  //         _isFavorite = !_isFavorite;
  //       });
  //       ScaffoldMessenger.of(context).showSnackBar(
  //         SnackBar(
  //           content: Text(LocaleKeys.error.tr()),
  //           duration: const Duration(seconds: 2),
  //         ),
  //       );
  //     }
  //   } finally {
  //     if (mounted) {
  //       setState(() {
  //         _isProcessing = false;
  //       });
  //     }
  //   }
  // }

  void _handleCardTap() {
    if (widget.onTap != null) {
      widget.onTap!();
    } else {
      Navigator.of(context, rootNavigator: true).pushNamed(
        RoutersNames.vehicleDetailsScreen,
        arguments: widget.vehicle.id,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    // CORRECTION : Synchronisation finale avant build
    final currentFavoriteState = widget.isInWishlist || widget.vehicle.isInWishlist;
    if (_isFavorite != currentFavoriteState && !_isProcessing) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) {
          setState(() {
            _isFavorite = currentFavoriteState;
          });
        }
      });
    }

    return Container(
      width: widget.width * 0.7,
      height: widget.height * 0.84,
      margin: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(10),
            onTap: _handleCardTap,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                // Container pour l'image
                Container(
                  margin: const EdgeInsets.all(4),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(6),
                    child: CachedNetworkImage(
                      imageUrl: widget.vehicle.imageUrls.isNotEmpty
                          ? widget.vehicle.imageUrls.first
                          : 'https://via.placeholder.com/300',
                      width: widget.width - 10,
                      height: widget.height * 0.5,
                      fit: BoxFit.cover,
                      placeholder: (context, url) => Container(
                        color: Colors.grey[200],
                        child: const Center(
                          child: CircularProgressIndicator(),
                        ),
                      ),
                      errorWidget: (context, url, error) => Container(
                        color: Colors.grey[200],
                        child: const Icon(Icons.error, color: Colors.grey),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Text(
                              '${widget.vehicle.makeName} ${widget.vehicle.modelName}',
                              style: const TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                overflow: TextOverflow.ellipsis,
                              ),
                              maxLines: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Center(
                        child: Wrap(
                          spacing: 3,
                          runSpacing: 3,
                          children: [
                            _buildFeatureItem(Icons.calendar_today, '${widget.vehicle.year}'),
                            if (widget.vehicle.fuelType.isNotEmpty)
                              _buildFeatureItem(Icons.local_gas_station, _getFuelTypeTranslation(widget.vehicle.fuelType)),
                            _buildFeatureItem2('assets/icons/real_estate_filter/automatic-transmission.png', '${widget.vehicle.transmission}'),
                            if (widget.vehicle.seats != null)
                              _buildFeatureItem2('assets/icons/real_estate_filter/car-seat.png', '${widget.vehicle.seats}'),
                            if (widget.vehicle.hasAirConditioning == true)
                              _buildFeatureItem2('assets/icons/real_estate_filter/airconditioner.png', 'AC'),
                          ],
                        ),
                      ),
                      const SizedBox(height: 6),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Text(
                            '${widget.vehicle.dailyPrice.toStringAsFixed(0)} MRU',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: ColorManager.primaryColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          if (widget.showWishlistButton)
            Positioned(
              top: 8,
              right: 8,
              child: GestureDetector(
                onTap: _handleWishlistTap,
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  curve: Curves.easeInOut,
                  padding: const EdgeInsets.all(5),
                  decoration: BoxDecoration(
                    color: _isFavorite
                        ? Colors.red.withOpacity(0.2)
                        : Colors.white,
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 3,
                        spreadRadius: 1,
                      ),
                    ],
                  ),
                  child: _isProcessing
                      ? SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        _isFavorite ? Colors.red : Colors.grey[600]!,
                      ),
                    ),
                  )
                      : Icon(
                    _isFavorite ? Icons.favorite : Icons.favorite_border,
                    color: _isFavorite ? Colors.red : Colors.grey[600],
                    size: 18,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildFeatureItem(IconData icon, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(icon, size: 15, color: ColorManager.primaryColor),
        const SizedBox(width: 2),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: ColorManager.primaryColor,
          ),
        ),
      ],
    );
  }

  Widget _buildFeatureItem2(String assetPath, String text) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Image.asset(
          assetPath,
          width: 16,
          height: 16,
          color: ColorManager.primaryColor,
          fit: BoxFit.contain,
        ),
        const SizedBox(width: 2),
        Text(
          text,
          style: TextStyle(
            fontSize: 10,
            color: ColorManager.primaryColor,
          ),
        ),
      ],
    );
  }

  String _getFuelTypeTranslation(String fuelType) {
    switch (fuelType.toLowerCase()) {
      case 'gasoline':
      case 'essence':
        return LocaleKeys.fuelTypeGasoline.tr();
      case 'diesel':
        return LocaleKeys.fuelTypeDiesel.tr();
      case 'electric':
      case 'électrique':
        return LocaleKeys.fuelTypeElectric.tr();
      case 'hybrid':
      case 'hybride':
        return LocaleKeys.fuelTypeHybrid.tr();
      default:
        return fuelType;
    }
  }
}