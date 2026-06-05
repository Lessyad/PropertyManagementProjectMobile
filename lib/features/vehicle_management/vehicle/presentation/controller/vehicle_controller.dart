import 'dart:async';
import 'package:enmaa/core/errors/failure.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:enmaa/core/constants/local_keys.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../data/models/vehicle_filter_model.dart';
import '../../data/models/global_rental_options.dart';
import '../../domain/entities/vehicle_entity.dart';
import '../../domain/entities/vehicle_details_entity.dart';
import '../../domain/use_cases/get_vehicles_usecase.dart';

class VehicleController extends GetxController {

  final GetVehiclesUseCase getVehiclesUseCase;

  VehicleController(this.getVehiclesUseCase);

  // États pour la liste principale des véhicules
  final vehicles = <VehicleEntity>[].obs;
  final isLoading = false.obs;
  final isLoadingMore = false.obs;
  final hasReachedMax = false.obs;
  final pageNumber = 1.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;

  // États pour la recherche et le filtrage
  final searchResults = <VehicleEntity>[].obs;
  final isSearching = false.obs;
  final hasSearchError = false.obs;
  final searchErrorMessage = ''.obs;
  final currentSearchQuery = ''.obs;
  final currentFilters = Rx<VehicleFilterModel?>(null);
  final selectedFuelType = Rx<String?>(null);
  final selectedTransmission = Rx<String?>(null);
  final selectedMinSeats = Rx<int?>(null);
  final selectedMinPrice = Rx<double?>(null);
  final selectedMaxPrice = Rx<double?>(null);
  
  // Pagination pour la recherche
  final searchPageNumber = 1.obs;
  final searchPageSize = 12.obs;
  final searchTotalCount = 0.obs;
  final searchTotalPages = 0.obs;
  final hasMoreSearchResults = false.obs;
  
  // Filtres géographiques selon VehicleFilterDto
  final selectedReceptionZoneId = Rx<int?>(null);
  final selectedDeliveryZoneId = Rx<int?>(null);
  final selectedUserAge = Rx<int?>(null);

  // Cache pour les détails des véhicules
  final _vehicleDetailsCache = <int, VehicleDetailsEntity>{}.obs;
  final _lastCacheUpdate = <int, DateTime>{}.obs;
  static const Duration _cacheExpiration = Duration(minutes: 5);

  // Cache pour les options de location globales
  final _globalOptionsCache = Rx<GlobalRentalOptions?>(null);
  final _lastOptionsUpdate = Rx<DateTime?>(null);

  @override
  void onInit() {
    super.onInit();
    getVehicles();
  }

  // Méthode pour récupérer les véhicules (liste principale)
  Future<void> getVehicles({bool loadMore = false, VehicleFilterModel? filter}) async {
    if (hasReachedMax.value && loadMore) return;

    try {
      if (!loadMore) {
        isLoading.value = true;
        vehicles.clear();
        pageNumber.value = 1;
        hasReachedMax.value = false;
        hasError.value = false;
        errorMessage.value = '';
      } else {
        isLoadingMore.value = true;
      }

      final result = await getVehiclesUseCase(
        pageNumber: pageNumber.value,
        pageSize: 10,
        filter: filter,
      );

      result.fold(
            (failure) {
          errorMessage.value = _mapFailureToMessage(failure);
          hasError.value = true;
          isLoading.value = false;
          isLoadingMore.value = false;
        },
            (paged) {
          vehicles.addAll(paged.items);

          hasReachedMax.value = !paged.hasNextPage;

          if (!hasReachedMax.value) {
            pageNumber.value++;
          }

          hasError.value = false;
          errorMessage.value = '';
          isLoading.value = false;
          isLoadingMore.value = false;
        },
      );
    } catch (e) {
      errorMessage.value = 'Une erreur inattendue est survenue';
      hasError.value = true;
      isLoading.value = false;
      isLoadingMore.value = false;
    }
  }

  // Méthode pour appliquer des filtres
  Future<void> applyFilters({
    String? fuelType,
    String? transmission,
    int? minSeats,
    double? minDailyPrice,
    double? maxDailyPrice,
  }) async {
    final filter = VehicleFilterModel(
      fuelType: fuelType,
      transmission: transmission,
      minSeats: minSeats,
      minDailyPrice: minDailyPrice,
      maxDailyPrice: maxDailyPrice,
    );

    currentFilters.value = filter;
    selectedFuelType.value = fuelType;
    selectedMinPrice.value = minDailyPrice;
    selectedTransmission.value = transmission;
    selectedMinSeats.value = minSeats;
    selectedMaxPrice.value = maxDailyPrice;

    await searchVehicles(filter: filter);
  }

  // Méthode helper pour combiner DateTime et TimeOfDay en un DateTime complet
  DateTime? _combineDateTime(DateTime? date, TimeOfDay? time) {
    if (date == null) return null;
    if (time == null) {
      // Si pas d'heure spécifiée, utiliser minuit
      return DateTime(date.year, date.month, date.day);
    }
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  // Méthode pour appliquer les filtres de recherche géographiques
  Future<void> applySearchFilters({
    // int? receptionZoneId,
    // int? deliveryZoneId,
    int? userAge,
    int? categoryId,
    int? userCountryId, // Accepter userCountryId depuis le paramètre (priorité)
    DateTime? receptionDate,
    TimeOfDay? receptionTime,
    DateTime? deliveryDate,
    TimeOfDay? deliveryTime,
  }) async {
    // selectedReceptionZoneId.value = receptionZoneId;
    // selectedDeliveryZoneId.value = deliveryZoneId;
    selectedUserAge.value = userAge;

    // Combiner les dates et heures pour créer des DateTime complets
    final DateTime? startDateTime = _combineDateTime(receptionDate, receptionTime);
    final DateTime? endDateTime = _combineDateTime(deliveryDate, deliveryTime);

    // Activer le filtre de disponibilité si les dates sont fournies
    final bool isAvailabilityFilterEnabled = startDateTime != null && endDateTime != null;

    // Utiliser userCountryId depuis le paramètre si fourni, sinon fallback vers SharedPreferences
    int? finalUserCountryId = userCountryId;
    if (finalUserCountryId == null) {
      final sharedPrefs = SharedPreferencesService();
      final userCountryIdStr = sharedPrefs.getValue(LocalKeys.userCountryID);
      finalUserCountryId = userCountryIdStr != null && userCountryIdStr.isNotEmpty 
          ? int.tryParse(userCountryIdStr) 
          : null;
    }

    final filter = VehicleFilterModel(
      vehicleCategoryId: categoryId,
      fuelType: selectedFuelType.value,
      transmission: selectedTransmission.value,
      minSeats: selectedMinSeats.value,
      minDailyPrice: selectedMinPrice.value,
      maxDailyPrice: selectedMaxPrice.value,
      // receptionZoneId: receptionZoneId,
      // deliveryZoneId: deliveryZoneId,
      userAge: userAge,
      userCountryId: finalUserCountryId, // Utiliser finalUserCountryId (paramètre ou SharedPreferences)
      isAvailabilityFilterEnabled: isAvailabilityFilterEnabled ? true : null,
      startDate: startDateTime,
      endDate: endDateTime,
    );

    currentFilters.value = filter;
    
    // Debug: Afficher les filtres appliqués
    print('🔍 VehicleController - Filtres appliqués:');
    print('  - VehicleCategoryId: ${categoryId}');
    // print('  - ReceptionZoneId: ${receptionZoneId}');
    // print('  - DeliveryZoneId: ${deliveryZoneId}');
    print('  - UserAge: ${userAge}');
    print('  - UserCountryId (paramètre): ${userCountryId}');
    print('  - UserCountryId (final): ${finalUserCountryId}');
    print('  - ReceptionDate: ${receptionDate}');
    print('  - ReceptionTime: ${receptionTime}');
    print('  - DeliveryDate: ${deliveryDate}');
    print('  - DeliveryTime: ${deliveryTime}');
    print('  - StartDateTime (combiné): ${startDateTime}');
    print('  - EndDateTime (combiné): ${endDateTime}');
    print('  - IsAvailabilityFilterEnabled: $isAvailabilityFilterEnabled');
    print('  - JSON envoyé: ${filter.toJson()}');
  }

  // Méthode pour réinitialiser tous les filtres
  void resetFilters() {
    selectedFuelType.value = null;
    selectedTransmission.value = null;
    selectedMinSeats.value = null;
    selectedMinPrice.value = null;
    selectedMaxPrice.value = null;
    selectedReceptionZoneId.value = null;
    selectedDeliveryZoneId.value = null;
    selectedUserAge.value = null;
    currentFilters.value = null;
    currentSearchQuery.value = '';
    searchResults.clear();
    searchPageNumber.value = 1;
    searchTotalCount.value = 0;
    searchTotalPages.value = 0;
    hasMoreSearchResults.value = false;
  }

  // Méthode pour rechercher des véhicules avec filtres et pagination
  Future<void> searchVehicles({
    String query = '',
    VehicleFilterModel? filter,
    int pageNumber = 1,
    bool loadMore = false,
  }) async {
    try {
      if (!loadMore) {
        isSearching.value = true;
        searchPageNumber.value = pageNumber;
        searchTotalPages.value = 0;
        searchTotalCount.value = 0;
        searchResults.clear();
      }
      hasSearchError.value = false;
      searchErrorMessage.value = '';
      currentSearchQuery.value = query;

      // Debug: Afficher les filtres envoyés
      if (filter != null) {
        print('🔍 VehicleController - Filtres appliqués:');
        print('  - VehicleCategoryId: ${filter.vehicleCategoryId}');
        print('  - ReceptionZoneId: ${filter.receptionZoneId}');
        print('  - DeliveryZoneId: ${filter.deliveryZoneId}');
        print('  - UserAge: ${filter.userAge}');
        print('  - FuelType: ${filter.fuelType}');
        print('  - Transmission: ${filter.transmission}');
        print('  - MinSeats: ${filter.minSeats}');
        print('  - MinDailyPrice: ${filter.minDailyPrice}');
        print('  - MaxDailyPrice: ${filter.maxDailyPrice}');
        print('  - Page: $pageNumber, PageSize: ${searchPageSize.value}');
        print('  - JSON envoyé: ${filter.toJson()}');
      }

      final result = await getVehiclesUseCase(
        pageNumber: pageNumber,
        pageSize: searchPageSize.value,
        filter: filter,
      );

      result.fold(
            (failure) {
          searchErrorMessage.value = _mapFailureToMessage(failure);
          hasSearchError.value = true;
          isSearching.value = false;
        },
            (paged) {
          // Filtrer par query locale si fournie
          List<VehicleEntity> filteredItems;
          if (query.isNotEmpty) {
            final lowerQuery = query.toLowerCase();
            filteredItems = paged.items.where((vehicle) =>
            vehicle.makeName.toLowerCase().contains(lowerQuery) ||
                vehicle.modelName.toLowerCase().contains(lowerQuery) ||
                vehicle.licensePlate.toLowerCase().contains(lowerQuery) ||
                vehicle.categoryName.toLowerCase().contains(lowerQuery) ||
                (vehicle.fuelType.isNotEmpty && vehicle.fuelType.toLowerCase().contains(lowerQuery)) ||
                (vehicle.transmission.isNotEmpty && vehicle.transmission.toLowerCase().contains(lowerQuery))
            ).toList();
          } else {
            filteredItems = paged.items;
          }

          // Toujours remplacer (navigation par pages, pas infinite scroll)
          searchResults.value = filteredItems;

          // Mettre à jour la pagination depuis les vraies données backend
          searchPageNumber.value = pageNumber;
          searchTotalCount.value = paged.totalCount;
          searchTotalPages.value = paged.totalPages;
          hasMoreSearchResults.value = paged.hasNextPage;

          isSearching.value = false;
        },
      );
    } catch (e) {
      searchErrorMessage.value = 'Une erreur inattendue est survenue';
      hasSearchError.value = true;
      isSearching.value = false;
    }
  }
  
  // Méthode pour charger plus de résultats
  Future<void> loadMoreSearchResults() async {
    if (!hasMoreSearchResults.value || isSearching.value) return;
    
    final nextPage = searchPageNumber.value + 1;
    await searchVehicles(
      query: currentSearchQuery.value,
      filter: currentFilters.value,
      pageNumber: nextPage,
      loadMore: true,
    );
  }
  
  // Méthode pour changer de page
  Future<void> goToSearchPage(int page) async {
    if (page < 1 || (searchTotalPages.value > 0 && page > searchTotalPages.value)) return;
    await searchVehicles(
      query: currentSearchQuery.value,
      filter: currentFilters.value,
      pageNumber: page,
      loadMore: false,
    );
  }

  // Méthode pour effacer la recherche
  void clearSearch() {
    searchResults.clear();
    currentSearchQuery.value = '';
    isSearching.value = false;
    hasSearchError.value = false;
  }

  // Méthode pour rafraîchir la recherche
  void refreshSearch() {
    if (currentSearchQuery.value.isNotEmpty || currentFilters.value != null) {
      searchVehicles(
        query: currentSearchQuery.value,
        filter: currentFilters.value,
        pageNumber: 1,
      );
    }
  }

  // Méthode pour appliquer un filtre de carburant
  void applyFuelFilter(String fuelType) {
    if (selectedFuelType.value == fuelType) {
      // Si le filtre est déjà sélectionné, le désélectionner
      applyFilters(
        fuelType: null,
        transmission: selectedTransmission.value,
        minSeats: selectedMinSeats.value,
        minDailyPrice: selectedMinPrice.value,
        maxDailyPrice: selectedMaxPrice.value,
      );
    } else {
      // Appliquer le nouveau filtre
      applyFilters(
        fuelType: fuelType,
        transmission: selectedTransmission.value,
        minSeats: selectedMinSeats.value,
        minDailyPrice: selectedMinPrice.value,
        maxDailyPrice: selectedMaxPrice.value,
      );
    }
  }

  // Méthode pour appliquer un filtre de transmission
  void applyTransmissionFilter(String transmission) {
    if (selectedTransmission.value == transmission) {
      // Si le filtre est déjà sélectionné, le désélectionner
      applyFilters(
        fuelType: selectedFuelType.value,
        transmission: null,
        minSeats: selectedMinSeats.value,
        minDailyPrice: selectedMinPrice.value,
        maxDailyPrice: selectedMaxPrice.value,
      );
    } else {
      // Appliquer le nouveau filtre
      applyFilters(
        fuelType: selectedFuelType.value,
        transmission: transmission,
        minSeats: selectedMinSeats.value,
        minDailyPrice: selectedMinPrice.value,
        maxDailyPrice: selectedMaxPrice.value,
      );
    }
  }

  // Méthode pour vérifier si un filtre est actif
  bool get hasActiveFilters {
    return selectedFuelType.value != null ||
        selectedTransmission.value != null ||
        selectedMinSeats.value != null ||
        selectedMinPrice.value != null ||
        selectedMaxPrice.value != null;
  }

  // Méthode pour obtenir la description des filtres actifs
  String get activeFiltersDescription {
    final filters = <String>[];

    if (selectedFuelType.value != null) {
      filters.add('Carburant: ${selectedFuelType.value}');
    }
    if (selectedTransmission.value != null) {
      filters.add('Transmission: ${selectedTransmission.value}');
    }
    if (selectedMinSeats.value != null) {
      filters.add('Sièges min: ${selectedMinSeats.value}');
    }
    if (selectedMinPrice.value != null) {
      filters.add('Prix min: ${selectedMinPrice.value!.round()} MRU');
    }
    if (selectedMaxPrice.value != null) {
      filters.add('Prix max: ${selectedMaxPrice.value!.round()} MRU');
    }

    return filters.join(', ');
  }

  // Méthode pour rafraîchir les véhicules
  Future<void> refreshVehicles() async {
    await getVehicles(loadMore: false);
  }

  // Méthode pour charger plus de véhicules
  void loadMoreVehicles() {
    if (!isLoadingMore.value && !hasReachedMax.value) {
      getVehicles(loadMore: true);
    }
  }

  // Méthode pour mapper les erreurs
  String _mapFailureToMessage(Failure failure) {
    switch (failure.runtimeType) {
      case ServerFailure:
        return 'Erreur serveur: ${failure.message}';
      // case NetworkFailure:
      //   return 'Problème de connexion: ${failure.message}';
      // case CacheFailure:
      //   return 'Erreur de cache: ${failure.message}';
      default:
        return 'Erreur inattendue: ${failure.message}';
    }
  }

  // Méthode pour obtenir les statistiques des véhicules
  Map<String, int> getVehicleStats() {
    final stats = <String, int>{
      'total': vehicles.length,
      'essence': vehicles.where((v) => v.fuelType == 'ESSENCE').length,
      'diesel': vehicles.where((v) => v.fuelType == 'DIESEL').length,
      'automatique': vehicles.where((v) => v.transmission == 'AUTOMATIQUE').length,
      'manuel': vehicles.where((v) => v.transmission == 'MANUEL').length,
    };

    return stats;
  }

  // Méthode pour trouver un véhicule par ID
  VehicleEntity? findVehicleById(int id) {
    try {
      return vehicles.firstWhere((vehicle) => vehicle.id == id);
    } catch (e) {
      return null;
    }
  }

  // Méthode pour mettre à jour le statut wishlist d'un véhicule
  void updateVehicleWishlistStatus(int vehicleId, bool isInWishlist) {
    final index = vehicles.indexWhere((v) => v.id == vehicleId);
    if (index != -1) {
      final updatedVehicle = vehicles[index].copyWith(isInWishlist: isInWishlist);
      vehicles[index] = updatedVehicle;
    }

    // Mettre à jour aussi dans les résultats de recherche si présent
    final searchIndex = searchResults.indexWhere((v) => v.id == vehicleId);
    if (searchIndex != -1) {
      final updatedVehicle = searchResults[searchIndex].copyWith(isInWishlist: isInWishlist);
      searchResults[searchIndex] = updatedVehicle;
    }
  }

  // Méthodes de cache pour les détails des véhicules
  VehicleDetailsEntity? getCachedVehicleDetails(int vehicleId) {
    final lastUpdate = _lastCacheUpdate[vehicleId];
    if (lastUpdate != null && 
        DateTime.now().difference(lastUpdate) < _cacheExpiration) {
      return _vehicleDetailsCache[vehicleId];
    }
    return null;
  }

  void cacheVehicleDetails(int vehicleId, VehicleDetailsEntity details) {
    _vehicleDetailsCache[vehicleId] = details;
    _lastCacheUpdate[vehicleId] = DateTime.now();
  }

  void clearVehicleDetailsCache() {
    _vehicleDetailsCache.clear();
    _lastCacheUpdate.clear();
  }

  // Méthodes de cache pour les options globales
  GlobalRentalOptions? getCachedGlobalOptions() {
    final lastUpdate = _lastOptionsUpdate.value;
    if (lastUpdate != null && 
        DateTime.now().difference(lastUpdate) < _cacheExpiration) {
      return _globalOptionsCache.value;
    }
    return null;
  }

  void cacheGlobalOptions(GlobalRentalOptions options) {
    _globalOptionsCache.value = options;
    _lastOptionsUpdate.value = DateTime.now();
  }

  // Méthode pour optimiser la recherche avec debounce
  Timer? _searchDebounceTimer;
  void debouncedSearch({String query = '', VehicleFilterModel? filter}) {
    _searchDebounceTimer?.cancel();
    _searchDebounceTimer = Timer(const Duration(milliseconds: 300), () {
      searchVehicles(query: query, filter: filter, pageNumber: 1);
    });
  }

  // Méthode pour précharger les détails des véhicules visibles
  void preloadVehicleDetails(List<VehicleEntity> visibleVehicles) {
    for (final vehicle in visibleVehicles) {
      if (getCachedVehicleDetails(vehicle.id) == null) {
        // Précharger en arrière-plan sans bloquer l'UI
        Future.microtask(() async {
          try {
            // Ici vous pourriez appeler le use case pour récupérer les détails
            // et les mettre en cache
          } catch (e) {
            // Ignorer les erreurs de préchargement
          }
        });
      }
    }
  }

  @override
  void onClose() {
    _searchDebounceTimer?.cancel();
    super.onClose();
  }
}