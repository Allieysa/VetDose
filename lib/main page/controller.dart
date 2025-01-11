import 'package:flutter/material.dart';

class Controller {
  final TextEditingController weightController = TextEditingController();
  bool isKg = true;
  ValueNotifier<bool> isKgNotifier = ValueNotifier<bool>(true);
  int currentIndex = 0;

  void onTabTapped(int index, BuildContext context) {
    currentIndex = index;
    String route = _getRouteName(index);

    // Clear the navigation stack and replace with new route
    Navigator.of(context).pushNamedAndRemoveUntil(
      route,
      (route) => false,
    );
  }

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
        return '/home';
    }
  }
}
