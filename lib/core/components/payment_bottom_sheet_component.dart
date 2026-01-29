import 'package:flutter/material.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/button_app_component.dart';
import 'package:enmaa/core/components/custom_bottom_sheet.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../translation/locale_keys.dart';

class PaymentBottomSheet {
  static void show({
    required BuildContext context,
    required double amountToPay,
    required double userBalance,
    required VoidCallback confirmPayment,
    required VoidCallback changePaymentMethod,
  }) {
    final bool hasSufficientBalance = amountToPay <= userBalance;

    showModalBottomSheet(
      context: context,
      backgroundColor: ColorManager.greyShade,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      builder: (_) {
        return CustomBottomSheet(
          widget: PaymentBottomSheetContent(
            amountToPay: amountToPay,
            hasSufficientBalance: hasSufficientBalance,
            confirmPayment: confirmPayment,
            changePaymentMethod: changePaymentMethod,
          ),
          padding: EdgeInsets.only(
            left: context.scale(16),
            right: context.scale(16),
            bottom: context.scale(16),
          ),
          headerText: '',
        );
      },
    );
  }
}

class PaymentBottomSheetContent extends StatelessWidget {
  final double amountToPay;
  final bool hasSufficientBalance;
  final VoidCallback confirmPayment;
  final VoidCallback changePaymentMethod;

  const PaymentBottomSheetContent({
    super.key,
    required this.amountToPay,
    required this.hasSufficientBalance,
    required this.confirmPayment,
    required this.changePaymentMethod,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SvgImageComponent(
          width: 80,
          height: 80,
          color: ColorManager.yellowColor,
          iconPath: hasSufficientBalance
              ? AppAssets.sufficientBalanceIcon
              : AppAssets.inSufficientBalanceIcon,
        ),
        SizedBox(
          height: context.scale(20),
        ),
        Text(
          hasSufficientBalance
              ? LocaleKeys.completePaymentWithWallet.tr()
              : LocaleKeys.insufficientWalletBalance.tr(),
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s18,
          ),
        ),
        SizedBox(
          height: context.scale(8),
        ),
        hasSufficientBalance
            ? RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            children: [
              TextSpan(
                text: LocaleKeys.willBeDeducted.tr(),
                style: getSemiBoldStyle(
                  color: ColorManager.grey2,
                  fontSize: FontSize.s14,
                ),
              ),
              TextSpan(
                text: '${amountToPay.toStringAsFixed(2)}',
                style: getSemiBoldStyle(
                  color: ColorManager.yellowColor,
                  fontSize: FontSize.s14,
                ),
              ),
              TextSpan(
                text: LocaleKeys.currencyEGP.tr(),
                style: getSemiBoldStyle(
                  color: ColorManager.yellowColor,
                  fontSize: FontSize.s14,
                ),
              ),
              TextSpan(
                text: LocaleKeys.fromYourWallet.tr(),
                style: getSemiBoldStyle(
                  color: ColorManager.grey2,
                  fontSize: FontSize.s14,
                ),
              ),
            ],
          ),
        )
            : Text(
          LocaleKeys.chooseAnotherPaymentMethod.tr(),
          textAlign: TextAlign.center,
          style: getSemiBoldStyle(
            color: ColorManager.grey2,
            fontSize: FontSize.s14,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ButtonAppComponent(
                width: 171,
                height: 46,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: ColorManager.grey3,
                  borderRadius: BorderRadius.circular(context.scale(24)),
                ),
                buttonContent: Center(
                  child: Text(
                    LocaleKeys.cancel.tr(),
                    style: getMediumStyle(
                      color: ColorManager.blackColor,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              ButtonAppComponent(
                width: 171,
                height: 46,
                padding: EdgeInsets.zero,
                decoration: BoxDecoration(
                  color: ColorManager.primaryColor,
                  borderRadius: BorderRadius.circular(context.scale(24)),
                ),
                buttonContent: Center(
                  child: Text(
                    hasSufficientBalance
                        ? LocaleKeys.confirm.tr()
                        : LocaleKeys.payWithPayPal.tr(),
                    style: getBoldStyle(
                      color: ColorManager.whiteColor,
                      fontSize: FontSize.s14,
                    ),
                  ),
                ),
                onTap: () {
                  if (hasSufficientBalance) {
                    confirmPayment();
                  } else {
                    changePaymentMethod();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}