import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: const FirebaseOptions(
            apiKey: "AIzaSyDB_F8NcHPnFGMjHqSyJSmv3V8o46YzlR4",
            authDomain: "placement-gcxahj.firebaseapp.com",
            projectId: "placement-gcxahj",
            storageBucket: "placement-gcxahj.appspot.com",
            messagingSenderId: "1056052903221",
            appId: "1:1056052903221:web:1e8cde9f0062f28ba2207c"));
  } else {
    await Firebase.initializeApp();
  }
}
