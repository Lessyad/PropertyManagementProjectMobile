// lib/firebase_options.dart
// GENERATED MANUALLY FOR MACINCLOUD
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      return web;
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        return macos;
      case TargetPlatform.windows:
        return windows;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  // ------------------- ANDROID -------------------
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAjz7yu80CTFdWRM08SzhfBTeRUB2ivDkk',
    appId: '1:363734642503:android:8eb4371b9de9587e65a662',
    messagingSenderId: '363734642503',
    projectId: 'enma-5090d',
    storageBucket: 'enma-5090d.firebasestorage.app',
  );

  // ------------------- IOS -------------------
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBn9Y06HbN55l5zNETuFoVyeWv6RmZFFqk',
    appId: '1:363734642503:ios:7a3dc9896f58985765a662',
    messagingSenderId: '363734642503',
    projectId: 'enma-5090d',
    iosBundleId: 'com.smpnt.enmaa',
    storageBucket: 'enma-5090d.firebasestorage.app',
  );

  // ------------------- MACOS -------------------
  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBn9Y06HbN55l5zNETuFoVyeWv6RmZFFqk',
    appId: '1:363734642503:ios:7a3dc9896f58985765a662',
    messagingSenderId: '363734642503',
    projectId: 'enma-5090d',
    iosBundleId: 'com.smpnt.enmaa',
    storageBucket: 'enma-5090d.firebasestorage.app',
  );

  // ------------------- WEB -------------------
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBn9Y06HbN55l5zNETuFoVyeWv6RmZFFqk',
    appId: '1:363734642503:web:dbf92188fbbe00d765a662',
    messagingSenderId: '363734642503',
    projectId: 'enma-5090d',
    authDomain: 'enma-5090d.firebaseapp.com',
    storageBucket: 'enma-5090d.firebasestorage.app',
  );

  // ------------------- WINDOWS -------------------
  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyBn9Y06HbN55l5zNETuFoVyeWv6RmZFFqk',
    appId: '1:363734642503:ios:7a3dc9896f58985765a662',
    messagingSenderId: '363734642503',
    projectId: 'enma-5090d',
    storageBucket: 'enma-5090d.firebasestorage.app',
  );
}


