/*import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Book-Hub"),
          backgroundColor: Colors.blue,
          elevation: 24,
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.settings),
              onPressed: () {
                // Ajoute un bouton d'action à l'AppBar
              },
            ),
          ],
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                onPressed: () {
                  // Action pour l'inscription
                },
                child: const Text('S\'inscrire'),
              ),
              const SizedBox(height: 16.0),
              ElevatedButton(
                onPressed: () {
                  // Action pour la connexion
                },
                child: const Text('Se connecter'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}*/
import 'package:flutter/material.dart';
import 'package:ma_bibliotheque_flutter/Screens/home_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/login_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/signup_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/welcome.dart';
import 'package:firebase_core/firebase_core.dart';



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
      },
    );
  }
}
