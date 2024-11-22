// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'controller.dart';


class PremedDetailed extends StatelessWidget {
  final String title;
  final Controller controller;
  final double animalWeightKg;
  final double animalWeightLbs;

  const PremedDetailed({
    required this.title,
    required this.controller,
    required this.animalWeightKg,
    required this.animalWeightLbs,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // Profile picture and weight details
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage('assets/animal_avatar.png'),
                ),
                const SizedBox(width: 16),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        Text(
                          '$animalWeightKg kg',
                          style: const TextStyle(fontSize: 16),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$animalWeightLbs lbs',
                          style: const TextStyle(fontSize: 16),
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Protocol details
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: [
                  _buildProtocolCard('Tramadol', '50 mg/ml', [
                    {'label': '2 mg/kg', 'dose': '0.2'},
                    {'label': '3 mg/kg', 'dose': '0.3'},
                    {'label': '5 mg/kg', 'dose': '0.5'},
                  ]),
                  _buildEmptyProtocolCard('Atropine'),
                  _buildEmptyProtocolCard('Midazolam'),
                  // Add more protocol cards as needed
                ],
              ),
            ),
          ],
        ),
      )
      );
  }

  Widget _buildProtocolCard(
      String title, String concentration, List<Map<String, String>> doses) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title, style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('($concentration)'),
            const SizedBox(height: 10),
            ...doses.map((dose) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(dose['label']!),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade200,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(dose['dose']!),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyProtocolCard(String title) {
    return Card(
      child: Center(
        child: Text(
          title,
          style: const TextStyle(fontSize: 16, color: Colors.grey),
        ),
      ),
    );
  }
}
