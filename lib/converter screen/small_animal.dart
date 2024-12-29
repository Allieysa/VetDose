import 'package:flutter/material.dart';
import 'package:vetdose/converter%20screen/smallA_blood_transfusion.dart';
import 'package:vetdose/converter%20screen/smallA_fluid_volume.dart';

class SmallAnimalConverterOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Small Animal Converters'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Fluid Volume Card
            _buildConverterCard(
              context,
              title: 'Fluid Volume',
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              textColor: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => FluidVolumePage(),
                  ),
                );
              },
            ),
            const SizedBox(height: 10),
            // Blood Transfusion Card
            _buildConverterCard(
              context,
              title: 'Blood Transfusion',
              backgroundColor: const Color.fromARGB(255, 255, 255, 255),
              textColor: Colors.teal,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => BloodTransfusionPage(),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildConverterCard(
    BuildContext context, {
    required String title,
    required Color backgroundColor,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: backgroundColor, // Teal-themed background
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12), // Rounded corners
        ),
        elevation: 3, // Shadow effect
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: textColor, // Teal-themed text color
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
