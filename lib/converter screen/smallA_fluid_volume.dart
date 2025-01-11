import 'package:flutter/material.dart';

class FluidVolumePage extends StatefulWidget {
  @override
  _FluidVolumePageState createState() => _FluidVolumePageState();
}

class _FluidVolumePageState extends State<FluidVolumePage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController dehydrationController = TextEditingController();
  final TextEditingController diuresisRateController = TextEditingController();
  final TextEditingController fluidLossController = TextEditingController();

  double totalFluidRequirementDog = 0.0;
  double totalFluidRequirementCat = 0.0;
  double maintenanceOnlyMacrodripDog = 0.0;
  double maintenanceOnlyMicrodripCat = 0.0;
  double infusionPumpRateDog = 0.0;
  double infusionPumpRateCat = 0.0;
  double microdripMorningRateCat = 0.0;
  double microdripNightRateCat = 0.0;

  bool showAddTreatmentButton = false;

  void calculateResults() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double dehydration = double.tryParse(dehydrationController.text) ?? 0.0;
    double diuresisRate = double.tryParse(diuresisRateController.text) ?? 0.0;
    double fluidLoss = double.tryParse(fluidLossController.text) ?? 0.0;

    double maintenanceVolumeDog = weight * 40;
    double maintenanceVolumeCat = weight * 60;

    double diuresisVolumeDog = diuresisRate * maintenanceVolumeDog;
    double diuresisVolumeCat = diuresisRate * maintenanceVolumeCat;

    double dehydrationVolume = weight * dehydration * 10;

    totalFluidRequirementDog =
        dehydrationVolume + fluidLoss + diuresisVolumeDog;
    totalFluidRequirementCat =
        dehydrationVolume + fluidLoss + diuresisVolumeCat;

    maintenanceOnlyMacrodripDog = (totalFluidRequirementDog / 24) / 3;
    maintenanceOnlyMicrodripCat = totalFluidRequirementCat / 14;

    infusionPumpRateDog = totalFluidRequirementDog / 24;
    infusionPumpRateCat = totalFluidRequirementCat / 24;

    microdripMorningRateCat = ((totalFluidRequirementCat - 150) / 14);
    microdripNightRateCat = 15;

    showAddTreatmentButton = true;

    setState(() {});
  }

  Widget buildInputField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextField(
        controller: controller,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          filled: true,
          fillColor: Colors.teal[50],
        ),
      ),
    );
  }

  Widget buildResultsCard(String title, List<Map<String, String>> results) {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.teal[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.teal,
              ),
            ),
            SizedBox(height: 8),
            ...results.map((result) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 3,
                        child: Text(
                          result['title']!,
                          style: TextStyle(
                            fontWeight: FontWeight.w500,
                            color: Colors.teal[700],
                          ),
                        ),
                      ),
                      SizedBox(width: 8),
                      Expanded(
                        flex: 2,
                        child: Text(
                          result['value']!,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.right,
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Fluid Volume',
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
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Enter Animal Data',
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  InkWell(
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            backgroundColor:
                                Colors.teal[50], // White background
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                            title: Text(
                              'Parameter Descriptions',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.teal[800],
                              ),
                            ),
                            content: SingleChildScrollView(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Dehydration:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'The percentage of body fluid loss. Common ranges: 5-10%.\n',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Diuresis Rate:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'The amount of urine produced over time, indicating kidney function and fluid balance.\n',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                  Text(
                                    'Fluid Loss:',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16),
                                  ),
                                  Text(
                                    'Fluids lost due to vomiting, diarrhea, or excessive urination.',
                                    style: TextStyle(fontSize: 14),
                                  ),
                                ],
                              ),
                            ),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.pop(context),
                                child: Text('Close'),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Icon(Icons.info_outline, color: Colors.teal),
                  ),
                ],
              ),
              SizedBox(height: 10),

              // Body Weight Input Field
              buildInputField('Body Weight (kg)', weightController),

              // Dehydration Input Field
              buildInputField('Dehydration (%)', dehydrationController),

              // Diuresis Rate Input Field
              buildInputField('Diuresis Rate', diuresisRateController),

              // Fluid Loss Input Field
              buildInputField('Fluid Loss', fluidLossController),

              SizedBox(height: 20),

              ElevatedButton(
                onPressed: calculateResults,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.teal,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
                ),
                child: Text(
                  'Calculate',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              SizedBox(height: 20),
              if (showAddTreatmentButton)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildResultsCard('Results for Dogs:', [
                      {
                        'title': 'Total Fluid Requirement',
                        'value':
                            '${totalFluidRequirementDog.toStringAsFixed(2)} mL/day'
                      },
                      {
                        'title': 'Maintenance Only Macrodrip',
                        'value':
                            '${maintenanceOnlyMacrodripDog.toStringAsFixed(2)} drops/min'
                      },
                      {
                        'title': 'Infusion Pump Rate        (24 hrs)',
                        'value':
                            '${infusionPumpRateDog.toStringAsFixed(2)} mL/hr'
                      },
                    ]),
                    SizedBox(height: 20),
                    buildResultsCard('Results for Cats/Small dogs (<10 kg):', [
                      {
                        'title': 'Total Fluid Requirement',
                        'value':
                            '${totalFluidRequirementCat.toStringAsFixed(2)} mL/day'
                      },
                      {
                        'title': 'Maintenance Only Microdrip',
                        'value':
                            '${maintenanceOnlyMicrodripCat.toStringAsFixed(2)} drops/min'
                      },
                      {
                        'title': 'Infusion Pump Rate        (24 hrs)',
                        'value':
                            '${infusionPumpRateCat.toStringAsFixed(2)} mL/hr'
                      },
                      {
                        'title': 'Microdrip Morning Rate',
                        'value':
                            '${microdripMorningRateCat.toStringAsFixed(2)} drops/min'
                      },
                      {
                        'title': 'Microdrip Night Rate',
                        'value':
                            '${microdripNightRateCat.toStringAsFixed(2)} drops/min'
                      },
                    ]),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
