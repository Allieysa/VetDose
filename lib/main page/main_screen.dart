import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'controller.dart';
import 'package:vetdose/bottom_nav_bar.dart';
import 'package:vetdose/main page/category_page.dart';
import 'package:vetdose/profile screen/add_patient_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainScreen extends StatefulWidget {
  final Controller controller; // Controller for shared logic
  final int currentIndex;

  MainScreen({required this.controller, required this.currentIndex});

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  late final Controller controller; // Use the passed controller
  late int currentIndex;

  User? currentUser = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  void initState() {
    super.initState();
    controller = widget.controller;
    currentIndex = widget.currentIndex;

    // Schedule the welcome dialog to appear after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showWelcomeDialog();
    });
  }

  void _showWelcomeDialog() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // Check if the user has logged in since the last logout
    bool hasSeenWelcome = prefs.getBool('hasSeenWelcome') ?? false;

    // If the user has logged out and logged back in, show the dialog
    if (!hasSeenWelcome) {
      String username = currentUser?.displayName ??
          currentUser?.email?.split('@')[0] ??
          'User';

      showDialog(
        context: context,
        barrierDismissible: false, // Prevent dismissal by tapping outside
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.teal[50], // Light teal background
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            title: Center(
              child: Text(
                'Hello, $username!',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.teal[900],
                ),
                textAlign: TextAlign.center,
              ),
            ),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.person_add_alt_1, // A friendly icon to enhance the UI
                  color: Colors.teal,
                  size: 48,
                ),
                SizedBox(height: 16),
                Text(
                  'Welcome to VetDose!',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[900],
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 8),
                Text(
                  'This app helps you manage your patients seamlessly. Add a new patient now or explore your existing records to get started.',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[800],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
            actionsPadding: EdgeInsets.only(bottom: 16),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              SizedBox(
                width: 120,
                child: TextButton(
                  onPressed: () {
                    Navigator.pop(context); // Close the dialog
                  },
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.teal[800],
                    textStyle: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  child: Text('Later'),
                ),
              ),
              SizedBox(
                width: 120,
                child: ElevatedButton(
                  onPressed: () {
                    showAddPatientDialog(context, () {
                      setState(() {
                        // Update the patient list or UI after the dialog is closed
                      });
                    });
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.teal,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: Text(
                    'Add Now',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      );

      // Mark the welcome dialog as shown
      await prefs.setBool('hasSeenWelcome', true);
    }
  }

  void _onTabTapped(int index) {
    setState(() {
      currentIndex = index;
    });
    controller.onTabTapped(index, context);
  }

  @override
  Widget build(BuildContext context) {
    final String username = currentUser?.displayName ?? 'User';
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 241, 250, 250),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 241, 250, 250),
          title: Text(
            'Hello, $username!',
            style: TextStyle(
              fontFamily: 'SF Pro',
              fontSize: 19,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Text(
              'This dosage is only for:',
              style: TextStyle(fontSize: 13),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/cat.png'),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage('assets/dog.png'),
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
                    width: 300,
                    height: 60,
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.2),
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
                        floatingLabelBehavior: FloatingLabelBehavior.auto,
                        labelStyle: TextStyle(
                          color: Colors.grey,
                        ),
                        border: InputBorder.none,
                        suffix: Text(
                          isKg ? 'kg' : 'lbs',
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
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                padding: const EdgeInsets.all(16),
                children: [
                  _buildProtocolItem('Pre-med', Icons.local_hospital,
                      category: 'Premed'),
                  _buildProtocolItem('Emergency', Icons.warning,
                      category: 'Emergency'),
                  _buildProtocolItem('Induction', Icons.auto_fix_high,
                      category: 'Induction'),
                  _buildProtocolItem('Intubation', Icons.air,
                      category: 'Intubation'),
                  _buildProtocolItem('Local block', Icons.healing,
                      category: 'Local block'),
                  _buildProtocolItem('Fluid rate', Icons.water_drop,
                      category: 'Fluid rate'),
                  _buildProtocolItem('Inotropic', Icons.science,
                      category: 'Inotropic'),
                  _buildProtocolItem('Maintenance', Icons.build,
                      category: 'Maintenance'),
                ],
              ),
            ),
          ],
        ),
        bottomNavigationBar: BottomNavBar(
          currentIndex: currentIndex,
          onTap: (index) {
            controller.onTabTapped(index, context);
          },
        ));
  }

  Widget _buildProtocolItem(String title, IconData icon,
      {required String category}) {
    return GestureDetector(
      onTap: () async {
        final double weightKg =
            double.tryParse(controller.weightController.text) ?? 0.0;

        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => CategoryPage(
              category: category,
              weightKg: weightKg,
            ),
          ),
        );
      },
      child: Card(
        color: const Color.fromARGB(255, 255, 255, 255),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        elevation: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 37,
              color: Colors.teal.shade500,
            ),
            const SizedBox(height: 5),
            Text(
              title,
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.bold,
                color: Colors.black54,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
