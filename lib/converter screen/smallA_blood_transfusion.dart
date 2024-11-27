import 'package:flutter/material.dart';

class BloodTransfusionPage extends StatefulWidget {
  @override
  _BloodTransfusionPageState createState() => _BloodTransfusionPageState();
}

class _BloodTransfusionPageState extends State<BloodTransfusionPage> {
  final TextEditingController recipientWeightController =
      TextEditingController();
  final TextEditingController recipientPCVController = TextEditingController();
  final TextEditingController desiredPCVController = TextEditingController();
  final TextEditingController donorPCVController = TextEditingController();

  double volumeRequired = 0.0;
  double infusionRateFirst15 = 0.0;
  double infusionRateAfter = 0.0;

  void calculate() {
    double recipientWeight =
        double.tryParse(recipientWeightController.text) ?? 0.0;
    double recipientPCV = double.tryParse(recipientPCVController.text) ?? 0.0;
    double desiredPCV = double.tryParse(desiredPCVController.text) ?? 0.0;
    double donorPCV = double.tryParse(donorPCVController.text) ?? 0.0;

    // Calculate Volume Required
    volumeRequired =
        ((desiredPCV - recipientPCV) / donorPCV * (recipientWeight * 70))
            .clamp(0, double.infinity);

    // Calculate Infusion Rates
    infusionRateFirst15 = recipientWeight * 1; // 1 mL/kg/hr
    infusionRateAfter = recipientWeight * 10; // 10 mL/kg/hr

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Transfusion'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: recipientWeightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Recipient Weight (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: recipientPCVController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Recipient PCV (%)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: desiredPCVController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Desired PCV (%)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: donorPCVController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Donor PCV (%)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculate,
                child: Text('Calculate'),
              ),
              SizedBox(height: 20),
              Text(
                'Results:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text('Volume Required: ${volumeRequired.toStringAsFixed(2)} mL'),
              Text(
                  'Infusion Rate (First 15 min): ${infusionRateFirst15.toStringAsFixed(2)} mL/hr'),
              Text(
                  'Infusion Rate (If No Reaction): ${infusionRateAfter.toStringAsFixed(2)} mL/hr'),
            ],
          ),
        ),
      ),
    );
  }
}
