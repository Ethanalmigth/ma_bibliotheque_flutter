import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});
  static String id = 'welcome_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Home'),
        actions: [
          IconButton(
            icon: Icon(Icons.search),
            onPressed: () {
              // Action de recherche
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
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
            height: 150, // Adjust this height based on your design
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
