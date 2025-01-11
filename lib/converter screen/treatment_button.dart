import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AddTreatmentButton extends StatelessWidget {
  final Function()? onTreatmentAdded; // Callback after treatment is added

  AddTreatmentButton({this.onTreatmentAdded});

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  void _selectPatient(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.teal[50], // Set dialog background color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12), // Rounded corners
          ),
          title: Center(
            child: Text(
              'Select a Patient',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal[800], // Text color to match the theme
              ),
            ),
          ),
          content: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('users')
                .doc(_auth.currentUser?.uid)
                .collection('patient_history')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(
                  child: CircularProgressIndicator(color: Colors.teal),
                );
              }
              if (snapshot.hasError) {
                return Center(
                  child: Text(
                    'Error loading patients.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.red,
                    ),
                  ),
                );
              }
              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No patients available.',
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.teal[800],
                    ),
                  ),
                );
              }

              final patients = snapshot.data!.docs;

              return ListView.builder(
                shrinkWrap: true,
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  final patientId = patient.id;
                  final patientData = patient.data() as Map<String, dynamic>;

                  return GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                        _addTreatment(context, patientId);
                      },
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 8.0),
                        padding: EdgeInsets.all(16.0),
                        decoration: BoxDecoration(
                          color:
                              Colors.white, // White background for list items
                          borderRadius: BorderRadius.circular(12.0),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.grey.withOpacity(0.3),
                              spreadRadius: 2,
                              blurRadius: 5,
                              offset:
                                  Offset(0, 3), // Changes position of shadow
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Case: ${patientData['case_number']}',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 18.0,
                                color: Colors.teal[900],
                              ),
                            ),
                            SizedBox(height: 8.0),
                            Text(
                              'Animal ID: ${patientData['animal_id']}',
                              style: TextStyle(color: Colors.teal[800]),
                            ),
                            Text(
                              'Species: ${patientData['species']}',
                              style: TextStyle(color: Colors.teal[800]),
                            ),
                            Text(
                              'Age: ${patientData['age']}',
                              style: TextStyle(color: Colors.teal[800]),
                            ),
                            Text(
                              'Weight: ${patientData['weight']} kg',
                              style: TextStyle(color: Colors.teal[800]),
                            ),
                          ],
                        ),
                      ));
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              style: TextButton.styleFrom(
                foregroundColor: Colors.teal[800],
                textStyle: const TextStyle(fontWeight: FontWeight.bold),
              ),
              child: const Text('Cancel'),
            ),
          ],
        );
      },
    );
  }

  void _addTreatment(BuildContext context, String patientId) {
    final TextEditingController _treatmentController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.teal[50], // Dialog background color
              borderRadius: BorderRadius.circular(12), // Rounded corners
            ),
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Add Treatment',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.teal[800],
                  ),
                ),
                SizedBox(height: 16),
                TextField(
                  controller: _treatmentController,
                  decoration: InputDecoration(
                    labelText: 'Enter Treatment Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  maxLines: 3,
                ),
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.teal[800],
                        textStyle: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      child: Text('Cancel'),
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        final treatment = _treatmentController.text.trim();

                        if (treatment.isNotEmpty) {
                          await _saveTreatmentToFirestore(
                              context, patientId, treatment);
                          Navigator.pop(context);
                          if (onTreatmentAdded != null) onTreatmentAdded!();
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Please enter a treatment.'),
                              backgroundColor: Colors.teal,
                            ),
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
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _saveTreatmentToFirestore(
      BuildContext context, String patientId, String treatment) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('patient_history')
          .doc(patientId)
          .collection('treatments') // Save the treatment in the subcollection
          .add({
        'treatmentDescription': treatment,
        'timestamp': FieldValue.serverTimestamp(),
      });

      // Show success message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Treatment added successfully!')),
      );
    } catch (e) {
      // Show error message
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error saving treatment: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: Icon(Icons.add_box, color: Colors.white), // Icon for the button
      label: Text('Add Treatment'), // Text label
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.teal, // Button background color
        foregroundColor: Colors.white, // Button color
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
      ),
      onPressed: () =>
          _selectPatient(context), // Call the patient selection method
    );
  }
}
