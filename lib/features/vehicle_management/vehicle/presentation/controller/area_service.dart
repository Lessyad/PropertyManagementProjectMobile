import 'package:get/get.dart';
import '../../../../../core/services/geo_service.dart';
import '../../../../../core/models/geo_models.dart';

class AreaService extends GetxController {
  final GeoService _geoService = GeoService();
  
  // États des zones
  final areas = <Area>[].obs;
  final isLoading = false.obs;
  final errorMessage = ''.obs;
  final hasError = false.obs;

  // Zone par défaut (Stade olympique)
  static const int defaultAreaId = 1;
  static const String defaultAreaName = "Stade olympique";

  /// Récupère les zones par ville
  Future<List<Area>> getAreasByCity(int cityId) async {
    try {
      isLoading.value = true;
      hasError.value = false;
      
      final areasList = await _geoService.getAreasByCity(cityId);
      areas.value = areasList;
      
      print('📍 Zones récupérées pour la ville $cityId: ${areasList.length}');
      for (final area in areasList) {
        print('  - ${area.name} (ID: ${area.id})');
      }
      
      isLoading.value = false;
      return areasList;
    } catch (e) {
      print('❌ Erreur lors de la récupération des zones: $e');
      hasError.value = true;
      errorMessage.value = e.toString();
      isLoading.value = false;
      return [];
    }
  }

  /// Récupère l'ID de la zone par défaut
  int getDefaultPickupAreaId() {
    print('📍 Zone de récupération par défaut: $defaultAreaName (ID: $defaultAreaId)');
    return defaultAreaId;
  }

  /// Récupère l'ID de la zone de retour par défaut
  int getDefaultReturnAreaId() {
    print('📍 Zone de retour par défaut: $defaultAreaName (ID: $defaultAreaId)');
    return defaultAreaId;
  }

  /// Trouve une zone par son nom
  Area? findAreaByName(String name) {
    return areas.firstWhereOrNull((area) => 
      area.name.toLowerCase().contains(name.toLowerCase())
    );
  }

  /// Trouve une zone par son ID
  Area? findAreaById(int id) {
    return areas.firstWhereOrNull((area) => area.id == id);
  }

  /// Récupère l'ID de la zone "Stade olympique" spécifiquement
  int getStadeOlympiqueAreaId() {
    // Chercher la zone "Stade olympique" dans la liste
    final stadeArea = findAreaByName("Stade olympique");
    if (stadeArea != null) {
      print('📍 Zone "Stade olympique" trouvée: ID ${stadeArea.id}');
      return stadeArea.id;
    }
    
    // Fallback vers l'ID par défaut
    print('📍 Zone "Stade olympique" non trouvée, utilisation de l\'ID par défaut: $defaultAreaId');
    return defaultAreaId;
  }
}
