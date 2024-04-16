// File generated by FlutterFire CLI.
// ignore_for_file: lines_longer_than_80_chars, avoid_classes_with_only_static_members
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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
          'you can reconfigure this by running the FlutterFire CLI again.',
        );
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
    apiKey: 'AIzaSyBd2J_5fdXL8JgO7-tYDk7nmlpV4lsEb0s',
    appId: '1:962368014904:web:fc96947de6aa0445ba74cd',
    messagingSenderId: '962368014904',
    projectId: 'apneaaware',
    authDomain: 'apneaaware.firebaseapp.com',
    databaseURL: 'https://apneaaware-default-rtdb.firebaseio.com',
    storageBucket: 'apneaaware.appspot.com',
    measurementId: 'G-CTRMHML4K7',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyA7j8MMlF8Jzhf6QDROiplG29enaiEO_lc',
    appId: '1:962368014904:android:0f1e7e0d9707ae87ba74cd',
    messagingSenderId: '962368014904',
    projectId: 'apneaaware',
    databaseURL: 'https://apneaaware-default-rtdb.firebaseio.com',
    storageBucket: 'apneaaware.appspot.com',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfEl19nyk-qJqgoOetYMm7neAIFaSaREw',
    appId: '1:962368014904:ios:fdfdf99ac076d592ba74cd',
    messagingSenderId: '962368014904',
    projectId: 'apneaaware',
    databaseURL: 'https://apneaaware-default-rtdb.firebaseio.com',
    storageBucket: 'apneaaware.appspot.com',
    iosBundleId: 'com.example.apneaAware',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBfEl19nyk-qJqgoOetYMm7neAIFaSaREw',
    appId: '1:962368014904:ios:62aa8e3ac9b88524ba74cd',
    messagingSenderId: '962368014904',
    projectId: 'apneaaware',
    databaseURL: 'https://apneaaware-default-rtdb.firebaseio.com',
    storageBucket: 'apneaaware.appspot.com',
    iosBundleId: 'com.example.apneaAware.RunnerTests',
  );
}