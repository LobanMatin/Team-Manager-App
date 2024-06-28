import 'package:flutter/material.dart';
import 'package:team_manager_application/assets/colours.dart';
import 'package:team_manager_application/assets/text.dart';
import 'package:team_manager_application/pages/login_page.dart';

void main() {
  runApp(const TeamApp());
}

class TeamApp extends StatelessWidget {
  const TeamApp({super.key});
  // Application root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: appColourScheme,
        useMaterial3: true,
        textTheme: appTextTheme,
      ),
      routes: {'/login_page': (context) => const LoginPage()},
      initialRoute: '/login_page',
    );
  }
}
