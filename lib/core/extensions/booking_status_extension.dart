import 'package:easy_localization/easy_localization.dart';
import '../translation/locale_keys.dart';
import '../utils/enums.dart';

extension BookingStatusExtension on BookingStatus {
  bool get isReserved => this == BookingStatus.reserved;
  bool get isAvailable => this == BookingStatus.available;

  String get getName {
    switch (this) {
      case BookingStatus.reserved:
        return LocaleKeys.reserved.tr();
      case BookingStatus.available:
        return LocaleKeys.available.tr();
    }
  }

  String toJson() {
    switch (this) {
      case BookingStatus.reserved:
        return 'pending';
      case BookingStatus.available:
        return 'available';
    }
  }
}
