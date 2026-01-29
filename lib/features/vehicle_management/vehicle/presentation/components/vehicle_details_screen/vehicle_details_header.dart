import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/translation/locale_keys.dart';

import '../../../../../../configuration/managers/color_manager.dart';
import '../../../../../../configuration/managers/font_manager.dart';
import '../../../../../../configuration/managers/style_manager.dart';
import '../../../../../../core/components/reserved_component.dart';
import '../../../../../../core/components/svg_image_component.dart';
import '../../../../../../core/constants/app_assets.dart';
import '../../../../../home_module/home_imports.dart';


class VehicleDetailsHeader extends StatelessWidget {
  const VehicleDetailsHeader({
    super.key,
    required this.vehicleDetailsTitle,
    required this.vehicleDetailsPrice,
    required this.vehicleDetailsLocation,
    required this.vehicleDetailsStatus,
  });

  final String vehicleDetailsTitle;
  final String vehicleDetailsPrice;
  final String vehicleDetailsLocation;
  final String vehicleDetailsStatus;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                vehicleDetailsTitle,
                overflow: TextOverflow.ellipsis,
                style: getBoldStyle(
                    color: ColorManager.blackColor,
                    fontSize: FontSize.s12
                ),
              ),
            ),

            // Visibility(
            //   visible: vehicleDetailsStatus == 'available',
            //   child: ReservedComponent(),
            // )
          ],
        ),
        SizedBox(height: context.scale(6)),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  SvgImageComponent(
                    iconPath: AppAssets.locationIcon,
                    width: 12,
                    height: 12,
                  ),
                  SizedBox(width: context.scale(4)),
                  Expanded(
                    child: Text(
                      vehicleDetailsLocation,
                      overflow: TextOverflow.ellipsis,
                      style: getLightStyle(
                        color: ColorManager.blackColor,
                        fontSize: FontSize.s11,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Align(
                alignment: Alignment.centerLeft,
                child: RichText(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: LocaleKeys.startingFrom.tr(),
                        style: getRegularStyle(
                          color: ColorManager.primaryColor,
                          fontSize: FontSize.s10,
                        ),
                      ),
                      TextSpan(
                        text: vehicleDetailsPrice,
                        style: getBoldStyle(
                          color: ColorManager.primaryColor,
                          fontSize: FontSize.s12,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}