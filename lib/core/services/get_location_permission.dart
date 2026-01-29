import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:geolocator/geolocator.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:latlong2/latlong.dart';

class LocationServicePermissions {
  /// Check and request location permissions
  static Future<bool> checkLocationPermission(BuildContext context) async {
    // First check if location services are enabled
    bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      await PlatformSpecificDialogs.showLocationServicesDialog(context);
      return false;
    }

    // Check for permission
    LocationPermission permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Show a message that permissions were denied
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Location permissions are required')),
        );
        return false;
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Show platform-specific dialog for permission denied
      await PlatformSpecificDialogs.showLocationPermissionDialog(context);
      return false;
    }

    return true;
  }

  /// Get current location with proper error handling
  static Future<Position?> getCurrentPosition(BuildContext context) async {
    try {
      final hasPermission = await checkLocationPermission(context);
      if (!hasPermission) return null;

      // Get position with appropriate accuracy for both platforms
      return await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      );
    } catch (e) {
      print('Error getting location: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not get current location: ${e.toString()}')),
      );
      return null;
    }
  }

  /// Get current location as LatLng
  static Future<LatLng?> getCurrentLocation(BuildContext context) async {
    final position = await getCurrentPosition(context);
    if (position != null) {
      return LatLng(position.latitude, position.longitude);
    }
    return null;
  }

  /// Calculate distance between two points in kilometers
  static double calculateDistance(LatLng point1, LatLng point2) {
    const Distance distance = Distance();
    return distance.as(LengthUnit.Kilometer, point1, point2);
  }
}

/// Platform specific dialogs for iOS and Android
class PlatformSpecificDialogs {
  /// Show appropriate location permission dialog based on platform
  static Future<void> showLocationPermissionDialog(BuildContext context) async {
    if (Platform.isIOS) {
      return _showCupertinoLocationPermissionDialog(context);
    } else {
      return _showMaterialLocationPermissionDialog(context);
    }
  }

  /// Show appropriate location services dialog based on platform
  static Future<void> showLocationServicesDialog(BuildContext context) async {
    if (Platform.isIOS) {
      return _showCupertinoLocationServicesDialog(context);
    } else {
      return _showMaterialLocationServicesDialog(context);
    }
  }

  // iOS-styled permission dialog
  static Future<void> _showCupertinoLocationPermissionDialog(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Location Permission Required'),
        content: Text('To use this feature, please enable location permissions in app settings.'),
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

  // Android/Material-styled permission dialog
  static Future<void> _showMaterialLocationPermissionDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Location Permission Required'),
        content: Text('To use this feature, please enable location permissions in app settings.'),
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

  // iOS-styled location services dialog
  static Future<void> _showCupertinoLocationServicesDialog(BuildContext context) {
    return showCupertinoDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => CupertinoAlertDialog(
        title: Text('Location Services Disabled'),
        content: Text('Please enable location services to use this feature.'),
        actions: [
          CupertinoDialogAction(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          CupertinoDialogAction(
            isDefaultAction: true,
            child: Text('Settings'),
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
          ),
        ],
      ),
    );
  }

  // Android/Material-styled location services dialog
  static Future<void> _showMaterialLocationServicesDialog(BuildContext context) {
    return showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Location Services Disabled'),
        content: Text('Please enable location services to use this feature.'),
        actions: [
          TextButton(
            child: Text('Cancel'),
            onPressed: () => Navigator.pop(context),
          ),
          TextButton(
            child: Text('Settings'),
            onPressed: () {
              Navigator.pop(context);
              Geolocator.openLocationSettings();
            },
          ),
        ],
      ),
    );
  }
}