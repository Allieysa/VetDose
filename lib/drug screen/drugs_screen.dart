import 'package:flutter/material.dart';
import 'package:vetdose/main page/controller.dart'; // Import the controller
import 'package:vetdose/bottom_nav_bar.dart'; // Import the BottomNavBar

class DrugsScreen extends StatefulWidget {
  @override
  _DrugsScreenState createState() => _DrugsScreenState();
}

class _DrugsScreenState extends State<DrugsScreen> {
  final Controller controller =
      Controller(); // Create an instance of the controller

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Drugs'),
      ),
      body: Center(
        child: Text('Welcome to the Drugs Screen!'),
      ),
      
      bottomNavigationBar: BottomNavBar(
        currentIndex: 0, // Set to the index for Drugs
        onTap: (index) {
          controller.onTabTapped(
              index, context); // Use the controller for navigation
        },
      ),
    );
  }
}
