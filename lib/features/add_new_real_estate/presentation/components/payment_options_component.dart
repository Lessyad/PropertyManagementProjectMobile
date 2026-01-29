import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/payment_methods_extension.dart';
import 'package:enmaa/core/utils/enums.dart';
import 'package:enmaa/features/add_new_real_estate/presentation/controller/add_new_real_estate_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:enmaa/core/translation/locale_keys.dart'; // Ajouter cette importation

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
      previous.currentPaymentMethod != current.currentPaymentMethod,
      builder: (context, state) {
        return FormWidgetComponent(
          label: LocaleKeys.paymentOptions.tr(), // ← Internationalisé
          content: Row(
            children: [
              Expanded(
                child: CustomDropdown<PaymentMethod>(
                  items: PaymentMethod.values,
                  value: context.read<AddNewRealEstateCubit>().state.currentPaymentMethod,
                  onChanged: (value) {
                    context.read<AddNewRealEstateCubit>().changePaymentMethod(value!);
                  },
                  itemToString: (item) => isEn ? item.toEnglish : item.toArabic,
                  hint: Text(
                    LocaleKeys.choosePaymentMethod.tr(), // ← Internationalisé
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
        );
      },
    );
  }
}