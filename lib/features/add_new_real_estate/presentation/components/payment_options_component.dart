import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/payment_methods_extension.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/translation/locale_keys.dart';

import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/components/custom_app_drop_down.dart';
import '../../../../configuration/managers/drop_down_style_manager.dart';
import 'form_widget_component.dart';

class PaymentOptionsComponent extends StatelessWidget {
  const PaymentOptionsComponent({super.key});

  @override
  Widget build(BuildContext context) {
    bool isEn = context.locale == Locale('en');

    return BlocBuilder<AddNewRealEstateCubit, AddNewRealEstateState>(
      buildWhen: (previous, current) =>
          previous.currentPaymentMethod != current.currentPaymentMethod ||
          previous.bankilyCommercialCode != current.bankilyCommercialCode,
      builder: (context, state) {
        final cubit = context.read<AddNewRealEstateCubit>();
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            FormWidgetComponent(
              label: LocaleKeys.paymentOptions.tr(),
              content: Row(
                children: [
                  Expanded(
                    child: CustomDropdown<PaymentMethod>(
                      items: PaymentMethod.values,
                      value: state.currentPaymentMethod,
                      onChanged: (value) {
                        cubit.changePaymentMethod(value!);
                      },
                      itemToString: (item) =>
                          isEn ? item.toEnglish : item.toArabic,
                      hint: Text(
                        LocaleKeys.choosePaymentMethod.tr(),
                        style: TextStyle(fontSize: FontSize.s12),
                      ),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: ColorManager.greyShade,
                      ),
                      decoration: DropdownStyles.getDropdownDecoration(),
                      dropdownColor: ColorManager.whiteColor,
                      menuMaxHeight: 200,
                      style: getMediumStyle(
                        color: ColorManager.blackColor,
                        fontSize: FontSize.s14,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (state.currentPaymentMethod.isBankily)
              FormWidgetComponent(
                label: LocaleKeys.codeCommercial.tr(),
                content: TextFormField(
                  controller: cubit.bankilyCommercialCodeController,
                  keyboardType: TextInputType.text,
                  decoration: InputDecoration(
                    hintText: LocaleKeys.enterCodeCommercial.tr(),
                    hintStyle: getRegularStyle(
                      color: ColorManager.grey,
                      fontSize: FontSize.s12,
                    ),
                    filled: true,
                    fillColor: ColorManager.whiteColor,
                    contentPadding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 10),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide.none,
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                          color: ColorManager.primaryColor, width: 1),
                    ),
                  ),
                  style: getMediumStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s14,
                  ),
                  onChanged: (value) {
                    cubit.changeBankilyCommercialCode(value.trim());
                  },
                ),
              ),
          ],
        );
      },
    );
  }
}
