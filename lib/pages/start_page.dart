import 'package:flutter/material.dart';

// Start Page for users that need to sign up or log in
class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {
  @override
  Widget build(BuildContext context) {
    // Constant height for all buttons for the page
    double buttonHeight = MediaQuery.sizeOf(context).height * 0.06;

    // Button style for both registration and login buttons
    ButtonStyle buttonStyle = ElevatedButton.styleFrom(
      minimumSize: Size.fromHeight(buttonHeight),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(buttonHeight * 0.2),
      ),
      backgroundColor: Theme.of(context).colorScheme.secondary,
    );

    return Scaffold(
      // Page background colour
      backgroundColor: Theme.of(context).colorScheme.tertiary,

      // Set title
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("MUTKD APP"),
      ),

      body: Center(
        // Set page padding
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              // Gap between top of page and buttons
              const Spacer(flex: 20),

              // Button to route to login page
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login_page');
                },
                style: buttonStyle,
                child: Text(
                  "Log in",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),

              // Gap between login and sign up buttons
              const Spacer(flex: 1),

              // Sign up button to route to registration page
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup_page');
                },
                style: buttonStyle,
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text("Sign Up",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
