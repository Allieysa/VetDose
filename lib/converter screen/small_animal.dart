import 'package:flutter/material.dart';
import 'package:vetdose/converter screen/smallA_blood_transfusion.dart';
import 'package:vetdose/converter screen/smallA_fluid_volume.dart';

class SmallAnimalConverterOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Small Animal Converters'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => FluidVolumePage()),
                );
              },
              child: Text('Fluid Volume'),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BloodTransfusionPage()),
                );
              },
              child: Text('Blood Transfusion'),
            ),
          ],
        ),
      ),
    );
  }
}
