import 'package:enmaa/core/components/custom_snack_bar.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/components/button_app_component.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:easy_localization/easy_localization.dart';
import '../../../core/translation/locale_keys.dart';
import '../models/on_boarding_mdoel.dart';

class OnBoardingPageWidget extends StatelessWidget {
  final OnBoardingPage page;
  final int currentPage;
  final int totalPages;

  const OnBoardingPageWidget({
    super.key,
    required this.page,
    required this.currentPage,
    required this.totalPages,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(context.scale(16)),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          SvgImageComponent(
            iconPath: page.image,
            width: 268,
            height: 196,
          ),

          SizedBox(height: context.scale(40)),

          Text(
            page.title,
            textAlign: TextAlign.center,
            style: getBoldStyle(color: ColorManager.blackColor, fontSize: FontSize.s20),
          ),

          SizedBox(height: context.scale(8)),

          Text(
            page.description1,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: getMediumStyle(color: ColorManager.grey, fontSize: FontSize.s14),
          ),

          SizedBox(height: context.scale(2)),

          Text(
            page.description2,
            textAlign: TextAlign.center,
            maxLines: 3,
            style: getMediumStyle(color: ColorManager.grey, fontSize: FontSize.s14),
          ),

          SizedBox(height: context.scale(20)),

          ButtonAppComponent(
            width: 140, // Augmenter la largeur pour éviter le débordement
            height: 46,
            padding: EdgeInsets.symmetric(horizontal: context.scale(16)), // Ajouter un padding horizontal
            decoration: BoxDecoration(
              color: ColorManager.whiteColor,
              borderRadius: BorderRadius.circular(context.scale(24)),
              border: Border.all(color: ColorManager.yellowColor, width: 1),
            ),
            buttonContent: Center(
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SvgImageComponent(
                    iconPath: AppAssets.phoneCallIcon,
                    width: 12,
                    height: 12,
                  ),
                  SizedBox(width: context.scale(8)),
                  Flexible( // Ajouter Flexible pour éviter le débordement
                    child: Text(
                      LocaleKeys.contactUs.tr(),
                      style: getBoldStyle(color: ColorManager.yellowColor, fontSize: FontSize.s14),
                      overflow: TextOverflow.ellipsis, // Ajouter ellipsis en cas de débordement
                    ),
                  ),
                ],
              ),
            ),
            onTap: () async {
              final Uri url = Uri.parse('https://www.musabholding.com/');

              if (await canLaunchUrl(url)) {
                await launchUrl(url, mode: LaunchMode.externalApplication);
              } else {
                CustomSnackBar.show(
                  context: context,
                  message: LocaleKeys.errorOpeningLink.tr(),
                  type: SnackBarType.error,
                );
              }
            },
          ),
        ],
      ),
    );
  }
}
