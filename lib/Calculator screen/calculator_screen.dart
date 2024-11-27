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

class _CalculatorScreenState extends State<CalculatorScreen>
    with SingleTickerProviderStateMixin {
  String input = '';
  String result = '0';
  bool isResultShown = false;

  // Method to handle button press
  void onButtonPressed(String value) {
    setState(() {
      if (value == 'C') {
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
          // Start new operation using the last result as the base
          input = result + value;
          isResultShown = false;
        } else if (isResultShown) {
          // If result is shown, start fresh with the new input
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
        return eval.toStringAsPrecision(12);
      }
    } catch (e) {
      return 'Error';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Calculator')),
      bottomNavigationBar: BottomNavBar(
        currentIndex: 3,
        onTap: (index) {
          widget.controller.onTabTapped(index, context);
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedSwitcher(
                    duration: const Duration(
                        milliseconds: 500), // Adjust duration for smoothness
                    transitionBuilder:
                        (Widget child, Animation<double> animation) {
                      return FadeScaleTransition(
                          animation: animation, child: child);
                    },
                    child: isResultShown
                        ? Text(
                            result,
                            key: ValueKey(result), // Unique key for switching
                            style: TextStyle(
                                fontSize: 48, fontWeight: FontWeight.bold),
                          )
                        : SizedBox
                            .shrink(), // Empty widget when result is hidden
                  ),
                  SizedBox(height: 8),
                  Text(
                    input,
                    style: TextStyle(fontSize: 24, color: Colors.black54),
                  ),
                ],
              ),
            ),
            // The remaining Expanded widget for the buttons
            Expanded(
              flex: 3,
              child: Row(
                children: [
                  Expanded(
                    flex: 3,
                    child: GridView.builder(
                      itemCount: buttons.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        childAspectRatio: 1.2,
                      ),
                      itemBuilder: (context, index) {
                        return CalculatorButton(
                          text: buttons[index],
                          onTap: () => onButtonPressed(buttons[index]),
                          color: buttons[index] == 'C'
                              ? Colors.grey
                              : Colors.white,
                          textColor: Colors.black,
                        );
                      },
                    ),
                  ),
                  Expanded(
                    child: Column(
                      children: operators.map((op) {
                        return Expanded(
                          child: CalculatorButton(
                            text: op,
                            onTap: () => onButtonPressed(op),
                            color: const Color.fromARGB(222, 108, 159, 150),
                            textColor: Colors.white,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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

const List<String> buttons = [
  'C',
  '±',
  '%',
  '7',
  '8',
  '9',
  '4',
  '5',
  '6',
  '1',
  '2',
  '3',
  '.',
  '0',
  '⌫',
];

const List<String> operators = [
  '÷',
  '×',
  '-',
  '+',
  '=',
];
