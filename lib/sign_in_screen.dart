import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SignInScreen extends StatelessWidget {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  Future<User?> _handleSignIn() async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      final UserCredential authResult =
          await _auth.signInWithCredential(credential);
      final User? user = authResult.user;
      return user;
    } catch (error) {
      print("Error signing in with Google: $error");
      Fluttertoast.showToast(
        msg: "Sign-in error: $error",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: Stack(
        fit: StackFit.expand,
        children: [
          // Background Image
          Image.asset(
            'assets/images/eth_logo.png',
            fit: BoxFit.cover,
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20.0, vertical: 20),
                child: Image.asset(
                  'assets/images/EthFlix.png',
                  color: Colors
                      .white, // Replace 'background_image.jpg' with your asset image path
                  fit: BoxFit.fitWidth,
                ),
              ),
              SizedBox(
                height: 30,
              ),
              ElevatedButton.icon(
                onPressed: () async {
                  final User? user = await _handleSignIn();
                  if (user != null) {
                    // Navigate to the main app screen or do other actions.
                    Navigator.pushReplacementNamed(context, '/home');
                    // You can also save user information in Firebase Firestore or Realtime Database.
                    print("User signed in with Google: ${user.displayName}");
                    Fluttertoast.showToast(
                      msg: "Hello! ${user.displayName}",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.green,
                      textColor: Colors.white,
                    );
                  } else {
                    // Handle sign-in error.
                    //give a toast
                    Fluttertoast.showToast(
                      msg: "Sign-in error",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.CENTER,
                      timeInSecForIosWeb: 1,
                      backgroundColor: Colors.red,
                      textColor: Colors.white,
                    );
                  }
                },
                icon: FaIcon(
                  FontAwesomeIcons.google,
                  size: 30,
                ),
                label: Text(
                  "Sign In with Google",
                  style: TextStyle(fontSize: 20),
                ),
                style: ButtonStyle(
                  foregroundColor: MaterialStateProperty.all(Colors.black),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all(StadiumBorder()),
                  padding: MaterialStateProperty.all(EdgeInsets.all(10.0)),
                ),
              ),
            ],
          ),
        ],
      )),
    );
  }
}
