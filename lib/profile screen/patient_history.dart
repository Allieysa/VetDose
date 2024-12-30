import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vetdose/bottom_nav_bar.dart';
import 'package:vetdose/main page/controller.dart';
import 'package:vetdose/profile screen/patient_details_screen.dart';

class PatientHistoryScreen extends StatefulWidget {
  final Controller controller;
  final int currentIndex;

  const PatientHistoryScreen({
    Key? key,
    required this.controller,
    required this.currentIndex,
  }) : super(key: key);

  @override
  _PatientHistoryScreenState createState() => _PatientHistoryScreenState();
}

class _PatientHistoryScreenState extends State<PatientHistoryScreen> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _showAddPatientDialog() {
    final TextEditingController typeController = TextEditingController();
    final TextEditingController nameController = TextEditingController();
    final TextEditingController ageController = TextEditingController();
    final TextEditingController weightController = TextEditingController();
    final TextEditingController symptomsController = TextEditingController();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) {
        return AlertDialog(
          contentPadding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Center(
            child: Text(
              'Patient Information',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInputField('Animal Type', typeController),
                _buildInputField('Animal Name', nameController),
                _buildInputField('Age', ageController),
                _buildInputField('Weight', weightController),
                _buildInputField('Symptoms', symptomsController),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (_validateInputs([
                  typeController.text,
                  nameController.text,
                  ageController.text,
                  weightController.text,
                  symptomsController.text,
                ])) {
                  await _savePatientData(
                    typeController.text,
                    nameController.text,
                    ageController.text,
                    weightController.text,
                    symptomsController.text,
                  );
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('All fields are required!')),
                  );
                }
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  bool _validateInputs(List<String> inputs) {
    for (var input in inputs) {
      if (input.trim().isEmpty) return false;
    }
    return true;
  }

  Widget _buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    );
  }

  Future<void> _savePatientData(String type, String name, String age,
      String weight, String symptoms) async {
    User? user = _auth.currentUser;

    if (user != null) {
      await _firestore
          .collection('users')
          .doc(user.uid)
          .collection('patient_history')
          .add({
        'type': type,
        'name': name,
        'age': age,
        'weight': weight,
        'symptoms': symptoms,
        'timestamp': FieldValue.serverTimestamp(),
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient information saved successfully!')),
      );
    } else {
      print('No user logged in');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 241, 250, 250),
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60.0),
        child: AppBar(
          title: Text(
            'Patients List',
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: const Color.fromARGB(255, 241, 250, 250),
          elevation: 0,
          actions: [
            Padding(
              padding: const EdgeInsets.only(
                  right: 20.0), // Adjust the right padding
              child: ElevatedButton(
                onPressed: _showAddPatientDialog,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6), // Reduce padding inside the button
                  minimumSize:
                      Size(80, 36), // Set minimum size (width x height)
                ),
                child: Text(
                  'Add Patient',
                  style: TextStyle(
                      color: Colors.white, fontSize: 12), // Adjust font size
                ),
              ),
            ),
          ],
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('patient_history')
            .orderBy('timestamp', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading data'));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator());
          }

          final patients = snapshot.data!.docs;

          if (patients.isEmpty) {
            return Center(child: Text('No patients added yet.'));
          }

          return ListView.builder(
            itemCount: patients.length,
            itemBuilder: (context, index) {
              final patientDoc = patients[index];
              final patient = patientDoc.data() as Map<String, dynamic>;

              return Card(
                color: Colors.white,
                margin: EdgeInsets.all(15.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: ListTile(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 25.0, vertical: 10.0),
                  title: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        patient['name'] ?? '',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        patient['type'] ?? '',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(height: 5), // Space above the first text
                      Text(
                        'Age: ${patient['age']}',
                        style: TextStyle(fontSize: 14), // Adjust font size
                      ),
                      Text(
                        'Weight: ${patient['weight']}',
                        style: TextStyle(fontSize: 14), // Adjust font size
                      ),
                      Text(
                        'Symptoms: ${patient['symptoms']}',
                        style: TextStyle(fontSize: 14), // Adjust font size
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PatientDetailsScreen(
                          patientId: patientDoc.id,
                        ),
                      ),
                    );
                  },
                ),
              );
            },
          );
        },
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: widget.currentIndex, // Use widget.currentIndex
        onTap: (index) {
          widget.controller.onTabTapped(index, context);
        },
      ),
    );
  }
}
