import 'package:flutter/material.dart';
import 'package:team_manager_application/services/auth_service.dart';


// Page class for both login and sign up depending on argument 'isLogin'
class AuthPage extends StatefulWidget {
  final bool isLogin;

  const AuthPage({super.key, required this.isLogin});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {

  // Set text style for text fields in the page
  final TextStyle textFieldStyle = const TextStyle(
    fontFamily: 'Whitney',
    fontSize: 16,
    color: Color.fromRGBO(255, 255, 255, 0.3),
  );


  // Define variables

  // Variable to check whether password is currently visible
  var passwordVisible = false;

  // Variable to check whether confirm password is currently visible
  var passwordConfirmVisible = false;

  // Check if the active button is pressed
  var activeIsPressed = false;

  // Check if the passive button is pressed
  var passiveIsPressed = false;

  // Controller for relevant text fields
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  // List of belts users are able to select
  List<String> beltSelection = ["white", "yellow", "blue", "red", "black"];

  // Variable to check the belt level selected by the user
  String? selectedBelt;


  @override
  Widget build(BuildContext context) {

    // Set constant height for all buttons for the page
    double buttonHeight = MediaQuery.sizeOf(context).height * 0.06;

    return Scaffold(
      // Background colour for the page
      backgroundColor: Theme.of(context).colorScheme.tertiary,

      // App bar for page, change title value depending on whether page is for login or not
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: widget.isLogin ? const Text('Log In') : const Text("Sign Up"),

        // Create a back button to go back to the previous page
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),

      // Page body
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 10),

              // Check whether page is for sign up, if so add name text field
              !widget.isLogin
                  ? TextField(
                      controller: _nameController,
                      decoration: InputDecoration(
                        hintText: "Name",
                        hintStyle: textFieldStyle,
                      ),
                    )
                  : Container(),
              !widget.isLogin ? const Spacer(flex: 1) : Container(),

              // Email text field
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: textFieldStyle,
                ),
              ),
              const Spacer(flex: 1),

              // Password text field
              TextField(
                controller: _passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: textFieldStyle,

                  // Add toggle visibility icon to allow user to check the password they have typed
                  suffixIcon: IconButton(
                    icon: Icon(
                      passwordVisible ? Icons.visibility : Icons.visibility_off,
                      color: Theme.of(context).colorScheme.primary,
                    ),
                    onPressed: () {
                      setState(() {
                        passwordVisible = !passwordVisible;
                      });
                    },
                  ),
                ),
              ),

              // Check whether page is for sign up, if so add confirm password text field
              !widget.isLogin ? const Spacer(flex: 1) : Container(),
              !widget.isLogin
                  ? TextField(
                      controller: _passwordConfirmController,
                      obscureText: !passwordConfirmVisible,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        hintStyle: textFieldStyle,

                        // Add toggle visibility icon to allow user to check the confirm password they have typed
                        suffixIcon: IconButton(
                          icon: Icon(
                            passwordConfirmVisible
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Theme.of(context).colorScheme.primary,
                          ),
                          onPressed: () {
                            setState(() {
                              passwordConfirmVisible = !passwordConfirmVisible;
                            });
                          },
                        ),
                      ),
                    )
                  : Container(),

              // Check whether page is for sign up, if so add belt level dropdown selection
              !widget.isLogin ? const Spacer(flex: 1) : Container(),
              !widget.isLogin
                  ? SizedBox(
                      width: double.infinity,
                      child: DropdownButtonFormField<String>(
                        decoration: InputDecoration(
                          hintText: "Belt Level",
                          hintStyle: textFieldStyle,
                        ),
                        value: null,
                        items: beltSelection
                            .map((item) => DropdownMenuItem<String>(
                                  value: item,
                                  child: FittedBox(
                                    child: Text(
                                      item,
                                      style:
                                          Theme.of(context).textTheme.bodyLarge,
                                    ),
                                  ),
                                ))
                            .toList(),

                        // set the selected belt variable depending on user selection
                        onChanged: (item) =>
                            setState(() => selectedBelt = item),
                      ),
                    )
                  : Container(),
              const Spacer(flex: 1),

              // Add text button to send password reset email
              TextButton(
                child: Text(
                  "Forgot your password?",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),

                // Run functin to send password reset email when pressed
                onPressed: () {
                  AuthService.forgotPassword(context: context);
                },
              ),
              const Spacer(flex: 2),


              // Active button, login if page is for login and vice versa
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    activeIsPressed = !activeIsPressed;
                  });

                  // Sign up or log in the user depending on page type
                  // Use variable values as collected through text fields
                  widget.isLogin
                      ? await AuthService.logIn(
                          context: context,
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                        )
                      : AuthService.signUp(
                          name: _nameController.text.trim(),
                          belt: selectedBelt,
                          context: context,
                          email: _emailController.text.trim(),
                          password: _passwordController.text.trim(),
                          confirmPassword: _passwordConfirmController.text.trim(),
                        );

                  // Determine when active button has been pressed
                  setState(() {
                    activeIsPressed = !activeIsPressed;
                  });
                },

                
                // Active button style, changing depending on whether it has been pressed
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonHeight * 0.2),
                  ),
                  backgroundColor: activeIsPressed
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
                ),

                // Label active button depending on page type
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text(widget.isLogin ? "Log In" : "Sign Up",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),

              // Divider between active and passive buttons
              const Spacer(flex: 1),
              Row(
                children: <Widget>[
                  const Expanded(
                    child: Divider(),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("OR",
                        style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const Expanded(
                    child: Divider(),
                  ),
                ],
              ),

              // // Active button, sign up if page is for login and vice versa
              const Spacer(flex: 1),
              ElevatedButton(
                onPressed: () {

                  // Button is pressed
                  setState(() {
                    passiveIsPressed = !passiveIsPressed;
                  });

                  // Route to other auth page when pressed
                  String nextAction =
                      widget.isLogin ? '/signup_page' : '/login_page';
                  Navigator.pushReplacementNamed(context, nextAction);

                  // Button no longer pressed
                  setState(() {
                    passiveIsPressed = !passiveIsPressed;
                  });
                },

                // Passive button style, changing depending on whether it has been pressed
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonHeight * 0.2),
                  ),
                  backgroundColor: passiveIsPressed
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.tertiary,
                ),

                // Label passive button depending on page type
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text(widget.isLogin ? "Sign Up" : "Log In",
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
