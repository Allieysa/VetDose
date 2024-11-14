import 'package:cloud_firestore/cloud_firestore.dart';

class FormulaService {
  // Generic method to fetch any document from the 'Formulas' collection by document ID
  Future<Map<String, dynamic>?> getFormula(String documentId) async {
    DocumentSnapshot doc = await FirebaseFirestore.instance
        .collection('Formulas')
        .doc(documentId)
        .get();
    if (doc.exists) {
      return doc.data() as Map<String, dynamic>;
    }
    return null;
  }
}
