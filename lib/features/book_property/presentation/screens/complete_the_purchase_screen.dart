import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as material;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/managers/value_manager.dart';
import '../../../../core/components/reusable_type_selector_component.dart';
import '../../../../core/components/svg_image_component.dart';
import '../../../../core/components/warning_message_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../../core/components/generic_form_fields.dart';
import '../../../add_new_real_estate/presentation/components/numbered_text_header_component.dart';
import '../../../home_module/home_imports.dart';
import '../controller/book_property_cubit.dart';

class CompleteThePurchaseScreen extends StatelessWidget {
  const CompleteThePurchaseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BookPropertyCubit, BookPropertyState>(
      builder: (context, state) {
        return Directionality(
          textDirection: context.locale.languageCode == 'ar' ? material.TextDirection.rtl : material.TextDirection.ltr,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(AppPadding.p16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                NumberedTextHeaderComponent(
                  number: '٣',
                  text: LocaleKeys.completingPayment.tr(),
                ),
                SizedBox(height: context.scale(20)),
                _buildSectionTitle(LocaleKeys.paymentDetails.tr()),
                SizedBox(height: context.scale(20)),
                PaymentDetailRow(
                  label: LocaleKeys.amountToBePaid.tr(),
                  value: '${state.propertySaleDetailsEntity!.bookingDeposit} ${LocaleKeys.egp.tr()}',
                ),
                SizedBox(height: context.scale(20)),
                _buildSectionTitle(LocaleKeys.reviewData.tr()),
                SizedBox(height: context.scale(20)),
                ReviewDataCard(
                  details: [
                    {
                      'label': LocaleKeys.fullName.tr(),
                      'value': state.userName,
                      'icon': AppAssets.birthDayIcon,
                    },
                    {
                      'label': LocaleKeys.phoneNumber.tr(),
                      'value': state.phoneNumber,
                      'icon': AppAssets.phoneIcon,
                    },
                    {
                      'label': LocaleKeys.idNumber.tr(),
                      'value': state.userID,
                      'icon': AppAssets.cardIdentityIcon,
                    },
                    {
                      'label': LocaleKeys.dateOfBirth.tr(),
                      'value': state.birthDate != null
                          ? '${state.birthDate!.day}-${state.birthDate!.month}-${state.birthDate!.year}'
                          : LocaleKeys.notSpecified.tr(),
                      'icon': AppAssets.birthDayIcon,
                    },
                    {
                      'label': LocaleKeys.expirationDate.tr(),
                      'value': state.idExpirationDate != null
                          ? '${state.idExpirationDate!.day}-${state.idExpirationDate!.month}-${state.idExpirationDate!.year}'
                          : LocaleKeys.notSpecified.tr(),
                      'icon': AppAssets.endTimeIcon,
                    },
                  ],
                ),
                SizedBox(height: context.scale(20)),
                Text(
                  LocaleKeys.paymentMethods.tr(),
                  style: getBoldStyle(color: ColorManager.blackColor, fontSize: FontSize.s16),
                ),
                SizedBox(height: context.scale(12)),
                TypeSelectorComponent<String>(
                  selectorWidth: 171,
                  values: [LocaleKeys.paypal.tr(), LocaleKeys.wallet.tr(), LocaleKeys.bankily.tr()],
                  currentType: state.currentPaymentMethod,
                  onTap: (type) {
                    print('DEBUG: Payment method selected: $type');
                    context.read<BookPropertyCubit>().changePaymentMethod(type);
                  },
                  getIcon: (type) {
                    print('DEBUG: Getting icon for payment method: $type');
                    if (type == LocaleKeys.paypal.tr()) {
                      return AppAssets.paypalIcon;
                    } else if (type == LocaleKeys.wallet.tr()) {
                      return AppAssets.walletIcon;
                    } else if (type == LocaleKeys.bankily.tr()) {
                      return AppAssets.walletIcon;
                    }
                    return AppAssets.paypalIcon;
                  },
                  getLabel: (type) => type,
                ),
                if (state.currentPaymentMethod == LocaleKeys.bankily.tr()) ...[
                  SizedBox(height: context.scale(12)),
                  GenericFormField(
                    label: LocaleKeys.passCode.tr(),
                    hintText: LocaleKeys.passCode.tr(),
                    keyboardType: TextInputType.number,
                    iconPath: AppAssets.lockIcon,
                    controller: context.read<BookPropertyCubit>().bankilyPassCodeController,
                    onChanged: (value) {
                      // Mettre à jour le state en temps réel quand l'utilisateur tape
                      context.read<BookPropertyCubit>().setBankilyPassCode(value.trim());
                    },
                    validator: (value){
                      if ((value ?? '').trim().isEmpty) {
                        return LocaleKeys.thisFieldIsRequired.tr();
                      }
                      return null;
                    },
                  ),
                ],
                SizedBox(height: context.scale(20)),
                WarningMessageComponent(
                  text: LocaleKeys.paymentVerificationWarning.tr(),
                ),
                SizedBox(height: context.scale(20)),
                WarningMessageComponent(
                  text: LocaleKeys.securePaymentMessage.tr(),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: getBoldStyle(
        color: ColorManager.blackColor,
        fontSize: FontSize.s16,
      ),
    );
  }
}

class PaymentDetailRow extends StatelessWidget {
  final String label;
  final String value;

  const PaymentDetailRow({
    required this.label,
    required this.value,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.scale(54),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(AppPadding.p16),
      child: Row(
        children: [
          SvgImageComponent(iconPath: AppAssets.apartmentIcon),
          SizedBox(width: context.scale(8)),
          Flexible(
            child: Text(
              label,
              style: getSemiBoldStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s14,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: getBoldStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s16,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}

class ReviewDataCard extends StatelessWidget {
  final List<Map<String, String>> details;

  const ReviewDataCard({
    required this.details,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: context.scale(194),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: EdgeInsets.all(AppPadding.p16),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: details
            .map((detail) => DetailRow(
          label: detail['label']!,
          value: detail['value']!,
          iconPath: detail['icon']!,
        ))
            .toList(),
      ),
    );
  }
}

class DetailRow extends StatelessWidget {
  final String label;
  final String value;
  final String iconPath;

  const DetailRow({
    required this.label,
    required this.value,
    required this.iconPath,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        SvgImageComponent(iconPath: iconPath, width: 20, height: 20),
        SizedBox(width: context.scale(8)),
        Flexible(
          child: Text(
            label,
            style: getSemiBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s14,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        Flexible(
          child: Text(
            value,
            style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s16,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}