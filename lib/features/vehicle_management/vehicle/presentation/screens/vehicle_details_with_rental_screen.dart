import 'package:enmaa/core/screens/error_app_screen.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:get/get.dart';
import 'package:easy_localization/easy_localization.dart';

import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../components/vehicle_details_screen/vehicle_details_header.dart';
import '../components/vehicle_images_slider.dart';
import '../controller/vehicle_details_controller.dart';
import '../controller/global_rental_options_controller.dart';
import '../../domain/entities/vehicle_entity.dart';
import 'rental_summary_screen.dart';

class VehicleDetailsWithRentalScreen extends StatefulWidget {
  final int vehicleId;
  final DateTime? receptionDate;
  final TimeOfDay? receptionTime;
  final String? receptionCity;
  final String? receptionLocation;
  final DateTime? deliveryDate;
  final TimeOfDay? deliveryTime;
  final String? deliveryCity;
  final String? deliveryLocation;
  final int? receptionZoneId;
  final int? deliveryZoneId;

  const VehicleDetailsWithRentalScreen({
    required this.vehicleId,
    this.receptionDate,
    this.receptionTime,
    this.receptionCity,
    this.receptionLocation,
    this.deliveryDate,
    this.deliveryTime,
    this.deliveryCity,
    this.deliveryLocation,
    this.receptionZoneId,
    this.deliveryZoneId,
    super.key,
  }); 

  @override
  State<VehicleDetailsWithRentalScreen> createState() => _VehicleDetailsWithRentalScreenState();
}

class _VehicleDetailsWithRentalScreenState extends State<VehicleDetailsWithRentalScreen> {
  final VehicleDetailsController controller = Get.put(
    VehicleDetailsController(Get.find()),
  );
  
  // Récupérer ou créer le contrôleur des options globales
  late final GlobalRentalOptionsController optionsController;

  // Variables pour les options de location
  bool extraKilometers = false;
  bool fullInsurance = false;
  bool childSeat = false;
  final TextEditingController kilometerController = TextEditingController();

  @override
  void initState() {
    super.initState();
    
    // Initialiser le contrôleur des options globales
    try {
      optionsController = Get.find<GlobalRentalOptionsController>();
    } catch (e) {
      // Si le contrôleur n'est pas trouvé, le créer
      optionsController = Get.put(GlobalRentalOptionsController());
    }
    
    // Faire l'appel API (le cache est géré dans le contrôleur)
    controller.getVehicleDetails(widget.vehicleId);
  }

  @override
  void dispose() {
    kilometerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: Obx(() {
        switch (_getRequestState(controller)) {
          case RequestState.initial:
          case RequestState.loading:
            return _buildLoadingScreen();
          case RequestState.loaded:
            final vehicle = controller.vehicleDetails.value!;
            return _buildLoadedScreen(context, vehicle);
          case RequestState.error:
            return ErrorAppScreen();
        }
      }),
    );
  }

  Widget _buildLoadingScreen() {
    return const Center(child: CircularProgressIndicator());
  }

  Widget _buildLoadedScreen(BuildContext context, vehicle) {
    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.only(bottom: context.scale(88)),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Bannière avec images du véhicule
              VehicleImagesSlider(imageUrls: vehicle.imageUrls),

              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(context.scale(16)),
                  child: SingleChildScrollView(
                    child: SafeArea(
                      top: false,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // En-tête avec titre, prix et statut
                          VehicleDetailsHeader(
                            vehicleDetailsTitle: '${vehicle.makeName} ${vehicle.modelName}',
                            vehicleDetailsPrice: '${vehicle.dailyPrice} MRU',
                            vehicleDetailsLocation: '${vehicle.categoryName}',
                            vehicleDetailsStatus: 'available',
                          ),

                          SizedBox(height: context.scale(24)),

                          // Description du véhicule
                          // VehicleDetailsDescription(
                          //   description:tr(LocaleKeys.vehicleDescription),
                          // ),

                          SizedBox(height: context.scale(16)),

                          // Spécifications techniques
                          Text(
                            tr(LocaleKeys.technicalSpecifications),
                            style: getBoldStyle(
                              color: ColorManager.blackColor,
                              fontSize: FontSize.s16,
                            ),
                          ),

                          SizedBox(height: context.scale(8)),

                          _buildTechnicalDetails(vehicle),

                          SizedBox(height: context.scale(24)),

                          // Options de location
                          _buildRentalOptions(vehicle),

                          SizedBox(height: context.scale(24)),

                          // Localisation du véhicule
                          // if (vehicle.latitude != null && vehicle.longitude != null) ...[
                          //   Text(
                          //     tr(LocaleKeys.location),
                          //     style: getBoldStyle(
                          //       color: ColorManager.blackColor,
                          //       fontSize: FontSize.s16,
                          //     ),
                          //   ),
                          //   VehicleDetailsLocation(
                          //     location: LatLng(
                          //       vehicle.latitude!,
                          //       vehicle.longitude!,
                          //     ),
                          //   ),
                          //   SizedBox(height: context.scale(16)),
                          // ],
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),

        // Footer avec bouton "Suivant"
        _buildRentalFooter(vehicle),
      ],
    );
  }

  Widget _buildTechnicalDetails(vehicle) {
    return Container(
      padding: EdgeInsets.all(context.scale(12)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildDetailRow(tr(LocaleKeys.brand), '${vehicle.makeName}'),
          _buildDetailRow(tr(LocaleKeys.model), vehicle.modelName),
          _buildDetailRow(tr(LocaleKeys.color), vehicle.color),
          _buildDetailRow(tr(LocaleKeys.mileage), '${vehicle.mileage} ${tr(LocaleKeys.km)}'),
          _buildDetailRow(tr(LocaleKeys.fuelType), vehicle.fuelType),
          _buildDetailRow(tr(LocaleKeys.transmission), vehicle.transmission),
          _buildDetailRow(tr(LocaleKeys.seatsNumber), '${vehicle.seats}'),
          _buildDetailRow(tr(LocaleKeys.year), '${vehicle.year}'),
          _buildDetailRow(tr(LocaleKeys.licensePlate), vehicle.licensePlate),
        ],
      ),
    );
  }

  Widget _buildRentalOptions(vehicle) {
    return Container(
      padding: EdgeInsets.all(context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            tr(LocaleKeys.rentalOptions),
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
          ),
          SizedBox(height: context.scale(16)),

          // Option 1: Kilomètres supplémentaires
          _buildOptionTile(
            title: tr(LocaleKeys.extraKilometers),
            subtitle: tr(LocaleKeys.extraKilometersDesc),
            price: '+ ${optionsController.kilometerIllimitedPerDayAmount.toStringAsFixed(1)}MRU',
            icon: Icons.speed,
            value: extraKilometers,
            onChanged: (value) {
              setState(() {
                extraKilometers = value;
                if (!value) {
                  kilometerController.clear();
                }
              });
            },
          ),

          // Option 2: Assurance complète
          _buildOptionTile(
            title: tr(LocaleKeys.fullInsurance),
            subtitle: tr(LocaleKeys.fullInsuranceDesc),
            price: '+ ${optionsController.allRiskCarInsuranceAmount.toStringAsFixed(1)}MRU',
            icon: Icons.shield,
            value: fullInsurance,
            onChanged: (value) {
              setState(() {
                fullInsurance = value;
              });
            },
          ),

          // Option 3: Siège enfant
          _buildOptionTile(
            title: tr(LocaleKeys.childSeat),
            subtitle: tr(LocaleKeys.childSeatDesc),
            price: '+ ${optionsController.addChildsChairAmount.toStringAsFixed(1)}MRU',
            icon: Icons.child_care,
            value: childSeat,
            onChanged: (value) {
              setState(() {
                childSeat = value;
              });
            },
          ),
        ],
      ),
    );
  }

  Widget _buildOptionTile({
    required String title,
    required String subtitle,
    required String price,
    required IconData icon,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: context.scale(8)),
      child: Row(
        children: [
          Icon(
            icon,
            color: ColorManager.primaryColor,
            size: 24,
          ),
          SizedBox(width: context.scale(12)),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: getRegularStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s14,
                  ),
                ),
                Text(
                  subtitle,
                  style: getRegularStyle(
                    color: ColorManager.grey,
                    fontSize: FontSize.s12,
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                price,
                style: getBoldStyle(
                  color: ColorManager.primaryColor,
                  fontSize: FontSize.s12,
                ),
              ),
              SizedBox(height: context.scale(4)),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: ColorManager.primaryColor,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildRentalFooter(vehicle) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        height: context.scale(55),
        width: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
        decoration: BoxDecoration(
          color: ColorManager.whiteColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(context.scale(24)),
            topRight: Radius.circular(context.scale(24)),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.1),
              blurRadius: 8,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          spacing: 10,
          children: [
            Expanded(
              child: ElevatedButton(
                onPressed: () => Navigator.pop(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.greyShade,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: context.scale(10)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.scale(25)),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  tr(LocaleKeys.previousButton),
                  style: getBoldStyle(
                    color: ColorManager.primaryColor,
                    fontSize: FontSize.s16,
                  ),
                ),
              ),
            ),
            // Prix estimé
            Expanded(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    tr(LocaleKeys.estimatedPricePerDay),
                    style: getRegularStyle(
                      color: ColorManager.grey,
                      fontSize: FontSize.s12,
                    ),
                  ),
                  Text(
                    '${_calculateEstimatedPrice(vehicle)}MRU',
                    style: getBoldStyle(
                      color: ColorManager.primaryColor,
                      fontSize: FontSize.s16,
                    ),
                  ),
                ],
              ),
            ),

            // Bouton Suivant
            Expanded(
              child: ElevatedButton(
                onPressed: _canProceed() ? () => _proceedToSummary(vehicle) : null,
                style: ElevatedButton.styleFrom(
                  backgroundColor: ColorManager.primaryColor,
                  foregroundColor: Colors.white,
                  padding: EdgeInsets.symmetric(vertical: context.scale(10)),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(context.scale(25)),
                  ),
                  elevation: 2,
                ),
                child: Text(
                  tr(LocaleKeys.nextButton),
                  style: getBoldStyle(
                    color: Colors.white,
                    fontSize: FontSize.s16,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: context.scale(8)),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            label,
            style: getRegularStyle(
              color: ColorManager.grey,
              fontSize: FontSize.s12,
            ),
          ),
          Text(
            value,
            style: getRegularStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12,
            ),
          ),
        ],
      ),
    );
  }

  // double _calculateEstimatedPrice(vehicle) {
  //   if (widget.receptionDate == null || widget.deliveryDate == null) {
  //     return vehicle.dailyPrice; // Prix par jour si pas de dates
  //   }
  //
  //   final numberOfDays = widget.deliveryDate!.difference(widget.receptionDate!).inDays + 1;
  //   double basePrice = vehicle.dailyPrice * numberOfDays;
  //   double extraCosts = 0;
  //
  //   if (extraKilometers) extraCosts += 50;
  //   if (fullInsurance) extraCosts += 30 ;
  //   if (childSeat) extraCosts += 20 ;
  //   return basePrice + extraCosts;
  // }
  double _calculateEstimatedPrice(vehicle) {
    if (widget.receptionDate == null || widget.deliveryDate == null) {
      return vehicle.dailyPrice; // Prix par jour si pas de dates
    }

    final duration = widget.deliveryDate!.difference(widget.receptionDate!);
        // .inDays + 1;
    final totalHours = duration.inHours;
    // double basePrice = vehicle.dailyPrice * numberOfDays;
    int numberOfDays;
    // double extraCosts = 0;

    if (totalHours <= 0) {
      numberOfDays = 1;
    } else if (totalHours < 24) {
      numberOfDays = 1;
    } else {
      numberOfDays = (totalHours / 24).ceil();
    }

    double basePrice = vehicle.dailyPrice * numberOfDays;

    // Note: Les coûts supplémentaires sont calculés dans RentalSummaryScreen
    // Ici on affiche seulement le prix de base pour l'estimation
    return basePrice;
  }


  bool _canProceed() {
    // Vérifier que tous les champs nécessaires sont disponibles
    // Note: receptionTime peut être null, on utilisera une valeur par défaut (00:00)
    return widget.receptionDate != null &&
        widget.deliveryDate != null &&
        widget.deliveryTime != null &&
        widget.receptionCity != null &&
        widget.deliveryCity != null &&
        widget.receptionLocation != null &&
        widget.deliveryLocation != null;
  }

  void _proceedToSummary(vehicle) {
    if (!_canProceed()) {
      Get.snackbar(
        tr(LocaleKeys.missingInfoTitle),
        tr(LocaleKeys.missingInfoMessage),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }



    // Créer l'entité véhicule à partir des données
    final vehicleEntity = VehicleEntity(
      id: vehicle.id,
      licensePlate: vehicle.licensePlate,
      color: vehicle.color,
      dailyPrice: vehicle.dailyPrice.toDouble(),
      weeklyPrice: vehicle.weeklyPrice?.toDouble() ?? vehicle.dailyPrice * 7,
      makeName: vehicle.makeName,
      modelName: vehicle.modelName,
      categoryName: vehicle.categoryName,
      year: vehicle.year,
      mileage: vehicle.mileage,
      fuelType: vehicle.fuelType,
      transmission: vehicle.transmission,
      vehicleAvailabilityStatus: vehicle.vehicleAvailabilityStatus,
      imageUrls: List<String>.from(vehicle.imageUrls),
      isInWishlist: false,
      latitude: vehicle.latitude,
      longitude: vehicle.longitude,
    );

    // Naviguer vers l'écran de résumé
    // Vérifier à nouveau avant de naviguer (sécurité supplémentaire)
    if (widget.receptionDate == null ||
        widget.deliveryDate == null ||
        widget.deliveryTime == null ||
        widget.receptionCity == null ||
        widget.deliveryCity == null ||
        widget.receptionLocation == null ||
        widget.deliveryLocation == null) {
      Get.snackbar(
        tr(LocaleKeys.missingInfoTitle),
        tr(LocaleKeys.missingInfoMessage),
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    // Utiliser une valeur par défaut pour receptionTime si elle est null (00:00)
    final receptionTime = widget.receptionTime ?? const TimeOfDay(hour: 0, minute: 0);

    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => RentalSummaryScreen(
          vehicle: vehicleEntity,
          receptionDate: widget.receptionDate!,
          receptionTime: receptionTime,
          receptionCity: widget.receptionCity!,
          receptionLocation: widget.receptionLocation!,
          deliveryDate: widget.deliveryDate!,
          deliveryTime: widget.deliveryTime!,
          deliveryCity: widget.deliveryCity!,
          deliveryLocation: widget.deliveryLocation!,
          extraKilometers: extraKilometers,
          kilometerDetails: extraKilometers ? kilometerController.text : null,
          fullInsurance: fullInsurance,
          childSeat: childSeat,
          receptionZoneId: widget.receptionZoneId,
          deliveryZoneId: widget.deliveryZoneId,
        ),
      ),
    );
  }

  RequestState _getRequestState(VehicleDetailsController controller) {
    if (controller.vehicleDetails.value == null && controller.errorMessage.value.isEmpty) {
      return controller.isLoading.value ? RequestState.loading : RequestState.initial;
    } else if (controller.errorMessage.value.isNotEmpty) {
      return RequestState.error;
    } else {
      return RequestState.loaded;
    }
  }
}