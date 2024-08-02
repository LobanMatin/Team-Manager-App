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

// Main function running Application
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialise Firebase authentication with default options
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  // Run the application
  runApp(const TeamApp());
}

// Application root
class TeamApp extends StatelessWidget {
  const TeamApp({super.key});
  
  @override
  Widget build(BuildContext context) {

    // Set App name, colorscheme and text theme
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'MUTKD APP',
      theme: ThemeData(
        colorScheme: appColourScheme,
        useMaterial3: true,
        textTheme: appTextTheme,
      ),

      // Define possible routes/pages for the application
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

      // Change initial route depending on whether they are logged in and verified
      initialRoute: AuthService.hasUser()
          ? (FirebaseAuth.instance.currentUser!.emailVerified
              // Display content page if user is logged in and verified
              ? '/content_page'
              // Display email verification page if user is not verified
              : '/verify_page')

          // Display start page if user is not logged in
          : '/start_page',
    );
  }
}
