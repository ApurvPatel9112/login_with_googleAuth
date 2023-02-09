// ignore_for_file: body_might_complete_normally_nullable

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:login/home_page.dart';
import 'package:login/screens/log_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  Future<void> signOutFromGoogle(BuildContext context) async {
    try {
      await _auth.signOut();
      await _googleSignIn.signOut().then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Loginpage()));
      });
    } catch (e) {
      print(e);
    }
  }

  Future<String?> signInwithGoogle(BuildContext context) async {
    try {
      final GoogleSignInAccount? googleSignInAccount =
          await _googleSignIn.signIn();
      final GoogleSignInAuthentication googleSignInAuthentication =
          await googleSignInAccount!.authentication;
      final AuthCredential credential = GoogleAuthProvider.credential(
        accessToken: googleSignInAuthentication.accessToken,
        idToken: googleSignInAuthentication.idToken,
      );
      await _auth.signInWithCredential(credential).then((value) {
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => HomePage()));
      });
    } on FirebaseAuthException catch (e) {
      print(e.message);
      throw e;
    }
  }
}
