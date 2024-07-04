import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  static Future<void> signUp({required BuildContext context, required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .createUserWithEmailAndPassword(
            email: email,
            password: password
            );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(context, '/content_page', (Route route) => false);

    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email';
      }
      
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  static Future<void> logIn({required BuildContext context, required String email, required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(
            email: email,
            password: password
            );

      await Future.delayed(const Duration(seconds: 1));
      Navigator.pushNamedAndRemoveUntil(context, '/content_page', (Route route) => false);
      
    } on FirebaseAuthException catch(e) {
      String message = '';
      if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user';
      }
      
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  static Future<void> signOut({
    required BuildContext context
  }) async {

    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));

    Navigator.pushReplacementNamed(context, '/start_page');
  }
}
