import '../services/shared_preferences_service.dart';
import '../constants/local_keys.dart';

class CurrencyInfo {
  final String code;
  final String symbol;
  final String name;
  final String perDayLabel;

  CurrencyInfo({
    required this.code,
    required this.symbol,
    required this.name,
    required this.perDayLabel,
  });
}

class CurrencyService {
  // Singleton instance
  static final CurrencyService _instance = CurrencyService._internal();
  factory CurrencyService() => _instance;
  CurrencyService._internal();

  final SharedPreferencesService _prefsService = SharedPreferencesService();

  // Map des codes pays vers les informations de devise
  static final Map<String, CurrencyInfo> _countryCurrencyMap = {
    '+20': CurrencyInfo(
      code: 'EGP',
      symbol: 'جنية',
      name: 'جنيه مصري',
      perDayLabel: 'جنية/يوم',
    ),
    '+222': CurrencyInfo(
      code: 'MRU',
      symbol: 'أوقية',
      name: 'أوقية موريتانية',
      perDayLabel: 'أوقية/يوم',
    ),
    '+966': CurrencyInfo(
      code: 'SAR',
      symbol: 'ريال',
      name: 'ريال سعودي',
      perDayLabel: 'ريال/يوم',
    ),
    '+212': CurrencyInfo(
      code: 'MAD',
      symbol: 'درهم',
      name: 'درهم مغربي',
      perDayLabel: 'درهم/يوم',
    ),
    '+971': CurrencyInfo(
      code: 'AED',
      symbol: 'درهم',
      name: 'درهم إماراتي',
      perDayLabel: 'درهم/يوم',
    ),
    '+965': CurrencyInfo(
      code: 'KWD',
      symbol: 'دينار',
      name: 'دينار كويتي',
      perDayLabel: 'دينار/يوم',
    ),
    '+974': CurrencyInfo(
      code: 'QAR',
      symbol: 'ريال',
      name: 'ريال قطري',
      perDayLabel: 'ريال/يوم',
    ),
    '+973': CurrencyInfo(
      code: 'BHD',
      symbol: 'دينار',
      name: 'دينار بحريني',
      perDayLabel: 'دينار/يوم',
    ),
    '+968': CurrencyInfo(
      code: 'OMR',
      symbol: 'ريال',
      name: 'ريال عماني',
      perDayLabel: 'ريال/يوم',
    ),
    '+962': CurrencyInfo(
      code: 'JOD',
      symbol: 'دينار',
      name: 'دينار أردني',
      perDayLabel: 'دينار/يوم',
    ),
    '+961': CurrencyInfo(
      code: 'LBP',
      symbol: 'ليرة',
      name: 'ليرة لبنانية',
      perDayLabel: 'ليرة/يوم',
    ),
    '+963': CurrencyInfo(
      code: 'SYP',
      symbol: 'ليرة',
      name: 'ليرة سورية',
      perDayLabel: 'ليرة/يوم',
    ),
    '+964': CurrencyInfo(
      code: 'IQD',
      symbol: 'دينار',
      name: 'دينار عراقي',
      perDayLabel: 'دينار/يوم',
    ),
    '+98': CurrencyInfo(
      code: 'IRR',
      symbol: 'ريال',
      name: 'ريال إيراني',
      perDayLabel: 'ريال/يوم',
    ),
    '+90': CurrencyInfo(
      code: 'TRY',
      symbol: 'ليرة',
      name: 'ليرة تركية',
      perDayLabel: 'ليرة/يوم',
    ),
  };

  // Map des codes pays vers les informations de devise en anglais
  static final Map<String, CurrencyInfo> _countryCurrencyMapEn = {
    '+20': CurrencyInfo(
      code: 'EGP',
      symbol: 'EGP',
      name: 'Egyptian Pound',
      perDayLabel: 'EGP/day',
    ),
    '+222': CurrencyInfo(
      code: 'MRU',
      symbol: 'MRU',
      name: 'Mauritanian Ouguiya',
      perDayLabel: 'MRU/day',
    ),
    '+966': CurrencyInfo(
      code: 'SAR',
      symbol: 'SAR',
      name: 'Saudi Riyal',
      perDayLabel: 'SAR/day',
    ),
    '+212': CurrencyInfo(
      code: 'MAD',
      symbol: 'MAD',
      name: 'Moroccan Dirham',
      perDayLabel: 'MAD/day',
    ),
    '+971': CurrencyInfo(
      code: 'AED',
      symbol: 'AED',
      name: 'UAE Dirham',
      perDayLabel: 'AED/day',
    ),
    '+965': CurrencyInfo(
      code: 'KWD',
      symbol: 'KWD',
      name: 'Kuwaiti Dinar',
      perDayLabel: 'KWD/day',
    ),
    '+974': CurrencyInfo(
      code: 'QAR',
      symbol: 'QAR',
      name: 'Qatari Riyal',
      perDayLabel: 'QAR/day',
    ),
    '+973': CurrencyInfo(
      code: 'BHD',
      symbol: 'BHD',
      name: 'Bahraini Dinar',
      perDayLabel: 'BHD/day',
    ),
    '+968': CurrencyInfo(
      code: 'OMR',
      symbol: 'OMR',
      name: 'Omani Rial',
      perDayLabel: 'OMR/day',
    ),
    '+962': CurrencyInfo(
      code: 'JOD',
      symbol: 'JOD',
      name: 'Jordanian Dinar',
      perDayLabel: 'JOD/day',
    ),
    '+961': CurrencyInfo(
      code: 'LBP',
      symbol: 'LBP',
      name: 'Lebanese Pound',
      perDayLabel: 'LBP/day',
    ),
    '+963': CurrencyInfo(
      code: 'SYP',
      symbol: 'SYP',
      name: 'Syrian Pound',
      perDayLabel: 'SYP/day',
    ),
    '+964': CurrencyInfo(
      code: 'IQD',
      symbol: 'IQD',
      name: 'Iraqi Dinar',
      perDayLabel: 'IQD/day',
    ),
    '+98': CurrencyInfo(
      code: 'IRR',
      symbol: 'IRR',
      name: 'Iranian Rial',
      perDayLabel: 'IRR/day',
    ),
    '+90': CurrencyInfo(
      code: 'TRY',
      symbol: 'TRY',
      name: 'Turkish Lira',
      perDayLabel: 'TRY/day',
    ),
  };

  // Map des codes pays vers les informations de devise en français
  static final Map<String, CurrencyInfo> _countryCurrencyMapFr = {
    '+20': CurrencyInfo(
      code: 'EGP',
      symbol: 'EGP',
      name: 'Livre égyptienne',
      perDayLabel: 'EGP/jour',
    ),
    '+222': CurrencyInfo(
      code: 'MRU',
      symbol: 'MRU',
      name: 'Ouguiya mauritanienne',
      perDayLabel: 'MRU/jour',
    ),
    '+966': CurrencyInfo(
      code: 'SAR',
      symbol: 'SAR',
      name: 'Riyal saoudien',
      perDayLabel: 'SAR/jour',
    ),
    '+212': CurrencyInfo(
      code: 'MAD',
      symbol: 'MAD',
      name: 'Dirham marocain',
      perDayLabel: 'MAD/jour',
    ),
    '+971': CurrencyInfo(
      code: 'AED',
      symbol: 'AED',
      name: 'Dirham émirati',
      perDayLabel: 'AED/jour',
    ),
    '+965': CurrencyInfo(
      code: 'KWD',
      symbol: 'KWD',
      name: 'Dinar koweïtien',
      perDayLabel: 'KWD/jour',
    ),
    '+974': CurrencyInfo(
      code: 'QAR',
      symbol: 'QAR',
      name: 'Riyal qatari',
      perDayLabel: 'QAR/jour',
    ),
    '+973': CurrencyInfo(
      code: 'BHD',
      symbol: 'BHD',
      name: 'Dinar bahreïni',
      perDayLabel: 'BHD/jour',
    ),
    '+968': CurrencyInfo(
      code: 'OMR',
      symbol: 'OMR',
      name: 'Rial omanais',
      perDayLabel: 'OMR/jour',
    ),
    '+962': CurrencyInfo(
      code: 'JOD',
      symbol: 'JOD',
      name: 'Dinar jordanien',
      perDayLabel: 'JOD/jour',
    ),
    '+961': CurrencyInfo(
      code: 'LBP',
      symbol: 'LBP',
      name: 'Livre libanaise',
      perDayLabel: 'LBP/jour',
    ),
    '+963': CurrencyInfo(
      code: 'SYP',
      symbol: 'SYP',
      name: 'Livre syrienne',
      perDayLabel: 'SYP/jour',
    ),
    '+964': CurrencyInfo(
      code: 'IQD',
      symbol: 'IQD',
      name: 'Dinar irakien',
      perDayLabel: 'IQD/jour',
    ),
    '+98': CurrencyInfo(
      code: 'IRR',
      symbol: 'IRR',
      name: 'Rial iranien',
      perDayLabel: 'IRR/jour',
    ),
    '+90': CurrencyInfo(
      code: 'TRY',
      symbol: 'TRY',
      name: 'Livre turque',
      perDayLabel: 'TRY/jour',
    ),
  };

  CurrencyInfo getPreferredCurrency() {
    final String? countryCode = _prefsService.getValue(LocalKeys.countryCodeNumber);
    return _countryCurrencyMap[countryCode] ?? _countryCurrencyMap['+20']!; // Default to EGP
  }

  CurrencyInfo getPreferredCurrencyEn() {
    final String? countryCode = _prefsService.getValue(LocalKeys.countryCodeNumber);
    return _countryCurrencyMapEn[countryCode] ?? _countryCurrencyMapEn['+20']!; // Default to EGP
  }

  CurrencyInfo getPreferredCurrencyFr() {
    final String? countryCode = _prefsService.getValue(LocalKeys.countryCodeNumber);
    return _countryCurrencyMapFr[countryCode] ?? _countryCurrencyMapFr['+20']!; // Default to EGP
  }

  String getCurrentCurrencySymbol() {
    return getPreferredCurrency().symbol;
  }

  String getCurrentCurrencyPerDayLabel() {
    return getPreferredCurrency().perDayLabel;
  }

  String formatAmountForUser(double amount) {
    final currency = getPreferredCurrency();
    return '${amount.toStringAsFixed(2)} ${currency.symbol}';
  }

  // Méthode pour obtenir la devise selon la langue
  CurrencyInfo getCurrencyForLanguage(String languageCode) {
    switch (languageCode) {
      case 'ar':
        return getPreferredCurrency();
      case 'en':
        return getPreferredCurrencyEn();
      case 'fr':
        return getPreferredCurrencyFr();
      default:
        return getPreferredCurrency();
    }
  }

  // Méthode pour obtenir le symbole de devise selon la langue
  String getCurrencySymbolForLanguage(String languageCode) {
    return getCurrencyForLanguage(languageCode).symbol;
  }

  // Méthode pour obtenir le label "par jour" selon la langue
  String getCurrencyPerDayForLanguage(String languageCode) {
    return getCurrencyForLanguage(languageCode).perDayLabel;
  }

  // Méthode pour formater un montant selon la langue
  String formatAmountForLanguage(double amount, String languageCode) {
    final currency = getCurrencyForLanguage(languageCode);
    return '${amount.toStringAsFixed(2)} ${currency.symbol}';
  }

  // Méthode pour obtenir toutes les devises supportées
  List<String> getSupportedCountryCodes() {
    return _countryCurrencyMap.keys.toList();
  }

  // Méthode pour obtenir le nom du pays à partir du code
  String getCountryName(String countryCode) {
    final countryNames = {
      '+20': 'مصر',
      '+222': 'موريتانيا',
      '+966': 'السعودية',
      '+212': 'المغرب',
      '+971': 'الإمارات',
      '+965': 'الكويت',
      '+974': 'قطر',
      '+973': 'البحرين',
      '+968': 'عمان',
      '+962': 'الأردن',
      '+961': 'لبنان',
      '+963': 'سوريا',
      '+964': 'العراق',
      '+98': 'إيران',
      '+90': 'تركيا',
    };
    return countryNames[countryCode] ?? 'غير محدد';
  }

  // Méthode pour définir le pays de l'utilisateur
  Future<void> setUserCountry(String countryCode) async {
    await _prefsService.storeValue(LocalKeys.countryCodeNumber, countryCode);
  }

  // Méthode pour obtenir le pays actuel de l'utilisateur
  String? getCurrentUserCountry() {
    return _prefsService.getValue(LocalKeys.countryCodeNumber);
  }
}
