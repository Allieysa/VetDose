import 'package:flutter/material.dart';

class FluidVolumePage extends StatefulWidget {
  @override
  _FluidVolumePageState createState() => _FluidVolumePageState();
}

class _FluidVolumePageState extends State<FluidVolumePage> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController dehydrationController = TextEditingController();
  final TextEditingController diuresisRateController = TextEditingController();

  double totalFluidRequirement = 0.0;
  double maintenanceOnlyMicrodrip = 0.0;
  double infusionPumpRate = 0.0;
  double microdripMorningRate = 0.0;
  double microdripNightRate = 0.0;

  void calculate() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double dehydration = double.tryParse(dehydrationController.text) ?? 0.0;
    double diuresisRate = double.tryParse(diuresisRateController.text) ?? 0.0;

    // Maintenance volume (Small dog/cat)
    double maintenanceVolume = weight * 60;

    // Dehydration (mL)
    double dehydrationVolume = weight * dehydration * 10;

    // Diuresis rate
    double diuresisVolume = diuresisRate * 300;

    // Total fluid requirement
    totalFluidRequirement =
        maintenanceVolume + dehydrationVolume + diuresisVolume;

    // Maintenance only microdrip
    maintenanceOnlyMicrodrip = maintenanceVolume / 5;

    // Infusion pump rate (24 hours)
    infusionPumpRate = totalFluidRequirement / 24;

    // Microdrip rates (morning and night)
    microdripMorningRate = infusionPumpRate / 2.1;
    microdripNightRate = infusionPumpRate / 4.0;

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fluid Volume'),
        centerTitle: true,
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
              Text(
                  'Total Fluid Requirement: ${totalFluidRequirement.toStringAsFixed(2)} mL/day'),
              Text(
                  'Maintenance Only Microdrip: ${maintenanceOnlyMicrodrip.toStringAsFixed(2)} drops/sec'),
              Text(
                  'Infusion Pump Rate (24 hrs): ${infusionPumpRate.toStringAsFixed(2)} mL/hr'),
              Text(
                  'Microdrip Morning Rate: ${microdripMorningRate.toStringAsFixed(2)} drops/sec'),
              Text(
                  'Microdrip Night Rate: ${microdripNightRate.toStringAsFixed(2)} drops/sec'),
            ],
          ),
        ),
      ),
    );
  }
}
