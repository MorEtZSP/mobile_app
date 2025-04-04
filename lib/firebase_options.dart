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
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for macos - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions have not been configured for windows - '
              'you can reconfigure this by running the FlutterFire CLI again.',
        );
      case TargetPlatform.linux:
        return linux; // Добавляем возвращаемое значение для Linux
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCcydgYw1F8NNkJ89VrPkkDQaVYLKImksE',
    appId: '1:857365457327:android:fd37f288d6316b55bc675a',
    messagingSenderId: '857365457327',
    projectId: 'mobile-app-959da',
    storageBucket: 'mobile-app-959da.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyCXBAdA5kwoEBX3UiBg4zSAwZDkQT2UuGQ',
    appId: '1:857365457327:ios:72e5e8087738a89ebc675a',
    messagingSenderId: '857365457327',
    projectId: 'mobile-app-959da',
    storageBucket: 'mobile-app-959da.firebasestorage.app',
    iosBundleId: 'com.example.mobileApp',
  );

  static const FirebaseOptions linux = FirebaseOptions(  // Конфигурация для Linux
    apiKey: 'AIzaSyCcydgYw1F8NNkJ89VrPkkDQaVYLKImksE',
    appId: '1:857365457327:linux:fd37f288d6316b55bc675a',
    messagingSenderId: '857365457327',
    projectId: 'mobile-app-959da',
    storageBucket: 'mobile-app-959da.firebasestorage.app',
  );

  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'AIzaSyBZnrFRStn-OGogI7j51zLvpuqXe6Dh29w',
    appId: '1:857365457327:web:3d9605af95528353bc675a',
    messagingSenderId: '857365457327',
    projectId: 'mobile-app-959da',
    authDomain: 'mobile-app-959da.firebaseapp.com',
    storageBucket: 'mobile-app-959da.firebasestorage.app',
    measurementId: 'G-J1611TDQ8R',
  );

}