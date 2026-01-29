import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';

import '../utils/enums.dart';

extension LandLicenseStatusExtension on LandLicenseStatus {
  /// Get the Arabic translation of the land license status
  String get toArabic {
    switch (this) {
      case LandLicenseStatus.licensed:
        return 'جاهزة للبناء';
      case LandLicenseStatus.notLicensed:
        return 'تحتاج إلى تصريح';
    }
  }

  /// Get the English translation of the land license status
  String get toEnglish {
    switch (this) {
      case LandLicenseStatus.licensed:
        return 'Ready for construction';
      case LandLicenseStatus.notLicensed:
        return 'Requires permit';
    }
  }

  String toName() {
    switch (this) {
      case LandLicenseStatus.licensed:
        return LocaleKeys.licensed.tr();
      case LandLicenseStatus.notLicensed:
        return LocaleKeys.notLicensed.tr();
    }
  }

  bool get isLicensed => this == LandLicenseStatus.licensed;
}
