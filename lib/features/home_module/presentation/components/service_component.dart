import 'package:easy_localization/easy_localization.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/core/components/custom_image.dart';
import 'package:enmaa/core/components/svg_image_component.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

import '../../../../configuration/managers/color_manager.dart';
import '../../../../configuration/managers/style_manager.dart';
import '../../../../../core/translation/locale_keys.dart';
import '../../domain/entities/app_service_entity.dart';
import '../../home_imports.dart';

class ServiceComponent extends StatelessWidget {
  const ServiceComponent({super.key, required this.category, required this.onTap});

  final AppServiceEntity category;
  final Function() onTap;

  @override
  Widget build(BuildContext context) {
    final bool disabled = category.isComingSoon;

    return InkWell(
      onTap: disabled ? null : onTap,
      borderRadius: BorderRadius.circular(context.scale(16)),
      child: Opacity(
        opacity: disabled ? 0.45 : 1.0,
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: context.scale(10)),
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  ClipOval(
                    child: Container(
                      width: context.scale(64),
                      height: context.scale(64),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                      ),
                      child: Center(
                        child: SvgImageComponent(
                          iconPath: category.image,
                          width: context.scale(24),
                          height: context.scale(24),
                        ),
                      ),
                    ),
                  ),
                  if (disabled)
                    Positioned(
                      top: context.scale(-6),
                      right: context.scale(-6),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: context.scale(5),
                          vertical: context.scale(2),
                        ),
                        decoration: BoxDecoration(
                          color: ColorManager.yellowColor,
                          borderRadius: BorderRadius.circular(context.scale(8)),
                        ),
                        child: Text(
                          tr(LocaleKeys.comingSoon),
                          style: TextStyle(
                            fontSize: context.scale(8),
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            SizedBox(height: context.scale(8)),
            Text(
              category.text.tr(),
              style: getSemiBoldStyle(
                color: ColorManager.blackColor,
                fontSize: FontSize.s14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
