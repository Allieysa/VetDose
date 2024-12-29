// main.dart
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:vetdose/calculator%20screen/calculator_screen.dart';
import 'package:vetdose/converter%20screen/converter_first_screen.dart';
import 'package:vetdose/main%20page/controller.dart';
import 'package:vetdose/main%20page/main_screen.dart';
import 'package:vetdose/profile%20screen/patient_history.dart';
import 'package:vetdose/profile%20screen/profile_screen.dart';
import 'splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(); // Initialize Firebase
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final Controller controller = Controller(); // Shared controller instance

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'My App',
      theme: ThemeData(primarySwatch: Colors.teal),
      initialRoute: '/splash',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/splash':
            return MaterialPageRoute(builder: (context) => SplashScreen());
          case '/home':
            return MaterialPageRoute(
                builder: (context) =>
                    MainScreen(controller: controller, currentIndex: 2));
          case '/profile':
            return MaterialPageRoute(
                builder: (context) =>
                    ProfileScreen(controller: controller, currentIndex: 4));
          case '/calculator':
            return MaterialPageRoute(
                builder: (context) =>
                    CalculatorScreen(controller: controller, currentIndex: 0));
          case '/converter':
            return MaterialPageRoute(
                builder: (context) =>
                    ConverterScreen(controller: controller, currentIndex: 1));
          case '/patient':
            return MaterialPageRoute(
                builder: (context) => PatientHistoryScreen(
                    controller: controller, currentIndex: 3));
          default:
            return MaterialPageRoute(builder: (context) => SplashScreen());
        }
      },
    );
  }
}
