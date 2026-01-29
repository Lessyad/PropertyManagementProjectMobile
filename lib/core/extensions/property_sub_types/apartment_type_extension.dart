import 'package:easy_localization/easy_localization.dart';

import '../../translation/locale_keys.dart';
import '../../utils/enums.dart';

extension ApartmentTypeExtension on ApartmentType {
  /// Get the Arabic translation of the apartment type.
  String get toArabic {
    switch (this) {
      case ApartmentType.studio:
        return 'ستوديو';
      case ApartmentType.duplex:
        return 'دوبلكس';
      case ApartmentType.penthouse:
        return 'بنتهاوس';
    }
  }

  /// Get the English translation of the apartment type.
  String get toEnglish {
    switch (this) {
      case ApartmentType.studio:
        return 'Studio';
      case ApartmentType.duplex:
        return 'Duplex';
      case ApartmentType.penthouse:
        return 'Penthouse';
    }
  }
  /// Get the localized name of the apartment type.
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

  /// Check if the apartment type is a studio.
  bool get isStudio => this == ApartmentType.studio;

  /// Check if the apartment type is a duplex.
  bool get isDuplex => this == ApartmentType.duplex;

  /// Check if the apartment type is a penthouse.
  bool get isPenthouse => this == ApartmentType.penthouse;

  /// Convert the apartment type to an ID to be used in the backend.
  int get toId {
    switch (this) {
      case ApartmentType.studio:
        return 3;
      case ApartmentType.duplex:
        return 1;
      case ApartmentType.penthouse:
        return 2;
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
