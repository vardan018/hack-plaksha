import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

Future initFirebase() async {
  if (kIsWeb) {
    await Firebase.initializeApp(
        options: FirebaseOptions(
            apiKey: "AIzaSyChtsrKRdNiIPyfgXQr3WZGz7kGrPCSE0Q",
            authDomain: "wavelength-4d2e8.firebaseapp.com",
            projectId: "wavelength-4d2e8",
            storageBucket: "wavelength-4d2e8.appspot.com",
            messagingSenderId: "418915064727",
            appId: "1:418915064727:web:8769c322757ace110f42d2",
            measurementId: "G-KYJBK28RQ6"));
  } else {
    await Firebase.initializeApp();
  }
}
