import 'package:flutter/material.dart';
import 'package:ma_bibliotheque_flutter/Screens/home_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/User/login_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/User/signup_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/User/welcome.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/librarian_signup_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/librarian_login_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/Librarian/librarian_welcome_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/Action/AddBookScreen.dart'; // Assurez-vous d'importer l'écran d'ajout de livre
import 'package:ma_bibliotheque_flutter/Screens/librarian/Action/ViewBooksScreen.dart';




void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
          textTheme: const TextTheme(
            bodyMedium: TextStyle(
              fontFamily: 'Ubuntu',
            ),
          )),
      initialRoute: HomeScreen.id,
      routes: {
        HomeScreen.id: (context) =>    HomeScreen(),
        LoginScreen.id: (context) =>   LoginScreen(),
        SignUpScreen.id: (context) =>  SignUpScreen(),
        WelcomeScreen.id: (context) => WelcomeScreen(),
        LibrarianSignUpScreen.id: (context)=> LibrarianSignUpScreen(),
        LibrarianLoginScreen.id: (context) => LibrarianLoginScreen(),
        LibrarianWelcomeScreen.id: (context) => LibrarianWelcomeScreen(),
        AddBookScreen.id: (context) => AddBookScreen(),
        ViewBooksScreen.id: (context) => ViewBooksScreen(),

      },
    );
  }
}
