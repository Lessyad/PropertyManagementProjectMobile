import 'shared_preferences_service.dart';
import '../constants/local_keys.dart';
import 'country_detection_service.dart';
import 'currency_service.dart';

class AppInitializationService {
  // Singleton instance
  static final AppInitializationService _instance = AppInitializationService._internal();
  factory AppInitializationService() => _instance;
  AppInitializationService._internal();

  final CountryDetectionService _countryDetectionService = CountryDetectionService();
  final CurrencyService _currencyService = CurrencyService();
  final SharedPreferencesService _prefsService = SharedPreferencesService();

  // Méthode pour initialiser l'application
  Future<void> initializeApp() async {
    try {
      // 1. Vérifier si c'est la première fois que l'app est lancée
      bool isFirstLaunch = _prefsService.getValue('is_first_launch') != 'false';
      
      if (isFirstLaunch) {
        // Première fois - détecter automatiquement le pays
        await _initializeFirstLaunch();
        await _prefsService.storeValue('is_first_launch', 'false');
      } else {
        // Pas la première fois - vérifier si le pays est défini
        String? currentCountry = _currencyService.getCurrentUserCountry();
        if (currentCountry == null) {
          // Si pas de pays défini, détecter automatiquement
          await _countryDetectionService.detectUserCountry();
        }
      }
      
      // 2. Initialiser d'autres services si nécessaire
      await _initializeOtherServices();
      
    } catch (e) {
      print('Erreur lors de l\'initialisation de l\'application: $e');
      // En cas d'erreur, définir l'Égypte par défaut
      await _currencyService.setUserCountry('+20');
    }
  }

  // Initialisation pour le premier lancement
  Future<void> _initializeFirstLaunch() async {
    print('Premier lancement de l\'application - détection du pays...');
    
    // Essayer de détecter le pays automatiquement
    String? detectedCountry = await _countryDetectionService.detectUserCountry();
    
    if (detectedCountry != null) {
      print('Pays détecté: $detectedCountry');
    } else {
      print('Impossible de détecter le pays - utilisation de l\'Égypte par défaut');
      await _currencyService.setUserCountry('+20');
    }
  }

  // Initialisation d'autres services
  Future<void> _initializeOtherServices() async {
    // Ici, vous pouvez ajouter l'initialisation d'autres services
    // comme les notifications, la base de données locale, etc.
    
    // Exemple: Initialiser les paramètres par défaut
    await _initializeDefaultSettings();
  }

  // Initialiser les paramètres par défaut
  Future<void> _initializeDefaultSettings() async {
    // Vérifier et définir les paramètres par défaut si nécessaire
    String? language = _prefsService.getValue('language');
    if (language == null) {
      await _prefsService.storeValue('language', 'ar'); // Arabe par défaut
    }
    
    String? theme = _prefsService.getValue('theme');
    if (theme == null) {
      await _prefsService.storeValue('theme', 'light'); // Thème clair par défaut
    }
  }

  // Méthode pour forcer une nouvelle détection du pays
  Future<void> forceCountryDetection() async {
    print('Forçage de la détection du pays...');
    await _countryDetectionService.forceCountryDetection();
  }

  // Méthode pour réinitialiser l'application
  Future<void> resetApp() async {
    print('Réinitialisation de l\'application...');
    
    // Supprimer toutes les préférences
    await _prefsService.clearAllData();
    
    // Redémarrer l'initialisation
    await initializeApp();
  }

  // Méthode pour obtenir les informations de l'application
  Map<String, dynamic> getAppInfo() {
    return {
      'currentCountry': _currencyService.getCurrentUserCountry(),
      'currentCurrency': _currencyService.getPreferredCurrency().code,
      'isFirstLaunch': _prefsService.getValue('is_first_launch') != 'false',
      'language': _prefsService.getValue('language') ?? 'ar',
      'theme': _prefsService.getValue('theme') ?? 'light',
    };
  }

  // Méthode pour vérifier si l'application est correctement initialisée
  bool isAppInitialized() {
    String? country = _currencyService.getCurrentUserCountry();
    return country != null;
  }
}
