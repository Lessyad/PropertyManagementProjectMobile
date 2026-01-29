import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/constants/app_assets.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../../features/home_module/home_imports.dart';
import '../components/button_app_component.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({
    super.key,
    required this.alertText1,
    required this.alertText2,
    this.buttonText,
    this.onTap,
    this.showActionButtonIcon = true ,
  });

  final String alertText1, alertText2;
  final String? buttonText;
  final Function? onTap;
  final bool showActionButtonIcon ;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ColorManager.greyShade,
      body: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return SizedBox(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SvgImageComponent(
                  iconPath: AppAssets.propertyEmptyImage,
                  width: constraints.maxWidth * 0.8,
                  height: constraints.maxHeight * 0.5
                ),
                SizedBox(
                  height: context.scale(8),
                ),
                Text(
                  alertText1,
                  style: getBoldStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s18,
                  ),
                ),
                SizedBox(
                  height: context.scale(12),
                ),
                Text(
                  alertText2,
                  textAlign: TextAlign.center,
                  style: getMediumStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s12,
                  ),
                ),
                SizedBox(
                  height: context.scale(24),
                ),
                if (buttonText != null)
                  ButtonAppComponent(
                    width: 324,
                    height: 48,
                    padding: EdgeInsets.zero,
                    decoration: BoxDecoration(
                      color: ColorManager.primaryColor,
                      borderRadius: BorderRadius.circular(context.scale(24)),
                    ),
                    buttonContent: Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Visibility(
                            visible: showActionButtonIcon,
                            child: SvgImageComponent(
                              iconPath: AppAssets.phoneCallIcon,
                              color: ColorManager.whiteColor,
                              width: 16,
                              height: 16,
                            ),
                          ),
                          SizedBox(width: context.scale(8)),
                          if (buttonText != null)
                            Text(
                              buttonText!,
                              style: getBoldStyle(
                                color: ColorManager.whiteColor,
                                fontSize: FontSize.s14,
                              ),
                            ),
                        ],
                      ),
                    ),
                    onTap: () {
                      onTap!();
                    },
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}