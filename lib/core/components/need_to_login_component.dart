import 'package:flutter/material.dart';
 
import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/translation/locale_keys.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/configuration/routers/route_names.dart';
import 'package:enmaa/core/components/button_app_component.dart';
import 'package:enmaa/core/components/custom_bottom_sheet.dart';


class LoginBottomSheet {
   static final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

   static void show() {
      final BuildContext? context = navigatorKey.currentContext;
      if (context == null) {
         return;
      }

      showModalBottomSheet(
         context: context,
         backgroundColor: ColorManager.greyShade,
         isScrollControlled: true,
         shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.vertical(
               top: Radius.circular(25),
            ),
         ),
         builder: (__) {
            return CustomBottomSheet(
               widget: const LoginComponent(),
               padding: EdgeInsets.only(left: context.scale(16),
                  right: context.scale(16),
                   bottom: context.scale(16)),

               headerText: '',
            );
         },
      );
   }
}

class LoginComponent extends StatelessWidget {
   const LoginComponent({super.key});

   @override
   Widget build(BuildContext context) {
      return Column(
         mainAxisSize: MainAxisSize.min,
         children: [
            SvgImageComponent(
               width: 80,
               height: 80,
               color: ColorManager.yellowColor,
               iconPath: AppAssets.logOutIcon,
            ),
            SizedBox(
               height: context.scale(20),
            ),
            Text(
               tr(LocaleKeys.youMustLogin),
               style: getBoldStyle(
                  color: ColorManager.blackColor,
                  fontSize: FontSize.s18,
               ),
            ),
            SizedBox(
               height: context.scale(8),
            ),
            Text(
               tr(LocaleKeys.loginFirstHint),
               overflow: TextOverflow.ellipsis,
               maxLines: 2,
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
                              tr(LocaleKeys.cancel) ,
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
                              tr(LocaleKeys.login) ,
                              style: getBoldStyle(
                                 color: ColorManager.whiteColor,
                                 fontSize: FontSize.s14,
                              ),
                           ),
                        ),
                        onTap: () {
                           Navigator.pushNamedAndRemoveUntil(context, RoutersNames.authenticationFlow , ( route) => false);
                        },
                     ),
                  ],
               ),
            ),
         ],
      );
   }
}