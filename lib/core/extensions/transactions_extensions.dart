import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/constants/app_assets.dart';

import '../translation/locale_keys.dart';
import '../utils/enums.dart';

extension TransactionTypeExtension on TransactionType {
  String get toName {
    switch (this) {
      case TransactionType.payment:
        return LocaleKeys.payment.tr();
      case TransactionType.refund:
        return LocaleKeys.refund.tr();
      case TransactionType.withdrawal:
        return LocaleKeys.withdrawal.tr();
      case TransactionType.walletRecharge:
        return LocaleKeys.walletRecharge.tr();
    }
  }

  String toJson() {
    switch (this) {
      case TransactionType.payment:
        return 'payment';
      case TransactionType.refund:
        return 'refund';
      case TransactionType.withdrawal:
        return 'withdrawal';
      case TransactionType.walletRecharge:
        return 'wallet_recharge';
    }
  }

  static TransactionType fromJson(String json) {
    switch (json) {
      case 'payment':
        return TransactionType.payment;
      case 'refund':
        return TransactionType.refund;
      case 'withdrawal':
        return TransactionType.withdrawal;
      case 'wallet_recharge':
        return TransactionType.walletRecharge;
      default:
        return TransactionType.payment;
    }
  }

  String get toIcon {
    switch (this) {
      case TransactionType.payment:
        return AppAssets.sendIcon;
      case TransactionType.refund:
        return AppAssets.refundMoneyIcon;
      case TransactionType.withdrawal:
        return AppAssets.withdrawIcon;
      case TransactionType.walletRecharge:
        return AppAssets.chargeWallerIcon;
    }
  }
}



extension TransactionPurposeExtension on TransactionPurpose {
  String get toName {
    switch (this) {
      case TransactionPurpose.propertyDeal:
        return LocaleKeys.propertyDeal.tr();
      case TransactionPurpose.viewingRequest:
        return LocaleKeys.viewingRequest.tr();
    }
  }

  String toJson() {
    switch (this) {
      case TransactionPurpose.propertyDeal:
        return 'property_deal';
      case TransactionPurpose.viewingRequest:
        return 'viewing_request';
    }
  }

  static TransactionPurpose fromJson(String json) {
    switch (json) {
      case 'property_deal':
        return TransactionPurpose.propertyDeal;
      case 'viewing_request':
        return TransactionPurpose.viewingRequest;
      default:
        return TransactionPurpose.propertyDeal;
    }
  }
}

