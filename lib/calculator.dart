import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
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
  List<String> historys = [];
  SharedPreferences? prefs;

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
            icon: const Icon(Icons.history_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            /// Input Display
            Container(
              padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 42),
              alignment: Alignment.bottomRight,
              child: Text(
                input,
                style: const TextStyle(fontSize: 24.0),
              ),
            ),

            /// Output Display
            Container(
              padding: const EdgeInsets.only(bottom: 20, left: 42, right: 42),
              alignment: Alignment.bottomRight,
              child: Text(
                output,
                style: const TextStyle(
                    fontSize: 36.0, fontWeight: FontWeight.bold),
              ),
            ),

            /// Keyboard Layout
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton("(", Colors.white12),
                buildButton(")", Colors.white12),
                buildButton("%", Colors.white12),
                buildButton(
                  input.isEmpty || input.contains('=') ? 'AC' : 'CE',
                  Colors.white12,
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton("7", Colors.white70),
                buildButton("8", Colors.white70),
                buildButton("9", Colors.white70),
                buildButton("÷", Colors.white12),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton("4", Colors.white70),
                buildButton("5", Colors.white70),
                buildButton("6", Colors.white70),
                buildButton("×", Colors.white12),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton("1", Colors.white70),
                buildButton("2", Colors.white70),
                buildButton("3", Colors.white70),
                buildButton("-", Colors.white12),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                buildButton("0", Colors.white70),
                buildButton(".", Colors.white70),
                buildButton("=", Colors.blueAccent),
                buildButton("+", Colors.grey),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget buildButton(String buttonText, Color color) {
    return ElevatedButton(
      onPressed: () {
        onButtonPressed(buttonText);
      },
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
      ),
      child: SizedBox(
        width: 40,
        height: 40,
        child: Center(
          child: Text(
            buttonText,
            style: const TextStyle(
              fontSize: 20.0,
              color: Colors.black,
            ),
          ),
        ),
      ),
    );
  }

  // Define a function to handle button clicks
  Future<void> onButtonPressed(String value) async {
    if (value == 'AC') {
      // Clear the input and output
      return setState(() {
        input = '';
        output = '';
      });
    }

    if (value == 'CE') {
      if (input.isNotEmpty) {
        return setState(() {
          input = input.substring(0, input.length - 1);
        });
      }
    }

    if (await canAppendValue(input, value)) {
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
  void onHistoryPressed() {
    List<Widget> historyWidgets = [];
    for (final element in historys) {
      final splits = element.split(' = ');
      historyWidgets.add(
        Row(
          children: [
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  input = splits[0];
                  output = '';
                });
                Navigator.of(context).pop();
              },
              child: Text(
                splits[0],
                style: const TextStyle(color: Colors.blue),
              ),
            ),
            const Text(' = '),
            SimpleDialogOption(
              onPressed: () {
                setState(() {
                  input = splits[1];
                  output = '';
                });
                Navigator.of(context).pop();
              },
              child: Text(
                splits[1],
                style: const TextStyle(color: Colors.blue),
              ),
            ),
          ],
        ),
      );
    }
    showDialog(
      barrierDismissible: true,
      context: context,
      builder: (BuildContext context) {
        return SimpleDialog(
          alignment: Alignment.topRight,
          title: const Align(
            alignment: Alignment.centerLeft,
            child: Icon(
              Icons.history_rounded,
            ),
          ),
          backgroundColor: Colors.white,
          children: historyWidgets,
        );
      },
    );
  }

  // TODO: Load last run history from file
  // Note: Everytime user pressed "=" to get math result, calculation input and
  // output should be persisted to disk for retrieving later.
  //
  // Reference: https://docs.flutter.dev/cookbook/persistence/key-value
  Future<void> loadHistory() async {
    prefs = await SharedPreferences.getInstance();
    setState(() {
      historys = (prefs!.getStringList('historys') ?? []);
    });
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
  Future<bool> canAppendValue(String currentInput, String nextValue) async {
    final List<String> buttons = ['+', '-', '×', '÷', '%'];
    final List<String> numbers = [
      '0',
      '1',
      '2',
      '3',
      '4',
      '5',
      '6',
      '7',
      '8',
      '9'
    ];

    if (currentInput.isEmpty) {
      if (numbers.contains(nextValue) || nextValue == '(') {
        return true;
      }
      return false;
    }

    String last = currentInput[currentInput.length - 1];

    switch (nextValue) {
      case '=':
        if (last == ')' || numbers.contains(last)) {
          final String result = calculate(input);
          setState(() {
            output = result;
            historys.add('$input = $result');
          });
          await prefs!.setStringList('historys', historys);
          return true;
        }
        return false;
      case '-':
        if (last != '-' && last != '+' && last != '.') {
          return true;
        }
        break;
      case '(':
        if (buttons.contains(last)) {
          return true;
        }
        break;
      case ')':
        int countOpen = '('.allMatches(currentInput).length;
        int countClose = ')'.allMatches(currentInput).length;
        if (countOpen > countClose && numbers.contains(last)) {
          return true;
        }
        return false;
      case '.':
        if (numbers.contains(last) == false) {
          return false;
        }
        for (int i = currentInput.length - 1; i >= 0; i--) {
          if (!numbers.contains(currentInput[i])) {
            if (currentInput[i] == '.') {
              return false;
            } else {
              return true;
            }
          }
        }
    }

    switch (last) {
      case '=':
        setState(() {
          input = '';
          output = '';
        });
        if (numbers.contains(nextValue) || nextValue == '(') {
          return true;
        }
        return false;
      case '(':
        if (numbers.contains(nextValue) || nextValue == '-') {
          return true;
        } else {
          return false;
        }
      case ')':
        if (buttons.contains(nextValue) || nextValue == '=') {
          return true;
        }
        return false;
      case '.':
        if (numbers.contains(nextValue)) {
          return true;
        }
        return false;
    }

    if (buttons.contains(last) && buttons.contains(nextValue)) {
      if (currentInput.length > 2) {
        String last2 = currentInput[currentInput.length - 2];
        if (buttons.contains(last2)) {
          return false;
        }
      }
      if (currentInput.isNotEmpty) {
        setState(() {
          input = currentInput.substring(0, currentInput.length - 1);
        });
        return true;
      }
    }

    return true;
  }
}

// TODO: Return calculation result given the input operations
// Example:
//  Input: 5.6×-9.21+12÷-0.521
//  Output: -75.576
String calculate(String input) {
  String ip = input.replaceAll('×', '*');
  ip = ip.replaceAll('÷', '/');
  Parser parser = Parser();
  Expression expression = parser.parse(ip);
  ContextModel contextModel = ContextModel();
  double output = expression.evaluate(EvaluationType.REAL, contextModel);
  output = double.parse((output).toStringAsFixed(10));
  return output.toString();
}
