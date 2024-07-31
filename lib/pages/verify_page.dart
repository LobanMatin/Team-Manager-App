import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_manager_application/pages/content_page.dart';
import 'package:team_manager_application/services/auth_service.dart';

class VerifyPage extends StatefulWidget {
  const VerifyPage({super.key});
  @override
  State<VerifyPage> createState() => _VerifyPageState();
}

class _VerifyPageState extends State<VerifyPage> {
  Timer? timer;
  bool isEmailVerified = false;
  bool canResendEmail = false;

  @override
  void initState() {
    super.initState();
    sendVerificationEmail();

    timer = Timer.periodic(
      const Duration(seconds: 3),
      (_) => checkEmailVerified(),
    );
  }

  @override
  void dispose() async {
    timer?.cancel;
    super.dispose();
  }

  Future checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser!.reload();

    if (mounted) {
      setState(
        () {
          isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
        },
      );
      if (isEmailVerified) timer?.cancel();
    }
  }

  Future sendVerificationEmail() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (mounted && user != null) {
      await user.sendEmailVerification();

      setState(() => canResendEmail = false);
      await Future.delayed(const Duration(seconds: 3));
      setState(() => canResendEmail = true);
      //TODO: Add error handling
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
                  icon: const Icon(Icons.email, size: 32),
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
