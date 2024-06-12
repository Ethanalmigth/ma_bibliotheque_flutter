import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ma_bibliotheque_flutter/constants.dart';

class LibrarianWelcomeScreen extends StatefulWidget {
  static String id = 'librarian_welcome_screen';

  @override
  _LibrarianWelcomeScreenState createState() => _LibrarianWelcomeScreenState();
}

class _LibrarianWelcomeScreenState extends State<LibrarianWelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String libraryDescription = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchLibraryDescription();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
      }
    } catch (e) {
      print(e);
    }
  }

  void fetchLibraryDescription() async {
    if (loggedInUser != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('bibliothecaires')
          .doc(loggedInUser.uid)
          .get();

      if (doc.exists) {
        setState(() {
          libraryDescription = doc['description'] ?? '';
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Bienvenue Bibliothécaire'),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
              Navigator.pop(context);
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue, ${loggedInUser.email}',
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 20),
            Text(
              'Description de la bibliothèque:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              libraryDescription,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
