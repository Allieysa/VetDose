// ignore_for_file: use_key_in_widget_constructors, prefer_const_constructors, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'controller.dart';
import 'package:vetdose/bottom_nav_bar.dart';
import 'package:vetdose/main page/Premed_detailed.dart';
import 'package:vetdose/Formulas/kgToLbs.dart'; // Import the KgToLbsConverter
import 'package:vetdose/main page/emergency_page.dart';

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
        title: Row(
          children: [
            Text(
              'Hello Allieysa!',
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
            ),
          ],
        ),
        centerTitle: false, // Ensure the title is not centered
        automaticallyImplyLeading: false, // Remove the back button arrow
      ),
      body: Column(
        children: [
          Text(
            'This dosage only for:',
            style: TextStyle(fontSize: 11),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 40, // Fixed size for simplicity
                  backgroundImage: AssetImage('assets/cat.png'), // Cat logo
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: CircleAvatar(
                  radius: 40, // Fixed size for simplicity
                  backgroundImage: AssetImage('assets/dog.png'), // Dog logo
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10.0),
            child: ValueListenableBuilder<bool>(
              valueListenable: controller.isKgNotifier,
              builder: (context, isKg, child) {
                return Container(
                  width: 300, // Adjust size as needed
                  height: 60, // Adjust height for a better appearance
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 1,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextField(
                    controller: controller.weightController,
                    decoration: InputDecoration(
                      labelText: 'Enter weight',
                      floatingLabelBehavior:
                          FloatingLabelBehavior.auto, // Floating label behavior
                      labelStyle: TextStyle(
                        color: Colors.grey, // Label color when inactive
                      ),
                      border: InputBorder.none, // Keeps the clean box design
                      suffix: Text(
                        isKg ? 'kg' : 'lbs', // Keeps the toggle functionality
                        style: TextStyle(color: Colors.grey),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: ListView(
              children: [
                _buildProtocolItem('Pre-med', PremedDetailed()), // Pass the specific page
                _buildProtocolItem('Emergency', EmergencyPage()),
                _buildProtocolItem('Induction', InductionPage()),
                _buildProtocolItem('Intubation', IntubationPage()),
                _buildProtocolItem('Local block', LocalBlockPage()),
                _buildProtocolItem('Inotropic', InotropicPage()),
                _buildProtocolItem('Maintenance', MaintenancePage()),
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

  Widget _buildProtocolItem(String title, Widget page) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward),
      onTap: () {
        // Navigate to the specific page
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => page),
        );
      },
    );
  }
}
