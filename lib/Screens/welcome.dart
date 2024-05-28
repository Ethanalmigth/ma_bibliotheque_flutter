import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:ma_bibliotheque_flutter/components/components.dart';
import 'package:ma_bibliotheque_flutter/screens/home_screen.dart';
class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Welcome"),
      ),
    );
  }
}