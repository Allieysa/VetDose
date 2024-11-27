import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Profile'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Profile Header
            Container(
              color: Colors.grey[200],
              padding: EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 40,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, size: 50, color: Colors.grey),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: CircleAvatar(
                          radius: 12,
                          backgroundColor: Colors.blue,
                          child: Icon(Icons.add, size: 16, color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(width: 16),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'User Name',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        'user@example.com',
                        style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),

            // Profile Options
            ListTile(
              title: Text('Patient History'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle navigation or functionality
              },
            ),
            Divider(),
            ListTile(
              title: Text('Important'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle navigation or functionality
              },
            ),
            Divider(),
            ListTile(
              title: Text('Notes'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle navigation or functionality
              },
            ),
            Divider(),
            ListTile(
              title: Text('Terms and Conditions'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle navigation or functionality
              },
            ),
            Divider(),
            ListTile(
              title: Text('Report Issue'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle navigation or functionality
              },
            ),
            Divider(),
            ListTile(
              title: Text('Change Password'),
              trailing: Icon(Icons.arrow_forward_ios),
              onTap: () {
                // Handle navigation or functionality
              },
            ),
            Divider(),
            ListTile(
              title: Row(
                children: [
                  Text('Dark Mode'),
                  Spacer(),
                  Switch(
                    value: false, // Add your logic to handle dark mode toggle
                    onChanged: (value) {
                      // Handle dark mode toggle
                    },
                  ),
                ],
              ),
              onTap: null,
            ),
            Divider(),
            ListTile(
              title: Text('Sign Out'),
              trailing: Icon(Icons.exit_to_app),
              onTap: () {
                // Handle sign out functionality
              },
            ),
          ],
        ),
      ),
    );
  }
}
