import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class PatientDetailsScreen extends StatelessWidget {
  final String patientId;

  const PatientDetailsScreen({required this.patientId, Key? key})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    final FirebaseFirestore _firestore = FirebaseFirestore.instance;

    return Scaffold(
      backgroundColor:
          const Color.fromRGBO(254, 254, 254, 1), // Updated background color
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Patient Details',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
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
            return Center(
              child: Text(
                'Error loading patient details.',
                style:
                    TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            );
          }
          if (!snapshot.hasData || !snapshot.data!.exists) {
            return Center(child: CircularProgressIndicator(color: Colors.teal));
          }

          final patientData = snapshot.data!.data() as Map<String, dynamic>;

          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Title for Patient Information
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Patient Information',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                ),
                // Patient Details
                Container(
                  width: double.infinity, // Makes the container fill the width
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: Colors.teal[50], // Background color for details
                    borderRadius: BorderRadius.circular(12), // Rounded corners
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Name: ${patientData['name']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Type: ${patientData['type']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Age: ${patientData['age']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Weight: ${patientData['weight']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      Text('Symptoms: ${patientData['symptoms']}',
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                    ],
                  ),
                ),
                SizedBox(height: 16), // Space between sections
                // Treatments Title
                Padding(
                  padding: const EdgeInsets.only(bottom: 8.0),
                  child: Text(
                    'Treatments',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.teal[800],
                    ),
                  ),
                ),
                // Treatments List
                Expanded(
                  child: StreamBuilder<QuerySnapshot>(
                    stream: _firestore
                        .collection('users')
                        .doc(_auth.currentUser?.uid)
                        .collection('patient_history')
                        .doc(patientId)
                        .collection('treatments')
                        .orderBy('timestamp', descending: true)
                        .snapshots(),
                    builder: (context, treatmentSnapshot) {
                      if (treatmentSnapshot.hasError) {
                        return Center(
                          child: Text(
                            'Error loading treatments.',
                            style: TextStyle(
                                color: Colors.red, fontWeight: FontWeight.bold),
                          ),
                        );
                      }
                      if (!treatmentSnapshot.hasData) {
                        return Center(
                          child: CircularProgressIndicator(color: Colors.teal),
                        );
                      }

                      final treatments = treatmentSnapshot.data!.docs;

                      if (treatments.isEmpty) {
                        return Center(
                          child: Text(
                            'No treatments saved for this patient.',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.teal[800],
                            ),
                          ),
                        );
                      }

                      return ListView.builder(
                        itemCount: treatments.length,
                        itemBuilder: (context, index) {
                          final treatment =
                              treatments[index].data() as Map<String, dynamic>;
                          final treatmentDescription =
                              treatment['treatmentDescription'] ??
                                  'No description';
                          final timestamp = treatment['timestamp'] != null
                              ? DateTime.fromMillisecondsSinceEpoch(
                                  treatment['timestamp'].seconds * 1000)
                              : null;

                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8.0),
                            child: Card(
                              color: Colors.teal[50], // Light teal background
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      treatmentDescription,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    if (timestamp != null) ...[
                                      SizedBox(height: 8),
                                      Text(
                                        'Date: ${timestamp.toLocal()}',
                                        style: TextStyle(
                                          fontSize: 14,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
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
