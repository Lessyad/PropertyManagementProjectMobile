import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/components/expandable_description_box.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../home_module/home_imports.dart';

class RealEstateDetailsDescription extends StatelessWidget {
  const RealEstateDetailsDescription({super.key,required this.description });

  final String description ;
  @override
  Widget build(BuildContext context) {

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.descriptionLabel.tr(),
          style: getBoldStyle(
              color: ColorManager.blackColor,
              fontSize: FontSize.s12),
        ),
        SizedBox(height: context.scale(8)),
        ExpandableDescriptionBox(
            description:description),
      ],
    );
  }
}
