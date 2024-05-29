import 'package:flutter/material.dart';
import 'package:ma_bibliotheque_flutter/components/components.dart';
import 'package:ma_bibliotheque_flutter/screens/home_screen.dart';
import 'package:ma_bibliotheque_flutter/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ma_bibliotheque_flutter/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ma_bibliotheque_flutter/service/auth_service.dart';
import 'package:ma_bibliotheque_flutter/constants.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _formkey = GlobalKey<FormState>();
  late String _name;
  late String _firstname;
  late String _gender;
  late String _email;
  late String _password;
  late String _confirmPass;

  bool _saving = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final List<String> _genderOptions = ['Homme', 'Femme'];
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();
  DateTime _dateOfBirth = DateTime.now();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Abonnez vous"),
        backgroundColor: Colors.yellow,
      ),
      backgroundColor: Colors.white,
      body: LoadingOverlay(
        isLoading: _saving,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const ScreenTitle(title: 'Sign Up'),
                          CustomTextField(
                            hintText: 'Nom',
                            controller: _nameController,
                            onChanged: (value) {
                              _name = value;
                            },
                            icon: Icons.person,
                          ),
                          CustomTextField(
                            hintText: 'Prenom',
                            controller: _firstnameController,
                            onChanged: (value) {
                              _firstname = value;
                            },
                            icon: Icons.person,
                          ),

                          DropdownButtonFormField<String>(
                            decoration: InputDecoration(
                              hintText: 'Sexe',
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(40),
                                borderSide: BorderSide(width: 2.5, color: kTextColor),
                              ),
                              prefixIcon: const Icon(Icons.person, color: kTextColor),
                            ),
                            items: _genderOptions.map((String value) {
                              return DropdownMenuItem<String>(
                                value: value,
                                child: Text(value),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _gender = value!;
                              });
                            },
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Tu dois sélectionner un sexe';
                              }
                              return null;
                            },
                          ),



                          CustomDateTimeField(
                            hintText: 'Date de naissance',
                            validator: (DateTime? value) {
                              if (value == null) {
                                return 'Tu dois saisir une date de naissance';
                              }
                              return null;
                            },
                            onChanged: (DateTime? value) {
                              if (value != null) {
                                setState(() {
                                  _dateOfBirth = value;
                                });
                              }
                            },
                          ),
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
                            obscureText: true,
                            onChanged: (value) {
                              _password = value;
                            },
                            icon: Icons.lock,
                          ),
                          CustomTextField(
                            hintText: 'Confirm Password',
                            controller: _confirmPassController,
                            obscureText: true,
                            onChanged: (value) {
                              _confirmPass = value;
                            },
                            icon: Icons.lock,
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
                          const Text(
                            'Abonne toi avec ton compte google',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              AuthService().signInWithGoogle(context);
                            },
                            child: Image.asset(
                              'asset/images/google_logo.png', // Assurez-vous d'avoir le logo Google dans vos assets
                              height: 50,
                            ),
                          ),
                          CustomBottomScreen(
                            textButton: 'Sign Up',
                            heroTag: 'signup_btn',
                            question: 'Have an account?',
                            buttonPressed: () async {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  _saving = true;
                                });
                                try {
                                  final email = _emailController.text;
                                  final password = _passwordController.text;

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(content: Text("Envoie en cours...")),
                                  );

                                  // Créer un nouvel utilisateur avec Firebase Authentication
                                  UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
                                    email: email,
                                    password: password,
                                  );

                                  // Ajouter des informations supplémentaires à Firestore
                                  CollectionReference lecteurref = FirebaseFirestore.instance.collection('lecteur');
                                  await lecteurref.add({
                                    "nom": _nameController.text,
                                    "prenom": _firstnameController.text,
                                    "date_de_naissance": _dateOfBirth,
                                    "sexe": _gender,
                                    "email": email,
                                    "userId": userCredential.user!.uid, // Utiliser l'ID utilisateur généré par Firebase Auth
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
                            questionPressed: () async {
                              Navigator.pushNamed(context, LoginScreen.id);
                            },
                          ),
                        ],
                      ),
                    ),
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
