import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart'; // Import FirebaseAuth
import 'controller.dart';
import 'package:vetdose/bottom_nav_bar.dart';
import 'package:vetdose/main page/category_page.dart';
import 'package:vetdose/profile screen/add_patient_dialog.dart';

class MainScreen extends StatefulWidget {
  final bool showWelcome; // Flag to trigger the welcome dialog
  final Controller controller; // Controller for shared logic

  const MainScreen({
    Key? key,
    required this.controller,
    this.showWelcome = false, // Default value for showWelcome
  }) : super(key: key);

  @override
  _MainScreenState createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  final Controller controller = Controller();
  int _currentIndex = 2; // Default to Home
  DateTime? lastBackPressTime; // For double back to exit

  User? currentUser = FirebaseAuth.instance.currentUser; // Get the current user

  @override
  void initState() {
    super.initState();
    // Schedule the dialog to appear after the first frame
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.showWelcome) {
        _showWelcomeDialog();
      }
    });
  }

  void _showWelcomeDialog() {
    String username =
        currentUser?.displayName ?? currentUser?.email?.split('@')[0] ?? 'User';
    showDialog(
      context: context,
      barrierDismissible: false, // Prevent dismissing the dialog accidentally
      builder: (context) {
        return AlertDialog(
          title: Text('Hello, $username!'),
          content: Text('Welcome to the app. What would you like to do?'),
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
                  setState(() {}); // Refresh UI if needed
                });
              },
              child: Text('Add Patient'),
            ),
          ],
        );
      },
    );
  }

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    controller.onTabTapped(index, context);
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        // Handle double back to exit
        final now = DateTime.now();

        if (lastBackPressTime == null ||
            now.difference(lastBackPressTime!) > Duration(seconds: 2)) {
          lastBackPressTime = now;

          // Show a snackbar to notify the user
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Press back again to exit'),
              duration: Duration(seconds: 2),
            ),
          );

          return false; // Prevent exiting the app
        }

        return true; // Allow exiting the app
      },
      child: Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Text(
                'Hello, ${currentUser?.displayName ?? 'User'}!',
                style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          centerTitle: false,
          automaticallyImplyLeading: false,
        ),
        body: Column(
          children: [
            Text(
              'This dosage is only for:',
              style: TextStyle(fontSize: 11),
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
              child: ListView(
                children: [
                  _buildProtocolItem('Pre-med', category: 'Premed'),
                  _buildProtocolItem('Emergency', category: 'Emergency'),
                  _buildProtocolItem('Induction', category: 'Induction'),
                  _buildProtocolItem('Intubation', category: 'Intubation'),
                  _buildProtocolItem('Local block', category: 'Local block'),
                  _buildProtocolItem('Fluid rate', category: 'Fluid rate'),
                  _buildProtocolItem('Inotropic', category: 'Inotropic'),
                  _buildProtocolItem('Maintenance', category: 'Maintenance'),
                ],
              ),
            ),
            BottomNavBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProtocolItem(String title, {required String category}) {
    return ListTile(
      title: Text(title),
      trailing: Icon(Icons.arrow_forward),
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
    );
  }
}
