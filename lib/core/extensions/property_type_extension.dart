import 'package:easy_localization/easy_localization.dart';

import '../translation/locale_keys.dart';
import '../utils/enums.dart';

extension PropertyTypeExtension on PropertyType {
  // Get Property Type in English
  String get toEnglish {
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
  String get toName {
    switch (this) {
      case PropertyType.apartment:
        return LocaleKeys.apartment.tr();
      case PropertyType.villa:
        return LocaleKeys.villa.tr();
      case PropertyType.building:
        return LocaleKeys.building.tr();
      case PropertyType.land:
       return  LocaleKeys.land.tr();
    }
  }

  // Get Property Type in Arabic
  String get toArabic {
    switch (this) {
      case PropertyType.apartment:
        return 'شقة';
      case PropertyType.villa:
        return 'فيلا';
      case PropertyType.building:
        return 'عمارة';
      case PropertyType.land:
        return 'أرض';
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
        return 1;
      case PropertyType.villa:
        return 3;
      case PropertyType.building:
        return 2;
      case PropertyType.land:
        return 4;
    }
  }
}
