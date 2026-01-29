import 'package:enmaa/core/utils/enums.dart';

extension PaymentMethodsExtension on PaymentMethod {
  /// Get the Arabic translation of the payment method
  String get toArabic {
    switch (this) {
      case PaymentMethod.cash:
        return 'نقدي';
      case PaymentMethod.wallet:
        return 'محفظة';
    }
  }

  /// Get the English translation of the payment method
  String get toEnglish {
    switch (this) {
      case PaymentMethod.cash:
        return 'Cash';
      case PaymentMethod.wallet:
        return 'Wallet';
    }
  }

  bool get isCash => this == PaymentMethod.cash;
  bool get isWallet => this == PaymentMethod.wallet;
}
