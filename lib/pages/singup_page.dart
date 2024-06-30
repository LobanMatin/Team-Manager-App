import 'package:flutter/material.dart';

class SingUpPage extends StatefulWidget {
  const SingUpPage({super.key});

  @override
  State<SingUpPage> createState() => _SingUpPageState();
}

class _SingUpPageState extends State<SingUpPage> {
  @override
  Widget build(BuildContext context) {
    double buttonHeight = MediaQuery.sizeOf(context).height * 0.06;

    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.tertiary,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          title: const Text('Sign Up'),
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

              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login_page');
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: Size.fromHeight(buttonHeight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(buttonHeight * 0.2),
                  ),
                  backgroundColor: Theme.of(context).colorScheme.primary,
                ),
                child: FittedBox(
                  fit: BoxFit.cover,
                  child: Text("Sign Up",
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
                    child: Text("OR", style: Theme.of(context).textTheme.bodySmall),
                  ),
                  const Expanded(
                    child: Divider(),
                  ),
                ],
              ),
              const Spacer(flex: 1),


              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.pushNamed(context, '/login_page');
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
                  child: Text("Log In",
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