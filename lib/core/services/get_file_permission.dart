import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:device_info_plus/device_info_plus.dart';

class FilePermissionService {
  /// Check and request file storage permissions
  static Future<bool> checkFilePermission(BuildContext context) async {
    if (Platform.isAndroid && await _isAndroid11OrAbove()) {
      // Request MANAGE_EXTERNAL_STORAGE for Android 11+
      var status = await Permission.manageExternalStorage.status;
      if (status.isGranted) {
        return true;
      }
      status = await Permission.manageExternalStorage.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        await PlatformSpecificDialogs.showFilePermissionDialog(context);
        return false;
      }
      return status.isGranted;
    } else if (Platform.isIOS) {
      // Request storage permission for iOS
      var status = await Permission.storage.status;
      if (status.isGranted) {
        return true;
      }
      status = await Permission.storage.request();
      if (status.isDenied || status.isPermanentlyDenied) {
        await PlatformSpecificDialogs.showFilePermissionDialog(context);
        return false;
      }
      return status.isGranted;
    } else {
      return true;
    }
  }

  /// Check if the device is running Android 11 or above
  static Future<bool> _isAndroid11OrAbove() async {
    final deviceInfo = await DeviceInfoPlugin().androidInfo;
    return deviceInfo.version.sdkInt >= 30;
  }

  /// Open app settings for the user to manually enable permissions
  static Future<bool> openAppSettings() async {
    return await openAppSettings();
  }
}

/// Platform-specific dialogs for file permissions
class PlatformSpecificDialogs {
  /// Show appropriate file permission dialog based on platform
  static Future<void> showFilePermissionDialog(BuildContext context) async {
    if (Platform.isIOS) {
      return _showCupertinoFilePermissionDialog(context);
    } else {
      return _showMaterialFilePermissionDialog(context);
    }
  }

  // iOS-styled file permission dialog
  static Future<void> _showCupertinoFilePermissionDialog(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text('File Access Permission Required'),
        content: Text('To use this feature, please enable file access permissions in app settings.'),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Settings'),
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }

  // Android/Material-styled file permission dialog
  static Future<void> _showMaterialFilePermissionDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('File Access Permission Required'),
        content: Text('To use this feature, please enable file access permissions in app settings.'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Settings'),
            onPressed: () {
              openAppSettings();
              Navigator.pop(context);
            },
          ),
        ],
      ),
    );
  }
}