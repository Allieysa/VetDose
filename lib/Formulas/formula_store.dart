class FormulaStore {
  // Static map to hold all formulas and their metadata
  static const Map<String, Map<String, dynamic>> formulas = {
    "Premed": {
      "Tramadol": {
        "concentration": "50 mg/ml",
        "formulas": {
          "2 mg/kg": "(2/50)*kg",
          "3 mg/kg": "(3/50)*kg",
          "5 mg/kg": "(5/50)*kg",
        },
        "unit": "mg",
      },
      "Atropine": {
        "concentration": "1 mg/ml",
        "formulas": {
          "0.04 mg/kg": "(0.04/1)*kg",
        },
        "unit": "mg",
      },
      "Midazolam": {
        "concentration": "5 mg/ml",
        "formulas": {
          "0.4 mg/kg": "(0.4/5)*kg",
        },
        "unit": "mg",
      },
      "Solucortef": {
        "concentration": "50 mg/ml",
        "formulas": {
          "5 mg/kg": "(5/50)*kg",
        },
        "unit": "mg",
      },
      "Dexamethasone": {
        "concentration": "2 mg/ml",
        "formulas": {
          "0.1 mg/kg": "(0.1/2)*kg",
        },
        "unit": "mg",
      },
      "Xylazine": {
        "concentration": "100 mg/ml",
        "formulas": {
          "1 mg/kg": "(1/100)*kg",
        },
        "unit": "mg",
      },
      "Morphine": {
        "concentration": "10 mg/ml",
        "formulas": {
          "0.2 mg/kg": "(0.2/10)*kg",
          "0.3 mg/kg": "(0.3/10)*kg",
          "0.5 mg/kg": "(0.5/10)*kg",
        },
        "unit": "mg",
      },
      "Fentanyl": {
        "concentration": "50 µg/ml",
        "formulas": {
          "1 µg/kg": "(1/50)*kg",
          "3 µg/kg": "(3/50)*kg",
          "5 µg/kg": "(5/50)*kg",
          "10 µg/kg": "(10/50)*kg",
        },
        "unit": "µg",
      },
      "Pethidine": {
        "concentration": "50 mg/ml",
        "formulas": {
          "2.5 mg/kg": "(2.5/50)*kg",
          "5 mg/kg": "(5/50)*kg",
        },
        "unit": "mg",
      },
    },
    "Induction": {
      "Propofol": {
        "concentration": "10 mg/ml",
        "formulas": {
          "1 mg/kg": "(1/10)*kg",
          "2 mg/kg": "(2/10)*kg",
          "3 mg/kg": "(3/10)*kg",
          "4 mg/kg": "(4/10)*kg",
          "5 mg/kg": "(5/10)*kg",
          "6 mg/kg": "(6/10)*kg",
          "7 mg/kg": "(7/10)*kg",
          "8 mg/kg": "(8/10)*kg",
        },
        "unit": "mg",
      },
    },
    "Intubation": {
      "EDTT": {
        "formulas": {
          "": "sqrt(5*kg)", // Formula for EDTT
        },
        "unit": "cm",
      },
    },
    "Local block": {
      "Bupivacaine": {
        "concentration": "5 mg/ml",
        "formulas": {
          "Epidural (0.2 ml/kg)": "0.2*kg",
          "Infiltrative (2 mg/kg)": "(2/5)*kg",
          "Infiltrative (1 mg/kg)": "(1/5)*kg",
        },
        "unit": "ml",
      },
      "Morphine": {
        "concentration": "10 mg/ml",
        "formulas": {
          "0.1 mg/kg": "(0.1/10)*kg",
        },
        "unit": "mg",
      },
      "Lidocaine": {
        "concentration": "20 mg/ml",
        "formulas": {
          "1 mg/kg (Cat)": "(1/20)*kg",
          "2 mg/kg (Cat)": "(2/20)*kg",
          "5 mg/kg (Dog)": "(5/20)*kg",
        },
        "unit": "mg",
      },
    },
    "Fluid rate": {
      "Microdrip": {
        "formulas": {
          "3 ml/kg/hr": "(60/(3*kg))",
          "5 ml/kg/hr": "(60/(5*kg))",
          "10 ml/kg/hr": "(60/(10*kg))",
        },
        "unit": "drops/min",
      },
      "Macrodrip": {
        "formulas": {
          "3 ml/kg/hr": "(60/((3*kg)/3))",
          "5 ml/kg/hr": "(60/((5*kg)/3))",
          "10 ml/kg/hr": "(60/((10*kg)/3))",
        },
        "unit": "drops/min",
      },
    },
    "Inotropic": {
      "Dopamine": {
        "concentration": "100 ml",
        "formulas": {
          "100 ml": "(3/20)*kg",
        },
        "unit": "ml",
      },
      "Adrenaline": {
        "concentration": "50 ml",
        "formulas": {
          "50 ml": "(3/10)*kg",
          "100 ml": "(3/5)*kg",
        },
        "unit": "ml",
      },
    },
    "Emergency": {
      "Adrenaline": {
        "concentration": "1 mg/ml",
        "formulas": {
          "Low dose": "0.01*kg",
          "High dose": "0.1*kg",
        },
        "unit": "mg",
      },
      "Chloramine": {
        "concentration": "10 mg/ml",
        "formulas": {
          "0.5 mg/kg": "(0.5/10)*kg",
        },
        "unit": "mg",
      },
      "Atropine": {
        "concentration": "1 mg/ml",
        "formulas": {
          "0.04 mg/kg": "0.04*kg",
        },
        "unit": "mg",
      },
      "Furosemide": {
        "concentration": "10 mg/ml",
        "formulas": {
          "2 mg/kg": "(2/10)*kg",
        },
        "unit": "mg",
      },
      "Aminophylline": {
        "concentration": "25 mg/ml",
        "formulas": {
          "5 mg/kg": "(5/25)*kg",
        },
        "unit": "mg",
      },
      "Lidocaine": {
        "concentration": "20 mg/ml",
        "formulas": {
          "1 mg/kg": "(1/20)*kg",
        },
        "unit": "mg",
      },
    },
    "Maintenance": {
      "Fentanyl": {
        "formulas": {
          "42 µg/kg/hr": "(42/50)*kg",
          "10 µg/kg/hr": "(10/50)*kg",
        },
        "unit": "µg/hr",
      },
      "Propofol": {
        "formulas": {
          "0.1 mg/kg/min": "((0.1/10)*kg)*60",
          "0.4 mg/kg/min": "((0.4/10)*kg)*60",
        },
        "unit": "mg/min",
      },
      "Meloxicam": {
        "concentration": "5 mg/ml",
        "formulas": {
          "0.2 mg/kg": "(0.2/5)*kg",
          "0.1 mg/kg": "(0.1/5)*kg",
        },
        "unit": "mg",
      },
    },
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
