import 'package:easy_localization/easy_localization.dart';

import '../../translation/locale_keys.dart';
import '../../utils/enums.dart';

extension ApartmentTypeExtension on ApartmentType {
  /// Localized name of the apartment type (use this for UI labels).
  String get toName {
    switch (this) {
      case ApartmentType.studio:
        return LocaleKeys.studio.tr();
      case ApartmentType.duplex:
        return LocaleKeys.duplex.tr();
      case ApartmentType.penthouse:
        return LocaleKeys.penthouse.tr();
    }
  }

  /// Backwards-compatible getters: delegate to localized name.
  String get toArabic => toName;
  String get toEnglish => toName;

  /// Check if the apartment type is a studio.
  bool get isStudio => this == ApartmentType.studio;

  /// Check if the apartment type is a duplex.
  bool get isDuplex => this == ApartmentType.duplex;

  /// Check if the apartment type is a penthouse.
  bool get isPenthouse => this == ApartmentType.penthouse;

  /// Convert the apartment type to an ID to be used in the backend.
  /// Must match PropertySubTypes table: 14=studio, 1=duplex, 18=penthouse (benth house).
  int get toId {
    switch (this) {
      case ApartmentType.studio:
        return 14;
      case ApartmentType.duplex:
        return 1;
      case ApartmentType.penthouse:
        return 18;
    }
  }

  /// Convert an ID from the backend to the corresponding apartment type.
  static ApartmentType fromId(int id) {
    switch (id) {
      case 14:
        return ApartmentType.studio;
      case 1:
        return ApartmentType.duplex;
      case 18:
        return ApartmentType.penthouse;
      default:
        throw ArgumentError('Invalid ApartmentType ID: $id');
    }
  }
}
