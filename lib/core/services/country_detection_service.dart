import 'dart:io';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'shared_preferences_service.dart';
import '../constants/local_keys.dart';
import 'currency_service.dart';

class CountryDetectionService {
  // Singleton instance
  static final CountryDetectionService _instance = CountryDetectionService._internal();
  factory CountryDetectionService() => _instance;
  CountryDetectionService._internal();

  final SharedPreferencesService _prefsService = SharedPreferencesService();
  final CurrencyService _currencyService = CurrencyService();

  // Map des coordonnées approximatives vers les codes pays
  static const Map<String, Map<String, double>> _countryCoordinates = {
    '+20': {'lat': 26.8206, 'lng': 30.8025}, // Egypt
    '+222': {'lat': 21.0079, 'lng': -10.9408}, // Mauritania
    '+966': {'lat': 23.8859, 'lng': 45.0792}, // Saudi Arabia
    '+212': {'lat': 31.6295, 'lng': -7.9811}, // Morocco
    '+971': {'lat': 23.4241, 'lng': 53.8478}, // UAE
    '+965': {'lat': 29.3117, 'lng': 47.4818}, // Kuwait
    '+974': {'lat': 25.3548, 'lng': 51.1839}, // Qatar
    '+973': {'lat': 25.9304, 'lng': 50.6378}, // Bahrain
    '+968': {'lat': 21.4735, 'lng': 55.9754}, // Oman
    '+962': {'lat': 30.5852, 'lng': 36.2384}, // Jordan
    '+961': {'lat': 33.8547, 'lng': 35.8623}, // Lebanon
    '+963': {'lat': 34.8021, 'lng': 38.9968}, // Syria
    '+964': {'lat': 33.2232, 'lng': 43.6793}, // Iraq
    '+98': {'lat': 32.4279, 'lng': 53.6880}, // Iran
    '+90': {'lat': 38.9637, 'lng': 35.2433}, // Turkey
  };

  // Méthode pour détecter le pays basé sur la géolocalisation
  Future<String?> detectCountryFromLocation() async {
    try {
      // Vérifier les permissions de géolocalisation
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return null;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return null;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        return null;
      }

      // Obtenir la position actuelle
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );

      // Convertir les coordonnées en adresse
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        String? countryCode = place.isoCountryCode;
        
        if (countryCode != null) {
          // Convertir le code ISO en code de téléphone
          String? phoneCode = _getPhoneCodeFromCountryCode(countryCode);
          if (phoneCode != null) {
            await _currencyService.setUserCountry(phoneCode);
            return phoneCode;
          }
        }
      }

      return null;
    } catch (e) {
      print('Erreur lors de la détection du pays: $e');
      return null;
    }
  }

  // Méthode pour détecter le pays basé sur l'adresse IP (fallback)
  Future<String?> detectCountryFromIP() async {
    try {
      // Cette méthode nécessiterait une API externe comme ipapi.co ou ipinfo.io
      // Pour l'instant, on retourne null
      return null;
    } catch (e) {
      print('Erreur lors de la détection du pays par IP: $e');
      return null;
    }
  }

  // Méthode pour détecter le pays basé sur les paramètres système
  Future<String?> detectCountryFromSystem() async {
    try {
      // Détecter la langue du système
      String systemLanguage = Platform.localeName.split('_').last;
      
      // Map des langues vers les codes pays
      Map<String, String> languageToCountry = {
        'EG': '+20', // Egypt
        'SA': '+966', // Saudi Arabia
        'MA': '+212', // Morocco
        'AE': '+971', // UAE
        'KW': '+965', // Kuwait
        'QA': '+974', // Qatar
        'BH': '+973', // Bahrain
        'OM': '+968', // Oman
        'JO': '+962', // Jordan
        'LB': '+961', // Lebanon
        'SY': '+963', // Syria
        'IQ': '+964', // Iraq
        'IR': '+98', // Iran
        'TR': '+90', // Turkey
        'MR': '+222', // Mauritania
      };

      String? countryCode = languageToCountry[systemLanguage];
      if (countryCode != null) {
        await _currencyService.setUserCountry(countryCode);
        return countryCode;
      }

      return null;
    } catch (e) {
      print('Erreur lors de la détection du pays par système: $e');
      return null;
    }
  }

  // Méthode principale pour détecter le pays
  Future<String?> detectUserCountry() async {
    // 1. Vérifier si le pays est déjà défini
    String? currentCountry = _currencyService.getCurrentUserCountry();
    if (currentCountry != null) {
      return currentCountry;
    }

    // 2. Essayer la géolocalisation
    String? countryFromLocation = await detectCountryFromLocation();
    if (countryFromLocation != null) {
      return countryFromLocation;
    }

    // 3. Essayer la détection par IP
    String? countryFromIP = await detectCountryFromIP();
    if (countryFromIP != null) {
      return countryFromIP;
    }

    // 4. Essayer la détection par système
    String? countryFromSystem = await detectCountryFromSystem();
    if (countryFromSystem != null) {
      return countryFromSystem;
    }

    // 5. Fallback vers l'Égypte par défaut
    await _currencyService.setUserCountry('+20');
    return '+20';
  }

  // Méthode pour permettre à l'utilisateur de sélectionner manuellement son pays
  Future<void> setUserSelectedCountry(String countryCode) async {
    await _currencyService.setUserCountry(countryCode);
  }

  // Méthode pour obtenir la distance entre deux coordonnées
  double _calculateDistance(double lat1, double lng1, double lat2, double lng2) {
    return Geolocator.distanceBetween(lat1, lng1, lat2, lng2);
  }

  // Map des codes ISO pays vers les codes de téléphone
  String? _getPhoneCodeFromCountryCode(String isoCountryCode) {
    Map<String, String> isoToPhone = {
      'EG': '+20', // Egypt
      'MR': '+222', // Mauritania
      'SA': '+966', // Saudi Arabia
      'MA': '+212', // Morocco
      'AE': '+971', // UAE
      'KW': '+965', // Kuwait
      'QA': '+974', // Qatar
      'BH': '+973', // Bahrain
      'OM': '+968', // Oman
      'JO': '+962', // Jordan
      'LB': '+961', // Lebanon
      'SY': '+963', // Syria
      'IQ': '+964', // Iraq
      'IR': '+98', // Iran
      'TR': '+90', // Turkey
    };

    return isoToPhone[isoCountryCode];
  }

  // Méthode pour réinitialiser la détection du pays
  Future<void> resetCountryDetection() async {
    // Supprimer la clé en stockant une valeur vide
    await _prefsService.storeValue(LocalKeys.countryCodeNumber, '');
  }

  // Méthode pour forcer une nouvelle détection
  Future<String?> forceCountryDetection() async {
    await resetCountryDetection();
    return await detectUserCountry();
  }
}
