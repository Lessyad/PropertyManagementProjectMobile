import 'package:flutter/material.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';

enum SnackBarType { success, error }

class CustomSnackBar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  static void show({
    BuildContext? context,
    required String message,
    SnackBarType type = SnackBarType.error,
    Duration duration = const Duration(seconds: 3),
  }) {
    final Color iconColor = type == SnackBarType.success
        ? ColorManager.primaryColor
        : ColorManager.redColor;

    final IconData icon = type == SnackBarType.success
        ? Icons.check_circle
        : Icons.error;

    final snackBar = SnackBar(
      margin: EdgeInsets.zero,
      backgroundColor: Colors.transparent,
      elevation: 0,
      behavior: SnackBarBehavior.floating,
      content: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: ColorManager.primaryColor2,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: iconColor, size: 24),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: getBoldStyle(
                  color: ColorManager.primaryColor,
                  fontSize: FontSize.s12,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      duration: duration,
    );

    final scaffoldMessenger = context != null
        ? ScaffoldMessenger.of(context)
        : scaffoldMessengerKey.currentState;

    if (scaffoldMessenger != null) {
      scaffoldMessenger
        ..hideCurrentSnackBar()
        ..showSnackBar(snackBar);
    }
  }
}
