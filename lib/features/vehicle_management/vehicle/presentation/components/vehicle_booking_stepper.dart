import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';

import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../core/extensions/context_extension.dart';
import '../../../../../../core/translation/locale_keys.dart';

/// Stepper 4 étapes pour le flux de réservation de voiture.
/// currentStep : 0 = Résumé, 1 = Conducteur, 2 = Contrat, 3 = Paiement
class VehicleBookingStepper extends StatelessWidget {
  final int currentStep;

  const VehicleBookingStepper({Key? key, required this.currentStep})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final steps = [
      LocaleKeys.rentalSummary.tr(),
      LocaleKeys.tenantInfo.tr(),
      LocaleKeys.rentalContract.tr(),
      LocaleKeys.paymentStep.tr(),
    ];

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.symmetric(vertical: 12.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: List.generate(steps.length, (index) {
          final bool isActive = index <= currentStep;
          return Column(
            children: [
              SizedBox(
                width: context.scale(82),
                child: Text(
                  steps[index],
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: getBoldStyle(
                    color: isActive
                        ? ColorManager.primaryColor
                        : ColorManager.blackColor,
                    fontSize: FontSize.s9,
                  ),
                ),
              ),
              SizedBox(height: context.scale(6)),
              AnimatedContainer(
                duration: const Duration(milliseconds: 500),
                margin: const EdgeInsets.symmetric(horizontal: 2.0),
                width: context.scale(82),
                height: context.scale(4),
                decoration: BoxDecoration(
                  color: isActive
                      ? ColorManager.primaryColor
                      : const Color(0xFFD9D9D9),
                  borderRadius: BorderRadius.circular(2.0),
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
