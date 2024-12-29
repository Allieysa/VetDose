import 'package:flutter/material.dart';
import 'package:vetdose/converter screen/treatment_button.dart';

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

  bool showAddTreatmentButton = false; // Show Add Treatment button

  void calculateResults() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double dehydration = double.tryParse(dehydrationController.text) ?? 0.0;
    double diuresisRate = double.tryParse(diuresisRateController.text) ?? 0.0;
    double fluidLoss = double.tryParse(fluidLossController.text) ?? 0.0;

    // Maintenance volume
    double maintenanceVolumeDog = weight * 40;
    double maintenanceVolumeCat = weight * 60;

    // Diuresis rate
    double diuresisVolumeDog = diuresisRate * maintenanceVolumeDog;
    double diuresisVolumeCat = diuresisRate * maintenanceVolumeCat;

    // Dehydration (mL)
    double dehydrationVolume = weight * dehydration * 10;

    // Total fluid requirement
    totalFluidRequirementDog =
        dehydrationVolume + fluidLoss + diuresisVolumeDog;
    totalFluidRequirementCat =
        dehydrationVolume + fluidLoss + diuresisVolumeCat;

    // Maintenance only Microdrip
    maintenanceOnlyMacrodripDog = (totalFluidRequirementDog / 24) / 3;
    maintenanceOnlyMicrodripCat = totalFluidRequirementCat / 14;

    // Infusion pump rate
    infusionPumpRateDog = totalFluidRequirementDog / 24;
    infusionPumpRateCat = totalFluidRequirementCat / 24;

    // Microdrip rates (cat only)
    microdripMorningRateCat = ((totalFluidRequirementCat - 150) / 14);
    microdripNightRateCat = 15;

    showAddTreatmentButton = true; // Show Add Treatment button

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fluid Volume'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextField(
                controller: weightController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Enter Body Weight (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: dehydrationController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Dehydration (%)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: diuresisRateController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Diuresis Rate',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: fluidLossController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Fluid Loss',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateResults,
                style: ElevatedButton.styleFrom(
                  backgroundColor:
                      Colors.teal, // Correct property for background color
                  foregroundColor:
                      Colors.white, // Correct property for text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12), // Rounded corners
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
              Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Results for Dogs
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    margin: const EdgeInsets.only(
                        bottom: 20), // Spacing between sections
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50, // Light background
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Results for Dogs:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            'Total Fluid Requirement: ${totalFluidRequirementDog.toStringAsFixed(2)} mL/day'),
                        Text(
                            'Maintenance Only Macrodrip: ${maintenanceOnlyMacrodripDog.toStringAsFixed(2)} drops/min'),
                        Text(
                            'Infusion Pump Rate (24 hrs): ${infusionPumpRateDog.toStringAsFixed(2)} mL/hr'),
                      ],
                    ),
                  ),

                  // Results for Cats
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    decoration: BoxDecoration(
                      color: Colors.teal.shade50, // Light background
                      borderRadius:
                          BorderRadius.circular(12), // Rounded corners
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Results for Cats:',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 8),
                        Text(
                            'Total Fluid Requirement: ${totalFluidRequirementCat.toStringAsFixed(2)} mL/day'),
                        Text(
                            'Maintenance Only Microdrip: ${maintenanceOnlyMicrodripCat.toStringAsFixed(2)} drops/min'),
                        Text(
                            'Infusion Pump Rate (24 hrs): ${infusionPumpRateCat.toStringAsFixed(2)} mL/hr'),
                        Text(
                            'Microdrip Morning Rate: ${microdripMorningRateCat.toStringAsFixed(2)} drops/min'),
                        Text(
                            'Microdrip Night Rate: ${microdripNightRateCat.toStringAsFixed(2)} drops/min'),
                      ],
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              if (showAddTreatmentButton)
                AddTreatmentButton(
                  onTreatmentAdded: () {},
                ),
            ],
          ),
        ),
      ),
    );
  }
}
