  import 'package:shared_preferences/shared_preferences.dart';

  class SharedPreferencesService {
    static const String _keyUserName = 'full_name';
    static const String _keyUserPhoneNumber = 'phoneNumber';
    static const String _keyAccessToken = 'access_token';
    static const String _keyRefreshToken = 'refresh_token';
    static const String _keyLanguage = 'language';
    static const String _keyFirstLaunch = 'first_launch';
    static const String _keyTheme = 'theme'; // Added for theme preservation

    // Singleton instance
    static final SharedPreferencesService _instance = SharedPreferencesService._internal();
    factory SharedPreferencesService() => _instance;
    SharedPreferencesService._internal();

    // SharedPreferences instance
    late SharedPreferences _prefs;

    // Initialize SharedPreferences
    Future<void> init() async {
      _prefs = await SharedPreferences.getInstance();
    }

    // User Name
    String get userName => _prefs.getString(_keyUserName) ?? '';
    Future<void> setUserName(String value) async => await _prefs.setString(_keyUserName, value);

    // User Phone
    String get userPhone => _prefs.getString(_keyUserPhoneNumber) ?? '';
    Future<void> setUserPhone(String value) async => await _prefs.setString(_keyUserPhoneNumber, value);

    // Access Token
    String get accessToken => _prefs.getString(_keyAccessToken) ?? '';
    Future<void> setAccessToken(String value) async => await _prefs.setString(_keyAccessToken, value);

    // Refresh Token
    String get refreshToken => _prefs.getString(_keyRefreshToken) ?? '';
    Future<void> setRefreshToken(String value) async => await _prefs.setString(_keyRefreshToken, value);

    // User ID
    int? get userId {
      final value = _prefs.get('user_id');
      if (value is int) {
        return value;
      } else if (value is String) {
        return int.tryParse(value);
      }
      return null;
    }

    // Language
    String get language => _prefs.getString(_keyLanguage) ?? '';
    Future<void> setLanguage(String value) async => await _prefs.setString(_keyLanguage, value);

    // First Launch
    Future<bool> isFirstLaunch() async {
      bool isFirstLaunch = _prefs.getBool(_keyFirstLaunch) ?? true;
      if (isFirstLaunch) {
        await _prefs.setBool(_keyFirstLaunch, false);
      }
      return isFirstLaunch;
    }

    Future<void> setFirstLaunch(bool value) async => await _prefs.setBool(_keyFirstLaunch, value);

    // Theme (assuming it's a string, e.g., 'light' or 'dark')
    String get theme => _prefs.getString(_keyTheme) ?? 'light'; // Default to 'light'
    Future<void> setTheme(String value) async => await _prefs.setString(_keyTheme, value);

    // Generic store value
    Future<void> storeValue(String key, dynamic value) async {
      if (value is String) {
        await _prefs.setString(key, value);
      } else if (value is int) {
        await _prefs.setInt(key, value);
      } else if (value is double) {
        await _prefs.setDouble(key, value);
      } else if (value is bool) {
        await _prefs.setBool(key, value);
      } else if (value is List<String>) {
        await _prefs.setStringList(key, value);
      } else {
        throw ArgumentError('Unsupported value type: ${value.runtimeType}');
      }
    }

    // Generic get value
    dynamic getValue(String key, {dynamic defaultValue}) {
      if (_prefs.containsKey(key)) {
        return _prefs.get(key);
      }
      return defaultValue;
    }

    bool hasKey(String key) => _prefs.containsKey(key);

    // Clear all data
    Future<void> clearAllData() async => await _prefs.clear();

    // New function to clear cached data while preserving language, first_launch, and theme
    Future<void> clearCachedData() async {
      // Store the values to preserve
      final String preservedLanguage = language;
      final bool preservedFirstLaunch = _prefs.getBool(_keyFirstLaunch) ?? true;
      final String preservedTheme = theme;

      // Clear all data
      await _prefs.clear();

      // Restore the preserved values
      await setLanguage(preservedLanguage);
      await setFirstLaunch(preservedFirstLaunch);
      await setTheme(preservedTheme);
    }
  }