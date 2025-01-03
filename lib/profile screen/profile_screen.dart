import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:vetdose/login_screen.dart';
import 'package:vetdose/profile screen/note_page.dart';
import 'package:vetdose/bottom_nav_bar.dart';
import 'package:vetdose/main page/controller.dart';
import 'package:vetdose/profile%20screen/report_issue_page.dart';
import 'package:vetdose/profile%20screen/term_and_conditions_page.dart';

class ProfileScreen extends StatefulWidget {
  final Controller controller;
  final int currentIndex;

  const ProfileScreen(
      {Key? key, required this.controller, required this.currentIndex})
      : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final User? currentUser = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 250, 250),
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 241, 250, 250),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Profile Header
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 30, // Smaller size for the avatar
                    backgroundColor: Colors.teal.shade200,
                    child: const Icon(
                      Icons.person,
                      size: 30,
                      color: Colors.white,
                    ),
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
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        currentUser?.email ?? 'user@example.com',
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Profile Options
            ..._buildProfileOptions(context),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: widget.currentIndex,
        onTap: (index) => widget.controller.onTabTapped(index, context),
      ),
    );
  }

  List<Widget> _buildProfileOptions(BuildContext context) {
    return [
      _buildOptionTile(
        context,
        title: 'Notes',
        icon: Icons.note,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => NotePage()),
          );
        },
      ),
      _buildOptionTile(
        context,
        title: 'Terms and Conditions',
        icon: Icons.article,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => TermsAndConditionsScreen()),
          );
        },
      ),
      _buildOptionTile(
        context,
        title: 'Report Issue',
        icon: Icons.report_problem,
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => ReportIssueScreen()),
          );
        },
      ),
      _buildOptionTile(
        context,
        title: 'Sign Out',
        icon: Icons.exit_to_app,
        onTap: () async {
          bool? shouldSignOut = await showDialog(
            context: context,
            builder: (context) => AlertDialog(
              backgroundColor: Colors.white,
              title: const Text('Log Out'),
              content: const Text('Are you sure you want to log out?'),
              actions: [
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, false);
                  },
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context, true);
                  },
                  child: const Text('Yes'),
                ),
              ],
            ),
          );

          if (shouldSignOut == true) {
            await FirebaseAuth.instance.signOut();
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }
        },
      ),
    ];
  }

  Widget _buildOptionTile(
    BuildContext context, {
    required String title,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.grey.withOpacity(0.2),
                blurRadius: 5,
                spreadRadius: 1,
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
          child: Row(
            children: [
              Icon(icon, size: 24, color: Colors.teal),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
              const Icon(
                Icons.arrow_forward_ios,
                size: 16,
                color: Colors.grey,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
