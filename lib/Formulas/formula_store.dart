class FormulaStore {
  // Static map to hold all formulas and their metadata
  static const Map<String, Map<String, dynamic>> formulas = {
    "Tramadol": {
      "concentration": "50 mg/ml",
      "formulas": {
        "2 mg/kg": "(2/50)*kg",
        "3 mg/kg": "(3/50)*kg",
        "5 mg/kg": "(5/50)*kg",
      },
    },
    "Atropine": {
      "concentration": "1 mg/ml",
      "formulas": {
        "low": "(0.04/1)*kg",
        "medium": "(0.06/1)*kg",
      },
    },
    "Midazolam": {
      "concentration": "5 mg/ml",
      "formulas": {
        "low": "(0.1/1)*kg",
        "medium": "(0.2/1)*kg",
      },
    },
    // Add more drugs here as needed
  };

  // Method to fetch formula details by drug name
  static Map<String, dynamic>? getFormula(String drugName) {
    return formulas[drugName];
  }
}
