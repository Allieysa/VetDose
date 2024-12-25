import 'package:flutter/material.dart';
import 'package:vetdose/converter screen/treatment_button.dart';

class Detomidine extends StatefulWidget {
  @override
  _DetomidineState createState() => _DetomidineState();
}

class _DetomidineState extends State<Detomidine> {
  final TextEditingController _weightController = TextEditingController();

  double? bolusInjection;
  Map<String, double>? criSolutions;
  Map<String, double>? discardedNaCl;
  List<Map<String, double>>? dripRatesOption1;
  List<Map<String, double>>? dripRatesOption2;

  bool showAddTreatmentButton = false; // To track if the button should be visible

  void calculateResults() {
    final double weight = double.tryParse(_weightController.text) ?? 0;

    if (weight > 0) {
      final calculator = DetomidineCalculator(weight);

      setState(() {
        bolusInjection = calculator.calculateBolusInjection();
        criSolutions = calculator.calculateCRI();
        discardedNaCl = calculator.calculateDiscardedNaCl(criSolutions!);

        dripRatesOption1 =
            calculator.calculateDripRate('Option1', criSolutions!['Option1']!);
        dripRatesOption2 =
            calculator.calculateDripRate('Option2', criSolutions!['Option2']!);

        showAddTreatmentButton = true; // Show the Add Treatment button
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter a valid weight.')),
      );
    }
  }
    Widget tableCell(String text, {bool bold = false}) {
    return Padding(
      padding: EdgeInsets.all(8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: bold ? FontWeight.bold : FontWeight.normal),
        textAlign: TextAlign.center,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Detomidine Calculator')),
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
                // Step 5: Drip Rates (Option 1)
                Text('Step 5: Drip Rates (Option 1)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Table(border: TableBorder.all(color: Colors.black), children: [
                  TableRow(children: [
                    tableCell('Dosage (mg/kg/hr)', bold: true),
                    tableCell('ml/min', bold: true),
                    tableCell('drop/min', bold: true),
                    tableCell('drop/sec', bold: true),
                    tableCell('sec/drop', bold: true),
                  ]),
                  ...dripRatesOption1!.map((rate) {
                    return TableRow(children: [
                      tableCell('${rate['dosage']?.toStringAsFixed(3)}'),
                      tableCell('${rate['ml/min']?.toStringAsFixed(2)}'),
                      tableCell('${rate['drop/min']?.toStringAsFixed(2)}'),
                      tableCell('${rate['drop/sec']?.toStringAsFixed(4)}'),
                      tableCell('${rate['sec/drop']?.toStringAsFixed(0)}'),
                    ]);
                  }).toList(),
                ]),

                SizedBox(height: 16),
                // Step 5: Drip Rates (Option 2)
                Text('Step 5: Drip Rates (Option 2)',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  children: [
                    TableRow(children: [
                      tableCell('Dosage (mg/kg/hr)', bold: true),
                      tableCell('ml/min', bold: true),
                      tableCell('drop/min', bold: true),
                      tableCell('drop/sec', bold: true),
                      tableCell('sec/drop', bold: true),
                    ]),
                    ...dripRatesOption2!.map((rate) {
                      return TableRow(children: [
                        tableCell('${rate['dosage']?.toStringAsFixed(3)}'),
                        tableCell('${rate['ml/min']?.toStringAsFixed(2)}'),
                        tableCell('${rate['drop/min']?.toStringAsFixed(2)}'),
                        tableCell('${rate['drop/sec']?.toStringAsFixed(4)}'),
                        tableCell('${rate['sec/drop']?.toStringAsFixed(0)}'),
                      ]);
                    }).toList(),
                  ],
                ),
                 SizedBox(height: 16),
              if (showAddTreatmentButton)
                AddTreatmentButton(
                  onTreatmentAdded: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Treatment process completed.')),
                    );
                  },
                )
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class DetomidineCalculator {
  final double bodyWeight;

  DetomidineCalculator(this.bodyWeight);

  // Step 1: Detomidine Bolus Injection
  double calculateBolusInjection() {
    const double dosageBolus = 0.005; // mg/kg
    const double concentration = 10; // mg/ml
    return (bodyWeight * dosageBolus) / concentration;
  }

  // Step 2: Detomidine CRI Solution
  Map<String, double> calculateCRI() {
    const double fluidRate = 100; // ml/hr
    const double criDosage = 0.01; // mg/kg/hr
    const double concentration = 10; // mg/ml

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

  // Step 5: Drip Rate Calculations
  List<Map<String, double>> calculateDripRate(
      String option, double solutionVolume) {
    const double concentration = 10; // mg/ml
    const double increment = 0.001; // Dosage increment
    const double initialDosage = 0.005; // Starting dosage
    const int steps = 6; // 0.005 to 0.010 (inclusive)

    double volumeFactor = option == 'Option1' ? 100 : 250;

    List<Map<String, double>> results = [];

    for (int i = 0; i < steps; i++) {
      double dosage = initialDosage + (i * increment);
      final double mlPerMinute =
          (bodyWeight * (1 / concentration) * dosage * volumeFactor) /
              solutionVolume /
              60;

      final double dropsPerMinute = mlPerMinute * 20;
      final double dropsPerSecond = dropsPerMinute / 60;
      final double secondsPerDrop = 60 / dropsPerMinute;

      results.add({
        'dosage': dosage,
        'ml/min': mlPerMinute,
        'drop/min': dropsPerMinute,
        'drop/sec': dropsPerSecond,
        'sec/drop': secondsPerDrop,
      });
    }

    return results;
  }
}
