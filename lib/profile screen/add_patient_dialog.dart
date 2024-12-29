import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showAddPatientDialog(BuildContext context, Function onPatientAdded) {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Controllers to capture user input
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
            onPressed: () => Navigator.pop(context), // Close dialog
            child: Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (typeController.text.trim().isEmpty ||
                  nameController.text.trim().isEmpty ||
                  ageController.text.trim().isEmpty ||
                  weightController.text.trim().isEmpty ||
                  symptomsController.text.trim().isEmpty) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('All fields are required!')),
                );
                return;
              }

              try {
                User? user = _auth.currentUser;

                if (user != null) {
                  await _firestore
                      .collection('users')
                      .doc(user.uid)
                      .collection('patient_history')
                      .add({
                    'type': typeController.text,
                    'name': nameController.text,
                    'age': ageController.text,
                    'weight': weightController.text,
                    'symptoms': symptomsController.text,
                    'timestamp': FieldValue.serverTimestamp(),
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Patient added successfully!')),
                  );

                  onPatientAdded(); // Callback to refresh data
                  Navigator.pop(context);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('No user is logged in!')),
                  );
                }
              } catch (e) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text('Error: $e')),
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
