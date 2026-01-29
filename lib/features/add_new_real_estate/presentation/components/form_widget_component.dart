import 'package:flutter/material.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/core/extensions/context_extension.dart';

class FormWidgetComponent extends StatelessWidget {
  final String label;
  final Widget content;
  final bool showBottomSpace;
  final TextStyle? labelStyle;

  const FormWidgetComponent({
    super.key,
    required this.label,
    required this.content,
    this.showBottomSpace = true,
    this.labelStyle,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Label
        Text(
          label,
          style: labelStyle ?? getBoldStyle(
            color: ColorManager.blackColor,
            fontSize: FontSize.s12,
          ),
        ),

        // Space after label (12)
        SizedBox(height: context.scale(12)),

        // Content
        content,

        // Bottom space (16)
        if (showBottomSpace) SizedBox(height: context.scale(16)),
      ],
    );
  }
}