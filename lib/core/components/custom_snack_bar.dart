import 'package:flutter/material.dart';
import 'package:enmaa/configuration/managers/color_manager.dart';
import 'package:enmaa/configuration/managers/style_manager.dart';
import 'package:enmaa/configuration/managers/font_manager.dart';

enum SnackBarType { success, error, warning }

class CustomSnackBar {
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey =
  GlobalKey<ScaffoldMessengerState>();

  static void show({
    BuildContext? context,
    required String message,
    SnackBarType type = SnackBarType.error,
    Duration duration = const Duration(seconds: 3),
  }) {
    final Duration effectiveDuration =
        type == SnackBarType.error ? const Duration(seconds: 5) : duration;
    final Color iconColor = type == SnackBarType.success
        ? ColorManager.primaryColor
        : type == SnackBarType.warning
            ? const Color(0xFFF59E0B)
            : ColorManager.redColor;

    final IconData icon = type == SnackBarType.success
        ? Icons.check_circle
        : type == SnackBarType.warning
            ? Icons.warning_amber_rounded
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
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
      duration: effectiveDuration,
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
