import 'package:vetdose/Formulas/formula_firestore.dart';

final FormulaService formulaService = FormulaService();

// Fetch kgToLbsConverter formula
Future<void> fetchKgToLbsFormula() async {
  final kgToLbsFormula = await formulaService.getFormula('kgToLbsConverter');
  print('kgToLbs formula: $kgToLbsFormula');
}

// Fetch Premed formula
Future<void> fetchPremedFormula() async {
  final premedFormula = await formulaService.getFormula('Premed');
  print('Premed formula: $premedFormula');
}
