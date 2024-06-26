import 'package:flutter/material.dart';
import 'package:ma_bibliotheque_flutter/components/components.dart';
import 'package:ma_bibliotheque_flutter/Screens/User/login_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/User/signup_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/librarian_signup_screen.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/librarian_login_screen.dart';
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});
  static String id = 'home_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("La bibliotheque du peuple"),
        backgroundColor: Colors.yellow,
      ),
      backgroundColor: Color(0xFFF4E6C0),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const TopScreenImage(screenImageName: 'bible_to.jpg'),
              SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(right: 15.0, left: 15, bottom: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      const ScreenTitle(title: 'Hello'),
                      const Text(
                        "Venez le monde des livres et du savoir n'attend que vous",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 20,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      Hero(
                        tag: 'login_btn',
                        child: CustomButton(
                          buttonText: 'Login',
                          onPressed: () {
                            Navigator.pushNamed(context, LoginScreen.id);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Hero(
                        tag: 'signup_btn',
                        child: CustomButton(
                          buttonText: 'Sign Up',
                          isOutlined: true,
                          onPressed: () {
                           Navigator.pushNamed(context, SignUpScreen.id);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Hero(
                        tag: 'librarian_signup_btn',
                        child: CustomButton(
                          buttonText: 'Sign Up as Librarian',
                          isOutlined: true,
                          onPressed: () {
                            Navigator.pushNamed(context, LibrarianSignUpScreen.id);
                          },
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Hero(
                        tag: 'librarian_login_btn',
                        child: CustomButton(
                          buttonText: 'Login as Librarian',
                          isOutlined: true,
                          onPressed: () {
                            Navigator.pushNamed(context, LibrarianLoginScreen.id);
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}