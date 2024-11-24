import 'package:expressions/expressions.dart';
import 'formula_store.dart';
import 'dart:math';

class DoseCalculator {
  // Calculate doses for a specific drug and weight, categorized by category and drug name
  Future<Map<String, double>> calculateDoses(
      String category, String drugName, double weight) async {
    final formulaData = FormulaStore.getFormula(category, drugName);
    if (formulaData == null || !formulaData.containsKey("formulas")) {
      return {};
    }

    final Map<String, String> doseFormulas =
        Map<String, String>.from(formulaData["formulas"]);
    final Map<String, double> calculatedDoses = {};

    for (String doseKey in doseFormulas.keys) {
      final formula =
          doseFormulas[doseKey]?.replaceAll('kg', weight.toString());
      if (formula != null) {
        try {
          final Expression expression = Expression.parse(formula);
          final evaluator = const ExpressionEvaluator();
          final context = {'sqrt': sqrt}; // Include sqrt function
          final result = evaluator.eval(expression, context);
          calculatedDoses[doseKey] = double.parse(result.toString());
        } catch (e) {
          print("Error evaluating formula for $doseKey: $e");
        }
      }
    }
    return calculatedDoses;
  }
}
