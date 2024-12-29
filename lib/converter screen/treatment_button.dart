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
          title: Text('Select a Patient'),
          content: StreamBuilder<QuerySnapshot>(
            stream: _firestore
                .collection('users')
                .doc(_auth.currentUser?.uid)
                .collection('patient_history')
                .orderBy('timestamp', descending: true)
                .snapshots(),
            builder: (context, snapshot) {
              if (snapshot.hasError) return Text('Error loading patients.');
              if (!snapshot.hasData) return CircularProgressIndicator();

              final patients = snapshot.data!.docs;

              if (patients.isEmpty) {
                return Text('No patients available.');
              }

              return ListView.builder(
                shrinkWrap: true,
                itemCount: patients.length,
                itemBuilder: (context, index) {
                  final patient = patients[index];
                  final patientId = patient.id;
                  final patientData = patient.data() as Map<String, dynamic>;

                  return Container(
                    margin:
                        EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
                    padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12.0),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.3),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3), // changes position of shadow
                        ),
                      ],
                    ),
                    child: ListTile(
                      contentPadding:
                          EdgeInsets.zero, // Removes default padding
                      title: Text(
                        '${patientData['name']}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 18.0,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SizedBox(
                              height:
                                  8.0), // Spacing between title and subtitle
                          Text('Type: ${patientData['type']}'),
                          Text('Age: ${patientData['age']}'),
                          Text('Weight: ${patientData['weight']} kg'),
                        ],
                      ),
                      onTap: () {
                        Navigator.pop(context);
                        _addTreatment(context, patientId);
                      },
                    ),
                  );
                },
              );
            },
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
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
        return AlertDialog(
          title: Text('Add Treatment'),
          content: TextField(
            controller: _treatmentController,
            decoration: InputDecoration(
              labelText: 'Enter Treatment Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
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
                    SnackBar(content: Text('Please enter a treatment.')),
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
