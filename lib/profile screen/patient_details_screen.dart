import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String patientId;

  const PatientDetailsScreen({required this.patientId, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      appBar: AppBar(
        title: Text('Patient Details'),
      ),
      body: FutureBuilder<DocumentSnapshot>(
        future: _firestore
            .collection('users')
            .doc(_auth.currentUser?.uid)
            .collection('patient_history')
            .doc(patientId)
            .get(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error loading patient details.'));
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: CircularProgressIndicator());
          }

          final patientData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display Patient Basic Info
                Text(
                  'Name: ${patientData['name']}',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                Text('Type: ${patientData['type']}'),
                Text('Age: ${patientData['age']}'),
                Text('Weight: ${patientData['weight']}'),
                Text('Symptoms: ${patientData['symptoms']}'),
                SizedBox(height: 16),

                // Display Treatments
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('users')
                        .doc(_auth.currentUser?.uid)
                        .collection('patient_history')
                        .doc(patientId)
                        .collection('treatments') // Fetch treatments under the specific patient
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, treatmentSnapshot) {
                      if (treatmentSnapshot.hasError) {
                        return Text('Error loading treatments.');
                      }
                      if (!treatmentSnapshot.hasData) {
                        return Center(child: CircularProgressIndicator());
                      }

                      final treatments = treatmentSnapshot.data!.docs;

                      if (treatments.isEmpty) {
                        return Text('No treatments saved for this patient.');
                      }

                      return ListView.builder(
                        itemCount: treatments.length,
                        itemBuilder: (context, index) {
                          final treatment = treatments[index].data() as Map<String, dynamic>;
                          final treatmentDescription = treatment['treatmentDescription'] ?? 'No description';
                          final timestamp = treatment['timestamp'] != null
                              ? DateTime.fromMillisecondsSinceEpoch(
                                  treatment['timestamp'].seconds * 1000)
                              : null;

                          return Card(
                            margin: EdgeInsets.symmetric(vertical: 8.0),
                            child: ListTile(
                              title: Text(treatmentDescription),
                              subtitle: timestamp != null
                                  ? Text('Date: ${timestamp.toLocal()}')
                                  : Text('No date available'),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
