import 'package:easy_localization/easy_localization.dart';

import '../../translation/locale_keys.dart';
import '../../utils/enums.dart';

extension BuildingTypeExtension on BuildingType {
  /// Get the Arabic translation of the building type.
  String get toArabic {
    switch (this) {
      case BuildingType.residential:
        return LocaleKeys.residential.tr();
      case BuildingType.commercial:
        return LocaleKeys.commercial.tr();
      case BuildingType.mixedUse:
        return LocaleKeys.mixedUse.tr();
    }
  }

  /// Get the English translation of the building type.
  String get toEnglish {
    switch (this) {
      case BuildingType.residential:
        return LocaleKeys.residential.tr();
      case BuildingType.commercial:
        return LocaleKeys.commercial.tr();
      case BuildingType.mixedUse:
        return LocaleKeys.mixedUse.tr();
    }
  }

  String get toName {
    switch (this) {
      case BuildingType.residential:
        return LocaleKeys.residential.tr();
      case BuildingType.commercial:
        return LocaleKeys.commercial.tr();
      case BuildingType.mixedUse:
        return LocaleKeys.mixedUse.tr();
    }
  }

  /// Check if the building type is residential.
  bool get isResidential => this == BuildingType.residential;

  /// Check if the building type is commercial.
  bool get isCommercial => this == BuildingType.commercial;

  /// Check if the building type is mixed-use.
  bool get isMixedUse => this == BuildingType.mixedUse;

  /// Convert the building type to an ID to be used in the backend.
  int get toId {
    switch (this) {
      case BuildingType.residential:
        return 28;
      case BuildingType.commercial:
        return 31;
      case BuildingType.mixedUse:
        return 27;
    }
  }

  /// Convert an ID from the backend to the corresponding building type.
  static BuildingType fromId(int id) {
    switch (id) {
      case 12:
        return BuildingType.residential;
      case 10:
        return BuildingType.commercial;
      case 11:
        return BuildingType.mixedUse;
      default:
        throw ArgumentError('Invalid BuildingType ID: $id');
    }
  }
}
