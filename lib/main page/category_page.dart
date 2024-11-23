import 'package:flutter/material.dart';
import 'package:vetdose/Formulas/dose_calculator.dart';
import 'package:vetdose/Formulas/formula_store.dart';

class CategoryPage extends StatelessWidget {
  final String category;
  final double weightKg;

  const CategoryPage({required this.category, required this.weightKg});

  @override
  Widget build(BuildContext context) {
    final drugs = FormulaStore.getFormulasByCategory(category);

    return Scaffold(
      appBar: AppBar(title: Text(category)),
      body: ListView.builder(
        itemCount: drugs.length,
        itemBuilder: (context, index) {
          final drugName = drugs.keys.elementAt(index);
          return FutureBuilder<Map<String, double>>(
            future: DoseCalculator().calculateDoses(
                category, drugName, weightKg), // Pass all required arguments
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }

              if (snapshot.hasError || !snapshot.hasData) {
                return ListTile(
                  title: Text(drugName),
                  subtitle: const Text("Error calculating dose"),
                );
              }

              final doses = snapshot.data!;
              return Card(
                margin: const EdgeInsets.all(8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(drugName,
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 16)),
                      for (var doseEntry in doses.entries)
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                              vertical: 8, horizontal: 12),
                          margin: const EdgeInsets.only(top: 8),
                          decoration: BoxDecoration(
                            color: Colors.blue.shade100,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Text(
                            '${doseEntry.key}: ${doseEntry.value.toStringAsFixed(2)} mg',
                            style: const TextStyle(fontSize: 14),
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
