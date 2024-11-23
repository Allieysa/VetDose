class FormulaStore {
  // Static map to hold all formulas and their metadata
  static const Map<String, Map<String, dynamic>> formulas = {
    "Premed": {
      "Tramadol": {
        "concentration": "50 mg/ml",
        "formulas": {
          "low": "(2/50)*kg",
          "medium": "(3/50)*kg",
          "high": "(5/50)*kg",
        },
      },
      "Atropine": {
        "concentration": "1 mg/ml",
        "formulas": {
          "low": "(0.04/1)*kg",
          "medium": "(0.06/1)*kg",
        },
      },
    },
    "Emergency": {
      "Epinephrine": {
        "concentration": "1 mg/ml",
        "formulas": {
          "low": "(0.01/1)*kg",
          "medium": "(0.02/1)*kg",
        },
      },
    },
    // Add more categories and drugs as needed
  };

  // Method to fetch formula details by category and drug name
  static Map<String, dynamic>? getFormula(String category, String drugName) {
    return formulas[category]?[drugName];
  }

  // Method to fetch all formulas in a category
  static Map<String, Map<String, dynamic>> getFormulasByCategory(
      String category) {
    final categoryData = formulas[category];
    if (categoryData != null) {
      return Map<String, Map<String, dynamic>>.from(categoryData);
    }
    return {};
  }
}
