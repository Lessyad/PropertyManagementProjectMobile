import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/core/entites/amenity_entity.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

import '../../../../../configuration/managers/color_manager.dart';
import '../../../../../configuration/managers/font_manager.dart';
import '../../../../../configuration/managers/style_manager.dart';
import '../../../../../core/components/chip_component.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../../../home_module/home_imports.dart';

class RealEstateDetailsAmenities extends StatelessWidget {
  const RealEstateDetailsAmenities({super.key, required this.amenities});

  final List<AmenityEntity> amenities;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          LocaleKeys.amenitiesLabel.tr(),
          style: getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s12,
          ),
        ),
        SizedBox(height: context.scale(16)),
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: amenities.map((amenity) {
            return ChipComponent(
              width: 114,
              text: amenity.name,
              backgroundColor: ColorManager.whiteColor,
            );
          }).toList(),
        ),
      ],
    );
  }
}
