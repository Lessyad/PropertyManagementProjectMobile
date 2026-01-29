import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/features/vehicle_management/vehicle/presentation/screens/vehicle_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../components/vehicle_card.dart';
import '../controller/vehicle_controller.dart';
import '../../../../wish_list/presentation/controller/vehicle_wish_list_cubit.dart';
import '../../../../wish_list/vehicle_wish_list_di.dart';

class VehiclesScreen extends StatelessWidget {
  VehiclesScreen({super.key});

  final VehicleController controller = Get.find<VehicleController>();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) {
        VehicleWishListDi().setup();
        return VehicleWishListCubit(
          ServiceLocator.getIt(),
          ServiceLocator.getIt(),
          ServiceLocator.getIt(),
          ServiceLocator.getIt(),
        )..getVehicleWishList();
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(tr(LocaleKeys.availableVehicles)),
          actions: [
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => controller.refreshVehicles(),
              tooltip: tr(LocaleKeys.refresh),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value && controller.vehicles.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.hasError.value && controller.vehicles.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(controller.errorMessage.value),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: controller.refreshVehicles,
                    child: Text(tr(LocaleKeys.retryButton)),
                  ),
                ],
              ),
            );
          }

          return NotificationListener<ScrollNotification>(
            onNotification: (scrollNotification) {
              if (scrollNotification.metrics.pixels ==
                  scrollNotification.metrics.maxScrollExtent) {
                controller.loadMoreVehicles();
              }
              return false;
            },
            child: RefreshIndicator(
              onRefresh: () async {
                await controller.refreshVehicles();
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: controller.vehicles.length +
                    (controller.hasReachedMax.value ? 0 : 1),
                itemBuilder: (context, index) {
                  if (index >= controller.vehicles.length) {
                    return Obx(() {
                      if (controller.isLoadingMore.value) {
                        return const Padding(
                          padding: EdgeInsets.all(16),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }
                      return const SizedBox.shrink();
                    });
                  }

                  final vehicle = controller.vehicles[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: VehicleCard(
                      vehicle: vehicle,
                      onTap: () => Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (_) => VehicleDetailsScreen(vehicleId: vehicle.id),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        }),
      ),
    );
  }
}