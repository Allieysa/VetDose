import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:vetdose/bottom_nav_bar.dart';
import 'package:vetdose/main page/controller.dart';
import 'package:vetdose/profile screen/patient_details_screen.dart';
import 'package:vetdose/profile screen/add_patient_dialog.dart';

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
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

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
              padding: const EdgeInsets.only(right: 20.0),
              child: ElevatedButton(
                onPressed: () {
                  showAddPatientDialog(context, () {
                    setState(() {}); // Refresh UI after adding a patient
                  });
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal.shade300,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  minimumSize: Size(80, 36),
                ),
                child: Text(
                  'Add Patient',
                  style: TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white, // White background for the search bar
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.2), // Subtle shadow
                    spreadRadius: 0,
                    blurRadius: 3,
                    offset: Offset(0, 4), // Shadow position
                  ),
                ],
              ),
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                  labelText: 'Search by Case Number',
                  labelStyle: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey.shade700, // Subtle text color for label
                  ),
                  prefixIcon: Icon(Icons.search, size: 20, color: Colors.grey),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none, // Remove default border
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(
                      color: Colors.teal.shade400, // Border color when focused
                      width: 1.5,
                    ),
                  ),
                  filled: true,
                  fillColor:
                      Colors.white, // Ensure the background remains white
                  contentPadding:
                      EdgeInsets.symmetric(vertical: 10, horizontal: 12),
                ),
                style: TextStyle(fontSize: 14),
                onChanged: (value) {
                  setState(() {
                    _searchQuery = value.trim().toLowerCase();
                  });
                },
              ),
            ),
          ),

          Expanded(
            child: StreamBuilder<QuerySnapshot>(
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

                // Filter patients based on the search query
                final filteredPatients = patients.where((doc) {
                  final data = doc.data() as Map<String, dynamic>;
                  final caseNumber = data['case_number']?.toString() ?? '';
                  return caseNumber.toLowerCase().contains(_searchQuery);
                }).toList();

                if (filteredPatients.isEmpty) {
                  return Center(child: Text('No matching patients found.'));
                }

                return ListView.builder(
                  itemCount: filteredPatients.length,
                  itemBuilder: (context, index) {
                    final patientDoc = filteredPatients[index];
                    final patient = patientDoc.data() as Map<String, dynamic>;

                    return Card(
                      color: Colors.white,
                      margin: EdgeInsets.all(15.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
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
                        child: Stack(
                          children: [
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 25.0, vertical: 10.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Case: ${patient['case_number'] ?? ''}',
                                        style: TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold),
                                      ),
                                      Text(
                                        'Animal ID: ${patient['animal_id'] ?? ''}',
                                        style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 5),
                                  Text(
                                    'Species: ${patient['species'] ?? ''}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Sex: ${patient['sex'] ?? ''}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Age: ${patient['age'] ?? ''}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Weight: ${patient['weight'] ?? ''}',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            Positioned(
                              bottom: 8,
                              right: 8,
                              child: IconButton(
                                icon: Icon(Icons.delete,
                                    color:
                                        const Color.fromARGB(255, 214, 78, 69),
                                    size: 20),
                                onPressed: () {
                                  _showDeleteConfirmationDialog(
                                      context, patientDoc.id);
                                },
                              ),
                            ),
                          ],
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
      bottomNavigationBar: BottomNavBar(
        currentIndex: widget.currentIndex,
        onTap: (index) {
          widget.controller.onTabTapped(index, context);
        },
      ),
    );
  }

  void _showDeleteConfirmationDialog(BuildContext context, String patientId) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text('Delete Note'),
          content: Text(
              'Are you sure you want to delete this note? This action cannot be undone.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                await _deletePatient(patientId);
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 253, 4, 4),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
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

  Future<void> _deletePatient(String patientId) async {
    try {
      await _firestore
          .collection('users')
          .doc(_auth.currentUser?.uid)
          .collection('patient_history')
          .doc(patientId)
          .delete();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Patient record deleted successfully.')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to delete patient: $e')),
      );
    }
  }
}
