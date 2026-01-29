import 'package:flutter/material.dart';
import '../../configuration/managers/color_manager.dart';
import '../../configuration/managers/font_manager.dart';
import '../../configuration/managers/style_manager.dart';

final TextStyle selectedItemTextStyle = getBoldStyle(
  color: ColorManager.primaryColor,
  fontSize: FontSize.s12,
);

final TextStyle notSelectedItemTextStyle = getMediumStyle(
  color: ColorManager.primaryColor,
  fontSize: FontSize.s12,
);

TextStyle currentTextStyle(bool isSelected) {
  return isSelected ? selectedItemTextStyle : notSelectedItemTextStyle;
}
