import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ma_bibliotheque_flutter/components/components.dart';
import 'package:ma_bibliotheque_flutter/constants.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/librarian_login_screen.dart';
import 'package:ma_bibliotheque_flutter/screens/home_screen.dart';

class LibrarianSignUpScreen extends StatefulWidget {
  static String id = 'librarian_signup_screen';

  @override
  _LibrarianSignUpScreenState createState() => _LibrarianSignUpScreenState();
}

class _LibrarianSignUpScreenState extends State<LibrarianSignUpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  final TextEditingController _libraryDescController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _saving = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Inscription Bibliothécaire'),
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
                const ScreenTitle(title: 'Inscription'),
                const SizedBox(height: 20),
                CustomTextField(
                  hintText: 'Nom',
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Veuillez entrer votre nom';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
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
                CustomTextField(
                  hintText: 'Confirmer Mot de passe',
                  controller: _confirmPassController,
                  obscureText: true,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Tu dois saisir quelque chose';
                    }
                    if (value != _passwordController.text) {
                      return 'Les mots de passe ne correspondent pas';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 30),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(40),
                    border: Border.all(width: 2.5, color: kTextColor),
                  ),
                  child: TextFormField(
                    controller: _libraryDescController,
                    maxLines: 5,  // Ajout de lignes multiples pour le champ de description
                    decoration: InputDecoration(
                      hintText: 'Description de la bibliothèque',
                      border: InputBorder.none,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Veuillez entrer la description de la bibliothèque';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 20),
                CustomBottomScreen(
                  textButton: 'Inscription',
                  heroTag: 'signup_btn',
                  question: 'Vous avez un compte?',
                  buttonPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() {
                        _saving = true;
                      });
                      try {
                        final email = _emailController.text;
                        final password = _passwordController.text;

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Envoi en cours...")),
                        );

                        UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                          email: email,
                          password: password,
                        );

                        // Utilisation du `uid` comme identifiant de document
                        DocumentReference docRef = FirebaseFirestore.instance
                            .collection('bibliothecaires')
                            .doc(userCredential.user!.uid);

                        await docRef.set({
                          "nom": _nameController.text,
                          "email": email,
                          "userId": userCredential.user!.uid,
                          "description": _libraryDescController.text,
                        });

                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text("Inscription réussie!")),
                        );
                        Navigator.pushNamed(context, HomeScreen.id);
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
                    Navigator.pushNamed(context, LibrarianLoginScreen.id);
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
