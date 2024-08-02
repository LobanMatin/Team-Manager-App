import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:team_manager_application/assets/colours.dart';
import 'package:team_manager_application/assets/text.dart';
import 'package:team_manager_application/pages/content_page.dart';
import 'package:team_manager_application/pages/auth_page.dart';
import 'package:team_manager_application/pages/start_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:team_manager_application/pages/verify_page.dart';
import 'package:team_manager_application/services/auth_service.dart';
import 'firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  runApp(const TeamApp());
}

class TeamApp extends StatelessWidget {
  const TeamApp({super.key});
  // Application root
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MUTKD APP',
      theme: ThemeData(
        colorScheme: appColourScheme,
        useMaterial3: true,
        textTheme: appTextTheme,
      ),
      routes: {
        '/start_page': (context) => const StartPage(),
        '/login_page': (context) => const AuthPage(
              isLogin: true,
            ),
        '/signup_page': (context) => const AuthPage(
              isLogin: false,
            ),
        '/content_page': (context) => const ContentPage(),
        '/verify_page': (context) => const VerifyPage(),
      },
      initialRoute: AuthService.hasUser()
          ? (FirebaseAuth.instance.currentUser!.emailVerified
              ? '/content_page'
              : '/verify_page')
          : '/start_page',
    );
  }
}
