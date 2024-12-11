import 'package:flutter/material.dart';

class Dobutamine extends StatefulWidget {
  @override
  _DobutamineState createState() => _DobutamineState();
}

class _DobutamineState extends State<Dobutamine> {
  final TextEditingController weightController = TextEditingController();
  final double concentration = 12.5; // Fixed Dobutamine concentration in mg/ml
  final double totalVolume = 100.0; // Final volume in ml

  // Results
  String dobAmount = "0";
  String dobVolume = "0";
  String naclVolume = "0";
  String finalConcentration = "0";

  void calculate() {
    final weight = double.tryParse(weightController.text);

    if (weight != null && weight > 0) {
      // Step 1: Calculate Dobutamine amount in mg
      final dobAmountCalc = weight * 3;

      // Step 2: Calculate Dobutamine volume in ml
      final dobVolumeCalc = dobAmountCalc / concentration;

      // Step 3: Calculate remaining NaCl volume
      final naclVolumeCalc = totalVolume - dobVolumeCalc;

      // Step 4: Calculate final concentration
      final finalConcentrationCalc = dobAmountCalc / totalVolume;

      // Update state
      setState(() {
        dobAmount = dobAmountCalc.toStringAsFixed(1);
        dobVolume = dobVolumeCalc.toStringAsFixed(1);
        naclVolume = naclVolumeCalc.toStringAsFixed(1);
        finalConcentration = finalConcentrationCalc.toStringAsFixed(1);
      });
    } else {
      // Handle invalid input
      setState(() {
        dobAmount = "0";
        dobVolume = "0";
        naclVolume = "0";
        finalConcentration = "0";
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Dobutamine Calculator')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Patient Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(onPressed: calculate, child: Text('Calculate')),
            SizedBox(height: 20),
            Text(
              'Results:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            Text('Amount of Dobutamine to Add: $dobAmount mg'),
            Text('Volume of Dobutamine: $dobVolume ml'),
            Text('Remaining NaCl Volume: $naclVolume ml'),
            Text('Final Concentration: $finalConcentration mg/ml'),
          ],
        ),
      ),
    );
  }
}
