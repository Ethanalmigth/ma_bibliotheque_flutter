import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class WelcomeScreen extends StatefulWidget {
  static const String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  String userName = '';
  String secondName="";

  @override
  void initState() {
    super.initState();
    getUserName();
  }

  Future<void> getUserName() async {
    final User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userDoc = await FirebaseFirestore.instance
          .collection('lecteur')
          .doc(user.uid)
          .get();
      if (userDoc.exists) {
        final userData = userDoc.data();
        setState(() {
          userName = userData?['nom'] ?? 'Utilisateur';
          secondName= userData?['prenom'] ?? 'Utilisateur';
        });
      } else {
        setState(() {
          userName = 'Utilisateur';
        });
      }
    } else {
      setState(() {
        userName = 'Utilisateur';
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Accueil'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              FirebaseAuth.instance.signOut();
              Navigator.pop(context);
            },
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Action de recherche
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                '$userName $secondName',
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              // Ajoutez ici vos sections et widgets pour afficher les livres, etc.
            ],
          ),
        ),
      ),
    );
  }
}