import 'package:flutter/material.dart';

class Lidocaine extends StatefulWidget {
  @override
  _LidocaineState createState() => _LidocaineState();
}

class _LidocaineState extends State<Lidocaine> {
  final TextEditingController _weightController = TextEditingController();

  double? bolusInjection;
  Map<String, double>? criSolutions;
  Map<String, double>? discardedNaCl;
  Map<String, double>? dripRateOption1;
  Map<String, double>? dripRateOption2;

  void calculateResults() {
    final double weight = double.tryParse(_weightController.text) ?? 0;

    if (weight > 0) {
      final calculator = LidocaineCalculator(weight);

      setState(() {
        bolusInjection = calculator.calculateBolusInjection();
        criSolutions = calculator.calculateCRI();
        discardedNaCl = calculator.calculateDiscardedNaCl(criSolutions!);

        dripRateOption1 =
            calculator.calculateDripRate('Option1', criSolutions!['Option1']!);
        dripRateOption2 =
            calculator.calculateDripRate('Option2', criSolutions!['Option2']!);
      });
    }
  }

  Widget tableCell(String text, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        style:
            TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Lidocaine Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: _weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Body Weight (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: calculateResults,
                child: Text('Calculate'),
              ),
              SizedBox(height: 16),
              if (bolusInjection != null) ...[
                // Step 1: Bolus Injection
                Text('Step 1: Bolus Injection',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      tableCell('Description', bold: true),
                      tableCell('Value', bold: true),
                    ]),
                    TableRow(children: [
                      tableCell('Bolus Injection'),
                      tableCell('${bolusInjection?.toStringAsFixed(2)} ml'),
                    ]),
                  ],
                ),

                SizedBox(height: 16),
                // Step 2: CRI Solution
                Text('Step 2: CRI Solution',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      tableCell('Option', bold: true),
                      tableCell('Volume (ml)', bold: true),
                    ]),
                    TableRow(children: [
                      tableCell('Option 1 (100 ml NS)'),
                      tableCell(
                          '${criSolutions?['Option1']?.toStringAsFixed(2)}'),
                    ]),
                    TableRow(children: [
                      tableCell('Option 2 (250 ml NS)'),
                      tableCell(
                          '${criSolutions?['Option2']?.toStringAsFixed(2)}'),
                    ]),
                  ],
                ),

                SizedBox(height: 16),
                // Step 3: Discarded NaCl Solution
                Text('Step 3: Discarded NaCl Solution',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      tableCell('Option', bold: true),
                      tableCell('Discarded Volume (ml)', bold: true),
                    ]),
                    TableRow(children: [
                      tableCell('Option 1 (100 ml NS)'),
                      tableCell(
                          '${discardedNaCl?['Option1']?.toStringAsFixed(2)}'),
                    ]),
                    TableRow(children: [
                      tableCell('Option 2 (250 ml NS)'),
                      tableCell(
                          '${discardedNaCl?['Option2']?.toStringAsFixed(2)}'),
                    ]),
                  ],
                ),

                SizedBox(height: 16),
                // Step 5: Drip Rates
                Text('Step 5: Drip Rates (Option 1)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      tableCell('Dosage', bold: true),
                      tableCell('ml/min', bold: true),
                      tableCell('drop/min', bold: true),
                      tableCell('drop/sec', bold: true),
                      tableCell('sec/drop', bold: true),
                    ]),
                    TableRow(children: [
                      tableCell('3 mg/kg/hr'),
                      tableCell(
                          '${dripRateOption1?['ml/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption1?['drop/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption1?['drop/sec']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption1?['sec/drop']?.toStringAsFixed(0)}'),
                    ]),
                  ],
                ),

                SizedBox(height: 16),
                Text('Step 5: Drip Rates (Option 2)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      tableCell('Dosage', bold: true),
                      tableCell('ml/min', bold: true),
                      tableCell('drop/min', bold: true),
                      tableCell('drop/sec', bold: true),
                      tableCell('sec/drop', bold: true),
                    ]),
                    TableRow(children: [
                      tableCell('3 mg/kg/hr'),
                      tableCell(
                          '${dripRateOption2?['ml/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption2?['drop/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption2?['drop/sec']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption2?['sec/drop']?.toStringAsFixed(0)}'),
                    ]),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class LidocaineCalculator {
  final double bodyWeight;

  LidocaineCalculator(this.bodyWeight);

  // Step 1: Bolus Injection
  double calculateBolusInjection() {
    const double dosageBolus = 1.3; // mg/kg
    const double concentration = 20; // mg/ml
    return (bodyWeight * dosageBolus) / concentration;
  }

  // Step 2: CRI Solution
  Map<String, double> calculateCRI() {
    const double fluidRate = 100; // ml/hr
    const double criDosage = 3; // mg/kg/hr
    const double concentration = 20; // mg/ml

    // Option 1
    final double solutionOption1 = (bodyWeight * criDosage) / concentration;

    // Option 2
    final double solutionOption2 = (250 / fluidRate) * solutionOption1;

    return {'Option1': solutionOption1, 'Option2': solutionOption2};
  }

  // Step 3: Discard NaCl Solution
  Map<String, double> calculateDiscardedNaCl(Map<String, double> criSolutions) {
    return {
      'Option1': criSolutions['Option1'] ?? 0,
      'Option2': criSolutions['Option2'] ?? 0,
    };
  }

  // Step 5: Drip Rate
  Map<String, double> calculateDripRate(String option, double solutionVolume) {
    const double criDosage = 3; // mg/kg/hr
    final double volumeFactor = option == 'Option1' ? 100 : 250;

    final double mlPerMinute =
        (1 / 20) * criDosage * bodyWeight * volumeFactor / solutionVolume / 60;

    final double dropsPerMinute = mlPerMinute * 20;
    final double dropsPerSecond = dropsPerMinute / 60;
    final double secondsPerDrop = 60 / dropsPerMinute;

    return {
      'ml/min': mlPerMinute,
      'drop/min': dropsPerMinute,
      'drop/sec': dropsPerSecond,
      'sec/drop': secondsPerDrop,
    };
  }
}
