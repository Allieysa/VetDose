import 'package:flutter/material.dart';
import 'package:vetdose/Formulas/dose_calculator.dart';

class PremedDetailed extends StatefulWidget {
  final String title;
  final double initialWeightKg;

  const PremedDetailed({
    required this.title,
    required this.initialWeightKg,
  });

  @override
  _PremedDetailedState createState() => _PremedDetailedState();
}

class _PremedDetailedState extends State<PremedDetailed> {
  late double animalWeightKg;
  late double animalWeightLbs;
  final TextEditingController weightController = TextEditingController();
  final DoseCalculator doseCalculator = DoseCalculator();

  @override
  void initState() {
    super.initState();
    animalWeightKg = widget.initialWeightKg;
    animalWeightLbs = widget.initialWeightKg * 2.20462;
    weightController.text = animalWeightKg.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Weight input section
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Enter weight (kg)',
                      border: OutlineInputBorder(),
                    ),
                    onChanged: (value) {
                      final newWeight = double.tryParse(value);
                      if (newWeight != null) {
                        setState(() {
                          animalWeightKg = newWeight;
                          animalWeightLbs =
                              newWeight * 2.20462; // Convert to lbs
                        });
                      }
                    },
                  ),
                ),
                const SizedBox(width: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Weight: ${animalWeightKg.toStringAsFixed(2)} kg'),
                    Text('(${animalWeightLbs.toStringAsFixed(2)} lbs)'),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Protocol details
            Expanded(
              child: GridView.count(
                crossAxisCount: MediaQuery.of(context).size.width > 600 ? 2 : 1,
                crossAxisSpacing: 6,
                mainAxisSpacing: 6,
                children: [
                  _buildDynamicProtocolCard('Premed', 'Tramadol'),
                  _buildDynamicProtocolCard('Premed', 'Atropine'),
                  _buildDynamicProtocolCard('Emergency', 'Midazolam'),
                  // Add more protocol cards as needed
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDynamicProtocolCard(String category, String drugName) {
    return FutureBuilder<Map<String, double>>(
      future: doseCalculator.calculateDoses(
          category, drugName, animalWeightKg), // Pass category
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (snapshot.hasError || !snapshot.hasData || snapshot.data!.isEmpty) {
          return Card(
            child: Center(
              child: Text(
                'Error calculating dose',
                style: TextStyle(color: Colors.red),
              ),
            ),
          );
        }

        final doses = snapshot.data!;
        return Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          elevation: 4,
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  drugName,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 16),
                for (var doseEntry in doses.entries)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${doseEntry.key}: ${doseEntry.value.toStringAsFixed(2)} mg',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.black87,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
