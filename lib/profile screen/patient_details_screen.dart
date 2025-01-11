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
      backgroundColor: const Color.fromRGBO(254, 254, 254, 1),
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
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16.0),
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 235, 248, 247),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Table(
                    columnWidths: const {
                      0: IntrinsicColumnWidth(),
                      1: FlexColumnWidth(),
                    },
                    defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                    children: [
                      _buildTableRow('Case Number', patientData['case_number']),
                      _buildTableRow('Animal ID', patientData['animal_id']),
                      _buildTableRow('Species', patientData['species']),
                      _buildTableRow('Sex', patientData['sex']),
                      _buildTableRow('Age', patientData['age']),
                      _buildTableRow('Weight', patientData['weight']),
                      _buildTableRow('Symptoms', patientData['symptoms']),
                      _buildTableRow('Owner Name', patientData['owner_name']),
                    ],
                  ),
                ),
                SizedBox(height: 10),
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
                          final treatmentDoc = treatments[index];
                          final treatment =
                              treatmentDoc.data() as Map<String, dynamic>;
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
                              color: const Color.fromARGB(255, 232, 245, 245),
                              margin: EdgeInsets.zero,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(12.0),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          child: Text(
                                            treatmentDescription,
                                            style: TextStyle(fontSize: 16),
                                          ),
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.edit,
                                              color: Colors.teal),
                                          onPressed: () {
                                            _showEditTreatmentDialog(context,
                                                treatmentDoc.id, treatment);
                                          },
                                        ),
                                        IconButton(
                                          icon: Icon(Icons.delete,
                                              color: Colors.red),
                                          onPressed: () {
                                            _showDeleteConfirmationDialog(
                                                context,
                                                patientId,
                                                treatmentDoc.id);
                                          },
                                        ),
                                      ],
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

  // Helper function to build a table row
  TableRow _buildTableRow(String label, String? value) {
    return TableRow(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            '$label:     ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4.0),
          child: Text(
            value ?? 'N/A',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  // Function to show edit treatment dialog
  void _showEditTreatmentDialog(BuildContext context, String treatmentId,
      Map<String, dynamic> treatment) {
    final TextEditingController treatmentController =
        TextEditingController(text: treatment['treatmentDescription']);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.teal[50], // Teal background for the dialog
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          title: Text(
            'Edit Treatment',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.teal[800],
            ),
          ),
          content: TextField(
            controller: treatmentController,
            decoration: InputDecoration(
              labelText: 'Treatment Description',
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              filled: true,
              fillColor: Colors.white, // White input area background
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection('users')
                    .doc(FirebaseAuth.instance.currentUser?.uid)
                    .collection('patient_history')
                    .doc(patientId)
                    .collection('treatments')
                    .doc(treatmentId)
                    .update({
                  'treatmentDescription': treatmentController.text,
                  'timestamp': FieldValue.serverTimestamp(),
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.teal,
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                'Update',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  // Function to show delete confirmation dialog
  void _showDeleteConfirmationDialog(
      BuildContext context, String patientId, String treatmentId) {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Confirm Deletion'),
          content: Text(
              'Are you sure you want to delete this treatment? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 253, 4, 4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onPressed: () async {
                await _deletePatient(context, patientId, treatmentId);

                Navigator.pop(context); // Close the dialog after deletion
              },
              child: Text(
                'Delete',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _deletePatient(
      BuildContext context, String patientId, String treatmentId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .collection('patient_history')
          .doc(patientId)
          .collection('treatments')
          .doc(treatmentId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Treatment record deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete treatment: $e')),
      );
    }
  }
}
