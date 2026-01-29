import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/components/selected_item_text_style.dart';
import 'package:flutter/material.dart';

import '../../../configuration/managers/color_manager.dart';
import '../../../core/components/button_app_component.dart';
import '../../../core/components/svg_image_component.dart';

class MultiSelectTypeSelectorComponent<T> extends StatelessWidget {
  final List<T> values;
  final List<T> selectedTypes;
  final ValueChanged<T> onToggle;
  final String Function(T)? getIcon;
  final String Function(T) getLabel;

  final double selectorWidth, selectorHeight;

  const MultiSelectTypeSelectorComponent({
    super.key,
    required this.values,
    required this.selectedTypes,
    required this.onToggle,
    required this.getLabel,
    required this.selectorWidth,
    this.getIcon,
    this.selectorHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      alignment: WrapAlignment.spaceBetween,
      children: values.map(
            (type) => _buildTypeButton(
          width: selectorWidth,
          height: selectorHeight,
          context: context,
          type: type,
          isSelected: selectedTypes.contains(type),
          onTap: () => onToggle(type),
        ),
      ).toList(),
    );
  }

  Widget _buildTypeButton({
    required BuildContext context,
    required T type,
    required bool isSelected,
    required VoidCallback onTap,
    required double width,
    required double height,
  }) {
    return ButtonAppComponent(
      width: width,
      height: height,
      padding: EdgeInsets.zero,
      decoration: BoxDecoration(
        color: isSelected ? ColorManager.primaryColor.withOpacity(0.1) : ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(context.scale(24)),
        border: Border.all(
          color: isSelected ? ColorManager.primaryColor : Colors.transparent,
          width: 1,
        ),
      ),
      buttonContent: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (getIcon != null)
            SvgImageComponent(
              iconPath: getIcon!(type),
              width: context.scale(16),
              height: context.scale(16),
              color: isSelected ? ColorManager.primaryColor : null,
            ),
          if (getIcon != null) SizedBox(width: context.scale(6)),
          Text(
            getLabel(type),
            style: currentTextStyle(isSelected),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}