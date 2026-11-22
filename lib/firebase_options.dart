import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

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
    apiKey: 'AIzaSyDxYAbR-Ew_TghdWIO39MO0NEyL5JeTZQ4',
    appId: '1:271144923473:web:8db5b03ab1947f35556370',
    messagingSenderId: '271144923473',
    projectId: 'parcial-6115a',
    authDomain: 'parcial-6115a.firebaseapp.com',
    storageBucket: 'parcial-6115a.firebasestorage.app',
    measurementId: 'G-196X3ZP5HX',
  );

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAiM8P_t9hjH8L0-cGlN_5jZmUY0bLbE78',
    appId: '1:271144923473:android:4ae5795115a31e04556370',
    messagingSenderId: '271144923473',
    projectId: 'parcial-6115a',
    storageBucket: 'parcial-6115a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBNnKKWOc6dze18VLz01WXMl4I53uCxQRA',
    appId: '1:271144923473:ios:46fe30578e40d017556370',
    messagingSenderId: '271144923473',
    projectId: 'parcial-6115a',
    storageBucket: 'parcial-6115a.firebasestorage.app',
    iosBundleId: 'com.example.appParcial',
  );

  static const FirebaseOptions macos = FirebaseOptions(
    apiKey: 'AIzaSyBNnKKWOc6dze18VLz01WXMl4I53uCxQRA',
    appId: '1:271144923473:ios:46fe30578e40d017556370',
    messagingSenderId: '271144923473',
    projectId: 'parcial-6115a',
    storageBucket: 'parcial-6115a.firebasestorage.app',
    iosBundleId: 'com.example.appParcial',
  );

  static const FirebaseOptions windows = FirebaseOptions(
    apiKey: 'AIzaSyDxYAbR-Ew_TghdWIO39MO0NEyL5JeTZQ4',
    appId: '1:271144923473:web:c747621ffdad04d9556370',
    messagingSenderId: '271144923473',
    projectId: 'parcial-6115a',
    authDomain: 'parcial-6115a.firebaseapp.com',
    storageBucket: 'parcial-6115a.firebasestorage.app',
    measurementId: 'G-86MRXMD0LT',
  );
}
