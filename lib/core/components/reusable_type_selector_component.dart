
import 'package:enmaa/core/extensions/context_extension.dart';
import 'package:enmaa/core/components/selected_item_text_style.dart';
import 'package:flutter/material.dart';

import '../../../configuration/managers/color_manager.dart';
import '../../../core/components/button_app_component.dart';
import '../../../core/components/svg_image_component.dart';


class TypeSelectorComponent<T> extends StatelessWidget {
  final List<T> values;
  final T? currentType;
  final ValueChanged<T> onTap;
  final String Function(T)? getIcon;
  final String Function(T) getLabel;

  final double selectorWidth, selectorHeight;

  const TypeSelectorComponent({
    super.key,
    required this.values,
    required this.currentType,
    required this.onTap,
    required this.getLabel,
    required this.selectorWidth,
    this.getIcon,
    this.selectorHeight = 40,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: selectorHeight,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: values.length,
        itemBuilder: (context, index) {
          final type = values[index];
          return Padding(
            padding: EdgeInsets.only(right: index < values.length - 1 ? 8.0 : 0.0),
            child: _buildTypeButton(
              width: selectorWidth,
              height: selectorHeight,
              context: context,
              type: type,
              isSelected: currentType == type,
              onTap: () => onTap(type),
            ),
          );
        },
      ),
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
        color: ColorManager.whiteColor,
        borderRadius: BorderRadius.circular(context.scale(24)),
        border: Border.all(
          color: isSelected ? ColorManager.primaryColor : Colors.transparent,
          width: 1,
        ),
      ),
      buttonContent: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          if (getIcon != null)
            SvgImageComponent(
              iconPath: getIcon!(type),
              width: context.scale(16),
              height: context.scale(16),
            ),
          if (getIcon != null) SizedBox(width: context.scale(6)),
          Flexible(
            child: Text(
              getLabel(type),
              style: currentTextStyle(isSelected),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
      onTap: onTap,
    );
  }
}