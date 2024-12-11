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
  final TextEditingController donorWeightController = TextEditingController();

  double volumeRequiredDog = 0.0;
  double volumeRequiredCat = 0.0;
  double infusionRateFirst15 = 0.0;
  double infusionRateAfter = 0.0;
  double totalBloodVolumeCat = 0.0;
  double totalBloodVolumeDog = 0.0;
  double donorBloodVolume = 0.0;

  void calculate() {
    double recipientWeight =
        double.tryParse(recipientWeightController.text) ?? 0.0;
    double recipientPCV = double.tryParse(recipientPCVController.text) ?? 0.0;
    double desiredPCV = double.tryParse(desiredPCVController.text) ?? 0.0;
    double donorPCV = double.tryParse(donorPCVController.text) ?? 0.0;
    double donorWeight = double.tryParse(donorWeightController.text) ?? 0.0;

    // Total Blood Volume Calculation
    totalBloodVolumeCat = recipientWeight * 70;
    totalBloodVolumeDog = recipientWeight * 90;

    // Donor Blood Volume
    donorBloodVolume = donorWeight * 90; // 90 mL/kg assumption

    // Volume Required Calculation
    volumeRequiredCat = ((desiredPCV - recipientPCV) * totalBloodVolumeCat) /
        donorPCV.clamp(1, double.infinity);
    volumeRequiredDog = ((desiredPCV - recipientPCV) * totalBloodVolumeDog) /
        donorPCV.clamp(1, double.infinity);

    // Infusion Rates Calculation
    infusionRateFirst15 =
        recipientWeight * 1; // 1 mL/kg/hr for first 15 minutes
    infusionRateAfter = recipientWeight * 10; // 10 mL/kg/hr if no reaction

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Blood Transfusion Calculator'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipient Input Section
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Recipient Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Donor Input Section
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Donor Information',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      TextField(
                        controller: donorWeightController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: 'Donor Weight (kg)',
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
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculate,
                child: Text('Calculate'),
              ),
              SizedBox(height: 20),
              // Results for Cats
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Results for Cats',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                          'Volume Required: ${volumeRequiredCat.toStringAsFixed(2)} mL'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Results for Dogs
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Results for Dogs',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                          'Volume Required: ${volumeRequiredDog.toStringAsFixed(2)} mL'),
                    ],
                  ),
                ),
              ),
              SizedBox(height: 20),
              // Infusion Rates
              Card(
                elevation: 3,
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Infusion Rates',
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 10),
                      Text(
                          'First 15 min: ${infusionRateFirst15.toStringAsFixed(2)} mL/hr'),
                      Text(
                          'If No Reaction: ${infusionRateAfter.toStringAsFixed(2)} mL/hr'),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
