import 'package:flutter/material.dart';

import 'color_manager.dart';
import 'font_manager.dart';

TextStyle _getTextStyle(double fontSize, FontWeight fontWeight, Color color,
    { Color? decorationColor,TextDecoration decoration = TextDecoration.none, double? letterSpacing}) {
  return TextStyle(

      overflow: TextOverflow.ellipsis,
      fontSize: fontSize,
      letterSpacing: letterSpacing ?? 0,
      color: color,
      decoration: decoration,
      decorationColor: decorationColor,
      fontWeight: fontWeight);
}

// regular style

TextStyle getRegularStyle({double fontSize = FontSize.s16, Color? color}) {
  return _getTextStyle(
      fontSize, FontWeightManager.regular, color ?? ColorManager.blackColor);
}

TextStyle getUnderlineSemiBoldStyle(
    {double fontSize = FontSize.s16,
    required Color color,
    decoration = TextDecoration.underline,
    Color? decorationColor}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.semiBold,
    decorationColor: decorationColor,
    color,
    decoration: decoration,
  );
}
TextStyle getUnderlineBoldStyle(
    {double fontSize = FontSize.s16,
    required Color color,
    decoration = TextDecoration.underline,
    Color? decorationColor}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.bold,
    decorationColor: decorationColor,
    color,
    decoration: decoration,
  );
}

TextStyle getUnderlineRegularStyle(
    {double fontSize = FontSize.s16,
      required Color color,
      decoration = TextDecoration.underline,
      Color? decorationColor}) {
  return _getTextStyle(
    fontSize,
    FontWeightManager.regular,
    decorationColor: decorationColor,
    color,
    decoration: decoration,
  );
}
// medium style

TextStyle getMediumStyle(
    {double fontSize = FontSize.s16, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.medium, color);
}

TextStyle getThroughLineMediumStyle(
    {double fontSize = FontSize.s16,
    required Color color,
    decoration = TextDecoration.lineThrough}) {
  return _getTextStyle(fontSize, FontWeightManager.regular, color,
      decoration: decoration);
}
// medium style

TextStyle getLightStyle(
    {double fontSize = FontSize.s14, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.light, color);
}

// bold style

TextStyle getBoldStyle({double fontSize = FontSize.s16, required Color color}) {
  return _getTextStyle(fontSize, FontWeightManager.bold, color);
}

// semiBold style

TextStyle getSemiBoldStyle(
    {double fontSize = FontSize.s16,
    required Color color,
    double? letterSpacing}) {
  return _getTextStyle(fontSize, FontWeightManager.semiBold, color,
      letterSpacing: letterSpacing);
}
