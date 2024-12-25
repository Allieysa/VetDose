import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vetdose/login_screen.dart';
import 'package:vetdose/profile screen/note_page.dart';
import 'package:vetdose/bottom_nav_bar.dart'; // Import your BottomNavBar class
import 'package:vetdose/main page/controller.dart';

class ProfileScreen extends StatefulWidget {
  final Controller controller;

  const ProfileScreen({Key? key, required this.controller}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser =
      FirebaseAuth.instance.currentUser; // Get current user

  int _currentIndex = 4; // Index for Profile in BottomNavBar

  void _onNavBarTap(int index) {
    if (index != _currentIndex) {
      widget.controller
          .onTabTapped(index, context); // Use Controller for navigation
      setState(() {
        _currentIndex = index;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: Colors.grey[200],
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        child: const Icon(Icons.person,
                            size: 50, color: Colors.grey),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blue,
                          child: const Icon(Icons.add,
                              size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        currentUser?.displayName ?? 'User Name',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        currentUser?.email ?? 'user@example.com',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey[700],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Options
            ListTile(
              title: const Text('Important'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle navigation or functionality
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Notes'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => NotePage()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Terms and Conditions'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle navigation or functionality
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Report Issue'),
              trailing: const Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle navigation or functionality
              },
            ),
            const Divider(),
            ListTile(
              title: const Text('Sign Out'),
              trailing: const Icon(Icons.exit_to_app),
              onTap: () async {
                bool? shouldSignOut = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    title: const Text('Log Out'),
                    content: const Text('Are you sure you want to log out?'),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, false); // Cancel log out
                        },
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context, true); // Confirm log out
                        },
                        child: const Text('Yes'),
                      ),
                    ],
                  ),
                );

                if (shouldSignOut == true) {
                  await FirebaseAuth.instance
                      .signOut(); // Sign out from Firebase
                  Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          LoginScreen(), // Navigate to LoginScreen
                    ),
                  );
                }
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: _currentIndex,
        onTap: _onNavBarTap,
      ),
    );
  }
}
