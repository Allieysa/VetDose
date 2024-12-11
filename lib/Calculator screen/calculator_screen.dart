// ignore_for_file: prefer_const_constructors_in_immutables, library_private_types_in_public_api, prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:vetdose/main page/controller.dart';
import 'package:vetdose/bottom_nav_bar.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:animations/animations.dart';

class CalculatorScreen extends StatefulWidget {
  final Controller controller;

  CalculatorScreen({required this.controller});

  @override
  _CalculatorScreenState createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String result = '0';
  bool isResultShown = false;

  void onButtonPressed(String value) {
    setState(() {
      if (value == 'AC') {
        input = '';
        result = '0';
        isResultShown = false;
      } else if (value == '⌫') {
        input = input.isNotEmpty ? input.substring(0, input.length - 1) : '';
      } else if (value == '=') {
        result = calculateResult(input);
        isResultShown = true;
      } else if (value == '%') {
        if (input.isNotEmpty) {
          double percentageValue = (double.tryParse(input) ?? 0) / 100;
          input = percentageValue.toString();
        }
      } else {
        if (isResultShown && "+-×÷".contains(value)) {
          input = result + value;
          isResultShown = false;
        } else if (isResultShown) {
          input = value;
          isResultShown = false;
        } else {
          input += value;
        }
      }
    });
  }

  String calculateResult(String input) {
    try {
      String finalInput = input.replaceAll('×', '*').replaceAll('÷', '/');

      Parser parser = Parser();
      Expression exp = parser.parse(finalInput);
      ContextModel cm = ContextModel();
      double eval = exp.evaluate(EvaluationType.REAL, cm);

      if (eval == eval.toInt()) {
        return eval.toInt().toString();
      } else {
        return eval.toStringAsFixed(6);
      }
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Calculator'),
        centerTitle: true,
      ),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          widget.controller.onTabTapped(index, context);
        },
      ),
      body: Column(
        children: [
// Result and Input Display
          Expanded(
            flex: 2,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.stretch, // Stretch to full width
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Align(
                    alignment:
                        Alignment.centerRight, // Ensure alignment to the right
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true, // Ensure it starts at the right side
                      child: Text(
                        result,
                        textAlign: TextAlign.right, // Align text to the right
                        style: TextStyle(
                            fontSize: 48, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Align(
                    alignment:
                        Alignment.centerRight, // Ensure alignment to the right
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      reverse: true, // Ensure input starts at the right side
                      child: Text(
                        input,
                        textAlign: TextAlign.right, // Align text to the right
                        style: TextStyle(fontSize: 24, color: Colors.black54),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Number Pad
          Expanded(
            flex: 4,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 4,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 1.2, // Adjust button size
              ),
              itemCount: arrangedButtons.length,
              itemBuilder: (context, index) {
                final button = arrangedButtons[index];
                final isOperator = operators.contains(button);

                return CalculatorButton(
                  text: button,
                  onTap: () => onButtonPressed(button),
                  color: isOperator
                      ? const Color.fromARGB(200, 157, 224, 207)
                      : button == 'AC'
                          ? const Color.fromARGB(255, 137, 233, 202)
                          : Colors.white,
                  textColor: isOperator || button == 'AC'
                      ? Colors.white
                      : Colors.black,
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

const List<String> arrangedButtons = [
  'AC',
  '⌫',
  '±',
  '÷',
  '7',
  '8',
  '9',
  '×',
  '4',
  '5',
  '6',
  '-',
  '1',
  '2',
  '3',
  '+',
  '%',
  '0',
  '.',
  '=',
];

const List<String> operators = [
  '÷',
  '×',
  '-',
  '+',
  '=',
];

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color color;
  final Color textColor;

  CalculatorButton({
    required this.text,
    required this.onTap,
    this.color = Colors.white,
    this.textColor = Colors.black,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            text,
            style: TextStyle(fontSize: 24, color: textColor),
          ),
        ),
      ),
    );
  }
}
