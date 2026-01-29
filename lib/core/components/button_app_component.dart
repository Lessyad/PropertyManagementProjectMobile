import 'package:enmaa/core/extensions/context_extension.dart';

import '../../configuration/managers/color_manager.dart';
import '../../features/home_module/home_imports.dart';

class ButtonAppComponent extends StatelessWidget {
  const ButtonAppComponent(
      {super.key,
      required this.buttonContent,
      required this.onTap,
      this.width = double.infinity, this.decoration ,
      this.height = 44,
      this.padding = const EdgeInsets.symmetric(
        horizontal: 16,
      )});

  final double width;
  final double height;
  final BoxDecoration ? decoration;
  final EdgeInsetsGeometry padding;
  final Widget buttonContent;
  final Function() onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(context.scale(8)),
      child: Padding(
        padding: padding,
        child: Container(
          width: context.scale(width),
          height: context.scale(height),
          decoration: decoration ?? BoxDecoration(
            color: ColorManager.primaryColor,
            borderRadius: BorderRadius.circular(context.scale(8)),
          ),
          child: buttonContent,
        ),
      ),
    );
  }
}
