import 'dart:async';
import 'dart:developer';
import 'dart:convert';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:enmaa/core/services/service_locator.dart';
import 'package:enmaa/core/services/shared_preferences_service.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:open_file/open_file.dart';
import '../../main.dart';
import '../constants/api_constants.dart';
import '../errors/failure.dart';
import 'dio_service.dart';
import 'handle_api_request_service.dart';

abstract class BaseFireBaseMessaging {
  Future<void> getToken();
  Future<String?> getFcmToken();

  Future<void> initInfo();

  Future<void> requestPermission();
}



class FireBaseMessaging extends BaseFireBaseMessaging {
  late FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();
  var initializationSettingsAndroid =
  const AndroidInitializationSettings('@mipmap/ic_launcher');
  final _firebaseMessaging = FirebaseMessaging.instance;

  @override
  Future<void> getToken() async {
    await _firebaseMessaging.getToken().then((token) async {
      _saveFirebaseNotificationToken(token!);
    });
  }

  @override
  Future<String?> getFcmToken() async {
    return await _firebaseMessaging.getToken();
  }

  Future<void> _saveFirebaseNotificationToken(String token) async {
    final dio = ServiceLocator.getIt<DioService>();

    final formData = FormData.fromMap({
      "registration_id": token,
      "type": Platform.isIOS ? "ios" : "android",
    });

    final result = await HandleRequestService.handleApiCall<void>(
          () async {
        final response = await dio.post(
          url: ApiConstants.notification,
          data: formData,
          options: Options(
            headers: {
              "Content-Type": "multipart/form-data",
            },
          ),
        );

        if (response.statusCode == 200) {
          print('firebase messaging token is : $token');
          await SharedPreferencesService().storeValue('firebaseToken', token);
        }
      },
    );
  }

  @override
  Future<void> requestPermission() async {
    NotificationSettings settings = await _firebaseMessaging.requestPermission(
      alert: true,
      badge: true,
      sound: true,
    );
    log('User granted permission: ${settings.authorizationStatus}');
  }

  @override
  Future<void> initInfo() async {
    var androidInitialize = initializationSettingsAndroid;
    var iosInitialize = const DarwinInitializationSettings();
    var initializationSettings = InitializationSettings(
      android: androidInitialize,
      iOS: iosInitialize,
    );

    flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveBackgroundNotificationResponse: backgroundHandler,
      /// to fire action after tap on notification in Foreground
      onDidReceiveNotificationResponse: _onNotificationTap,
    );

    await _firebaseMessaging.setForegroundNotificationPresentationOptions(
      alert: true,
      badge: true,
      sound: true,
    );

    // Listen for messages when the app is in foreground
    FirebaseMessaging.onMessage.listen((RemoteMessage message) async {
      print('🔔 [FOREGROUND] Notification reçue en premier plan');
      print('🔔 [FOREGROUND] Titre: ${message.notification?.title ?? "Pas de titre"}');
      print('🔔 [FOREGROUND] Corps: ${message.notification?.body ?? "Pas de corps"}');
      print('🔔 [FOREGROUND] Data: ${message.data}');
      _showNotification(message);
    });

    // Handling when the app is opened from a notification when in background or terminated
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      log("App opened from notification: ${message.notification?.title ?? "No Title"}");
      log("App opened from notification: ${message.notification?.body ?? "No Body"}");

      // Log all notification data
      if (message.data.isNotEmpty) {
        message.data.forEach((key, value) {
          log("Data: $key = $value");
        });
      }

      // You can also print the entire message for debugging purposes
      log("Full Message: ${message.toMap()}");
      _navigateToNotificationScreen(message);
    });

    // Handling when the app is launched from a terminated state due to a notification
    _firebaseMessaging.getInitialMessage().then((message) {
      if (message != null) {
        log("App launched from terminated state due to notification: ${message
            .notification?.title}");
        _navigateToNotificationScreen(message);
      }
    });

  }


  // Helper function to show notifications
  Future<void> _showNotification(RemoteMessage message) async {
    BigTextStyleInformation bigTextStyleInformation = BigTextStyleInformation(
      message.notification!.body.toString(),
      htmlFormatBigText: true,
      contentTitle: message.notification!.title.toString(),
      htmlFormatContentTitle: true,
    );
    final notification = message.notification;
    AndroidNotificationDetails androidPlatformChannelSpecifics =
    AndroidNotificationDetails(
      'high_importance_channel', // id
      'High Importance Notifications', // title
      importance: Importance.max,
      priority: Priority.max,
      styleInformation: bigTextStyleInformation,
      playSound: true,
      timeoutAfter: 5000,
    );

    NotificationDetails platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
      iOS: const DarwinNotificationDetails(
        presentAlert: true,
        presentBadge: true,
        presentSound: true,
      ),
    );

    await flutterLocalNotificationsPlugin.show(
      notification.hashCode,
      message.notification?.title,
      message.notification?.body,
      platformChannelSpecifics,
      payload: jsonEncode(message.data),
    );
  }

  // This method is called when a notification is tapped
  void _onNotificationTap(NotificationResponse response) async{

    if (response.payload != null) {
      if(response.payload!.contains('.pdf')){
        String filePath = response.payload!;
        await OpenFile.open(filePath, type: 'application/pdf');
      }
      else {
        var data = jsonDecode(response.payload!);
        log('$data << data  response.payload >>${response.payload}${response
            .id} <<id  response.input>> ${response.input}');
        _navigateToNotificationScreenFromPayload(data);
      }

    }
  }

  /// Navigate to NotificationScreen from notification tap (for foreground/background cases)
  void _navigateToNotificationScreen(RemoteMessage message) {
    /*notificationData = message.data;
    //{request_type: hr_letter, user_id: 81, model: hr.letter, notification_id: 1134, request_id: 12}
    if (MainScreen.navigatorKey.currentState != null) {
      // Pop to LayoutScreen if it's already in the stack
      MainScreen.navigatorKey.currentState!
          .popUntil((route) => route.settings.name != '/LayoutScreen');

      /// Push LayoutScreen with the first page index (0) and the notification data
      MainScreen.navigatorKey.currentState!.pushNamed(
        '/LayoutScreen',
        arguments: {
          'initialPage': 0, // Set the initial page to 0
          'notificationData': message.data,
        },
      );
    }*/
  }

  /// Navigate to NotificationScreen from notification payload (for terminated cases)
  void _navigateToNotificationScreenFromPayload(Map<String, dynamic> data) {
    /*MainScreen.navigatorKey.currentState?.pushNamed(
      '/LayoutScreen',
      arguments: {
        'initialPage': 0, // Set the initial page to 0
        'notificationData': data,
      },
    );*/
  }



  void createProgressNotification(int id, int progress, int maxProgress) {
    if (Platform.isIOS) {
      if (progress == 0 || progress == 100) {
        var iosDetails = const DarwinNotificationDetails(
          presentAlert: false,
          presentBadge: false,
          presentSound: false,
        );

        var platformChannelSpecifics = NotificationDetails(iOS: iosDetails);
        flutterLocalNotificationsPlugin.show(
          id,
          'File Saving Progress',
          'Progress: $progress%',
          platformChannelSpecifics,
        );
      }
      return;
    }

    var androidPlatformChannelSpecifics = AndroidNotificationDetails(
      'progress_channel',
      'File Download',
      channelDescription: 'Shows the progress of file downloads',
      channelShowBadge: false,
      importance: Importance.low,
      priority: Priority.low,
      onlyAlertOnce: true,
      showProgress: true,
      maxProgress: maxProgress,
      playSound: false,
      enableVibration: false,
      progress: progress,
    );

    var platformChannelSpecifics = NotificationDetails(
      android: androidPlatformChannelSpecifics,
    );

    flutterLocalNotificationsPlugin.show(
      id,
      'Saving PDF',
      'Saving in progress...',
      platformChannelSpecifics,
    );
  }

  void showSuccessNotification(int id, String fileName, String filePath) {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'success_channel',
      'Download Complete',
      channelDescription: 'Shows when a file download is complete',
      importance: Importance.max,
      priority: Priority.high,
      playSound: true,
    );

    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);

    flutterLocalNotificationsPlugin.show(
      id,
      'Download Complete',
      'File saved as: $fileName',
      platformChannelSpecifics,
      payload: filePath,
    );
  }

  void showErrorNotification(int id, String errorMessage) {
    var androidPlatformChannelSpecifics = const AndroidNotificationDetails(
      'error_channel',
      'Download Error',
      channelDescription: 'Shows when an error occurs during a file download',
      importance: Importance.max,
      priority: Priority.high,
    );

    var platformChannelSpecifics =
    NotificationDetails(android: androidPlatformChannelSpecifics);
    flutterLocalNotificationsPlugin.show(
      id,
      'Download Failed',
      errorMessage,
      platformChannelSpecifics,
    );
  }

}