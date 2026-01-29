import 'package:flutter/material.dart';
import '../../../../../configuration/managers/color_manager.dart';

class DropdownStyles {
  static InputDecoration getDropdownDecoration() {
    return InputDecoration(
      filled: true,
      fillColor: ColorManager.whiteColor,
      contentPadding: EdgeInsets.symmetric(horizontal: 16),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(24),
        borderSide: BorderSide.none,
      ),
    );
  }
}