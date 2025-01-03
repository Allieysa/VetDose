import 'package:flutter/material.dart';
import 'package:vetdose/converter%20screen/treatment_button.dart';

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

  bool showAddTreatmentButton = false;

  void calculateResults() {
    double weight = double.tryParse(weightController.text) ?? 0.0;
    double replacementPercent =
        double.tryParse(replacementPercentController.text) ?? 0.0;
    double maintenanceVolumeRate =
        double.tryParse(maintenanceVolumeController.text) ?? 0.0;
    double fluidGiven = double.tryParse(fluidGivenController.text) ?? 1.0;

    if (weight <= 0 || replacementPercent <= 0 || maintenanceVolumeRate <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Please enter valid data for all fields!'),
        backgroundColor: Colors.red,
      ));
      return;
    }

    setState(() {
      // Replacement Volume Calculation
      replacementVolume =
          weight * replacementPercent * 10; // Multiply by 10 for mL/kg

      // Maintenance Volume Calculation
      maintenanceVolume = weight * maintenanceVolumeRate;

      // Ongoing Losses Volume (assumed input, set as 0 for now)
      ongoingLossesVolume = 0.0;

      // Total Volume Calculation
      totalVolume = replacementVolume + maintenanceVolume + ongoingLossesVolume;

      // Volume to Be Delivered Calculations
      volumeToBeDeliveredPerHour = totalVolume / fluidGiven;
      volumeToBeDeliveredPerMinute = volumeToBeDeliveredPerHour / 60;
      volumeToBeDeliveredPerSecond = volumeToBeDeliveredPerMinute / 60;

      // Drip Calculations
      double dripSet = 60; // Micro drip set (drops/mL)
      dropsPerMinute = volumeToBeDeliveredPerHour * dripSet / 60;
      dropsPer10Seconds = dropsPerMinute / 6;
      dropsPerSecond = dropsPerMinute / 60;
      secondsPerDrop = 60 / dropsPerMinute;

      showAddTreatmentButton = true;
    });
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

  Widget buildResultsCard() {
    return Card(
      elevation: 6,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      color: Colors.teal[50],
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            'Results:',
            style: TextStyle(
                fontWeight: FontWeight.bold, fontSize: 18, color: Colors.teal),
          ),
          Divider(),
          resultRow('Replacement Volume',
              '${replacementVolume.toStringAsFixed(2)} mL'),
          resultRow('Maintenance Volume',
              '${maintenanceVolume.toStringAsFixed(2)} mL'),
          resultRow('Ongoing Losses Volume',
              '${ongoingLossesVolume.toStringAsFixed(2)} mL'),
          resultRow('Total Volume', '${totalVolume.toStringAsFixed(2)} mL'),
          SizedBox(height: 10),
          Text(
            'Volume:',
            style: TextStyle(
              fontSize: 14, // Adjust font size as needed
              fontWeight: FontWeight.bold, // Make the text bold
              color: Colors.teal, // Set the text color
            ),
          ),
          resultRow('Delivered Per Hour',
              '${volumeToBeDeliveredPerHour.toStringAsFixed(2)} mL/hr'),
          resultRow('Delivered Per Minute',
              '${volumeToBeDeliveredPerMinute.toStringAsFixed(2)} mL/min'),
          resultRow('Delivered Per Second',
              '${volumeToBeDeliveredPerSecond.toStringAsFixed(2)} mL/sec'),
          SizedBox(height: 10),
          resultRow('Drops Per Minute',
              '${dropsPerMinute.toStringAsFixed(2)} drops/min'),
          resultRow('Drops Per 10 Seconds',
              '${dropsPer10Seconds.toStringAsFixed(2)} drops/10 sec'),
          resultRow('Drops Per Second',
              '${dropsPerSecond.toStringAsFixed(2)} drops/sec'),
          resultRow('Seconds Per Drop',
              '${secondsPerDrop.toStringAsFixed(3)} sec/drop'),
        ]),
      ),
    );
  }

  Widget resultRow(String title, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.teal[700],
              )),
          Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Align(
          alignment: Alignment.centerLeft, // Aligns the text to the right
          child: Text(
            'Fluid Theraphy',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 20, // Adjust the font size as needed
            ),
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter Animal Data',
                style: TextStyle(fontSize: 18),
              ),
              SizedBox(height: 10),
              buildInputField('Weight (kg)', weightController),
              buildInputField(
                  'Replacement Percent (%)', replacementPercentController),
              buildInputField(
                  'Maintenance (mL/kg)', maintenanceVolumeController),
              buildInputField('Fluid Duration (hours)', fluidGivenController),
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
              if (replacementVolume > 0) buildResultsCard(),
              SizedBox(height: 20),
              if (showAddTreatmentButton)
                AddTreatmentButton(
                  onTreatmentAdded: () {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Treatment added successfully!'),
                    ));
                  },
                ),
            ],
          ),
        ),
      ),
    );
  }
}
