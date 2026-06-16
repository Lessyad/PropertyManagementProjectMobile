import 'package:easy_localization/easy_localization.dart';

import '../translation/locale_keys.dart';
import '../utils/enums.dart';

extension FurnishedStatusExtension on FurnishingStatus {
  /// Furnished status label in current locale (use this for display).
  String get toName {
    switch (this) {
      case FurnishingStatus.furnished:
        return LocaleKeys.furnished.tr();
      case FurnishingStatus.notFurnished:
        return LocaleKeys.notFurnished.tr();
    }
  }

  /// Furnished status label in current locale (same as toName).
  String get toArabic => toName;

  /// Furnished status label in current locale (same as toName).
  String get toEnglish => toName;

  bool get isFurnished => this == FurnishingStatus.furnished;
  bool get isUnfurnished => this == FurnishingStatus.notFurnished;
}