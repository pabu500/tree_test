import 'dart:async';
import 'dart:html';
import 'dart:js' as js;
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
// ignore: unused_import
import 'dart:html' as html;

import '../model/user_model.dart';

Future<void> revokeAccessToken(String url, BuildContext context) async {
  const logoutUrl =
      'https://login.microsoftonline.com/common/oauth2/v2.0/logout';

  js.context.callMethod('open', [logoutUrl, '_blank', 'width=600,height=400']);

  FirebaseAuth.instance.signOut();
}

Future<void> listenFirebaseUser() async {
  // Attempt to retrieve user credential

  if (FirebaseAuth.instance.currentUser == null) {
    if (window.location.href != loginUrl) {
      launchUrl(Uri.parse(loginUrl), webOnlyWindowName: '_self');
    }
  }
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      UserSession.isLoggedIn = false;
      UserSession.firebaseUid = "";
      UserSession.idToken = "";
      UserSession.credentialUid = "";
      UserSession.accessToken = "";

      if (window.location.href != loginUrl) {
        launchUrl(Uri.parse(loginUrl), webOnlyWindowName: '_self');
      }
    } else {
      User user = FirebaseAuth.instance.currentUser!;
      UserSession.firebaseUid = user.uid;
      UserSession.isLoggedIn = true;
    }
  });
}
