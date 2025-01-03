import 'package:flutter/material.dart';
import 'package:vetdose/converter%20screen/smallA_blood_transfusion.dart';
import 'package:vetdose/converter%20screen/smallA_fluid_volume.dart';

class SmallAnimalConverterOptions extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // List of options for the converters
    final List<Map<String, dynamic>> options = [
      {
        'title': 'Fluid Volume',
        'subtitle': 'Calculate fluid volume for small animals.',
        'icon': Icons.water_drop,
        'page': FluidVolumePage(),
      },
      {
        'title': 'Blood Transfusion',
        'subtitle': 'Estimate blood transfusion needs.',
        'icon': Icons.bloodtype,
        'page': BloodTransfusionPage(),
      },
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FA),
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: const Text(
          'Small Animal Converters',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        elevation: 2,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView.builder(
          itemCount: options.length,
          itemBuilder: (context, index) {
            return GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => options[index]['page'],
                  ),
                );
              },
              child: Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(16.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6.0,
                      offset: const Offset(0, 3),
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
                        borderRadius: const BorderRadius.only(
                          topLeft: Radius.circular(16.0),
                          bottomLeft: Radius.circular(16.0),
                        ),
                      ),
                      child: Center(
                        child: Icon(
                          options[index]['icon'],
                          color: Colors.teal,
                          size: 32.0,
                        ),
                      ),
                    ),
                    // Text Section
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16.0,
                          vertical: 8.0,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              options[index]['title'],
                              style: const TextStyle(
                                fontSize: 16.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.black87,
                              ),
                            ),
                            const SizedBox(height: 4.0),
                            Text(
                              options[index]['subtitle'],
                              style: const TextStyle(
                                fontSize: 14.0,
                                color: Colors.black54,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    // Trailing Arrow
                    const Padding(
                      padding: EdgeInsets.all(16.0),
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
