import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/preview_property/presentation/controller/preview_property_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter/material.dart' as material; // For TextDirection
import 'package:easy_localization/easy_localization.dart';
import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/font_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../configuration/managers/value_manager.dart';
import '../../../../core/components/loading_overlay_component.dart';
import '../../../../core/components/reusable_type_selector_component.dart';
import '../../../../core/components/svg_image_component.dart';
import '../../../../core/components/warning_message_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../add_new_real_estate/presentation/components/numbered_text_header_component.dart';

class ConfirmPreviewPaymentScreen extends material.StatefulWidget {
  const ConfirmPreviewPaymentScreen({super.key, required this.propertyId});

  final String propertyId;

  @override
  material.State<ConfirmPreviewPaymentScreen> createState() => _ConfirmPreviewPaymentScreenState();
}

class _ConfirmPreviewPaymentScreenState extends material.State<ConfirmPreviewPaymentScreen> {
  @override
  void initState() {
    context.read<PreviewPropertyCubit>().getInspectionAmountToBePaid(widget.propertyId);
    super.initState();
  }

  @override
  material.Widget build(material.BuildContext context) {
    final screenWidth = material.MediaQuery.of(context).size.width;
    final screenHeight = material.MediaQuery.of(context).size.height;

    final horizontalPadding = screenWidth * 0.04; // ~16px sur 400px
    final verticalSpacing = screenHeight * 0.02; // ~16px sur 800px
    final containerHeight = screenHeight * 0.065; // ~52px
    final selectorWidth = screenWidth * 0.45; // 45% de l'écran

    return material.Directionality(
      textDirection: context.locale.languageCode == 'ar'
          ? material.TextDirection.rtl
          : material.TextDirection.ltr,
      child: BlocBuilder<PreviewPropertyCubit, PreviewPropertyState>(
        builder: (context, state) {
          return material.Stack(
            children: [
              material.Padding(
                padding: material.EdgeInsets.all(horizontalPadding),
                child: material.SingleChildScrollView(
                  child: material.Column(
                    crossAxisAlignment: material.CrossAxisAlignment.start,
                    children: [
                      NumberedTextHeaderComponent(
                        number: '2',
                        text: LocaleKeys.completePayment.tr(),
                      ),
                      material.SizedBox(height: verticalSpacing),

                      /// Titre
                      material.Text(
                        LocaleKeys.paymentDetails.tr(),
                        style: getBoldStyle(
                          color: ColorManager.blackColor,
                          fontSize: (screenWidth * 0.045).clamp(14, 20),
                        ),
                      ),
                      material.SizedBox(height: verticalSpacing * 0.75),

                      /// Montant à payer
                      material.Container(
                        width: double.infinity,
                        height: containerHeight,
                        decoration: material.BoxDecoration(
                          color: ColorManager.whiteColor,
                          borderRadius: material.BorderRadius.circular(12),
                        ),
                        padding: material.EdgeInsets.symmetric(
                          horizontal: horizontalPadding,
                          vertical: screenHeight * 0.01,
                        ),
                        child: material.Row(
                          children: [
                            SvgImageComponent(iconPath: AppAssets.apartmentIcon),
                            material.SizedBox(width: screenWidth * 0.02),
                            material.Expanded(
                              child: material.Text(
                                LocaleKeys.amountToBePaid.tr(),
                                style: getSemiBoldStyle(
                                  color: ColorManager.blackColor,
                                  fontSize: (screenWidth * 0.04).clamp(12, 18),
                                ),
                              ),
                            ),
                            material.Text(
                              '${state.inspectionAmount} ${LocaleKeys.currency.tr()}',
                              style: getBoldStyle(
                                color: ColorManager.blackColor,
                                fontSize: (screenWidth * 0.045).clamp(14, 20),
                              ),
                            ),
                          ],
                        ),
                      ),
                      material.SizedBox(height: verticalSpacing),

                      /// Sélecteur de méthode de paiement
                      TypeSelectorComponent<String>(
                        selectorWidth: selectorWidth,
                        values: [
                          LocaleKeys.paypal.tr(),
                          LocaleKeys.wallet.tr(),
                          LocaleKeys.bankily.tr(),
                        ],
                        currentType: state.currentPaymentMethod,
                        onTap: (type) {
                          context.read<PreviewPropertyCubit>().changePaymentMethod(type);
                        },
                        getIcon: (type) {
                          switch (type) {
                            case 'PayPal':
                            case 'بايبال':
                              return AppAssets.paypalIcon;
                            case 'المحفظة':
                            case 'Wallet':
                            case 'Portefeuille':
                              return AppAssets.walletIcon;
                            case 'Bankily':
                            case 'بانكيلي':
                              return AppAssets.walletIcon;
                            default:
                              return AppAssets.paypalIcon;
                          }
                        },
                        getLabel: (type) => type,
                      ),

                      /// Champ Bankily si sélectionné
                      if (state.currentPaymentMethod == LocaleKeys.bankily.tr()) ...[
                        material.SizedBox(height: verticalSpacing),
                        material.Container(
                          width: double.infinity,
                          height: containerHeight,
                          decoration: material.BoxDecoration(
                            color: ColorManager.whiteColor,
                            borderRadius: material.BorderRadius.circular(12),
                          ),
                          padding: material.EdgeInsets.symmetric(
                            horizontal: horizontalPadding,
                            vertical: screenHeight * 0.01,
                          ),
                          child: material.Row(
                            children: [
                              SvgImageComponent(iconPath: AppAssets.lockIcon),
                              material.SizedBox(width: screenWidth * 0.02),
                              material.Expanded(
                                child: material.TextField(
                                  onChanged: (value) {
                                    context.read<PreviewPropertyCubit>().setBankilyPassCode(value);
                                  },
                                  decoration: material.InputDecoration(
                                    hintText: LocaleKeys.passCode.tr(),
                                    border: material.InputBorder.none,
                                    hintStyle: getRegularStyle(
                                      color: ColorManager.grey,
                                      fontSize: (screenWidth * 0.04).clamp(12, 18),
                                    ),
                                  ),
                                  style: getRegularStyle(
                                    color: ColorManager.blackColor,
                                    fontSize: (screenWidth * 0.04).clamp(12, 18),
                                  ),
                                  obscureText: true,
                                  keyboardType: material.TextInputType.number,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      material.SizedBox(height: verticalSpacing),
                      WarningMessageComponent(
                        text: LocaleKeys.paymentWarning.tr(),
                      ),

                      material.SizedBox(height: verticalSpacing),
                      WarningMessageComponent(
                        text: LocaleKeys.securityWarning.tr(),
                      ),
                    ],
                  ),
                ),
              ),

              /// Loaders
              if (state.addNewPreviewTimeState.isLoading)
                LoadingOverlayComponent(
                  opacity: 0,
                  text: LocaleKeys.paymentConfirmationInProgress.tr(),
                ),
              if (state.getInspectionAmountState.isLoading)
                LoadingOverlayComponent(
                  opacity: 0,
                  text: LocaleKeys.loadingDataInProgress.tr(),
                ),
            ],
          );
        },
      ),
    );
  }

}