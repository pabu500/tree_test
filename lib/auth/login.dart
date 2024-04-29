import 'dart:convert';

import 'package:aad_oauth/model/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:aad_oauth/aad_oauth.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:html' as html;
import '../model/user_model.dart';
import '../utils/util.dart';
import 'package:flutter_signin_button/flutter_signin_button.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  LoginState createState() => LoginState();
}

class LoginState extends State<Login> {
  late final Config config;
  late final AadOAuth oauth;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  initState() {
    super.initState();
  }

  @override
  dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  Future<void> verifyEmailAddress() async {
    try {
      String email =
          decodeEmailAddress(FirebaseAuth.instance.currentUser!.email!);
      // Define the URL of your Spring Boot backend
      const String url =
          'http://localhost:7222/verifyToken'; // Adjust the URL as needed

      // Define the headers for the HTTP request
      final Map<String, String> headers = {
        'Content-Type': 'application/json', // Content type of the request body
      };

      if (kDebugMode) {
        print(email);
      }
      // Define the body of the HTTP request (in JSON format)
      final Map<String, dynamic> body = {
        'email': email, // Pass the ID token as a parameter
      };

      // Send the HTTP POST request to your Spring Boot backend
      final http.Response response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: jsonEncode(body), // Encode the body as JSON
      );

      // Check if the request was successful (status code 200)
      if (response.statusCode == 200) {
        final jsonResponse = jsonDecode(response.body);

        setState(() {
          //isLoggedIn = jsonResponse['verified'] as bool;
          UserSession.isLoggedIn = jsonResponse['verified'];

          html.document.title = 'Sign Out';

          if (UserSession.isLoggedIn) {
            listenFirebaseUser();
            Navigator.pushReplacementNamed(context, '/signout');
          }
        });
      } else {
        if (kDebugMode) {
          print(
              'Failed to send ID token to Spring Boot: ${response.statusCode}');
        }
        // Handle the error response from the server if needed
      }
    } catch (e) {
      if (kDebugMode) {
        print('Error sending ID token to Spring Boot: $e');
      }
      // Handle any exceptions that occur during the request
    }
  }

  String decodeEmailAddress(String rawEmail) {
    List<String> emailList = rawEmail.split('#ext#');
    String email = emailList[0].replaceAll('_', '@');

    return email;
  }

  void loginWithMicrosoft(BuildContext context) async {
    try {
      UserSession.idToken = "";
      UserSession.firebaseUid = "";

      final OAuthProvider authProvider = OAuthProvider('microsoft.com');

      authProvider.setCustomParameters({
        'tenant': '8b19aa86-8724-4e0b-8200-41ae5e975ef5',
      });

      await Future.delayed(const Duration(seconds: 1));

      final UserCredential userCredential =
          await FirebaseAuth.instance.signInWithPopup(authProvider);

      if (userCredential.credential != null) {
        UserSession.accessToken = userCredential.credential!.accessToken;
      }

      final String? idToken =
          await FirebaseAuth.instance.currentUser!.getIdToken();

      if (idToken != null) {
        UserSession.credentialUid = userCredential.user!.uid;
        validateAccessToken();
      } else {
        if (kDebugMode) {
          print(idToken ?? "No Id token");
        }
      }
    } catch (e) {
      print('Microsoft login failed: $e');
      // Handle login failure
    }
  }

  Future<void> validateAccessToken() async {
    try {
      final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
      final IdTokenResult tokenResult =
          await firebaseAuth.currentUser!.getIdTokenResult();

      if (tokenResult.token != null) {
        UserSession.idToken = tokenResult.token;
        UserSession.firebaseUid = firebaseAuth.currentUser!.uid;
        verifyEmailAddress();
      }
    } catch (e) {
      // Token validation failed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          //title: const Text('Login'),
          ),
      body: Center(
        child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: SizedBox(
              width: MediaQuery.of(context).size.width,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Expanded(
                    child: SizedBox.shrink(),
                  ),
                  Expanded(
                      child: Container(
                    padding: EdgeInsets.symmetric(
                        horizontal: MediaQuery.of(context).size.width * 0.5 -
                            MediaQuery.of(context).size.width * 0.4),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextField(
                          controller: emailController,
                          decoration: const InputDecoration(
                            labelText: 'Username',
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextField(
                          obscureText: true,
                          controller: passwordController,
                          decoration: const InputDecoration(
                            labelText: 'Password',
                          ),
                        ),
                        const SizedBox(height: 80),
                        Container(
                          width: 250,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              // Handle login with username and password
                            },
                            child: const Text('Login'),
                          ),
                        ),
                        SizedBox(
                          height: 60,
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: Divider(
                            color: Colors.grey.withOpacity(0.5),
                            height: 1,
                          ),
                        ),
                        SignInButton(
                          padding: const EdgeInsets.symmetric(vertical: 20),
                          Buttons.Microsoft,
                          onPressed: () {
                            loginWithMicrosoft(context);
                          },
                        ),
                      ],
                    ),
                  ))
                ],
              ),
            )),
      ),
    );
  }
}
