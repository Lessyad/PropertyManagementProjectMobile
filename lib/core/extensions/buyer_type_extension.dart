
import 'package:easy_localization/easy_localization.dart';

import '../translation/locale_keys.dart';
import '../utils/enums.dart';

extension BuyerTypeExtension on BuyerType {
  bool get amIABuyer => this == BuyerType.iAmBuyer;

  String get toName {
    switch (this) {
      case BuyerType.iAmBuyer:
        return LocaleKeys.iAmBuyer.tr();
      case BuyerType.anotherBuyer:
        return LocaleKeys.anotherBuyer.tr();
    }
  }

  String toJson() {
    switch (this) {
      case BuyerType.iAmBuyer:
        return 'iAmBuyer';
      case BuyerType.anotherBuyer:
        return 'anotherBuyer';
    }
  }

  BuyerType fromJson(String json) {
    switch (json) {
      case 'iAmBuyer':
        return BuyerType.iAmBuyer;
      case 'anotherBuyer':
        return BuyerType.anotherBuyer;
      default:
        return BuyerType.iAmBuyer;
    }
  }
}
