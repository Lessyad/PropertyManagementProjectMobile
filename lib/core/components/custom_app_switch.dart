import 'package:flutter/material.dart';
import '../../configuration/managers/color_manager.dart';
import '../../features/home_module/home_imports.dart';

class CustomAppSwitch extends StatelessWidget {
  final bool value;
  final ValueChanged<bool> onChanged;

  const CustomAppSwitch({
    super.key,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Transform.scale(
      scale: .9,
      child: Switch(
        value: value,
        onChanged: onChanged,
        activeColor: ColorManager.yellowColor,
        inactiveTrackColor: Colors.grey,
        thumbColor: WidgetStateProperty. resolveWith<Color>((Set<WidgetState> states) {
          return ColorManager.whiteColor;
        }),
        trackOutlineColor: WidgetStateProperty. resolveWith<Color?>((Set<WidgetState> states) {
          return Colors.transparent;
        }),
      ),
    );
  }
}
