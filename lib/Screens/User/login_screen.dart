import 'package:flutter/material.dart';
import 'package:ma_bibliotheque_flutter/components/components.dart';
import 'package:ma_bibliotheque_flutter/screens/User/welcome.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ma_bibliotheque_flutter/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ma_bibliotheque_flutter/service/auth_service.dart'; // Importez votre AuthService

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  late String _email;
  late String _password;
  bool _saving = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text("Connectez-vous"),
          backgroundColor: Colors.yellow,
        ),
        backgroundColor: Colors.white,
        body: LoadingOverlay(
          isLoading: _saving,
          child: SafeArea(
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Expanded(
                    flex: 2,
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ScreenTitle(title: 'Login'),
                          CustomTextField(
                            hintText: 'Email',
                            controller: _emailController,
                            onChanged: (value) {
                              _email = value;
                            },
                            icon: Icons.email,
                          ),
                          CustomTextField(
                            hintText: 'Password',
                            controller: _passwordController,
                            onChanged: (value) {
                              _password = value;
                            },
                            icon: Icons.lock,
                          ),
                          const Text(
                            'Connectez-vous avec votre compte Google',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            onPressed: () async {
                              setState(() {
                                _saving = true;
                              });
                              try {
                                await AuthService().signInWithGoogle(context);
                              } catch (e) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text("Erreur: $e")),
                                );
                              } finally {
                                setState(() {
                                  _saving = false;
                                });
                              }
                            },
                            icon: CircleAvatar(
                              radius: 25,
                              child: Image.asset('asset/images/google_logo.png'),
                            ),
                          ),
                          CustomBottomScreen(
                            textButton: 'Login',
                            heroTag: 'login_btn',
                            question: 'Forgot password?',
                            buttonPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                final email = _emailController.text;
                                final pass = _passwordController.text;
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(content: Text("Envoi en cours...")),
                                );
                                FocusScope.of(context).requestFocus(FocusNode());
                                print("Son email est $email et son mot de passe est $pass ");

                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  _saving = true;
                                });
                                try {
                                  UserCredential userCredential = await _auth.signInWithEmailAndPassword(
                                    email: email,
                                    password: pass,
                                  );

                                  // Vérifier si l'utilisateur est un lecteur
                                  DocumentSnapshot userDoc = await FirebaseFirestore.instance
                                      .collection('lecteur')
                                      .doc(userCredential.user!.uid)
                                      .get();

                                  if (userDoc.exists) {
                                    // L'utilisateur est un lecteur, naviguer vers l'écran WelcomeScreen
                                    if (context.mounted) {
                                      Navigator.popAndPushNamed(context, WelcomeScreen.id);
                                    }
                                  } else {
                                    // L'utilisateur n'est pas un lecteur, afficher un message d'erreur
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
                              // Code pour la réinitialisation du mot de passe
                            },
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
