import 'package:enmaa/core/extensions/context_extension.dart';

import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';
import '../../features/home_module/home_imports.dart';

class CustomTab extends StatelessWidget {
  final String text;
  final bool isSelected;

  const CustomTab({
    super.key,
    required this.text,
    required this.isSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.scale(173),
      height: context.scale(38),
      decoration: ShapeDecoration(
        color: Colors.white,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
          side: BorderSide(
            color: isSelected ? ColorManager.primaryColor : Colors.transparent,
            width: 1,
          ),
        ),

      ),
      alignment: Alignment.center,
      child: Text(
        text,
        style: isSelected
            ? getBoldStyle(
            color: ColorManager.primaryColor, fontSize: FontSize.s12)
            : getMediumStyle(
            color: ColorManager.primaryColor, fontSize: FontSize.s12),
      ),
    );
  }
}
