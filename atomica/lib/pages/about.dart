import 'package:flutter/material.dart';

class AboutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('About Atomica'),
        backgroundColor: Color(0xFF65E892),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // About Atomica Title
            Text(
              'About Atomica',
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                color: Color(0xFF3D289B),
                letterSpacing: 1.5,
              ),
            ),
            SizedBox(height: 20),

            // Description Text
            Text(
              'Atomica is a powerful habit-tracking app designed to help you build and maintain positive habits. Whether it’s improving your fitness, organizing your day, or fostering mindfulness, Atomica provides all the tools you need to reach your goals.',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70, // Soft white for better contrast
                height: 1.5,
              ),
            ),
            SizedBox(height: 30),

            // Features Title
            Text(
              'Features:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Color(0xFF65E892), // Matching the app bar color
                letterSpacing: 1.2,
              ),
            ),
            SizedBox(height: 10),

            // Features List
            Text(
              '- Customizable habit tracking\n'
              '- Insights and analytics for progress\n'
              '- Motivation and reminders\n'
              '- Seamless navigation and user-friendly design',
              style: TextStyle(
                fontSize: 16,
                color: Colors.white70,
                height: 1.5,
              ),
            ),
            SizedBox(height: 30),

            // Closing Message
            Spacer(),
            Center(
              child: Text(
                'Thank you for using Atomica!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF65E892), // Matching the feature color
                ),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
      backgroundColor: Color(0xFF3D289B), // Set the background color
    );
  }
}
