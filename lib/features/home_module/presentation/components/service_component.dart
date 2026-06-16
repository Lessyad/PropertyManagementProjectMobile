import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../domain/entities/app_service_entity.dart';
import '../../home_imports.dart';

class ServiceComponent extends StatelessWidget {
  const ServiceComponent({
    super.key,
    required this.category,
    required this.onTap,
    this.isEnabled = true,
  });

  final AppServiceEntity category;
  final Function() onTap;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final iconColor = isEnabled ? ColorManager.navyColor : ColorManager.grey2;
    final textColor = isEnabled ? ColorManager.navyColor : ColorManager.grey2;

    return InkWell(
      onTap: isEnabled ? onTap : null,
      borderRadius: BorderRadius.circular(context.scale(16)),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.symmetric(horizontal: context.scale(10)),
            child: ClipOval(
              child: Container(
                width: context.scale(64),
                height: context.scale(64),
                decoration: BoxDecoration(
                  color: isEnabled ? Colors.white : ColorManager.greyShade,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child:SvgImageComponent(
                      iconPath: category.image,
                      width: context.scale(24),
                      height: context.scale(24),
                      color: iconColor,
                  )
                  /*CustomNetworkImage(
                    image: category.image,
                    fit: BoxFit.cover,
                    width: context.scale(64),
                    height: context.scale(64),
                  )*/,
                ),
              ),
            ),
          ),
          SizedBox(height: context.scale(8)),
          Text(
            category.text.tr(),
            style: getSemiBoldStyle(color: textColor, fontSize: FontSize.s14),
          ),
        ],
      ),
    );
  }
}
