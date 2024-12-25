import 'package:flutter/material.dart';
import 'package:vetdose/converter%20screen/large_animal.dart';
import 'package:vetdose/converter%20screen/small_animal.dart';
import 'package:vetdose/main%20page/controller.dart';
import 'package:vetdose/bottom_nav_bar.dart'; // Ensure the BottomNavBar is imported correctly

class ConverterScreen extends StatefulWidget {
  final Controller controller;

  ConverterScreen({required this.controller});

  @override
  _ConverterScreenState createState() => _ConverterScreenState();
}

class _ConverterScreenState extends State<ConverterScreen> {
  int _currentIndex = 1; // Index for the ConverterScreen

  void _onNavBarTap(int index) {
    setState(() {
      _currentIndex = index;
    });

    // Handle navigation based on index
    if (index == 0) {
      Navigator.pushNamed(context, '/home'); // Adjust route as needed
    } else if (index == 1) {
      // Stay on the ConverterScreen
    } else if (index == 2) {
      Navigator.pushNamed(context, '/profile'); // Adjust route as needed
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Animal Converter'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => SmallAnimalConverterOptions()),
                );
              },
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Small Animal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(height: 20),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => LargeAnimalConverter()),
                );
              },
              child: Container(
                height: 100,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 2,
                      blurRadius: 5,
                      offset: Offset(0, 3), // Shadow position
                    ),
                  ],
                ),
                child: Center(
                  child: Text(
                    'Large Animal',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ),
              ),
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
