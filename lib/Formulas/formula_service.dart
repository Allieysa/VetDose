import 'package:cloud_firestore/cloud_firestore.dart';

class FormulaService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // Fetch formula for a specific drug by its document ID
  Future<Map<String, dynamic>?> getFormula(String documentId) async {
    try {
      DocumentSnapshot doc =
          await _db.collection("Formulas").doc(documentId).get();
      if (doc.exists) {
        return doc.data() as Map<String, dynamic>?;
      }
    } catch (e) {
      print("Error fetching formula: $e");
    }
    return null;
  }
}

