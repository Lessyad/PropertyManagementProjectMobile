import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import '../../../../../core/services/service_locator.dart';
import '../../../../wish_list/presentation/controller/vehicle_wish_list_cubit.dart';
import '../../../../wish_list/vehicle_wish_list_di.dart';
import '../../../../add_new_vehicle/add_new_vehicle_DI.dart';
import '../../../../add_new_vehicle/presentation/controller/add_new_vehicle_cubit.dart';
import '../../../../add_new_vehicle/domain/use_cases/use_cases.dart';
import '../../../../add_new_vehicle/presentation/screens/add_vehicle_form_screen.dart';
import '../components/VehicleCardComponent.dart';
import '../controller/vehicle_controller.dart';
import '../controller/global_rental_options_controller.dart';
import 'vehicle_search_screen.dart'; // Import de l'écran de recherche
import 'vehicle_details_screen.dart'; // Import de l'écran de détails
import 'vehicle_details_with_rental_screen.dart'; // Import de l'écran de détails avec options
import '../../domain/entities/vehicle_entity.dart';

class HomeVehicleScreen extends StatelessWidget {
  HomeVehicleScreen({Key? key}) : super(key: key);

  final VehicleController controller = Get.find<VehicleController>();

  @override
  Widget build(BuildContext context) {
    // DI pour wishlist et add_new_vehicle
    VehicleWishListDi().setup();
    AddNewVehicleDi().setup();
    
    // S'assurer que le contrôleur des options globales est disponible
    try {
      Get.find<GlobalRentalOptionsController>();
    } catch (e) {
      Get.put(GlobalRentalOptionsController());
    }

    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) => VehicleWishListCubit(
            ServiceLocator.getIt(),
            ServiceLocator.getIt(),
            ServiceLocator.getIt(),
            ServiceLocator.getIt(),
          )..getVehicleWishList(),
        ),
        BlocProvider(
          create: (_) => AddNewVehicleCubit(
            createVehicle: ServiceLocator.getIt<CreateVehicleUseCase>(),
            updateVehicle: ServiceLocator.getIt<UpdateVehicleUseCase>(),
            deleteVehicle: ServiceLocator.getIt<DeleteVehicleUseCase>(),
          ),
        ),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Véhicules'),
          actions: [
            // Bouton de recherche (qui inclut maintenant les filtres avancés)
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(builder: (_) => VehicleSearchScreen()),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => controller.refreshVehicles(),
            ),
          ],
        ),
        // body: Obx(() {
        //   if (controller.isLoading.value && controller.vehicles.isEmpty) {
        //     return const Center(child: CircularProgressIndicator());
        //   }
        //   if (controller.hasError.value && controller.vehicles.isEmpty) {
        //     return Center(
        //       child: Column(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Text(controller.errorMessage.value),
        //           const SizedBox(height: 12),
        //           ElevatedButton(
        //             onPressed: controller.refreshVehicles,
        //             child: const Text('Réessayer'),
        //           ),
        //         ],
        //       ),
        //     );
        //   }
        //   return RefreshIndicator(
        //     onRefresh: () async => controller.refreshVehicles(),
        //     child: GridView.builder(
        //       padding: const EdgeInsets.all(12),
        //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        //         crossAxisCount: 2, // 2 colonnes
        //         crossAxisSpacing: 12, // Espacement horizontal entre les éléments
        //         mainAxisSpacing: 12, // Espacement vertical entre les éléments
        //         childAspectRatio: 0.75, // Ratio largeur/hauteur des cartes
        //       ),
        //       itemCount: controller.vehicles.length + (controller.hasReachedMax.value ? 0 : 1),
        //       itemBuilder: (context, index) {
        //         // Afficher l'indicateur de chargement pour le chargement supplémentaire
        //         if (index >= controller.vehicles.length) {
        //           return Obx(() {
        //             if (controller.isLoadingMore.value) {
        //               return const Center(child: CircularProgressIndicator());
        //             }
        //             return const SizedBox.shrink();
        //           });
        //         }
        //
        //         final vehicle = controller.vehicles[index];
        //         return VehicleCardComponent(
        //           key: ValueKey(vehicle.id),
        //           vehicle: vehicle,
        //           width: (MediaQuery.of(context).size.width - 36) / 2, // Calcul de la largeur pour 2 colonnes
        //           height: 200, // Hauteur réduite pour s'adapter à la grille
        //           isInWishlist: vehicle.isInWishlist,
        //           onTap: () {
        //             // Navigation vers les détails du véhicule
        //             // Navigator.of(context).push(
        //             //   MaterialPageRoute(
        //             //     builder: (_) => VehicleDetailsScreen(vehicleId: vehicle.id),
        //             //   ),
        //             // );
        //           },
        //         );
        //       },
        //     ),
        //   );
        // }),
        // ... imports et début du code inchangé ...

          body: Builder(
            builder: (context) {
              // DONNÉES DE TEST pour voir immédiatement la grille 2x3




              final testVehicles = [
                VehicleEntity(
                  id: 1,
                  licensePlate: 'ABC-123',
                  color: 'Rouge',
                  dailyPrice: 45.0,
                  weeklyPrice: 280.0,
                  makeName: 'Toyota',
                  modelName: 'Camry',
                  categoryName: 'Berline',
                  year: 2020,
                  mileage: 50000,
                  fuelType: 'Gasoline',
                  transmission: 'Automatique',
                  vehicleAvailabilityStatus: 'Available',
                  imageUrls: ['https://via.placeholder.com/300x200/FF5722/FFFFFF?text=Toyota+Camry'],
                  isInWishlist: false,
                    // addChildsChairAmount: 30 ,
                    // allRiskCarInsuranceAmount: 40 ,
                    // kilometerIllimitedPerDayAmount: 5,
                ),

              ];

              // Calculer la largeur disponible pour chaque carte
              final screenWidth = MediaQuery.of(context).size.width;
              final cardWidth = (screenWidth - 34) / 2; // 34 = padding (24) + espacement (10)

              return RefreshIndicator(
                onRefresh: () async {
                  // Pour l'instant, juste un délai pour simuler le refresh
                  await Future.delayed(const Duration(seconds: 1));
                },
                child: GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2, // 2 cartes par ligne
                    crossAxisSpacing: 10, // Espacement horizontal
                    mainAxisSpacing: 10, // Espacement vertical
                    childAspectRatio: 1.1, // Ratio pour avoir 3 lignes sur l'écran
                  ),
                  itemCount: testVehicles.length,
                  itemBuilder: (context, index) {
                    final vehicle = testVehicles[index];

                    return VehicleCardComponent(
                      key: ValueKey(vehicle.id),
                      vehicle: vehicle,

                      width: cardWidth,
                      height: 140, // Hauteur plus petite pour 3 lignes
                      isInWishlist: vehicle.isInWishlist,
                      onTap: () {
                        // Navigation vers l'écran de détails du véhicule simple (sans options de location)
                        Navigator.of(context).push(
                          PageRouteBuilder(
                            pageBuilder: (context, animation, secondaryAnimation) => 
                              VehicleDetailsScreen(vehicleId: vehicle.id),
                            transitionsBuilder: (context, animation, secondaryAnimation, child) {
                              const begin = Offset(1.0, 0.0);
                              const end = Offset.zero;
                              const curve = Curves.ease;

                              var tween = Tween(begin: begin, end: end).chain(
                                CurveTween(curve: curve),
                              );

                              return SlideTransition(
                                position: animation.drive(tween),
                                child: child,
                              );
                            },
                            transitionDuration: const Duration(milliseconds: 300),
                          ),
                        );
                      },
                    );
                  },
                ),
              );
            },
          ),

// ... suite du code inchangé ...
        floatingActionButton: BlocBuilder<AddNewVehicleCubit, AddNewVehicleState>(
          builder: (context, state) {
            return FloatingActionButton(
              onPressed: () async {
                final result = await Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (_) => BlocProvider.value(
                      value: context.read<AddNewVehicleCubit>(),
                      child: const AddVehicleFormScreen(),
                    ),
                  ),
                );
                if (result == true) {
                  controller.refreshVehicles();
                }
              },
              child: const Icon(Icons.add),
            );
          },
        ),
      ),
    );
  }
}