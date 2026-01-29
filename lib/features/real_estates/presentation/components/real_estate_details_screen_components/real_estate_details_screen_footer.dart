import 'package:enmaa/configuration/routers/route_names.dart';
import 'package:enmaa/core/components/need_to_login_component.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/main.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/components/button_app_component.dart';
import '../../../../../core/components/custom_snack_bar.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../home_module/home_imports.dart';

class RealEstateDetailsScreenFooter extends StatelessWidget {
  const RealEstateDetailsScreenFooter({
    super.key, 
    required this.propertyId,
    required this.officePhoneNUmber,
    required this.actionIsDimmed,
    this.operation, // 🆕 Paramètre optionnel
    this.monthlyRentPeriod, // 🆕 Paramètre optionnel
  });

  final String propertyId;
  final String officePhoneNUmber;
  final bool actionIsDimmed;
  final String? operation; // 🆕 "for_rent" ou "for_sale"
  final String? monthlyRentPeriod; // 🆕 nombre de mois

  @override
  Widget build(BuildContext context) {
    print("isss dimmed $actionIsDimmed");
    return Container(
      height: context.scale(88),
      width: double.infinity,
      padding: EdgeInsets.symmetric(horizontal: context.scale(16)),
      decoration: BoxDecoration(
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(context.scale(24)),
          topRight: Radius.circular(context.scale(24)),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ButtonAppComponent(
            width: 140,
            height: 46,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: actionIsDimmed? ColorManager.grey2: ColorManager.whiteColor,
              borderRadius: BorderRadius.circular(context.scale(24)),
              border:actionIsDimmed? null : Border.all(
                color: ColorManager.primaryColor,
                width: 1,
              ),
            ),
            buttonContent: Center(
              child: Text(
                LocaleKeys.preview.tr(),
                style: getBoldStyle(
                  color:actionIsDimmed?ColorManager.blackColor : ColorManager.primaryColor,
                  fontSize: FontSize.s12,
                ),
              ),
            ),
            onTap: () async {
              if (isAuth) {
                if(!actionIsDimmed){
                  final result = await Navigator.of(context).pushNamed(
                    RoutersNames.previewPropertyScreen,
                    arguments: {
                      'id': propertyId,
                    },
                  );
                  if (result == true) {
                    CustomSnackBar.show(
                      message: LocaleKeys.previewConfirmed.tr(),
                      type: SnackBarType.success,
                    );
                  }
                }
                else {
                  CustomSnackBar.show(
                    message: LocaleKeys.previewError.tr(),
                    type: SnackBarType.error,
                  );
                }
              } else {
                LoginBottomSheet.show();
              }
            },
          ),
          ButtonAppComponent(
            width: 140,
            height: 46,
            padding: EdgeInsets.zero,
            decoration: BoxDecoration(
              color: actionIsDimmed? ColorManager.grey2: ColorManager.primaryColor,
              borderRadius: BorderRadius.circular(context.scale(24)),
            ),
            buttonContent: Center(
              child: Text(
                LocaleKeys.bookNow.tr(),
                style: getBoldStyle(
                  color:actionIsDimmed?ColorManager.blackColor : ColorManager.whiteColor,
                  fontSize: FontSize.s12,
                ),
              ),
            ),
            onTap: () async {
              if (isAuth) {
                if(!actionIsDimmed){
                  // 🆕 Passer les informations complètes de la propriété
                  final result = await Navigator.of(context).pushNamed(
                    RoutersNames.bookPropertyScreen,
                    arguments: {
                      'propertyId': propertyId,
                      'operation': operation,
                      'monthlyRentPeriod': monthlyRentPeriod,
                    },
                  );
                  if (result == true) {
                    CustomSnackBar.show(
                      message: LocaleKeys.previewConfirmed.tr(),
                      type: SnackBarType.success,
                    );
                  }
                }
                else {
                  CustomSnackBar.show(
                    message: LocaleKeys.bookNowError.tr(),
                    type: SnackBarType.error,
                  );
                }
              } else {
                LoginBottomSheet.show();
              }
            },
          ),
        ],
      ),
    );
  }
}