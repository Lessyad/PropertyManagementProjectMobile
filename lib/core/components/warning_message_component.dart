import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../../features/home_module/home_imports.dart';
import '../constants/app_assets.dart';

class WarningMessageComponent extends StatelessWidget {
  const WarningMessageComponent({super.key ,required this.text});

  final String text ;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgImageComponent(
              iconPath: AppAssets.warningIcon,
              width: 16,
              height: 16,
            ),
            SizedBox(width: context.scale(8)),
            Expanded(
              child: Text(
                text,
                maxLines: 3,
                style: getMediumStyle(
                  color: ColorManager.grey,
                  fontSize: FontSize.s12,
                ),
              ),
            ),
          ],
        ),

      ],
    ) ;
  }
}
