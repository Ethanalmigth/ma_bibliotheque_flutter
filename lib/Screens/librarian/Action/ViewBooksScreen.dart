import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ViewBooksScreen extends StatelessWidget {
  static const String id = 'view_books_screen';

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      appBar: AppBar(
        title: Text('Mes Livres'),
        backgroundColor: Colors.yellow,
      ),
      body: user == null
          ? Center(child: Text('Utilisateur non connecté'))
          : StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('books')
            .where('added_by', isEqualTo: user.uid)
            .snapshots(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final books = snapshot.data!.docs;
          List<BookItem> bookItems = [];
          for (var book in books) {
            final id = book.id;
            final title = book['title'];
            final author = book['author'];
            final description = book['description'];

            final bookItem = BookItem(
              id: id,
              title: title,
              author: author,
              description: description,
            );

            bookItems.add(bookItem);
          }

          return ListView(
            children: bookItems,
          );
        },
      ),
    );
  }
}

class BookItem extends StatelessWidget {
  final String id;
  final String title;
  final String author;
  final String description;

  BookItem({
    required this.id,
    required this.title,
    required this.author,
    required this.description,
  });

  void deleteBook(BuildContext context) async {
    await FirebaseFirestore.instance.collection('books').doc(id).delete();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Livre supprimé')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(title),
      subtitle: Text('Auteur: $author\nDescription: $description'),
      trailing: IconButton(
        icon: Icon(Icons.delete),
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Confirmer la suppression"),
                content: Text("Êtes-vous sûr de vouloir supprimer ce livre ?"),
                actions: [
                  TextButton(
                    child: Text("Annuler"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                  TextButton(
                    child: Text("Supprimer"),
                    onPressed: () {
                      deleteBook(context);
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
      ),
    );
  }
}
