import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:vetdose/main page/main_screen.dart';
import 'package:vetdose/main page/controller.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    _checkLoginState(context); // Check authentication state

    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Image.asset(
          'assets/splash_logo.gif',
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) => Icon(
            Icons.error,
            size: 80,
            color: Colors.red,
          ), // Fallback if image is not found
        ),
      ),
    );
  }

  void _checkLoginState(BuildContext context) async {
    await Future.delayed(Duration(seconds: 2)); // Simulate splash screen delay
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Navigate to MainScreen if user is logged in
      final controller = Controller(); // Initialize controller
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) =>
              MainScreen(controller: controller, currentIndex: 2),
        ),
      );
    } else {
      // Navigate to LoginScreen if user is not logged in
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }
}
