import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class WelcomeScreen extends StatefulWidget {
  static String id = 'welcome_screen';

  @override
  _WelcomeScreenState createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  late User loggedInUser;
  String userEmail = "";

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        setState(() {
          loggedInUser = user;
          userEmail = loggedInUser.email ?? '';
        });
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              _auth.signOut();
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
                'Bienvenue, $userEmail',
                style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 20),
              Section(
                title: 'New Arrivals',
                courses: [
                  Course(title: 'Learn Mobile App Development', image: 'assets/learn_mobile_app_dev.png'),
                  Course(title: 'Learn Mobile App Development', image: 'assets/learn_mobile_app_dev.png'),
                  Course(title: 'Flutter Recipes & Android', image: 'assets/flutter_recipes.png'),
                ],
              ),
              Section(
                title: 'Trending Courses',
                courses: [
                  Course(title: 'Fundamentals of Dart', image: 'assets/dart_fundamentals.png'),
                  Course(title: 'React Js Blueprints', image: 'assets/react_js_blueprints.png'),
                  Course(title: 'Ionic 2', image: 'assets/ionic2.png'),
                ],
              ),
              Section(
                title: 'Top Picks',
                courses: [
                  Course(title: 'Flutter Recipes', image: 'assets/flutter_recipes.png'),
                  Course(title: 'Flutter Recipes', image: 'assets/flutter_recipes.png'),
                  Course(title: 'React Js Blueprints', image: 'assets/react_js_blueprints.png'),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class Section extends StatelessWidget {
  final String title;
  final List<Course> courses;

  Section({required this.title, required this.courses});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Container(
            height: 150,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: courses.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: CourseCard(course: courses[index]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class Course {
  final String title;
  final String image;

  Course({required this.title, required this.image});
}

class CourseCard extends StatelessWidget {
  final Course course;

  CourseCard({required this.course});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 100,
          height: 100,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            image: DecorationImage(
              image: AssetImage(course.image),
              fit: BoxFit.cover,
            ),
          ),
        ),
        SizedBox(height: 8),
        Text(
          course.title,
          style: TextStyle(fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
