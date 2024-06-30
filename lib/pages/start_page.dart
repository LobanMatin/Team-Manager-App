import 'package:flutter/material.dart';

class StartPage extends StatefulWidget {
  const StartPage({super.key});

  @override
  State<StartPage> createState() => _StartPageState();
}

class _StartPageState extends State<StartPage> {

  @override
  Widget build(BuildContext context) {
    double buttonHeight = MediaQuery.sizeOf(context).height * 0.06;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        title: const Text("TeamApp"),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(50.0, 50.0, 50.0, 80.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Spacer(flex: 20),


              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login_page');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonHeight * 0.2),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
                child: Text(
                  "Log in",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ),


              const Spacer(flex: 1),


              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/signup_page');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonHeight * 0.2),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.secondary,
                ),
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
