import 'dart:async';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_manager_application/pages/content_page.dart';
import 'package:team_manager_application/services/auth_service.dart';


// Verification Page for users that have not verified their email
class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});
  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {

  // Define variable to track when user has verified
  Timer? timer;
  bool isEmailVerified = false;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    // Send verification email on page start up
    sendVerificationEmail();

    // Check if email has been verified every three seconds
    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );
  }


  // Once email has been verified, dispose of timer
  @override
  void dispose() async {
    timer?.cancel;
    super.dispose();
  }

  // Function to refresh user status and check if email has been verified
  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    // Update when email has been verified
    if (mounted) {
      setState(
        () {
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        },
      );

      // Cancel timer if email has been verified
      if (isEmailVerified) timer?.cancel();
    }
  }

  // Async function to send verification email
  Future sendVerificationEmail() async {

    // Get current user and send verification email
    final User? user = FirebaseAuth.instance.currentUser;
    if (mounted && user != null) {
      await user.sendEmailVerification();

      // Allow for verification emial to be resent every 15 seconds
      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 15));
      setState(() => canResendEmail = true);
    }
  }

  @override
  Widget build(BuildContext context) => isEmailVerified
      ? const ContentPage()
      : Scaffold(
          backgroundColor: Theme.of(context).colorScheme.tertiary,
          appBar: AppBar(
            title: const Text("Verify Email"),
            backgroundColor: Colors.transparent,
          ),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'A verification email has been sent to you email.',
                  style: Theme.of(context).textTheme.bodyLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    minimumSize: const Size.fromHeight(50),
                  ),
                  icon: const Icon(Icons.email, size: 32, color: Colors.white),
                  label: Text("Resend Email",
                      style: Theme.of(context).textTheme.bodyLarge),
                  onPressed: canResendEmail ? sendVerificationEmail : null,
                ),
                const SizedBox(height: 8),
                TextButton(
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(50),
                    ),
                    child: Text(
                      "Cancel",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    onPressed: () => AuthService.signOut(
                          context: context,
                        )),
              ],
            ),
          ),
        );
}
