import 'package:flutter/material.dart';
import 'package:vetdose/converter screen/treatment_button.dart';

class Xylazine extends StatefulWidget {
  @override
  _XylazineState createState() => _XylazineState();
}

class _XylazineState extends State<Xylazine> {
  final TextEditingController _weightController = TextEditingController();

  double? bolusInjection;
  Map<String, double>? criSolutions;
  Map<String, double>? dripRateOption1_07, dripRateOption1_11;
  Map<String, double>? dripRateOption2_07, dripRateOption2_11;

  bool showAddTreatmentButton =
      false; // To track if the button should be visible

  void calculateResults() {
    final double weight = double.tryParse(_weightController.text) ?? 0;

    if (weight > 0) {
      final calculator = XylazineCalculator(weight);

      showAddTreatmentButton = true; // Show Add Treatment button

      setState(() {
        bolusInjection = calculator.calculateBolusInjection();
        criSolutions = calculator.calculateCRI();

        dripRateOption1_07 = calculator.calculateDripRate(
            'Option1', 0.7, criSolutions!['Option1']!);
        dripRateOption1_11 = calculator.calculateDripRate(
            'Option1', 1.1, criSolutions!['Option1']!);
        dripRateOption2_07 = calculator.calculateDripRate(
            'Option2', 0.7, criSolutions!['Option2']!);
        dripRateOption2_11 = calculator.calculateDripRate(
            'Option2', 1.1, criSolutions!['Option2']!);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Xylazine Calculator',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
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
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.teal[50],
                ),
              ),
              SizedBox(height: 16),
              ElevatedButton(
                onPressed: calculateResults,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                ),
                child: Text(
                  'Calculate',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 16),
              if (bolusInjection != null) ...[
                SizedBox(height: 16),
                Text('Step 1: Bolus Injection',
                    style: TextStyle(fontWeight: FontWeight.bold)),

// Table for Step 1 (Bolus Injection)
                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(2), // Step column
                    1: FlexColumnWidth(3), // Result column
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.teal[50]),
                      children: [
                        tableCell('Description', bold: true),
                        tableCell('Value', bold: true),
                      ],
                    ),
                    TableRow(children: [
                      tableCell('Bolus Injection'),
                      tableCell('${bolusInjection?.toStringAsFixed(2)} ml'),
                    ]),
                  ],
                ),

                SizedBox(height: 16),
                Text('Step 2: CRI Solution',
                    style: TextStyle(fontWeight: FontWeight.bold)),

// Table for Step 2 (Option 1 and Option 2)
                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(2), // Option column
                    1: FlexColumnWidth(3), // Volume column
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.teal[50]),
                      children: [
                        tableCell('Option', bold: true),
                        tableCell('Volume (ml)', bold: true),
                      ],
                    ),
                    TableRow(children: [
                      tableCell('Option 1 (100 ml NS)'),
                      tableCell(
                          '${criSolutions?['Option1']?.toStringAsFixed(2)} ml'),
                    ]),
                    TableRow(children: [
                      tableCell('Option 2 (250 ml NS)'),
                      tableCell(
                          '${criSolutions?['Option2']?.toStringAsFixed(2)} ml'),
                    ]),
                  ],
                ),

// Table for Step 3 (Discarded NaCl Solution)
                SizedBox(height: 16),
                Text('Step 3: Discarded NaCl solution (ml)',
                    style: TextStyle(fontWeight: FontWeight.bold)),

                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: const {
                    0: FlexColumnWidth(2), // Option column
                    1: FlexColumnWidth(3), // Volume column
                  },
                  children: [
                    TableRow(
                      decoration: BoxDecoration(color: Colors.teal[50]),
                      children: [
                        tableCell('Option', bold: true),
                        tableCell('Discarded Volume (ml)', bold: true),
                      ],
                    ),
                    TableRow(children: [
                      tableCell('Option 1 (100 ml NS)'),
                      tableCell(
                          '${criSolutions?['Option1']?.toStringAsFixed(2)} ml'),
                    ]),
                    TableRow(children: [
                      tableCell('Option 2 (250 ml NS)'),
                      tableCell(
                          '${criSolutions?['Option2']?.toStringAsFixed(2)} ml'),
                    ]),
                  ],
                ),
// Table for Option 1 STEP 5
                SizedBox(height: 16),
                Text('Step 5: Drip Rates',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                SizedBox(height: 8),
                Text('OPTION 1', style: TextStyle(fontWeight: FontWeight.bold)),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: {
                    0: FlexColumnWidth(2), // Dosage column
                    1: FlexColumnWidth(2), // ml/min column
                    2: FlexColumnWidth(2), // drop/min column
                    3: FlexColumnWidth(2), // drop/sec column
                    4: FlexColumnWidth(2), // sec/drop column
                  },
                  children: [
                    // Header Row
                    TableRow(
                      decoration: BoxDecoration(color: Colors.teal[50]),
                      children: [
                        tableCell('Dosage mg/kg/hr', bold: true),
                        tableCell('ml/min', bold: true),
                        tableCell('drop/min', bold: true),
                        tableCell('drop/sec', bold: true),
                        tableCell('sec/drop', bold: true),
                      ],
                    ),
                    // Row for 0.7 mg/kg/hr
                    TableRow(children: [
                      tableCell('0.7 '),
                      tableCell(
                          '${dripRateOption1_07?['ml/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption1_07?['drop/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption1_07?['drop/sec']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption1_07?['sec/drop']?.toStringAsFixed(0)}'),
                    ]),
                    // Row for 1.1 mg/kg/hr
                    TableRow(children: [
                      tableCell('1.1'),
                      tableCell(
                          '${dripRateOption1_11?['ml/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption1_11?['drop/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption1_11?['drop/sec']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption1_11?['sec/drop']?.toStringAsFixed(0)}'),
                    ]),
                  ],
                ),

                SizedBox(height: 16),

// Table for Option 2 STEP 5
                Text('OPTION 2', style: TextStyle(fontWeight: FontWeight.bold)),
                Table(
                  border: TableBorder.all(color: Colors.black),
                  columnWidths: {
                    0: FlexColumnWidth(2), // Dosage column
                    1: FlexColumnWidth(2), // ml/min column
                    2: FlexColumnWidth(2), // drop/min column
                    3: FlexColumnWidth(2), // drop/sec column
                    4: FlexColumnWidth(2), // sec/drop column
                  },
                  children: [
                    // Header Row
                    TableRow(
                      decoration: BoxDecoration(color: Colors.teal[50]),
                      children: [
                        tableCell('Dosage  mg/kg/hr', bold: true),
                        tableCell('ml/min', bold: true),
                        tableCell('drop/min', bold: true),
                        tableCell('drop/sec', bold: true),
                        tableCell('sec/drop', bold: true),
                      ],
                    ),
                    // Row for 0.7 mg/kg/hr
                    TableRow(children: [
                      tableCell('0.7'),
                      tableCell(
                          '${dripRateOption2_07?['ml/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption2_07?['drop/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption2_07?['drop/sec']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption2_07?['sec/drop']?.toStringAsFixed(0)}'),
                    ]),
                    // Row for 1.1 mg/kg/hr
                    TableRow(children: [
                      tableCell('1.1'),
                      tableCell(
                          '${dripRateOption2_11?['ml/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption2_11?['drop/min']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption2_11?['drop/sec']?.toStringAsFixed(2)}'),
                      tableCell(
                          '${dripRateOption2_11?['sec/drop']?.toStringAsFixed(0)}'),
                    ]),
                  ],
                ),
                SizedBox(height: 16),
                if (showAddTreatmentButton)
                  AddTreatmentButton(
                    onTreatmentAdded: () {},
                  ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class XylazineCalculator {
  final double bodyWeight;

  XylazineCalculator(this.bodyWeight);

  double calculateBolusInjection() {
    const double dosageBolus = 0.55; // mg/kg
    const double concentration = 100; // mg/ml
    return (bodyWeight * dosageBolus) / concentration;
  }

  Map<String, double> calculateCRI() {
    const double dosageCRI = 0.011; // ml/kg/hr (Option 1)
    const double fluidRate = 100; // ml/hr
    const double naclVolume = 250; // ml

    final double option1 = bodyWeight * dosageCRI;

    final double k5 = 1.1;
    final double k10 = (bodyWeight * k5) / 100;
    final double k11 = naclVolume / fluidRate;
    final double option2 = k11 * k10;

    return {'Option1': option1, 'Option2': option2};
  }

  Map<String, double> calculateDripRate(
      String option, double dosageMgPerKgHr, double solutionVolume) {
    double volumeFactor = option == 'Option1' ? 100 : 250;

    final double mlPerMinute = (1 / 100) *
        dosageMgPerKgHr *
        bodyWeight *
        volumeFactor /
        solutionVolume /
        60;

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
