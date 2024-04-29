import 'dart:html';

import 'package:flutter/material.dart';

class Signout extends StatefulWidget {
  @override
  SignoutState createState() => SignoutState();
}

class SignoutState extends State<Signout> {
  // final MsalConfig _msal = MsalConfig.construct();

  @override
  initState() {
    super.initState();
  }

  Future<void> _logout(BuildContext context) async {
    try {
      var logoutUrl =
          'https://login.microsoftonline.com/common/oauth2/logout?post_logout_redirect_uri=http://localhost:8000/logout/';

      // Redirect the user to the logout URL
      window.location.href = logoutUrl;
      //await _msal.logout();
    } catch (e) {
      print('Error logging out: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: ElevatedButton(
      onPressed: () async {
        await _logout(context);
        // Add the code to sign out the user
      },
      child: const Text('Sign out'),
    ));
  }
}
