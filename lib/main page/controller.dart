import 'package:flutter/material.dart';
import 'package:vetdose/drug screen/drugs_screen.dart';
import 'package:vetdose/main page/main_screen.dart';
import 'package:vetdose/calculator screen/calculator_screen.dart';
import 'package:vetdose/converter screen/converter_first_screen.dart';
import 'package:vetdose/profile%20screen/profile_screen.dart'; 

class Controller {
  final TextEditingController weightController = TextEditingController();
  bool isKg = true;

  // Add a ValueNotifier to notify changes in weight unit
  ValueNotifier<bool> isKgNotifier = ValueNotifier<bool>(true);

  void toggleWeightUnit() {
    // Switch between kg and lbs.
    isKg = !isKg;
    isKgNotifier.value = isKg; // Notify listeners about the change
    print('Switched to ${isKg ? 'kg' : 'lbs'}');
  }

  void onTabTapped(int index, BuildContext context) {
    switch (index) {
      case 0: // Drugs tab
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => DrugsScreen()), // Navigate to DrugsScreen
        );
        break;
      case 1:
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ConverterScreen(controller: this,)),
        );
        break;
      case 2:
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => MainScreen()),
        );
        break;
      case 3: // Calculator tab
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CalculatorScreen(controller: this),
          ),
        );
        break;
        case 4: // Profile tab
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfileScreen(),
          ),
        );
        break;

    }
  }
}
