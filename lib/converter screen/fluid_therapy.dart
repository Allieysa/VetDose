import 'package:flutter/material.dart';
import 'package:vetdose/converter screen/treatment_button.dart';

class FluidTherapy extends StatefulWidget {
  @override
  _FluidTherapyState createState() => _FluidTherapyState();
}

class _FluidTherapyState extends State<FluidTherapy> {
  final TextEditingController weightController = TextEditingController();
  final TextEditingController replacementPercentController =
      TextEditingController();
  final TextEditingController maintenanceVolumeController =
      TextEditingController();
  final TextEditingController fluidGivenController = TextEditingController();

  double replacementVolume = 0.0;
  double maintenanceVolume = 0.0;
  double ongoingLossesVolume = 0.0; // Assume input or keep at 0 by default
  double totalVolume = 0.0;
  double volumeToBeDeliveredPerHour = 0.0;
  double volumeToBeDeliveredPerMinute = 0.0;
  double volumeToBeDeliveredPerSecond = 0.0;
  double dropsPerMinute = 0.0;
  double dropsPer10Seconds = 0.0;
  double dropsPerSecond = 0.0;
  double secondsPerDrop = 0.0;

  bool showAddTreatmentButton =
      false; // To track if the button should be visible

  void calculateResults() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double replacementPercent =
        double.tryParse(replacementPercentController.text) ?? 0.0;
    double maintenanceVolumeRate =
        double.tryParse(maintenanceVolumeController.text) ?? 0.0;
    double fluidGiven = double.tryParse(fluidGivenController.text) ?? 0.0;

    // Replacement Volume Calculation
    replacementVolume =
        weight * replacementPercent * 10; // Multiply by 10 for mL/kg

    // Maintenance Volume Calculation
    maintenanceVolume = weight * maintenanceVolumeRate;

    // Ongoing Losses Volume (assumed input, set as 0 for now)
    ongoingLossesVolume = 0.0;

    // Total Volume Calculation
    totalVolume = replacementVolume + maintenanceVolume + ongoingLossesVolume;

    // Volume to Be Delivered
    volumeToBeDeliveredPerHour = totalVolume / fluidGiven;
    volumeToBeDeliveredPerMinute = volumeToBeDeliveredPerHour / 60;
    volumeToBeDeliveredPerSecond = volumeToBeDeliveredPerMinute / 60;

    // Drip Calculations
    double dripSet = 60; // Micro drip set (drops/mL)
    dropsPerMinute = volumeToBeDeliveredPerHour * dripSet / 60;
    dropsPer10Seconds = dropsPerMinute / 6;
    dropsPerSecond = dropsPerMinute / 60;
    secondsPerDrop = 60 / dropsPerMinute;

    showAddTreatmentButton = true; // Show Add Treatment button
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
          border: OutlineInputBorder(),
        ),
      ),
    );
  }

  Widget buildResultsSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Results:',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        Text('Replacement Volume: ${replacementVolume.toStringAsFixed(2)} mL'),
        Text('Maintenance Volume: ${maintenanceVolume.toStringAsFixed(2)} mL'),
        Text('Total Volume: ${totalVolume.toStringAsFixed(2)} mL'),
        Text(
            'Volume to be Delivered Per Hour: ${volumeToBeDeliveredPerHour.toStringAsFixed(2)} mL/hr'),
        Text(
            'Drops Per Minute: ${dropsPerMinute.toStringAsFixed(2)} drops/min'),
        Text('Seconds Per Drop: ${secondsPerDrop.toStringAsFixed(2)} sec/drop'),
        SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Fluid Therapy for Large Animals'),
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
                  labelText: 'Weight of the Animal (kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: replacementPercentController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Replacement Percent (%)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: maintenanceVolumeController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Maintenance Volume (mL/kg)',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: fluidGivenController,
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  labelText: 'Fluid Given in Hours',
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: calculateResults,
                child: Text('Calculate'),
              ),
              SizedBox(height: 20),
              Text(
                'Results:',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Text(
                  'Replacement Volume: ${replacementVolume.toStringAsFixed(2)} mL'),
              Text(
                  'Maintenance Volume: ${maintenanceVolume.toStringAsFixed(2)} mL'),
              Text(
                  'Ongoing Losses Volume: ${ongoingLossesVolume.toStringAsFixed(2)} mL'),
              Text('Total Volume: ${totalVolume.toStringAsFixed(2)} mL'),
              SizedBox(height: 10),
              Text(
                  'Volume to Be Delivered Per Hour: ${volumeToBeDeliveredPerHour.toStringAsFixed(2)} mL/hr'),
              Text(
                  'Volume to Be Delivered Per Minute: ${volumeToBeDeliveredPerMinute.toStringAsFixed(2)} mL/min'),
              Text(
                  'Volume to Be Delivered Per Second: ${volumeToBeDeliveredPerSecond.toStringAsFixed(2)} mL/sec'),
              SizedBox(height: 10),
              Text(
                  'Drops Per Minute: ${dropsPerMinute.toStringAsFixed(2)} drops/min'),
              Text(
                  'Drops Per 10 Seconds: ${dropsPer10Seconds.toStringAsFixed(2)} drops/10 sec'),
              Text(
                  'Drops Per Second: ${dropsPerSecond.toStringAsFixed(2)} drops/sec'),
              Text(
                  'Seconds Per Drop: ${secondsPerDrop.toStringAsFixed(2)} sec/drop'),
              SizedBox(height: 16),
              if (showAddTreatmentButton)
                AddTreatmentButton(
                  onTreatmentAdded: () {},
                ),
            ],
          )),
        ));
  }
}
