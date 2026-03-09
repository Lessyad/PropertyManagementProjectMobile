import 'package:easy_localization/easy_localization.dart';

import '../translation/locale_keys.dart';
import '../utils/enums.dart';

extension PropertyTypeExtension on PropertyType {
  /// Property type label in current locale (use this for display).
  String get toEnglish {
    return toName;
  }

  String get toName {
    switch (this) {
      case PropertyType.apartment:
        return LocaleKeys.apartment.tr();
      case PropertyType.villa:
        return LocaleKeys.villa.tr();
      case PropertyType.building:
        return LocaleKeys.building.tr();
      case PropertyType.land:
        return LocaleKeys.land.tr();
    }
  }

  /// Property type label in current locale (same as toName).
  String get toArabic {
    return toName;
  }

  /// API path segment (English, lowercase) for URLs, e.g. "apartment", "villa".
  String get toApiPathSegment {
    switch (this) {
      case PropertyType.apartment:
        return 'apartment';
      case PropertyType.villa:
        return 'villa';
      case PropertyType.building:
        return 'building';
      case PropertyType.land:
        return 'land';
    }
  }

  /// Value for API filter property_type_name (English, as expected by backend).
  String get toApiPropertyTypeName {
    switch (this) {
      case PropertyType.apartment:
        return 'Apartment';
      case PropertyType.villa:
        return 'Villa';
      case PropertyType.building:
        return 'Building';
      case PropertyType.land:
        return 'Land';
    }
  }

  bool get isApartment => this == PropertyType.apartment;
  bool get isVilla => this == PropertyType.villa;
  bool get isBuilding => this == PropertyType.building;
  bool get isLand => this == PropertyType.land;

  // Convert PropertyType to its corresponding ID for JSON
  int get toJsonId {
    switch (this) {
      case PropertyType.apartment:
        return 8;
      case PropertyType.villa:
        return 1;
      case PropertyType.building:
        return 4;
      case PropertyType.land:
        return 3;
    }
  }
}
