import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../../data/models/global_rental_options.dart';

class GlobalRentalOptionsController extends GetxController {
  // Options par défaut en cas de problème de récupération
  static final GlobalRentalOptions _defaultOptions = GlobalRentalOptions(
    addChildsChairAmount: 0.24,
    allRiskCarInsuranceAmount: 0.2,
    kilometerIllimitedPerDayAmount: 0.2,
    secondDriverAmount: 100.0,
  );

  // État des options globales
  final _options = _defaultOptions.obs;
  final _isLoading = false.obs;
  final _errorMessage = ''.obs;
  final _lastUpdate = Rx<DateTime?>(null);
  static const Duration _cacheExpiration = Duration(hours: 1);
  static const String _cacheKey = 'global_rental_options_cache';

  // Getters
  GlobalRentalOptions get options => _options.value;
  bool get isLoading => _isLoading.value;
  String get errorMessage => _errorMessage.value;

  // Prix des options individuelles
  double get addChildsChairAmount => _options.value.addChildsChairAmount;
  double get allRiskCarInsuranceAmount => _options.value.allRiskCarInsuranceAmount;
  double get kilometerIllimitedPerDayAmount => _options.value.kilometerIllimitedPerDayAmount;
  double get secondDriverAmount => _options.value.secondDriverAmount;

  @override
  void onInit() {
    super.onInit();
    // Charger les options depuis le cache au démarrage
    _loadFromCache();
  }

  // Charger les options depuis le cache local
  Future<void> _loadFromCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cachedData = prefs.getString(_cacheKey);
      final cachedTime = prefs.getString('${_cacheKey}_time');
      
      if (cachedData != null && cachedTime != null) {
        final lastUpdate = DateTime.parse(cachedTime);
        if (DateTime.now().difference(lastUpdate) < _cacheExpiration) {
          final options = GlobalRentalOptions.fromJson(jsonDecode(cachedData));
          _options.value = options;
          _lastUpdate.value = lastUpdate;
          return;
        }
      }
    } catch (e) {
      // En cas d'erreur, utiliser les options par défaut
      _errorMessage.value = 'Erreur lors du chargement du cache: $e';
    }
  }

  // Sauvegarder les options dans le cache local
  Future<void> _saveToCache() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_cacheKey, jsonEncode(_options.value.toJson()));
      await prefs.setString('${_cacheKey}_time', DateTime.now().toIso8601String());
      _lastUpdate.value = DateTime.now();
    } catch (e) {
      _errorMessage.value = 'Erreur lors de la sauvegarde du cache: $e';
    }
  }

  // Méthode pour mettre à jour les options depuis la réponse de l'API
  void updateOptions(Map<String, dynamic> jsonResponse) {
    try {
      _options.value = GlobalRentalOptions.fromJson(jsonResponse);
      _errorMessage.value = '';
      _saveToCache(); // Sauvegarder dans le cache
    } catch (e) {
      _errorMessage.value = 'Erreur lors de la mise à jour des options: $e';
      // Garder les options par défaut en cas d'erreur
      _options.value = _defaultOptions;
    }
  }

  // Méthode pour mettre à jour les options directement
  void setOptions(GlobalRentalOptions newOptions) {
    _options.value = newOptions;
    _errorMessage.value = '';
    _saveToCache(); // Sauvegarder dans le cache
  }

  // Vérifier si le cache est valide
  bool get isCacheValid {
    if (_lastUpdate.value == null) return false;
    return DateTime.now().difference(_lastUpdate.value!) < _cacheExpiration;
  }

  // Forcer le rechargement depuis l'API
  Future<void> refreshFromAPI() async {
    _isLoading.value = true;
    try {
      // Ici vous pourriez appeler votre API pour récupérer les dernières options
      // Pour l'instant, on garde les options actuelles
      await Future.delayed(const Duration(milliseconds: 500)); // Simulation
      _saveToCache();
    } catch (e) {
      _errorMessage.value = 'Erreur lors du rechargement: $e';
    } finally {
      _isLoading.value = false;
    }
  }

  // Méthode pour réinitialiser aux valeurs par défaut
  void resetToDefaults() {
    _options.value = _defaultOptions;
    _errorMessage.value = '';
  }

  // Méthode pour calculer le coût total des options sélectionnées
  double calculateExtraCosts({
    required bool extraKilometers,
    required bool fullInsurance,
    required bool childSeat,
    required bool secondDriver,
    required int numberOfDays,
  }) {
    double total = 0;

    if (extraKilometers) {
      total += kilometerIllimitedPerDayAmount; // Frais unique
    }
    if (fullInsurance) {
      total += allRiskCarInsuranceAmount ; // Par jour
    }
    if (childSeat) {
      total += addChildsChairAmount; // Par jour
    }
    if (secondDriver) {
      total += secondDriverAmount; // Frais unique pour le deuxième chauffeur
    }

    return total;
  }
}
