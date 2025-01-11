import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

void showAddPatientDialog(BuildContext context, Function onPatientAdded) {
  print("Updated Add Patient Dialog is called");
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  final TextEditingController speciesController = TextEditingController();
  final TextEditingController animalIdController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController weightController = TextEditingController();
  final TextEditingController symptomsController = TextEditingController();
  final TextEditingController sexController = TextEditingController();
  final TextEditingController caseNumberController = TextEditingController();
  final TextEditingController ownerNameController = TextEditingController();

  showDialog(
    context: context,
    barrierDismissible: false,
    builder: (context) {
      return GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(), // Dismiss keyboard
        child: AlertDialog(
          backgroundColor: Colors.teal[50], // Light teal background
          contentPadding: EdgeInsets.all(16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Center(
            child: Text(
              'Patient Information',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal[900],
              ),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                _buildInputField('Case Number', caseNumberController,
                    keyboardType: TextInputType.number,
                    labelFontWeight: FontWeight.normal),
                _buildInputField('Animal ID', animalIdController,
                    labelFontWeight: FontWeight.normal),
                _buildInputField('Species', speciesController,
                    labelFontWeight: FontWeight.normal),
                _buildInputField('Sex', sexController,
                    labelFontWeight: FontWeight.normal),
                _buildInputField('Age', ageController,
                    keyboardType: TextInputType.number,
                    labelFontWeight: FontWeight.normal),
                _buildInputField('Weight', weightController,
                    keyboardType: TextInputType.number,
                    labelFontWeight: FontWeight.normal),
                _buildInputField('Symptoms', symptomsController,
                    labelFontWeight: FontWeight.normal),
                _buildInputField('Owner Name', ownerNameController,
                    labelFontWeight: FontWeight.normal),
              ],
            ),
          ),
          actionsPadding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          actionsAlignment: MainAxisAlignment.spaceBetween,
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context), // Close dialog
              child: Text(
                'Cancel',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                  color: Colors.teal[800],
                ),
              ),
            ),
            ElevatedButton(
              onPressed: () async {
                if (speciesController.text.trim().isEmpty ||
                    animalIdController.text.trim().isEmpty ||
                    ageController.text.trim().isEmpty ||
                    weightController.text.trim().isEmpty ||
                    symptomsController.text.trim().isEmpty ||
                    sexController.text.trim().isEmpty ||
                    caseNumberController.text.trim().isEmpty ||
                    ownerNameController.text.trim().isEmpty) {
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
                      'species': speciesController.text,
                      'animal_id': animalIdController.text,
                      'age': ageController.text,
                      'weight': weightController.text,
                      'symptoms': symptomsController.text,
                      'sex': sexController.text,
                      'case_number': caseNumberController.text,
                      'owner_name': ownerNameController.text,
                      'timestamp': FieldValue.serverTimestamp(),
                    });

                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Patient added successfully!')),
                    );

                    onPatientAdded();
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
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Save',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

Widget _buildInputField(String label, TextEditingController controller,
    {TextInputType keyboardType = TextInputType.text,
    FontWeight labelFontWeight = FontWeight.bold}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: Container(
      decoration: BoxDecoration(
        color: const Color.fromARGB(
            255, 241, 250, 250), // Adjusted background color
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: Colors.teal[800],
            fontWeight: labelFontWeight,
          ),
          filled: true,
          fillColor: Colors.white, // White input area background
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.transparent),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.teal),
          ),
          contentPadding: const EdgeInsets.all(12),
        ),
      ),
    ),
  );
}
