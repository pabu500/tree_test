import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
//import html as html
import 'auth/login.dart';
import 'model/user_model.dart';
import 'utils/util.dart';
import 'widget/signout.dart';
//

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: const FirebaseOptions(
        apiKey: "AIzaSyAfcSlN6BB1tNIJr0PZ2BzLVyrpnmXOO0Q",
        authDomain: "sso-eab51.firebaseapp.com",
        projectId: "sso-eab51",
        storageBucket: "sso-eab51.appspot.com",
        messagingSenderId: "745293441367",
        appId: "1:745293441367:web:14ddc5865297ef3acb3612",
        measurementId: "G-9BBWP27N0B"),
  ).then((value) => listenFirebaseUser());

  runApp(const MindMapApp());
}

class MindMapApp extends StatelessWidget {
  const MindMapApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      initialRoute: '/',
      routes: {
        '/': (context) => const Login(),
        '/signout': (context) => Signout(),
        '/logout/': (context) => const Login(),
      },
    );
  }
}
