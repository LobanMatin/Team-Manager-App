import 'package:flutter/material.dart';
import 'package:team_manager_application/services/auth_service.dart';

class AuthPage extends StatefulWidget {
  final bool isLogin;

  const AuthPage({super.key, required this.isLogin});

  @override
  State<AuthPage> createState() => _AuthPageState();
}

class _AuthPageState extends State<AuthPage> {
  final TextStyle textFieldStyle = const TextStyle(
    fontFamily: 'Whitney',
    fontSize: 16,
    color: Color.fromRGBO(255, 255, 255, 0.3),
  );

  var passwordVisible = false;
  var passwordConfirmVisible = false;
  var activeIsPressed = false;
  var passiveIsPressed = false;
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _passwordConfirmController = TextEditingController();

  List<String> beltSelection = ["white", "yellow", "blue", "red", "black"];
  String? selectedBelt;

  @override
  Widget build(BuildContext context) {
    double buttonHeight = MediaQuery.sizeOf(context).height * 0.06;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: widget.isLogin ? const Text('Log In') : const Text("Sign Up"),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 10),
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
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: "Email",
                  hintStyle: textFieldStyle,
                ),
              ),
              const Spacer(flex: 1),
              TextField(
                controller: _passwordController,
                obscureText: !passwordVisible,
                decoration: InputDecoration(
                  hintText: "Password",
                  hintStyle: textFieldStyle,
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
              !widget.isLogin ? const Spacer(flex: 1) : Container(),
              !widget.isLogin
                  ? TextField(
                      controller: _passwordConfirmController,
                      obscureText: !passwordConfirmVisible,
                      decoration: InputDecoration(
                        hintText: "Confirm Password",
                        hintStyle: textFieldStyle,
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
                        onChanged: (item) =>
                            setState(() => selectedBelt = item),
                      ),
                    )
                  : Container(),
              const Spacer(flex: 1),
              TextButton(
                child: Text(
                  "Forgot your password?",
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                onPressed: () {
                  AuthService.forgotPassword(context: context);
                },
              ),
              const Spacer(flex: 2),
              ElevatedButton(
                onPressed: () async {
                  setState(() {
                    activeIsPressed = !activeIsPressed;
                  });

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
                  setState(() {
                    activeIsPressed = !activeIsPressed;
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonHeight * 0.2),
                  ),
                  backgroundColor: activeIsPressed
                      ? Theme.of(context).colorScheme.onPrimary
                      : Theme.of(context).colorScheme.primary,
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text(widget.isLogin ? "Log In" : "Sign Up",
                      style: Theme.of(context).textTheme.bodyLarge),
                ),
              ),
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
              const Spacer(flex: 1),
              ElevatedButton(
                onPressed: () {
                  setState(() {
                    passiveIsPressed = !passiveIsPressed;
                  });

                  String nextAction =
                      widget.isLogin ? '/signup_page' : '/login_page';
                  Navigator.pushReplacementNamed(context, nextAction);

                  setState(() {
                    passiveIsPressed = !passiveIsPressed;
                  });
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonHeight * 0.2),
                  ),
                  backgroundColor: passiveIsPressed
                      ? Theme.of(context).colorScheme.secondary
                      : Theme.of(context).colorScheme.tertiary,
                ),
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
