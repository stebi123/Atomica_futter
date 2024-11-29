import 'package:flutter/material.dart';
import 'pages/homepage.dart';


void main() {
  runApp(HabitTrackerApp());
}

class HabitTrackerApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Habits to Goals',
      theme: ThemeData(
        primaryColor: Color(0xFF65E892),
        scaffoldBackgroundColor: Color(0xFF3D289B),
        textTheme: TextTheme(
          bodyText1: TextStyle(color: Colors.white),
          bodyText2: TextStyle(color: Colors.white.withOpacity(0.7)),
        ),
      ),
      debugShowCheckedModeBanner: false,
      home: HabitHomePage(),
    );
  }
}

