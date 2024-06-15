// File generated by FlutterFire CLI.
// ignore_for_file: type=lint
import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Default [FirebaseOptions] for use with your Firebase apps.
///
/// Example:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
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
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for linux - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyAlTNQ7AnsoPiHziug34v22JVskysa_VoU',
    appId: '1:357585279556:web:1075b7c092a10aea893a11',
    messagingSenderId: '357585279556',
    projectId: 'flutterproj-a6076',
    authDomain: 'flutterproj-a6076.firebaseapp.com',
    storageBucket: 'flutterproj-a6076.appspot.com',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCULKfaijRtzdY3zlLupGRUu7Zi2jXU7Q4',
    appId: '1:357585279556:android:1c6505c91625cc86893a11',
    messagingSenderId: '357585279556',
    projectId: 'flutterproj-a6076',
    storageBucket: 'flutterproj-a6076.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCrQooMSjlLvihLXguddxUtWrC5_kJYWDo',
    appId: '1:357585279556:ios:0e4e70b611acf905893a11',
    messagingSenderId: '357585279556',
    projectId: 'flutterproj-a6076',
    storageBucket: 'flutterproj-a6076.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyCrQooMSjlLvihLXguddxUtWrC5_kJYWDo',
    appId: '1:357585279556:ios:0e4e70b611acf905893a11',
    messagingSenderId: '357585279556',
    projectId: 'flutterproj-a6076',
    storageBucket: 'flutterproj-a6076.appspot.com',
    iosBundleId: 'com.example.flutterApplication1',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyAlTNQ7AnsoPiHziug34v22JVskysa_VoU',
    appId: '1:357585279556:web:caa8ead433c81d42893a11',
    messagingSenderId: '357585279556',
    projectId: 'flutterproj-a6076',
    authDomain: 'flutterproj-a6076.firebaseapp.com',
    storageBucket: 'flutterproj-a6076.appspot.com',
  );
}
