import 'package:easy_localization/easy_localization.dart';

import '../../translation/locale_keys.dart';
import '../../utils/enums.dart';

extension VillaTypeExtension on VillaType {
  /// Get the Arabic translation of the villa type.
  String get toArabic {
    switch (this) {
      case VillaType.standalone:
        return LocaleKeys.standalone.tr();
      case VillaType.twinHouse:
        return LocaleKeys.twinHouse.tr();
      case VillaType.townHouse:
        return LocaleKeys.townHouse.tr();
    }
  }

  /// Get the English translation of the villa type.
  String get toEnglish {
    switch (this) {
      case VillaType.standalone:
        return LocaleKeys.standalone.tr();
      case VillaType.twinHouse:
        return 'Twin House';
      case VillaType.townHouse:
        return 'Town House';
    }
  }


  String get toName {
    switch (this) {
      case VillaType.standalone:
        return LocaleKeys.standalone.tr();
      case VillaType.twinHouse:
        return LocaleKeys.twinHouse.tr();
      case VillaType.townHouse:
        return LocaleKeys.townHouse.tr();
    }
  }

  /// Check if the villa type is standalone.
  bool get isStandalone => this == VillaType.standalone;

  /// Check if the villa type is twin house.
  bool get isTwinHouse => this == VillaType.twinHouse;

  /// Check if the villa type is town house.
  bool get isTownHouse => this == VillaType.townHouse;

  /// Convert the villa type to an ID to be used in the backend.
  int get toId {
    switch (this) {
      case VillaType.standalone:
        return 26;
      case VillaType.twinHouse:
        return 19;
      case VillaType.townHouse:
        return 24;
    }
  }

  /// Convert an ID from the backend to the corresponding villa type.
  static VillaType fromId(int id) {
    switch (id) {
      case 1:
        return VillaType.standalone;
      case 2:
        return VillaType.twinHouse;
      case 3:
        return VillaType.townHouse;
      default:
        throw ArgumentError('Invalid VillaType ID: $id');
    }
  }
}
