// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors

import 'package:flutter/material.dart';
import 'controller.dart';
import 'package:vetdose/bottom_nav_bar.dart';
import 'package:vetdose/main page/Premed_detailed.dart';
import 'package:vetdose/Formulas/kgToLbs.dart'; // Import the KgToLbsConverter

class MainScreen extends StatefulWidget {
  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Controller controller = Controller();
  final KgToLbsConverter converter = KgToLbsConverter();
  int _currentIndex = 2; // Default to Home

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    controller.onTabTapped(index, context);
  }

  Future<void> _navigateToPremedDetailed(String title) async {
    // Get the weight in kg from the controller's TextField
    final double animalWeightKg =
        double.tryParse(controller.weightController.text) ?? 0.0;

    // Convert kg to lbs using KgToLbsConverter
    final double? animalWeightLbs = await converter.convert(animalWeightKg);

    // Navigate to PremedDetailed, passing both kg and lbs weights
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => PremedDetailed(
          title: title,
          controller: controller,
          animalWeightKg: animalWeightKg,
          animalWeightLbs:
              animalWeightLbs ?? 0.0, // Provide a default value in case of null
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home screen'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Hello Allieysa!', style: TextStyle(fontSize: 20)),
                CircleAvatar(
                  radius: 40,
                  backgroundImage: AssetImage('assets/animal_avatar.png'),
                ),
              ],
            ),
          ),
          Text(
            'Choose animal',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.grey.shade300,
                  child: Icon(Icons.pets),
                ),
              );
            }),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 20.0),
            child: ValueListenableBuilder<bool>(
              valueListenable: controller.isKgNotifier,
              builder: (context, isKg, child) {
                return TextField(
                  controller: controller.weightController,
                  decoration: InputDecoration(
                    labelText: 'Enter weight',
                    suffix: TextButton(
                      onPressed: controller.toggleWeightUnit,
                      child: Text(isKg ? 'kg' : 'lbs'),
                    ),
                  ),
                  keyboardType: TextInputType.number,
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildProtocolItem('Pre-med'),
                _buildProtocolItem('Emergency'),
                _buildProtocolItem('Induction'),
                _buildProtocolItem('Intubation'),
                _buildProtocolItem('Local block'),
                _buildProtocolItem('Inotropic'),
                _buildProtocolItem('Maintenance'),
              ],
            ),
          ),
          BottomNavBar(
            currentIndex: _currentIndex,
            onTap: _onTabTapped,
          ),
        ],
      ),
    );
  }

  Widget _buildProtocolItem(String title) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        print('$title selected');
        _navigateToPremedDetailed(title); // Call the async function to navigate
      },
    );
  }
}
