import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


// Service to manage all authentication operations
class AuthService {

  // Function to sign up a user and add the relevant data to the app database
  static Future<void> signUp({
    required BuildContext context,
    required String email,
    required String password,
    required String confirmPassword,
    required String name,
    required String? belt,
  }) async {

    // Handle any authentication errors that occur during the sign up process
    try {
      if (FirebaseAuth.instance.currentUser != null) {

        // If any of the required field and missing throw an exception
        if (email == '' ||
            password == '' ||
            confirmPassword == '' ||
            name == '' ||
            belt == null) {
          throw InvalidSignUpException('Please fill in all fields', email,
              password, confirmPassword, name, belt.toString());

        // If the confirm password does not match the password throw an exception
        } else if (password != confirmPassword) {
          throw InvalidSignUpException("Confirm password does not match", email,
              password, confirmPassword, name, belt);
        }

        // Create a user with the provided data
        await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: email, password: password);

        String id = FirebaseAuth.instance.currentUser!.uid;

        // Add the relevant data to the database
        DatabaseReference dbRef = FirebaseDatabase.instance.ref("users/$id");
        await dbRef.set(
          {
            "name": name,
            "belt": belt,

            // admin rights for user can be set manuall through the database
            "admin": false,
          },
        );

        // If the user does not have a verified email, route to verification page
        if (!FirebaseAuth.instance.currentUser!.emailVerified) {
          Navigator.pushNamedAndRemoveUntil(
              context, '/verify_page', (Route route) => false);
        
        // If the user has a verified email, route to content page
        } else {
          await Future.delayed(const Duration(seconds: 1));
          Navigator.pushNamedAndRemoveUntil(
              context, '/content_page', (Route route) => false);
        }
      }
      // On authentication exception handle the errors and show a toast message
    } on FirebaseAuthException catch (e) {

      // Set error message depending on error code
      String message = '';
      if (e.code == 'weak-password') {
        message = 'The password is too weak';
      } else if (e.code == 'email-already-in-use') {
        message = 'An account already exists with that email';
      }

      // Show Firebase error messages as toast
      Fluttertoast.showToast(
        msg: message,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.SNACKBAR,
        backgroundColor: Colors.black54,
        textColor: Colors.white,
        fontSize: 14.0,
      );

      // Show other error messages as toast
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

  // Static function to login user, required their email and password
  static Future<void> logIn(
      {required BuildContext context,
      required String email,
      required String password}) async {
    try {

      // Try to sign in the user using the info provided
      await FirebaseAuth.instance
          .signInWithEmailAndPassword(email: email, password: password);

      // If the user is not verified, route to verification page
      if (!FirebaseAuth.instance.currentUser!.emailVerified) {
        Navigator.pushNamedAndRemoveUntil(
            context, '/verify_page', (Route route) => false);

      // If the user is verified, route to content page
      } else {
        await Future.delayed(const Duration(seconds: 1));
        Navigator.pushNamedAndRemoveUntil(
            context, '/content_page', (Route route) => false);
      }
    
    // On firebase exception when signing in catch the error
    } on FirebaseAuthException catch (e) {
      String message = '';

      // Set the error message depending on the error code
      if (e.code == 'user-not-found') {
        message = 'No user found for that email';
      } else if (e.code == 'wrong-password') {
        message = 'Wrong password provided for that user';
      }

      // Display error message as a toast
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


  // Function to sign out a user that is logged in
  static Future<void> signOut({required BuildContext context}) async {

    // Route the user to the start page and sign them out
    await Navigator.pushNamedAndRemoveUntil(
        context, '/start_page', ModalRoute.withName('/'));
    await FirebaseAuth.instance.signOut();
    await Future.delayed(const Duration(seconds: 1));
  }


  // Function to check if a logged in user has their email verified.
  static Future<bool> emailVerified() async {
    // Check if a user is logged in
    User? user = FirebaseAuth.instance.currentUser;

    // if logged in check if they are verified
    if (user != null) {
      return user.emailVerified;
    } else {
      return false;
    }
  }

  
  // Function to send user a reset password email in case they forget their password
  static Future<void> forgotPassword({required BuildContext context}) async {
    final emailController = TextEditingController();


    // Aler message to prompt user to enter account email
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Forgot Password"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
                "Please enter your email address to be sent a verification email."),


            // Text Field for user to enter their account email
            TextField(
              controller: emailController,
              cursorColor: Theme.of(context).colorScheme.onSecondary,
              autofocus: true,

              // Text Field decoration
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

        // Bottom Button to confirm submission of email
        actions: [
          TextButton(
            child: Text(
              "Submit",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            // Try to send a password reset email when submit is pressed
            onPressed: () async {
              try {
                await FirebaseAuth.instance
                    .sendPasswordResetEmail(email: emailController.text.trim());
                Navigator.of(context).pop();

                // Alert the user that a verification email has been sent
                Fluttertoast.showToast(
                  msg: "Verification Email Sent if Account Exists",
                  toastLength: Toast.LENGTH_LONG,
                  gravity: ToastGravity.SNACKBAR,
                  backgroundColor: Colors.black54,
                  textColor: Colors.white,
                  fontSize: 14.0,
                );

              // Catch any errors during the password reset process and display a message
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

// Function to check if a logged in user exists
  static bool hasUser() {
    User? user = FirebaseAuth.instance.currentUser;
    return user != null;
  }
}


// Custom exception for when signing up user
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

  // String messgae for easier debugging
  @override
  String toString() =>
      "InvalidSignUpException{email: $email, password: $password, confirm password: $confirmPassword, name: $name, belt: $belt}";
}
