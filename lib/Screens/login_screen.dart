import 'package:flutter/material.dart';
import 'package:ma_bibliotheque_flutter/components/components.dart';
import 'package:ma_bibliotheque_flutter/constants.dart';
import 'package:ma_bibliotheque_flutter/screens/welcome.dart';
import 'package:loading_overlay/loading_overlay.dart';
import 'package:ma_bibliotheque_flutter/screens/home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  static String id = 'login_screen';

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;
  final _formkey =GlobalKey<FormState>();
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
          title: Text("Connecter vous"),
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
                            'Connecte toi avec ton compte google',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 16,
                            ),
                          ),
                          IconButton(
                            onPressed: () {},
                            icon: CircleAvatar(
                              radius: 25,
                              child: Image.asset(
                                  'asset/images/google_logo.png'),
                            ),
                          ),
                          CustomBottomScreen(
                            textButton: 'Login',
                            heroTag: 'login_btn',
                            question: 'Forgot password?',
                            buttonPressed: () async {
                                  if(_formkey.currentState!.validate()){
                                    final email= _emailController.text;
                                    final pass= _passwordController.text;
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        const SnackBar(content: Text("Envoie en cours..."))
                                    );
                                    FocusScope.of(context).requestFocus(FocusNode());
                                    print("Son est email $email et son mot de passe est $pass ");
                                  }

                              FocusManager.instance.primaryFocus?.unfocus();
                              setState(() {
                                _saving = true;
                              });
                              try {
                                await _auth.signInWithEmailAndPassword(
                                    email: _email, password: _password);

                                if (context.mounted) {
                                  setState(() {
                                    _saving = false;
                                    Navigator.popAndPushNamed(
                                        context, LoginScreen.id);
                                  });
                                  Navigator.pushNamed(context, WelcomeScreen.id);
                                }
                              } catch (e) {
                                signUpAlert(
                                  context: context,
                                  onPressed: () {
                                    setState(() {
                                      _saving = false;
                                    });
                                    Navigator.popAndPushNamed(
                                        context, LoginScreen.id);
                                  },
                                  title: 'WRONG PASSWORD OR EMAIL',
                                  desc:
                                  'Confirm your email and password and try again',
                                  btnText: 'Try Now',
                                ).show();
                              }
                            },
                            questionPressed: () {
                              signUpAlert(
                                onPressed: () async {
                                  await FirebaseAuth.instance
                                      .sendPasswordResetEmail(email: _email);
                                },
                                title: 'RESET YOUR PASSWORD',
                                desc:
                                'Click on the button to reset your password',
                                btnText: 'Reset Now',
                                context: context,
                              ).show();
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