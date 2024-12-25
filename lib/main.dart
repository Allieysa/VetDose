// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vetdose/calculator%20screen/calculator_screen.dart';
import 'package:vetdose/converter%20screen/converter_first_screen.dart';
import 'package:vetdose/main%20page/controller.dart';
import 'package:vetdose/main%20page/main_screen.dart';
import 'package:vetdose/profile screen/patient_history.dart';
import 'package:vetdose/profile%20screen/profile_screen.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding
      .ensureInitialized(); // Ensures binding before Firebase initialization
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Controller controller = Controller();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.blue),
      initialRoute: '/splash',
      routes: {
        '/splash': (context) => SplashScreen(), // Splash screen route
        '/home': (context) => MainScreen(controller: controller),
        '/profile': (context) => ProfileScreen(controller: controller),
        '/calculator': (context) => CalculatorScreen(controller: controller),
        '/converter': (context) => ConverterScreen(controller: controller),
        '/patient': (context) => PatientHistoryScreen(controller: controller),
      },
    );
  }
}
