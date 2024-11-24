import 'package:flutter/material.dart';
import 'package:vetdose/Formulas/dose_calculator.dart';
import 'package:vetdose/Formulas/formula_store.dart';

class CategoryPage extends StatefulWidget {
  final String category;
  final double weightKg;

  const CategoryPage({required this.category, required this.weightKg});

  @override
  _CategoryPageState createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  late TextEditingController _weightController;
  late double _weightKg;

  @override
  void initState() {
    super.initState();
    _weightKg = widget.weightKg; // Initialize weight with the passed value
    _weightController = TextEditingController(text: _weightKg.toString());
  }

  @override
  void dispose() {
    _weightController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final drugs = FormulaStore.getFormulasByCategory(widget.category);

    return Scaffold(
      appBar: AppBar(title: Text(widget.category)),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Container(
              width: double.infinity,
              height: 60,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 1,
                    blurRadius: 5,
                    offset: Offset(0, 3),
                  ),
                ],
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _weightController,
                      decoration: const InputDecoration(
                        labelText: 'Enter weight',
                        border: InputBorder.none,
                      ),
                      keyboardType: TextInputType.number,
                      onChanged: (value) {
                        setState(() {
                          _weightKg = double.tryParse(value) ?? 0.0;
                        });
                      },
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 8.0),
                    child: Text(
                      'kg',
                      style: TextStyle(color: Colors.grey),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: drugs.length,
              itemBuilder: (context, index) {
                final drugName = drugs.keys.elementAt(index);
                final drugData = drugs[drugName]!;
                final unit = drugData["unit"] ?? "units";
                final concentration = drugData["concentration"] ?? "N/A";

                return FutureBuilder<Map<String, double>>(
                  future: DoseCalculator().calculateDoses(
                    widget.category,
                    drugName,
                    _weightKg,
                  ),
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
                            Text(
                              drugName,
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Concentration: $concentration',
                              style: const TextStyle(
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(height: 12),
                            for (var doseEntry in doses.entries)
                              Container(
                                width: double.infinity,
                                padding: const EdgeInsets.symmetric(
                                    vertical: 12, horizontal: 12),
                                margin: const EdgeInsets.only(top: 8),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: RichText(
                                    text: TextSpan(
                                      text: '${doseEntry.key}: ',
                                      style: const TextStyle(
                                        fontSize: 14,
                                        color: Colors.black, // Dose key color
                                        fontWeight: FontWeight.bold,
                                      ),
                                      children: [
                                        TextSpan(
                                          text:
                                              '${doseEntry.value.toStringAsFixed(2)} $unit',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors
                                                .green.shade800, // Value color
                                            fontWeight: FontWeight.normal,
                                          ),
                                        ),
                                      ],
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
              },
            ),
          ),
        ],
      ),
    );
  }
}
