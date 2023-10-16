import 'package:flutter/material.dart';
// ignore: unused_import
import 'package:shared_preferences/shared_preferences.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String output = '';

  @override
  void initState() {
    super.initState();
    loadHistory();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple Calculator'),
        actions: [
          IconButton(
              onPressed: onHistoryPressed,
              icon: const Icon(Icons.history_rounded)),
        ],
      ),
      body: Column(
        children: <Widget>[
          /// Input Display
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                input,
                style: const TextStyle(fontSize: 24.0),
              ),
            ),
          ),

          /// Output Display
          Expanded(
            child: Container(
              padding: const EdgeInsets.all(16.0),
              alignment: Alignment.bottomRight,
              child: Text(
                output,
                style: const TextStyle(
                    fontSize: 36.0, fontWeight: FontWeight.bold),
              ),
            ),
          ),

          /// Keyboard Layout
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton("("),
              buildButton(")"),
              buildButton("%"),
              buildButton("C"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton("7"),
              buildButton("8"),
              buildButton("9"),
              buildButton("÷"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton("4"),
              buildButton("5"),
              buildButton("6"),
              buildButton("×"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton("1"),
              buildButton("2"),
              buildButton("3"),
              buildButton("-"),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              buildButton("0"),
              buildButton("."),
              buildButton("="),
              buildButton("+"),
            ],
          ),
          Expanded(
            child: Container(),
          ),
        ],
      ),
    );
  }

  Widget buildButton(String buttonText) {
    return ElevatedButton(
      onPressed: () {
        onButtonPressed(buttonText);
      },
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(fontSize: 20.0),
          ),
        ),
      ),
    );
  }

  // Define a function to handle button clicks
  void onButtonPressed(String value) {
    if (value == '=') {
      // Calculate and update the result
      final result = calculate(input);
      return setState(() {
        output = result;
      });
    }

    if (value == 'C') {
      // Clear the input and output
      return setState(() {
        input = '';
        output = '';
      });
    }

    if (canAppendValue(input, value)) {
      // Append the value to the input
      return setState(() {
        input += value;
      });
    }
  }

  // TODO: Show Popup dialog displaying calculation history so that when user
  // clicks a line, replace current input and output with input and output from
  // that line
  // See Google Calculator for reference: https://i.imgur.com/iwKp1JS.gif
  void onHistoryPressed() {}

  // TODO: Load last run history from file
  // Note: Everytime user pressed "=" to get math result, calculation input and
  // output should be persisted to disk for retrieving later.
  //
  // Reference: https://docs.flutter.dev/cookbook/persistence/key-value
  void loadHistory() async {}
}

// TODO: Return true when next value or operation can be added to current input
// Example:
//  ----------------
//  currentInput: 5
//  nextValue: ÷
//  Output: true
//  ----------------
//  currentInput: 5÷
//  nextValue: /
//  Output: false (Invalid operation: 5÷/)
bool canAppendValue(String currentInput, String nextValue) {
  return true;
}

// TODO: Return calculation result given the input operations
// Example:
//  Input: 5.6×-9.21+12÷-0.521
//  Output: -75.576
String calculate(String input) {
  return input;
}
