// IMPORTANT: This file contains placeholder Firebase configuration.
// To use this app with real Firebase, run:
//
//   dart pub global activate flutterfire_cli
//   flutterfire configure --project=YOUR_FIREBASE_PROJECT_ID
//
// Then replace this file with the generated one.
//
// Firebase Console: https://console.firebase.google.com

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) return web;
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
        throw UnsupportedError('Linux is not configured for Firebase.');
      default:
        throw UnsupportedError('Unsupported platform for Firebase.');
    }
  }

  // TODO: Replace all placeholder values below with your actual Firebase config.
  static const FirebaseOptions web = FirebaseOptions(
    apiKey: 'YOUR_WEB_API_KEY',
    appId: 'YOUR_WEB_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.firebasestorage.app',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyCP91GXQbdSrzHMUXxL4Cjzeq9XZgWBbD0',
    appId: '1:681065586207:android:f179132c028a7bcb14bf2a',
    messagingSenderId: '681065586207',
    projectId: 'flutter-productivity-app',
    storageBucket: 'flutter-productivity-app.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBXYLT8ZXb6j_gH_MdRRIwjUAWAThBFjL4',
    appId: '1:681065586207:ios:9a37eb95d0b6632114bf2a',
    messagingSenderId: '681065586207',
    projectId: 'flutter-productivity-app',
    storageBucket: 'flutter-productivity-app.firebasestorage.app',
    iosBundleId: 'com.productivitypro.productivityPro',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'YOUR_MACOS_API_KEY',
    appId: 'YOUR_MACOS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    storageBucket: 'YOUR_PROJECT_ID.firebasestorage.app',
    iosBundleId: 'com.productivitypro.productivityPro',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'YOUR_WINDOWS_API_KEY',
    appId: 'YOUR_WINDOWS_APP_ID',
    messagingSenderId: 'YOUR_MESSAGING_SENDER_ID',
    projectId: 'YOUR_PROJECT_ID',
    authDomain: 'YOUR_PROJECT_ID.firebaseapp.com',
    storageBucket: 'YOUR_PROJECT_ID.firebasestorage.app',
  );
}