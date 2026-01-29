import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:flutter_svg/svg.dart';

import '../../features/home_module/home_imports.dart';

class SvgImageComponent extends StatelessWidget {
  const SvgImageComponent({
    super.key,
    required this.iconPath,
    this.width = 24,
    this.height = 24,
    this.color,
  });

  final String iconPath;
  final double width;
  final double height;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return SvgPicture.asset(
      iconPath,
      width: context.scale(width),
      height: context.scale(height),
      colorFilter: color != null
          ? ColorFilter.mode(color!, BlendMode.srcIn)
          : null,
    );
  }
}