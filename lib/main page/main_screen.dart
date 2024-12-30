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
    SharedPreferences prefs = await SharedPreferences.getInstance();
    bool hasSeenDialog = prefs.getBool('hasSeenDialog') ?? false;

    if (!hasSeenDialog) {
      String username = currentUser?.displayName ??
          currentUser?.email?.split('@')[0] ??
          'User';

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          return AlertDialog(
            title: Text('Hello, $username!'),
            content: Text('Welcome to VetDose. What would you like to do?'),
            actions: [
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the dialog
                },
                child: Text('Close'),
              ),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context); // Close the welcome dialog
                  showAddPatientDialog(context, () {
                    setState(() {}); // Refresh the UI
                  });
                },
                child: Text('Add Patient'),
              ),
            ],
          );
        },
      );

      // Mark the dialog as shown
      await prefs.setBool('hasSeenDialog', true);
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
    return Scaffold(
        backgroundColor: const Color.fromARGB(255, 241, 250, 250),
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 241, 250, 250),
          title: Text(
            'Hello, ${currentUser?.displayName ?? 'User'}!',
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
              color: Colors.teal.shade300,
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
