import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/shimmer_component.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/extensions/request_states_extension.dart';
import 'package:enmaa/features/book_property/presentation/controller/book_property_cubit.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../../configuration/managers/value_manager.dart';
import '../../../../core/components/warning_message_component.dart';
import '../../../../core/constants/app_assets.dart';
import '../../../../core/translation/locale_keys.dart';
import '../../../../core/services/currency_service.dart';
import '../../../../core/components/currency_display_widget.dart';
import '../../../add_new_real_estate/presentation/components/numbered_text_header_component.dart';
import '../../../home_module/home_imports.dart';

class SaleDetailsScreen extends StatelessWidget {
  const SaleDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
        padding: EdgeInsets.all(AppPadding.p16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
              NumberedTextHeaderComponent(
              number: '1',
              text: LocaleKeys.saleDetailsHeader.tr(), // Using tr() for translation
            ),
            SizedBox(height: context.scale(20)),
            Text(
              LocaleKeys.saleConditions.tr(), // Using tr() for translation
              style: getBoldStyle(
                  color: ColorManager.blackColor, fontSize: FontSize.s16),
            ),
            SizedBox(height: context.scale(20)),
            Container(
              width: double.infinity,
              decoration: BoxDecoration(
                color: ColorManager.whiteColor,
                borderRadius: BorderRadius.circular(12),
              ),
              padding: EdgeInsets.all(AppPadding.p16),
              child: BlocBuilder<BookPropertyCubit, BookPropertyState>(
                builder: (context, state) {
                  if (state.getPropertySaleDetailsState.isLoaded) {
                    final details = state.propertySaleDetailsEntity!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _priceRow(
                          context,
                          LocaleKeys.bookingDepositLabel.tr(),
                          double.tryParse(details.bookingDeposit) ?? 0.0,
                        ),
                        SizedBox(height: context.scale(12)),
                        _priceRow(
                          context,
                          LocaleKeys.finalPriceLabel.tr(),
                          double.tryParse(details.propertyPrice) ?? 0.0,
                        ),
                        SizedBox(height: context.scale(12)),
                        // TVA : pourcentage appliqué au prix de la propriété + sa valeur
                        _priceRow(
                          context,
                          '${LocaleKeys.taxLabel.tr()} (${details.taxPercent}%) : ',
                          double.tryParse(details.taxAmount) ?? 0.0,
                        ),
                        SizedBox(height: context.scale(12)),
                        // Total TTC = prix de la propriété + TVA
                        _priceRow(
                          context,
                          LocaleKeys.totalWithTaxLabel.tr(),
                          double.tryParse(details.totalPriceWithTax) ?? 0.0,
                        ),
                      ],
                    );
                  } else {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _shimmerRow(context, LocaleKeys.bookingDepositLabel.tr()),
                        SizedBox(height: context.scale(12)),
                        _shimmerRow(context, LocaleKeys.finalPriceLabel.tr()),
                        SizedBox(height: context.scale(12)),
                        _shimmerRow(context, LocaleKeys.taxLabel.tr()),
                        SizedBox(height: context.scale(12)),
                        _shimmerRow(context, LocaleKeys.totalWithTaxLabel.tr()),
                      ],
                    );
                  }
                },
              ),
            ),
            SizedBox(height: context.scale(20)),
            WarningMessageComponent(
              text: LocaleKeys.bookingProcedureWarning.tr(), // Using tr() for translation
            ),
            SizedBox(height: context.scale(20)),
            WarningMessageComponent(
              text: LocaleKeys.bookingConfirmationWarning.tr(), // Using tr() for translation
            ),
          ],
        ));
  }

  Widget _priceRow(BuildContext context, String label, double amount) {
    return Row(
      children: [
        SvgImageComponent(
          width: 16,
          height: 16,
          iconPath: AppAssets.priceToBePaidIcon,
        ),
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
          child: BoldCurrencyDisplayWidget(
            amount: amount,
            textColor: ColorManager.blackColor,
            fontSize: FontSize.s16,
          ),
        ),
      ],
    );
  }

  Widget _shimmerRow(BuildContext context, String label) {
    return Row(
      children: [
        SvgImageComponent(
          width: 16,
          height: 16,
          iconPath: AppAssets.priceToBePaidIcon,
        ),
        SizedBox(width: context.scale(8)),
        Text(
          label,
          style: getSemiBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s14,
          ),
        ),
        ShimmerComponent(height: context.scale(10), width: context.scale(100)),
      ],
    );
  }
}
