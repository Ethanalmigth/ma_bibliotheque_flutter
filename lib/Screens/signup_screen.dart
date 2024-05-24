import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ma_bibliotheque_flutter/components/components.dart';
import 'package:ma_bibliotheque_flutter/screens/home_screen.dart';
import 'package:ma_bibliotheque_flutter/screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ma_bibliotheque_flutter/constants.dart';
import 'package:loading_overlay/loading_overlay.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});
  static String id = 'signup_screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _auth = FirebaseAuth.instance;
  final _formkey =GlobalKey<FormState>();
  late String _name;
  late String _firstname;
  late String _email;
  late String _password;
  late String _confirmPass;
  bool _saving = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstnameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.popAndPushNamed(context, HomeScreen.id);
        return true;
      },
      child: Scaffold(
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
                      padding: const EdgeInsets.symmetric(
                        horizontal: 15,
                      ),
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
                            ),

                            CustomTextField(
                              hintText: 'Prenom',
                              controller: _firstnameController,
                              onChanged: (value) {
                                _firstname = value;
                              },
                            ),
                            CustomTextField(
                              hintText: 'Email',
                              controller: _emailController,
                              onChanged: (value) {
                                _email = value;
                              },
                            ),
                            CustomTextField(
                              hintText: 'Password',
                              controller: _passwordController,
                              obscureText: true,
                              onChanged: (value) {
                                _password = value;
                              },
                            ),
                            CustomTextField(
                              hintText: 'Confirm Password',
                              controller: _confirmPassController,
                              obscureText: true,
                              onChanged: (value) {
                                _confirmPass = value;
                              },
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
                            CustomBottomScreen(
                              textButton: 'Sign Up',
                              heroTag: 'signup_btn',
                              question: 'Have an account?',
                              buttonPressed: () async {
                                if(_formkey.currentState!.validate()){
                                  final nom = _nameController.text;
                                  final prenom = _firstnameController.text;
                                  final email = _emailController.text;
                                  final password= _passwordController.text;
                                  final confpass= _confirmPassController.text;
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      const SnackBar(content: Text("Envoie en cours..."))
                                  );
                                  FocusScope.of(context).requestFocus(FocusNode());
                                  print("Il s'appele $nom $prenom son email est $email");
                                  print("Son mots de passe est $password il a confirmer avec $confpass");
                                }
                                /*
                                FocusManager.instance.primaryFocus?.unfocus();
                                setState(() {
                                  _saving = true;
                                });
                                if (_confirmPass == _password) {
                                  try {
                                    await _auth.createUserWithEmailAndPassword(
                                        email: _email, password: _password);

                                    if (context.mounted) {
                                      signUpAlert(
                                        context: context,
                                        title: 'GOOD JOB',
                                        desc: 'Go login now',
                                        btnText: 'Login Now',
                                        onPressed: () {
                                          setState(() {
                                            _saving = false;
                                            Navigator.popAndPushNamed(
                                                context, SignUpScreen.id);
                                          });
                                          Navigator.pushNamed(
                                              context, LoginScreen.id);
                                        },
                                      ).show();
                                    }
                                  } catch (e) {
                                    signUpAlert(
                                        context: context,
                                        onPressed: () {
                                          SystemNavigator.pop();
                                        },
                                        title: 'SOMETHING WRONG',
                                        desc: 'Close the app and try again',
                                        btnText: 'Close Now');
                                  }
                                } else {
                                  showAlert(
                                      context: context,
                                      title: 'WRONG PASSWORD',
                                      desc:
                                      'Make sure that you write the same password twice',
                                      onPressed: () {
                                        Navigator.pop(context);
                                      }).show();
                                }*/
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
      ),
    );
  }
}