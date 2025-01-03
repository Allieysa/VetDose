import 'package:flutter/material.dart';
import 'fluid_therapy.dart';
import 'dobutamine.dart';
import 'xylazine.dart';
import 'lidocaine.dart';
import 'detomidine.dart';

class LargeAnimalConverter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Data list for items
    final List<Map<String, dynamic>> items = [
      {
        'title': 'Fluid Therapy',
        'subtitle': 'Calculate fluid rates for large animals.',
        'icon': Icons.water_drop,
        'page': FluidTherapy(),
      },
      {
        'title': 'Dobutamine',
        'subtitle': 'Calculate Dobutamine dosage.',
        'icon': Icons.medical_services,
        'page': Dobutamine(),
      },
      {
        'title': 'Xylazine',
        'subtitle': 'Calculate Xylazine dosage.',
        'icon': Icons.healing,
        'page': Xylazine(),
      },
      {
        'title': 'Lidocaine',
        'subtitle': 'Calculate Lidocaine dosage.',
        'icon': Icons.local_pharmacy,
        'page': Lidocaine(),
      },
      {
        'title': 'Detomidine',
        'subtitle': 'Calculate Detomidine dosage.',
        'icon': Icons.vaccines,
        'page': Detomidine(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text(
          'Large Animal Converter',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.teal,
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => items[index]['page']),
              ),
              child: Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6.0,
                      offset: Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    // Icon Section
                    Container(
                      width: 78.0,
                      height: 90.0,
                      decoration: BoxDecoration(
                        color: Colors.teal.withOpacity(0.1),
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0),
                        ),
                      ),
                      child: Icon(
                        items[index]['icon'],
                        color: Colors.teal,
                        size: 32.0,
                      ),
                    ),
                    // Text Section
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16.0, vertical: 12.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              items[index]['title'],
                              style: TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              items[index]['subtitle'],
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Trailing Arrow
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(
                        Icons.arrow_forward_ios,
                        color: Colors.grey,
                        size: 18.0,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
