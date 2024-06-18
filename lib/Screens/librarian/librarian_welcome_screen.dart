import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/Action/AddBookScreen.dart';
import 'package:ma_bibliotheque_flutter/Screens/librarian/Action/ViewBooksScreen.dart';


class LibrarianWelcomeScreen extends StatefulWidget {
  static String id = 'librarian_welcome_screen';

  @override
  _LibrarianWelcomeScreenState createState() => _LibrarianWelcomeScreenState();
}

class _LibrarianWelcomeScreenState extends State<LibrarianWelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String libraryName = "";
  String libraryDescription = "";
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    fetchLibraryDetails();
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

  void fetchLibraryDetails() async {
    if (loggedInUser != null) {
      DocumentSnapshot doc = await FirebaseFirestore.instance
          .collection('bibliothecaires')
          .doc(loggedInUser.uid)
          .get();

      if (doc.exists) {
        setState(() {
          libraryName = doc['nom'] ?? 'Bibliothèque';
          libraryDescription = doc['description'] ?? '';
        });
      }
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      LibrarianHomeScreen(libraryName: libraryName, libraryDescription: libraryDescription),
      StatisticsScreen(),
      AnnouncementsScreen(),
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text('Bienvenue, $libraryName'),
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
      body: _widgetOptions.elementAt(_selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Accueil',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.bar_chart),
            label: 'Statistiques',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.announcement),
            label: 'Annonces',
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.amber[800],
        onTap: _onItemTapped,
      ),
    );
  }
}

class LibrarianHomeScreen extends StatelessWidget {
  final String libraryName;
  final String libraryDescription;

  LibrarianHomeScreen({required this.libraryName, required this.libraryDescription});

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bienvenue, $libraryName',
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

class StatisticsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Statistiques',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

class AnnouncementsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        'Annonces',
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}
