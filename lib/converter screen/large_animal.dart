import 'package:flutter/material.dart';
import 'fluid_therapy.dart';
import 'dobutamine.dart';
import 'xylazine.dart';
import 'lidocaine.dart';
import 'detomidine.dart';

class LargeAnimalConverter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Large Animal Converter'),
      ),
      body: ListView(
        padding: EdgeInsets.all(16.0),
        children: [
          ListTile(
            title: Text('Fluid Therapy'),
            subtitle: Text('Calculate fluid rates for large animals.'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => FluidTherapy()),
            ),
          ),
          ListTile(
            title: Text('Dobutamine'),
            subtitle: Text('Calculate Dobutamine dosage.'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Dobutamine()),
            ),
          ),
          ListTile(
            title: Text('Xylazine'),
            subtitle: Text('Calculate Xylazine dosage.'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Xylazine()),
            ),
          ),
          ListTile(
            title: Text('Lidocaine'),
            subtitle: Text('Calculate Lidocaine dosage.'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Lidocaine()),
            ),
          ),
          ListTile(
            title: Text('Detomidine'),
            subtitle: Text('Calculate Detomidine dosage.'),
            trailing: Icon(Icons.chevron_right),
            onTap: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => Detomidine()),
            ),
          ),
        ],
      ),
    );
  }
}
