import 'package:flutter/material.dart';

class Controller {
  final TextEditingController weightController = TextEditingController();
  bool isKg = true;

  // Notify changes in weight unit
  ValueNotifier<bool> isKgNotifier = ValueNotifier<bool>(true);

  int currentIndex = 0; // Track the current index

  // Manage tab changes with navigation
  void onTabTapped(int index, BuildContext context) {
    if (index == currentIndex) return; // Prevent navigating to the same screen

    currentIndex = index; // Update the current index
    Navigator.pushReplacementNamed(context, _getRouteName(index));
  }

  // Map index to route names
  String _getRouteName(int index) {
    switch (index) {
      case 0:
        return '/calculator';
      case 1:
        return '/converter';
      case 2:
        return '/home';
      case 3:
        return '/patient';
      case 4:
        return '/profile';
      default:
        return '/home'; // Default fallback route
    }
  }
}
