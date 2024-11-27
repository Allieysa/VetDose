import 'package:flutter/material.dart';

class LargeAnimalConverter extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Large Animal Converter'),
      ),
      body: Center(
        child: Text(
          'Large Animal Converter Functionality Here',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}
