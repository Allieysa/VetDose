import 'package:flutter/material.dart';

class Detomidine extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final weightController = TextEditingController();
    final doseController = TextEditingController();
    String result = "";

    void calculateDetomidine() {
      final weight = double.tryParse(weightController.text);
      final dose = double.tryParse(doseController.text);
      if (weight != null && dose != null) {
        final doseRate = weight * dose;
        result = "Dobutamine Rate: ${doseRate.toStringAsFixed(2)} mg/hr";
        (context as Element).markNeedsBuild();
      }
    }

    return Scaffold(
      appBar: AppBar(title: Text('Dobutamine')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: weightController,
              decoration: InputDecoration(labelText: 'Weight (kg)'),
              keyboardType: TextInputType.number,
            ),
            TextField(
              controller: doseController,
              decoration: InputDecoration(labelText: 'Dose (mg/kg/hr)'),
              keyboardType: TextInputType.number,
            ),
            SizedBox(height: 20),
            ElevatedButton(
                onPressed: calculateDetomidine, child: Text('Calculate')),
            SizedBox(height: 20),
            Text(result, style: TextStyle(fontSize: 18)),
          ],
        ),
      ),
    );
  }
}
