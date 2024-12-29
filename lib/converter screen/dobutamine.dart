import 'package:flutter/material.dart';
import 'package:vetdose/converter screen/treatment_button.dart';

class Dobutamine extends StatefulWidget {
  @override
  _DobutamineState createState() => _DobutamineState();
}

class _DobutamineState extends State<Dobutamine> {
  final _formKey = GlobalKey<FormState>();
  final _weightController = TextEditingController();
  Map<String, double> dobAndNaCl = {};
  List<Map<String, double>> dripRates = [];

  bool showAddTreatmentButton =
      false; // To track if the button should be visible

  void calculateResults() {
    final double weight = double.tryParse(_weightController.text) ?? 0;

    if (weight > 0) {
      final calculator = DobutamineCalculator(weight);
      final Map<String, double> volumes =
          calculator.calculateDobutamineAndNaCl();
      final double dobutamineVolume = volumes['Dobutamine'] ?? 0;

      if (dobutamineVolume > 0) {
        setState(() {
          dobAndNaCl = volumes;
          dripRates = List.generate(10, (index) {
            final double dosage = index + 1.0; // Dosage increment
            return calculator.calculateDripRate(dosage, dobutamineVolume);
          });
          showAddTreatmentButton = true; // Show Add Treatment button
        });
      } else {
        setState(() {
          dobAndNaCl = {};
          dripRates = [];
          showAddTreatmentButton = false; // Hide Add Treatment button
        });
        print('Invalid Dobutamine volume.');
      }
    } else {
      setState(() {
        dobAndNaCl = {};
        dripRates = [];
        showAddTreatmentButton = false; // Hide Add Treatment button
      });
      print('Invalid weight input.');
    }
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dobutamine Calculator'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _weightController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Enter Patient Weight (kg)',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter the patient weight';
                    }
                    if (double.tryParse(value) == null ||
                        double.parse(value) <= 0) {
                      return 'Enter a valid weight';
                    }
                    return null;
                  },
                ),
                SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState?.validate() ?? false) {
                      calculateResults();
                    }
                  },
                  child: Text('Calculate'),
                ),
                SizedBox(height: 16),
                if (dobAndNaCl.isNotEmpty)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Results:',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(
                          'Dobutamine: ${dobAndNaCl['Dobutamine']?.toStringAsFixed(2)} ml'),
                      Text(
                          'NaCl: ${dobAndNaCl['NaCl']?.toStringAsFixed(2)} ml'),
                      SizedBox(height: 16),
                      Text('Drip Rates (1-10 µg/kg/min):',
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      SizedBox(height: 8),
                      Table(
                        border: TableBorder.all(),
                        columnWidths: const {
                          0: FlexColumnWidth(2.5),
                          1: FlexColumnWidth(2),
                          2: FlexColumnWidth(2),
                          3: FlexColumnWidth(2),
                          4: FlexColumnWidth(2),
                        },
                        children: [
                          // Table Header Row
                          TableRow(
                            decoration: BoxDecoration(
                                color:
                                    const Color.fromARGB(255, 225, 240, 226)),
                            children: [
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('Dosage         (µg/kg/min)',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('ml/min',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('drop/min',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('drop/sec',
                                    style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.bold,
                                    )),
                              ),
                              Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Text('sec/drop',
                                    style: TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold)),
                              ),
                            ],
                          ),
                          // Data Rows
                          ...dripRates.asMap().entries.map((entry) {
                            final index = entry.key + 1; // Dosage number
                            final rate = entry.value;
                            return TableRow(
                              children: [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('$index'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      '${rate['ml/min']?.toStringAsFixed(2)}'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      '${rate['drop/min']?.toStringAsFixed(2)}'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      '${rate['drop/sec']?.toStringAsFixed(2)}'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text(
                                      '${rate['sec/drop']?.toStringAsFixed(2)}'),
                                ),
                              ],
                            );
                          }).toList(),
                        ],
                      ),
                      SizedBox(height: 16),
                      if (showAddTreatmentButton)
                        AddTreatmentButton(
                          onTreatmentAdded: () {},
                        )
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class DobutamineCalculator {
  final double bodyWeight;

  DobutamineCalculator(this.bodyWeight);

  double calculateDiscardedNaCl() {
    final double drugDosePerMinute = ((bodyWeight * 10 * 60) / 1000 * 1);
    //final double drugDosePerHour = drugDosePerMinute * 60;
    final double concentration = 12.5; // mg/ml
    final double discardedNaCl = drugDosePerMinute / concentration;
    return discardedNaCl;
  }

  Map<String, double> calculateDobutamineAndNaCl() {
    final double dobutamineVolume = calculateDiscardedNaCl();
    final double naclVolume = 100 - dobutamineVolume;
    return {'Dobutamine': dobutamineVolume, 'NaCl': naclVolume};
  }

  Map<String, double> calculateDripRate(
      double dosage, double dobutamineVolume) {
    // M21 base value = 0.00008
    final double M21 = 0.00008 * dosage; // Increment by *2 for each dosage
    final double dbtNeededInAMin = M21 * bodyWeight;
    final double dbtNeededInAnHour = dbtNeededInAMin * 60;

    // Drip rate formula
    final double mlPerMinute =
        (dbtNeededInAnHour * 100) / (dobutamineVolume * 60);

    // Drop rate calculations
    final double dropsPerMinute =
        mlPerMinute * 20; // Macro drip set: 20 drops/ml
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
