import 'package:enmaa/core/screens/error_app_screen.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:flutter/material.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:get/get.dart';

import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../components/vehicle_details_screen/vehicle_details_header.dart';
import '../components/vehicle_images_slider.dart';
import '../controller/vehicle_details_controller.dart';

class VehicleDetailsScreen extends StatefulWidget {
  final int vehicleId;

  const VehicleDetailsScreen({required this.vehicleId, super.key});

  @override
  State<VehicleDetailsScreen> createState() => _VehicleDetailsScreenState();
}

class _VehicleDetailsScreenState extends State<VehicleDetailsScreen> {
  final VehicleDetailsController controller = Get.put(
    VehicleDetailsController(Get.find()),
  );

  @override
  void initState() {
    super.initState();
    controller.getVehicleDetails(widget.vehicleId);
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
                          // En-tête avec titre et prix (sans localisation)
                          VehicleDetailsHeader(
                            vehicleDetailsTitle: '${vehicle.makeName} ${vehicle.modelName}',
                            vehicleDetailsPrice: '${vehicle.dailyPrice} DH/jour',
                            vehicleDetailsLocation: '', // Paramètre vide
                            vehicleDetailsStatus: 'available',
                          ),

                          SizedBox(height: context.scale(24)),

                          // Spécifications techniques
                          Text(
                            'Spécifications Techniques',
                            style: getBoldStyle(
                              color: ColorManager.blackColor,
                              fontSize: FontSize.s12,
                            ),
                          ),

                          SizedBox(height: context.scale(8)),

                          // Autres informations techniques
                          _buildTechnicalDetails(vehicle),

                          SizedBox(height: context.scale(24)),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
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
          _buildDetailRow('Marque', '${vehicle.makeName}'),
          _buildDetailRow('Modèle', vehicle.modelName),
          _buildDetailRow('Couleur', vehicle.color),
          _buildDetailRow('Carburant', vehicle.fuelType),
          _buildDetailRow('Transmission', vehicle.transmission),
          _buildDetailRow('Climatisation', vehicle.hasAirConditioning ? 'Oui' : 'Non'),
          _buildDetailRow('Nombre de sièges', '${vehicle.seats}'),
          _buildDetailRow('Année', '${vehicle.year}'),
          _buildDetailRow('Plaque d\'immatriculation', vehicle.licensePlate),
          _buildDetailRow('VIN', vehicle.vin),
        ],
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
            style: getMediumStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s11,
            ),
          ),
          Text(
            value,
            style: getBoldStyle(
              color: ColorManager.primaryColor,
              fontSize: FontSize.s11,
            ),
          ),
        ],
      ),
    );
  }

  RequestState _getRequestState(VehicleDetailsController controller) {
    if (controller.isLoading.value) {
      return RequestState.loading;
    } else if (controller.errorMessage.value.isNotEmpty) {
      return RequestState.error;
    } else if (controller.vehicleDetails.value != null) {
      return RequestState.loaded;
    } else {
      return RequestState.initial;
    }
  }
}