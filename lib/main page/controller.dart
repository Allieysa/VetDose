// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:vetdose/main page/main_screen.dart';
import 'package:vetdose/calculator screen/calculator_screen.dart';
import 'package:vetdose/converter screen/converter_first_screen.dart';
import 'package:vetdose/profile screen/profile_screen.dart';
import 'package:vetdose/profile screen/patient_history.dart';

class Controller {
  final TextEditingController weightController = TextEditingController();
  bool isKg = true;

  // Notify changes in weight unit
  ValueNotifier<bool> isKgNotifier = ValueNotifier<bool>(true);

  void onTabTapped(int index, BuildContext context) {
    switch (index) {
      case 0: // Calculator
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => CalculatorScreen(controller: this),
          ),
        );
        break;
      case 1: // Converter
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ConverterScreen(controller: this),
          ),
        );
        break;
      case 2: // Main Screen
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => MainScreen(controller: this),
          ),
        );
        break;
      case 3: // Patient
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => PatientHistoryScreen(controller: this),
          ),
        );
        break;
      case 4: // Profile
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(controller: this),
          ),
        );
        break;
    }
  }
}
