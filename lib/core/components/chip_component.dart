import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

import '../../configuration/managers/font_manager.dart';
import '../../features/home_module/home_imports.dart';

class ChipComponent extends StatelessWidget {
  final String text;
  final Color backgroundColor;
  final Color textColor;
  final double width;
  final double height;
  final double borderRadius;
  final Color borderColor;

  const ChipComponent({
    super.key,
    required this.text,
    this.backgroundColor = Colors.white,
    this.textColor = Colors.black,
    this.width = 175,
    this.height = 40,
    this.borderRadius = 12,
    this.borderColor = const Color(0xFFE8E8E8),
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: context.scale(width),
      height: context.scale(height),
      padding: const EdgeInsets.all(8),
      decoration: ShapeDecoration(
        color: backgroundColor,
        shape: RoundedRectangleBorder(
          side: BorderSide(
            width: 1,
            strokeAlign: BorderSide.strokeAlignOutside,
            color: borderColor,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [

          Text(
            text,
            overflow: TextOverflow.ellipsis,
            style: getMediumStyle(color: textColor, fontSize: FontSize.s12),
          ),
        ],
      ),
    );
  }
}