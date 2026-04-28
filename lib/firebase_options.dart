import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart'
    show TargetPlatform, defaultTargetPlatform, kIsWeb;

class DefaultFirebaseOptions {
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions are not configured for web in this project.',
      );
    }

    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
      case TargetPlatform.windows:
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not configured for this platform.',
        );
      case TargetPlatform.fuchsia:
        throw UnsupportedError(
          'DefaultFirebaseOptions are not supported for Fuchsia.',
        );
    }
  }

  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyB5nrbKDR2wegki2IHjRRNCCoAD8FL2S1o',
    appId: '1:364628625664:android:dd37f7a5a4384c0bdf0be5',
    messagingSenderId: '364628625664',
    projectId: 'pinterest-clone-7ff5a',
    storageBucket: 'pinterest-clone-7ff5a.firebasestorage.app',
  );

  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyB2zII_7MUYcWl3TzT46SibbRlQDtFtcQA',
    appId: '1:364628625664:ios:2d1ecb55d58b48fedf0be5',
    messagingSenderId: '364628625664',
    projectId: 'pinterest-clone-7ff5a',
    storageBucket: 'pinterest-clone-7ff5a.firebasestorage.app',
    iosBundleId: 'com.anshu.pinterestclone.pinterestClone',
  );
}
