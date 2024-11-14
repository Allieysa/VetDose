import 'package:vetdose/Formulas/formula_firestore.dart';
import 'package:expressions/expressions.dart'; // Import expressions package

class KgToLbsConverter {
  final FormulaService _formulaService = FormulaService();

  Future<double?> convert(double kg) async {
    // Fetch the kg to lbs conversion formula directly using getFormula
    final formulaData = await _formulaService.getFormula('kgToLbsConverter');
    final formulaString =
        (formulaData != null && formulaData.containsKey('formula'))
            ? formulaData['formula']
            : "kg * 2.20462"; // Default formula if missing

    final expression = Expression.parse(formulaString);
    final evaluator = const ExpressionEvaluator();
    final result = evaluator.eval(expression, {'kg': kg});

    return result as double?;
  }
}
