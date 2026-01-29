import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:get/get.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../core/constants/app_assets.dart';
import '../../../../../core/components/circular_icon_button.dart';
import '../../../../../core/components/custom_bottom_sheet.dart';
import '../../../../../core/components/range_slider_with_text_fields_component.dart';
import '../../../../../core/components/multi_selector_component.dart';
import '../../../../../core/extensions/context_extension.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../components/VehicleCardComponent.dart';
import '../controller/vehicle_controller.dart';
import 'vehicle_details_with_rental_screen.dart';

// Enums pour les filtres
enum VehicleFuelType {
  essence,
  diesel,
  // electrique,
  hybride,
  // gaz,
}

enum VehicleTransmissionType {
  manuel,
  automatique,
  // semiAutomatique,
}

class VehicleSearchResultsScreen extends StatefulWidget {
  final DateTime? receptionDate;
  final TimeOfDay? receptionTime;
  final String? receptionCity;
  final String? receptionLocation;
  final DateTime? deliveryDate;
  final TimeOfDay? deliveryTime;
  final String? deliveryCity;
  final String? deliveryLocation;
  
  // Nouveaux paramètres pour le filtrage selon VehicleFilterDto
  final int? receptionZoneId;
  final int? deliveryZoneId;
  final int? vehicleCategoryId;
  final int? userAge;
  final int? userCountryId; // ID du pays sélectionné par l'utilisateur

  const VehicleSearchResultsScreen({
    super.key,
    required this.receptionDate,
    this.receptionTime,
    this.receptionCity,
    this.receptionLocation,
    // this.deliveryDate,
    required this.deliveryDate,
    this.deliveryTime,
    this.deliveryCity,
    this.deliveryLocation,
    this.receptionZoneId,
    this.deliveryZoneId,
    this.vehicleCategoryId,
    this.userAge,
    this.userCountryId,
  });

  @override
  _VehicleSearchResultsScreenState createState() => _VehicleSearchResultsScreenState();
}

class _VehicleSearchResultsScreenState extends State<VehicleSearchResultsScreen> {
  final VehicleController _vehicleController = Get.find<VehicleController>();

  @override
  void initState() {
    super.initState();
    // Démarrer la recherche avec les filtres appliqués
    _applyFiltersAndSearch();
  }

  void _applyFiltersAndSearch() {
    // Appliquer les filtres au contrôleur selon VehicleFilterDto
    _vehicleController.applySearchFilters(
      // receptionZoneId: widget.receptionZoneId,
      // deliveryZoneId: widget.deliveryZoneId,
      categoryId: widget.vehicleCategoryId,
      userAge: widget.userAge,
      userCountryId: widget.userCountryId, // Passer userCountryId depuis la sélection
      receptionDate: widget.receptionDate,
      receptionTime: widget.receptionTime,
      deliveryDate: widget.deliveryDate,
      deliveryTime: widget.deliveryTime,
    );
    
    // Utiliser la recherche avec debounce pour optimiser les performances
    _vehicleController.debouncedSearch(
      query: '',
      filter: _vehicleController.currentFilters.value,
    );
  }

  bool get _hasActiveSearch {
    return true; // Toujours true car nous venons d'appliquer des filtres
  }

  // void _showPriceFilter() {
  //   showModalBottomSheet(
  //     context: context,
  //     isScrollControlled: true,
  //     backgroundColor: Colors.transparent,
  //     builder: (context) => PriceFilterBottomSheet(
  //       onApplyFilter: (maxPrice) {
  //         _vehicleController.applyFilters(
  //           maxDailyPrice: maxPrice,
  //           fuelType: _vehicleController.selectedFuelType.value,
  //           transmission: _vehicleController.selectedTransmission.value,
  //           minSeats: _vehicleController.selectedMinSeats.value,
  //         );
  //       },
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.whiteColor,
      body: Column(
        children: [
          // Header avec barre de recherche et navigation
          _buildResultsHeader(context),

          // Indicateur de recherche active
          // if (_hasActiveSearch) _buildActiveSearchIndicator(),

          // Liste des résultats
          Expanded(
            child: Obx(() {
              final state = _vehicleController;

              if (state.isSearching.value && state.searchResults.isEmpty) {
                return _buildLoadingState();
              } else if (state.hasSearchError.value && state.searchResults.isEmpty) {
                return _buildErrorState(state);
              } else {
                if (state.searchResults.isEmpty && _hasActiveSearch) {
                  return _buildNoResultsState();
                }

                return _buildResultsList(state);
              }
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildResultsHeader(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: MediaQuery.of(context).padding.top + 16,
        bottom: 16,
        left: 16,
        right: 16,
      ),
      child: Row(
        children: [
          CircularIconButton(
            iconPath: AppAssets.backIcon,
            containerSize: 40,
            iconSize: 24,
            backgroundColor: ColorManager.greyShade,
            onPressed: () => Navigator.pop(context),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  tr(LocaleKeys.searchResults),
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: ColorManager.blackColor,
                  ),
                ),
                // Text(
                //   tr(LocaleKeys.vehiclesFound),
                //   style: TextStyle(
                //     fontSize: 14,
                //     color: ColorManager.grey,
                //   ),
                // ),
              ],
            ),
          ),
          // GestureDetector(
          //   onTap: () {
          //     // Afficher le filtre par prix
          //     _showPriceFilter();
          //   },
          //   child: Container(
          //     width: 40,
          //     height: 40,
          //     decoration: BoxDecoration(
          //       color: ColorManager.primaryColor,
          //       borderRadius: BorderRadius.circular(24),
          //     ),
          //     child: Icon(
          //       Icons.tune,
          //       color: Colors.white,
          //       size: 24,
          //     ),
          //   ),
          // ),
          // Bouton de filtres
          GestureDetector(
            onTap: () => _showFilterBottomSheet(context),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: ColorManager.primaryColor,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Icon(
                Icons.tune,
                color: Colors.white,
                size: 24,
              ),
            ),
          ),
        ],
      ),
    );
  }
  
  void _showFilterBottomSheet(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25)),
      ),
      builder: (context) {
        return CustomBottomSheet(
          widget: _FilterBottomSheet(
            vehicleController: _vehicleController,
            onApplyFilters: () {
              _applyFiltersAndSearch();
              Navigator.pop(context);
            },
          ),
          headerText: tr(LocaleKeys.filter),
        );
      },
    );
  }

  // Widget _buildActiveSearchIndicator() {
  //   return Container(
  //     padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
  //     color: ColorManager.primaryColor.withOpacity(0.05),
  //     child: Row(
  //       mainAxisAlignment: MainAxisAlignment.spaceBetween,
  //       children: [
  //         Obx(() {
  //           final state = _vehicleController;
  //           return Row(
  //             children: [
  //               Icon(
  //                 Icons.filter_list,
  //                 color: ColorManager.primaryColor,
  //                 size: 20,
  //               ),
  //               const SizedBox(width: 8),
  //               Text(
  //                 '${state.searchResults.length} ${tr(LocaleKeys.vehiclesFoundCount)}',
  //                 style: TextStyle(
  //                   color: ColorManager.primaryColor,
  //                   fontSize: 14,
  //                   fontWeight: FontWeight.w600,
  //                 ),
  //               ),
  //             ],
  //           );
  //         }),
  //         GestureDetector(
  //           onTap: _resetFiltersAndGoBack,
  //           child: Container(
  //             padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
  //             decoration: BoxDecoration(
  //               color: ColorManager.primaryColor,
  //               borderRadius: BorderRadius.circular(15),
  //             ),
  //             child: Text(
  //               tr(LocaleKeys.modifyFilters),
  //               style: TextStyle(
  //                 color: Colors.white,
  //                 fontSize: 12,
  //                 fontWeight: FontWeight.w600,
  //               ),
  //             ),
  //           ),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  // Widget _buildLoadingState() {
  //   return GridView.builder(
  //     padding: const EdgeInsets.all(16),
  //     gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //       crossAxisCount: 2,
  //       crossAxisSpacing: 10,
  //       mainAxisSpacing: 10,
  //       childAspectRatio: 1.1,
  //     ),
  //     itemCount: 6, // Afficher 6 shimmers (2x3)
  //     itemBuilder: (context, index) {
  //       return Container(
  //         decoration: BoxDecoration(
  //           color: Colors.grey[300],
  //           borderRadius: BorderRadius.circular(8),
  //         ),
  //         child: const Center(
  //           child: CircularProgressIndicator(),
  //         ),
  //       );
  //     },
  //   );
  // }
  Widget _buildLoadingState() {
    return Column(
      children: [
        // Header normal
        // _buildResultsHeader(context),

        // Liste de cartes en mode loading
        Expanded(
          child: RefreshIndicator(
            color: ColorManager.primaryColor,
            onRefresh: () async {
              _vehicleController.refreshSearch();
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 4, // Afficher 4 cartes de loading
              itemBuilder: (context, index) {
                return _buildVehicleCardShimmer();
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVehicleCardShimmer() {
    return Container(
      margin: EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Image placeholder (avec gradient shimmer)
          Container(
            height: 140,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(12),
                topRight: Radius.circular(12),
              ),
            ),
            child: Center(
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(ColorManager.primaryColor),
              ),
            ),
          ),

          // Contenu de la carte
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Nom du véhicule (shimmer)
                Row(
                  children: [
                    // Icône voiture
                    Container(
                      width: 20,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    SizedBox(width: 8),
                    // Texte placeholder
                    Expanded(
                      child: Container(
                        height: 16,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 12),

                // Prix par jour
                Row(
                  children: [
                    Container(
                      width: 100,
                      height: 20,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    Spacer(),
                    Container(
                      width: 80,
                      height: 16,
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 16),

                // Caractéristiques (3 icônes)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildFeatureShimmer(),
                    _buildFeatureShimmer(),
                    _buildFeatureShimmer(),
                  ],
                ),

                SizedBox(height: 16),

                // Bouton (shimmer)
                Container(
                  width: double.infinity,
                  height: 40,
                  decoration: BoxDecoration(
                    color: Colors.grey[200],
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeatureShimmer() {
    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        SizedBox(height: 4),
        Container(
          width: 40,
          height: 10,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(2),
          ),
        ),
      ],
    );
  }

  Widget _buildErrorState(VehicleController state) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.error_outline, size: 64, color: Colors.red),
          const SizedBox(height: 16),
          Text(
            tr(LocaleKeys.searchError),
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: ColorManager.blackColor,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            state.searchErrorMessage.value,
            textAlign: TextAlign.center,
            style: TextStyle(
              color: ColorManager.grey,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () {
              _vehicleController.refreshSearch();
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: Text(tr(LocaleKeys.tryAgain)),
          ),
        ],
      ),
    );
  }

  Widget _buildNoResultsState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.search_off, size: 80, color: ColorManager.grey),
          const SizedBox(height: 20),
          Text(
            tr(LocaleKeys.noResultsFound),
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: ColorManager.blackColor,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Text(
              tr(LocaleKeys.noVehiclesMatch),
              textAlign: TextAlign.center,
              style: TextStyle(
                color: ColorManager.grey,
                fontSize: 16,
                height: 1.4,
              ),
            ),
          ),
          const SizedBox(height: 30),
          ElevatedButton.icon(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: ColorManager.primaryColor,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            icon: Icon(Icons.tune, size: 20),
            label: Text(
              tr(LocaleKeys.modifyFilters),
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }

  // Widget _buildResultsList(VehicleController state) {
  //   // Calculer la largeur disponible pour chaque carte
  //   final screenWidth = MediaQuery.of(context).size.width;
  //   final cardWidth = (screenWidth - 42) / 2; // 42 = padding (32) + espacement (10)
  //
  //   return RefreshIndicator(
  //     color: ColorManager.primaryColor,
  //     onRefresh: () async {
  //       _vehicleController.refreshSearch();
  //     },
  //     child: GridView.builder(
  //       padding: const EdgeInsets.all(16),
  //       gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
  //         crossAxisCount: 1, // 2 cartes par ligne
  //         crossAxisSpacing: 10, // Espacement horizontal
  //         mainAxisSpacing: 10, // Espacement vertical
  //         childAspectRatio: 1.1, // Ratio pour avoir 3 lignes sur l'écran
  //       ),
  //       itemCount: state.searchResults.length,
  //       itemBuilder: (context, index) {
  //         final vehicle = state.searchResults[index];
  //         return VehicleCardComponent(
  //           vehicle: vehicle,
  //           width: cardWidth,
  //           height: 140, // Hauteur plus petite pour 3 lignes
  //           isInWishlist: vehicle.isInWishlist,
  //           onTap: () {
  //             // Navigation vers l'écran de détails avec options de location
  //             Navigator.of(context).push(
  //               PageRouteBuilder(
  //                 pageBuilder: (context, animation, secondaryAnimation) =>
  //                     VehicleDetailsWithRentalScreen(
  //                       vehicleId: vehicle.id,
  //                       receptionDate: widget.receptionDate,
  //                       receptionTime: widget.receptionTime,
  //                       receptionLocation: widget.receptionLocation,
  //                       deliveryDate: widget.deliveryDate,
  //                       deliveryTime: widget.deliveryTime,
  //                       deliveryLocation: widget.deliveryLocation,
  //                     ),
  //                 transitionsBuilder: (context, animation, secondaryAnimation, child) {
  //                   const begin = Offset(1.0, 0.0);
  //                   const end = Offset.zero;
  //                   const curve = Curves.ease;
  //
  //                   var tween = Tween(begin: begin, end: end).chain(
  //                     CurveTween(curve: curve),
  //                   );
  //
  //                   return SlideTransition(
  //                     position: animation.drive(tween),
  //                     child: child,
  //                   );
  //                 },
  //                 transitionDuration: const Duration(milliseconds: 300),
  //               ),
  //             );
  //           },
  //         );
  //       },
  //     ),
  //   );
  // }
  Widget _buildResultsList(VehicleController state) {
    // Calculer la largeur pour une seule carte par ligne (pleine largeur)
    final screenWidth = MediaQuery.of(context).size.width;
    final cardWidth = screenWidth - 32; // 32 = padding gauche + droite

    return RefreshIndicator(
      color: ColorManager.primaryColor,
      onRefresh: () async {
        _vehicleController.refreshSearch();
      },
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.searchResults.length + (state.hasMoreSearchResults.value ? 1 : 0),
              itemBuilder: (context, index) {
                // Afficher l'indicateur de chargement en bas si on peut charger plus
                if (index == state.searchResults.length) {
                  return Obx(() {
                    if (state.isSearching.value) {
                      return const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Center(child: CircularProgressIndicator()),
                      );
                    }
                    return const SizedBox.shrink();
                  });
                }
                
                final vehicle = state.searchResults[index];
                
                // Précharger les détails des véhicules visibles pour optimiser la navigation
                if (index < 5) { // Précharger les 5 premiers véhicules
                  _vehicleController.preloadVehicleDetails([vehicle]);
                }
                
                // Charger plus de résultats quand on approche de la fin
                if (index == state.searchResults.length - 3 && state.hasMoreSearchResults.value) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {
                    _vehicleController.loadMoreSearchResults();
                  });
                }
                
                return Padding(
                  padding: const EdgeInsets.only(bottom: 9), // Espacement entre les lignes
                  child: VehicleCardComponent(
                    vehicle: vehicle,
                    width: cardWidth, // Pleine largeur
                    height: 257, // Hauteur pour format horizontal avec image au centre
                    isInWishlist: vehicle.isInWishlist,
                    onTap: () {
                      // Navigation vers l'écran de détails avec options de location
                      Navigator.of(context).push(
                        PageRouteBuilder(
                          pageBuilder: (context, animation, secondaryAnimation) =>
                              VehicleDetailsWithRentalScreen(
                                vehicleId: vehicle.id,
                                receptionDate: widget.receptionDate,
                                receptionTime: widget.receptionTime,
                                receptionCity: widget.receptionCity,
                                receptionLocation: widget.receptionLocation,
                                deliveryDate: widget.deliveryDate,
                                deliveryTime: widget.deliveryTime,
                                deliveryCity: widget.deliveryCity,
                                deliveryLocation: widget.deliveryLocation,
                                receptionZoneId: widget.receptionZoneId,
                                deliveryZoneId: widget.deliveryZoneId,
                              ),
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
                  ),
                );
              },
            ),
          ),
          // Pagination en bas
          Obx(() => _buildPaginationControls(state)),
        ],
      ),
    );
  }
  
  Widget _buildPaginationControls(VehicleController state) {
    if (state.searchResults.isEmpty) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Bouton précédent
          IconButton(
            onPressed: state.searchPageNumber.value > 1
                ? () => state.goToSearchPage(state.searchPageNumber.value - 1)
                : null,
            icon: const Icon(Icons.chevron_left),
            color: ColorManager.primaryColor,
          ),
          
          // Informations de page
          Text(
            'Page ${state.searchPageNumber.value}',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: ColorManager.blackColor,
            ),
          ),
          
          // Bouton suivant
          IconButton(
            onPressed: state.hasMoreSearchResults.value
                ? () => state.goToSearchPage(state.searchPageNumber.value + 1)
                : null,
            icon: const Icon(Icons.chevron_right),
            color: ColorManager.primaryColor,
          ),
        ],
      ),
    );
  }

}

// Widget pour le bottom sheet de filtres - Style inspiré de properties
class _FilterBottomSheet extends StatefulWidget {
  final VehicleController vehicleController;
  final VoidCallback onApplyFilters;

  const _FilterBottomSheet({
    required this.vehicleController,
    required this.onApplyFilters,
  });

  @override
  _FilterBottomSheetState createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<_FilterBottomSheet> {
  String? selectedFuelType;
  String? selectedTransmission;
  double minPriceValue = 0.0;
  double maxPriceValue = 100000.0;
  @override
  void initState() {
    super.initState();
    selectedFuelType = widget.vehicleController.selectedFuelType.value;
    selectedTransmission = widget.vehicleController.selectedTransmission.value;
    minPriceValue = widget.vehicleController.selectedMinPrice.value ?? 0.0;
    maxPriceValue = widget.vehicleController.selectedMaxPrice.value ?? 100000.0;
  }


  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final buttonHeight = context.scale(48) + context.scale(32) + MediaQuery.of(context).padding.bottom;
    final contentHeight = screenHeight - context.scale(280) - buttonHeight;
    
    return SizedBox(
      width: double.infinity,
      height: contentHeight > 200 ? contentHeight : screenHeight * 0.5,
      child: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  _buildSectionTitle('نوع الوقود', context),
                  SizedBox(height: context.scale(12)),
                  _buildFuelTypeSelector(context),
                  SizedBox(height: context.scale(20)),
                  _buildSectionTitle('ناقل الحركة', context),
                  SizedBox(height: context.scale(12)),
                  _buildTransmissionSelector(context),
                  SizedBox(height: context.scale(20)),
                  _buildSectionTitle('السعر (MRU)', context),
                  SizedBox(height: context.scale(12)),
                  _buildPriceRangeSlider(context),
                  SizedBox(height: context.scale(8)),
                ],
              ),
            ),
          ),
          _buildActionButtons(context),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: getBoldStyle(
        color: ColorManager.blackColor,
        fontSize: FontSize.s12,
      ),
    );
  }

  Widget _buildFuelTypeSelector(BuildContext context) {
    final fuelTypes = [
      VehicleFuelType.essence,
      VehicleFuelType.diesel,
      // VehicleFuelType.electrique,
      VehicleFuelType.hybride,
      // VehicleFuelType.gaz,
    ];

    return MultiSelectTypeSelectorComponent<VehicleFuelType>(
      values: fuelTypes,
      selectedTypes: selectedFuelType != null
          ? [fuelTypes.firstWhere((f) => _getFuelTypeString(f) == selectedFuelType)]
          : [],
      onToggle: (type) {
        setState(() {
          final fuelString = _getFuelTypeString(type);
          selectedFuelType = selectedFuelType == fuelString ? null : fuelString;
        });
      },
      getLabel: _getFuelTypeLabel,
      selectorWidth: context.scale(163),
    );
  }

  Widget _buildTransmissionSelector(BuildContext context) {
    final transmissions = [
      VehicleTransmissionType.manuel,
      VehicleTransmissionType.automatique,
      // VehicleTransmissionType.semiAutomatique,
    ];

    return MultiSelectTypeSelectorComponent<VehicleTransmissionType>(
      values: transmissions,
      selectedTypes: selectedTransmission != null
          ? [transmissions.firstWhere((t) => _getTransmissionString(t) == selectedTransmission)]
          : [],
      onToggle: (type) {
        setState(() {
          final transString = _getTransmissionString(type);
          selectedTransmission = selectedTransmission == transString ? null : transString;
        });
      },
      getLabel: _getTransmissionLabel,
      selectorWidth: context.scale(163),
    );
  }

  Widget _buildPriceRangeSlider(BuildContext context) {
    return RangeSliderWithFields(
      minValue: 0.0,
      maxValue: 100000.0,
      initialMinValue: minPriceValue,
      initialMaxValue: maxPriceValue,
      unit: 'MRU',
      onRangeChanged: (double min, double max) {
        setState(() {
          minPriceValue = min;
          maxPriceValue = max;
        });
      },
    );
  }

  Widget _buildActionButtons(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: context.scale(16),
        vertical: context.scale(16),
      ),
      decoration: BoxDecoration(
        color: ColorManager.greyShade,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: SafeArea(
        top: false,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: SizedBox(
                height: context.scale(48),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      selectedFuelType = null;
                      selectedTransmission = null;
                      minPriceValue = 0.0;
                      maxPriceValue = 100000.0;
                    });
                    widget.vehicleController.resetFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFD6D8DB),
                    foregroundColor: const Color(0xFFD6D8DB),
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scale(8),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'الغاء الكل',
                      style: TextStyle(
                        color: ColorManager.blackColor,
                        fontSize: context.scale(14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: context.scale(12)),
            Expanded(
              child: SizedBox(
                height: context.scale(48),
                child: ElevatedButton(
                  onPressed: () {
                    widget.vehicleController.applyFilters(
                      fuelType: selectedFuelType,
                      transmission: selectedTransmission,
                      minDailyPrice: minPriceValue > 0 ? minPriceValue : null,
                      maxDailyPrice: maxPriceValue < 100000 ? maxPriceValue : null,
                    );
                    widget.onApplyFilters();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: ColorManager.primaryColor,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                      horizontal: context.scale(8),
                    ),
                  ),
                  child: FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      'عرض النتائج',
                      style: TextStyle(
                        fontSize: context.scale(14),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getFuelTypeString(VehicleFuelType type) {
    switch (type) {
      case VehicleFuelType.essence:
        return tr(LocaleKeys.filterGasoline);
      case VehicleFuelType.diesel:
        return tr(LocaleKeys.filterDiesel);
      // case VehicleFuelType.electrique:
      //   return 'Électrique';
      case VehicleFuelType.hybride:
        return 'Hybride';
      // case VehicleFuelType.gaz:
      //   return 'Gaz';
    }
  }

  String _getFuelTypeLabel(VehicleFuelType type) {
    switch (type) {
      case VehicleFuelType.essence:
        return tr(LocaleKeys.filterGasoline);
      case VehicleFuelType.diesel:
        return tr(LocaleKeys.filterDiesel);
      // case VehicleFuelType.electrique:
      //   return tr(LocaleKeys.filterElectric);
      case VehicleFuelType.hybride:
        return tr(LocaleKeys.filterHybrid);
      // case VehicleFuelType.gaz:
      //   return tr(LocaleKeys.filterGas);
    }
  }

  String _getTransmissionString(VehicleTransmissionType type) {
    switch (type) {
      case VehicleTransmissionType.manuel:
        return tr(LocaleKeys.filterManual);
      case VehicleTransmissionType.automatique:
        return tr(LocaleKeys.filterAutomatic);
      // case VehicleTransmissionType.semiAutomatique:
      //   return 'Semi-automatique';
    }
  }

  String _getTransmissionLabel(VehicleTransmissionType type) {
    switch (type) {
      case VehicleTransmissionType.manuel:
        return tr(LocaleKeys.filterManual);
      case VehicleTransmissionType.automatique:
        return tr(LocaleKeys.filterAutomatic);
      // case VehicleTransmissionType.semiAutomatique:
      //   return tr(LocaleKeys.filterSemiAutomatic);
    }
  }
}