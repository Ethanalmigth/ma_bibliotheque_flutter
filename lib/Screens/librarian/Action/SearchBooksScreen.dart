import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class SearchBooksScreen extends StatefulWidget {
  static const String id = 'search_books_screen';

  @override
  _SearchBooksScreenState createState() => _SearchBooksScreenState();
}

class _SearchBooksScreenState extends State<SearchBooksScreen> {
  String query = '';
  List<QueryDocumentSnapshot> searchResults = [];
  bool isLoading = false;

  void searchBooks() async {
    if (query.isNotEmpty) {
      setState(() {
        isLoading = true;
      });

      try {
        User? user = FirebaseAuth.instance.currentUser;
        if (user != null) {
          final results = await FirebaseFirestore.instance
              .collection('books')
              .where('added_by', isEqualTo: user.uid)
              .where('title', isGreaterThanOrEqualTo: query)
              .where('title', isLessThanOrEqualTo: query + '\uf8ff')
              .get();
          setState(() {
            searchResults = results.docs;
          });
        }
      } catch (e) {
        // Gérer les erreurs ici
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Erreur lors de la recherche: $e')),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    } else {
      setState(() {
        searchResults = [];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rechercher un livre'),
        backgroundColor: Colors.yellow,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                hintText: 'Entrez le titre du livre',
                suffixIcon: IconButton(
                  icon: Icon(Icons.search),
                  onPressed: searchBooks,
                ),
              ),
              onChanged: (value) {
                setState(() {
                  query = value;
                });
              },
              onSubmitted: (value) {
                searchBooks();
              },
            ),
            const SizedBox(height: 20),
            isLoading
                ? CircularProgressIndicator()
                : Expanded(
              child: ListView.builder(
                itemCount: searchResults.length,
                itemBuilder: (context, index) {
                  final book = searchResults[index];
                  final title = book['title'];
                  final author = book['author'];
                  final description = book['description'];

                  return Card(
                    margin: EdgeInsets.all(10),
                    elevation: 5,
                    child: ListTile(
                      leading: FlutterLogo(size: 56),
                      title: Text(title),
                      subtitle: Text('Auteur: $author\nDescription: $description'),
                      trailing: IconButton(
                        icon: Icon(Icons.delete),
                        onPressed: () async {
                          try {
                            await FirebaseFirestore.instance.collection('books').doc(book.id).delete();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Livre supprimé')),
                            );
                            searchBooks();
                          } catch (e) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Erreur lors de la suppression: $e')),
                            );
                          }
                        },
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
