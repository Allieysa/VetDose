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
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Blood Transfusion Calculator',
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
              // Recipient Information Card
              _buildInputCard(
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Recipient Information',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.teal[50],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              title: const Text(
                                'Recipient Information',
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.teal,
                                ),
                              ),
                              content: Column(
                                mainAxisSize: MainAxisSize.min,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: const [
                                  Text(
                                    'Recipient PCV (%):',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'The percentage of red blood cells in the recipient\'s blood.\n',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Desired PCV (%):',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'The target percentage of red blood cells in the recipient\'s blood after the transfusion.\n',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Donor PCV (%):',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'The target percentage of red blood cells in the donor\'s blood after the transfusion.\n',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.pop(context),
                                  child: const Text('Close'),
                                ),
                              ],
                            );
                          },
                        );
                      },
                      child: const Icon(
                        Icons.info_outline,
                        color: Colors.teal,
                      ),
                    ),
                  ],
                ),
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

              // Donor Information Card
              _buildInputCard(
                title: const Text(
                  'Donor Information',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
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
                    horizontal: 16.0,
                    vertical: 12.0,
                  ),
                ),
                child: const Text(
                  'Calculate',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 20),
              // Results Display
              if (showAddTreatmentButton)
                buildResultsCard(
                  'Results Summary',
                  [
                    {
                      'title': 'Volume Required (Cats)',
                      'value': '${volumeRequiredCat.toStringAsFixed(2)} mL',
                    },
                    {
                      'title': 'Volume Required (Dogs)',
                      'value': '${volumeRequiredDog.toStringAsFixed(2)} mL',
                    },
                    {
                      'title': 'First 15 min Rate',
                      'value':
                          '${infusionRateFirst15.toStringAsFixed(2)} mL/hr',
                    },
                    {
                      'title': 'Rate if No Reaction',
                      'value': '${infusionRateAfter.toStringAsFixed(2)} mL/hr',
                    },
                  ],
                ),
              const SizedBox(height: 16),
              // Add Treatment Button
              if (showAddTreatmentButton)
                AddTreatmentButton(
                  onTreatmentAdded: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Treatment added successfully!'),
                        backgroundColor: Colors.green,
                      ),
                    );
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputCard({
    required Widget title,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 1,
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            title,
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
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.teal.shade50,
        ),
      ),
    );
  }

  Widget buildResultsCard(String title, List<Map<String, String>> results) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.teal[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...results.map(
              (result) => Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 8.0,
                ),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      flex: 3,
                      child: Text(
                        result['title']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.teal,
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Expanded(
                      flex: 2,
                      child: Text(
                        result['value']!,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
