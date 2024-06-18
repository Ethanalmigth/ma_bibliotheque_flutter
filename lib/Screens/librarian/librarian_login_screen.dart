import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ma_bibliotheque_flutter/components/components.dart';
import 'package:ma_bibliotheque_flutter/constants.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/librarian_signup_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/librarian_welcome_screen.dart';

class LibrarianLoginScreen extends StatefulWidget {
  static String id = 'librarian_login_screen';

  @override
  _LibrarianLoginScreenState createState() => _LibrarianLoginScreenState();
}

class _LibrarianLoginScreenState extends State<LibrarianLoginScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Connexion Bibliothécaire'),
        backgroundColor: Colors.yellow,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ScreenTitle(title: 'Connexion Bibliothécaire'),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Email',
                  controller: _emailController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre email';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                CustomTextField(
                  hintText: 'Mot de passe',
                  controller: _passwordController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre mot de passe';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: CustomBottomScreen(
                    textButton: 'Connexion',
                    heroTag: 'login_btn',
                    question: 'Vous n\'avez pas de compte?',
                    buttonPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        setState(() {
                          _saving = true;
                        });
                        try {
                          final email = _emailController.text;
                          final password = _passwordController.text;

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text("Connexion en cours...")),
                          );

                          UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                            email: email,
                            password: password,
                          );

                          DocumentSnapshot doc = await FirebaseFirestore.instance
                              .collection('bibliothecaires')
                              .doc(userCredential.user!.uid)
                              .get();
                          if (doc.exists) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Connexion réussie!")),
                            );
                            Navigator.pushNamed(context, LibrarianWelcomeScreen.id);
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text("Erreur: Compte non trouvé.")),
                            );
                          }
                        } catch (e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text("Erreur: $e")),
                          );
                        } finally {
                          setState(() {
                            _saving = false;
                          });
                        }
                      }
                    },
                    questionPressed: () {
                      Navigator.pushNamed(context, LibrarianSignUpScreen.id);
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
