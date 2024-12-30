import 'package:flutter/material.dart';
import 'package:vetdose/converter%20screen/treatment_button.dart';

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

  bool showAddTreatmentButton = false;

  void calculateResults() {
    double recipientWeight =
        double.tryParse(recipientWeightController.text) ?? 0.0;
    double recipientPCV = double.tryParse(recipientPCVController.text) ?? 0.0;
    double desiredPCV = double.tryParse(desiredPCVController.text) ?? 0.0;
    double donorPCV = double.tryParse(donorPCVController.text) ?? 0.0;
    double donorWeight = double.tryParse(donorWeightController.text) ?? 0.0;

    totalBloodVolumeCat = recipientWeight * 70;
    totalBloodVolumeDog = recipientWeight * 90;
    donorBloodVolume = donorWeight * 90;

    volumeRequiredCat = ((desiredPCV - recipientPCV) * totalBloodVolumeCat) /
        donorPCV.clamp(1, double.infinity);
    volumeRequiredDog = ((desiredPCV - recipientPCV) * totalBloodVolumeDog) /
        donorPCV.clamp(1, double.infinity);

    infusionRateFirst15 = recipientWeight * 1;
    infusionRateAfter = recipientWeight * 10;

    showAddTreatmentButton = true;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Align(
          alignment: Alignment.centerLeft,
          child: Text(
            'Blood Transfusion Calculator',
            style: TextStyle(fontSize: 20),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipient Information
              _buildInputCard(
                title: 'Recipient Information',
                children: [
                  _buildTextField(
                    controller: recipientWeightController,
                    label: 'Recipient Weight (kg)',
                  ),
                  _buildTextField(
                    controller: recipientPCVController,
                    label: 'Recipient PCV (%)',
                  ),
                  _buildTextField(
                    controller: desiredPCVController,
                    label: 'Desired PCV (%)',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Donor Information
              _buildInputCard(
                title: 'Donor Information',
                children: [
                  _buildTextField(
                    controller: donorWeightController,
                    label: 'Donor Weight (kg)',
                  ),
                  _buildTextField(
                    controller: donorPCVController,
                    label: 'Donor PCV (%)',
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Calculate Button
              ElevatedButton(
                onPressed: calculateResults,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12.0,
                    vertical: 6.0,
                  ),
                ),
                child: const Text('Calculate'),
              ),
              const SizedBox(height: 20),
              // Results Display
              _buildResults(),
              const SizedBox(height: 16),
              // Add Treatment Button
              if (showAddTreatmentButton)
                AddTreatmentButton(
                  onTreatmentAdded: () {
                    setState(() {});
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard(
      {required String title, required List<Widget> children}) {
    return Card(
      color: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildResults() {
    return Column(
      children: [
        _buildResultContainer(
          title: 'Results for Cats',
          content:
              'Volume Required: ${volumeRequiredCat.toStringAsFixed(2)} mL',
        ),
        _buildResultContainer(
          title: 'Results for Dogs',
          content:
              'Volume Required: ${volumeRequiredDog.toStringAsFixed(2)} mL',
        ),
        _buildResultContainer(
          title: 'Infusion Rates',
          content:
              'First 15 min: ${infusionRateFirst15.toStringAsFixed(2)} mL/hr\n'
              'If No Reaction: ${infusionRateAfter.toStringAsFixed(2)} mL/hr',
        ),
      ],
    );
  }

  Widget _buildResultContainer({
    required String title,
    required String content,
  }) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.teal.shade50,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.2),
            blurRadius: 5,
            spreadRadius: 1,
          ),
        ],
      ),
      padding: const EdgeInsets.all(16.0),
      margin: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 10),
          Text(content),
        ],
      ),
    );
  }
}
