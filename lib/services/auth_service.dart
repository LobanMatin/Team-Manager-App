import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class AuthService {
  static Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String? belt,
  }) async {
    try {
      if (FirebaseAuth.instance.currentUser != null) {
        if (email == '' ||
            password == '' ||
            confirmPassword == '' ||
            name == '' ||
            belt == null) {
          throw InvalidSignUpException('Please fill in all fields', email,
              password, confirmPassword, name, belt.toString());
        } else if (password != confirmPassword) {
          throw InvalidSignUpException("Confirm password does not match", email,
              password, confirmPassword, name, belt);
        }

        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String id = FirebaseAuth.instance.currentUser!.uid;
        DatabaseReference dbRef = FirebaseDatabase.instance.ref("users/$id");
        await dbRef.set(
          {
            "name": name,
            "belt": belt,
            "admin": false,
          },
        );

        if (!FirebaseAuth.instance.currentUser!.emailVerified) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/verify_page', (Route route) => false);
        } else {
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushNamedAndRemoveUntil(
              context, '/content_page', (Route route) => false);
        }
      }
    } on FirebaseAuthException catch (e) {
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
    } on InvalidSignUpException catch (e) {
      Fluttertoast.showToast(
        msg: e.message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );
    }
  }

  static Future<void> logIn(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/verify_page', (Route route) => false);
      } else {
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushNamedAndRemoveUntil(
            context, '/content_page', (Route route) => false);
      }
    } on FirebaseAuthException catch (e) {
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

  static Future<void> signOut({required BuildContext context}) async {
    await Navigator.pushNamedAndRemoveUntil(
        context, '/start_page', ModalRoute.withName('/'));
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
  }

  static Future<bool> emailVerified() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.emailVerified;
    } else {
      return false;
    }
  }

  static Future<void> forgotPassword({required BuildContext context}) async {
    final emailController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Forgot Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "Please enter your email address to be sent a verification email."),
            TextField(
              controller: emailController,
              cursorColor: Theme.of(context).colorScheme.onSecondary,
              autofocus: true,
              decoration: InputDecoration(
                hintText: "account email",
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
                focusedBorder: UnderlineInputBorder(
                  borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.onSecondary),
                ),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            child: Text(
              "Submit",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
            onPressed: () async {
              try {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: emailController.text.trim());
                Navigator.of(context).pop();

                Fluttertoast.showToast(
                  msg: "Verification Email Sent if Account Exists",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.SNACKBAR,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 14.0,
                );
              } on FirebaseAuthException catch (e) {
                Fluttertoast.showToast(
                  msg: e.code,
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.SNACKBAR,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 14.0,
                );
              }
            },
          ),
        ],
      ),
    );
  }

  static bool hasUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}

class InvalidSignUpException implements Exception {
  final String message;
  final String email;
  final String password;
  final String confirmPassword;
  final String name;
  final String belt;

  InvalidSignUpException(
    this.message,
    this.email,
    this.password,
    this.confirmPassword,
    this.name,
    this.belt,
  );

  @override
  String toString() =>
      "InvalidSignUpException{email: $email, password: $password, confirm password: $confirmPassword, name: $name, belt: $belt}";
}
