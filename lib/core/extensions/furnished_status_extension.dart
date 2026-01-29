import '../utils/enums.dart';

extension FurnishedStatusExtension on FurnishingStatus {
  /// Get the Arabic translation of the furnished status
  String get toArabic {
    switch (this) {
      case FurnishingStatus.furnished:
        return 'مفروشة';
      case FurnishingStatus.notFurnished:
        return 'غير مفروشة';

    }
  }

  /// Get the English translation of the furnished status
  String get toEnglish {
    switch (this) {
      case FurnishingStatus.furnished:
        return 'Furnished';
      case FurnishingStatus.notFurnished:
        return 'Not Furnished';

    }
  }

  bool get isFurnished => this == FurnishingStatus.furnished;
  bool get isUnfurnished => this == FurnishingStatus.notFurnished;
}