import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/Action/AddBookScreen.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/Action/ViewBooksScreen.dart';

class LibrarianHomeScreen extends StatelessWidget {
  final String libraryName;
  final String libraryDescription;

  LibrarianHomeScreen({required this.libraryName, required this.libraryDescription});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(020.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              'Description de la bibliothèque:',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            Text(
              libraryDescription,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Expanded(
              child: ListView(
                children: [
                  ListTile(
                    leading: Icon(Icons.book),
                    title: Text('Ajouter un livre'),
                    onTap: () {
                      Navigator.pushNamed(context, AddBookScreen.id);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.search),
                    title: Text('Rechercher un livre'),
                    onTap: () {
                      // Naviguez vers l'écran de recherche de livre
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.list),
                    title: Text('Liste des livres'),
                    onTap: () {
                      Navigator.pushNamed(context, ViewBooksScreen.id);
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.notifications),
                    title: Text('Notifications'),
                    onTap: () {
                      // Naviguez vers l'écran des notifications
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
