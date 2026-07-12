import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show defaultTargetPlatform, kIsWeb, TargetPlatform;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions have not been configured for web - '
        'this app targets Android only.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for this platform.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyAdNntqbUx-2ghGqR8KnDzmt1j8GyZNzrM',
    appId: '1:340027641957:android:801473cfafea7d07c0f68c',
    messagingSenderId: '340027641957',
    projectId: 'aluconnect-alu',
    storageBucket: 'aluconnect-alu.firebasestorage.app',
  );
}
