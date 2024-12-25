import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';
import 'package:vetdose/main page/main_screen.dart';
import 'package:vetdose/main page/controller.dart';
import 'dart:async';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    // Check the user's authentication state after a delay
    Timer(Duration(seconds: 3), () {
      _checkLoginState();
    });
  }

  void _checkLoginState() {
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // User is logged in, navigate to MainScreen
      final controller = Controller(); // Create a Controller instance
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => MainScreen(controller: controller),
        ),
      );
    } else {
      // User is not logged in, navigate to LoginScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child:
            Image.asset('assets/splash_logo.gif'), // Display the animated GIF
      ),
    );
  }
}
