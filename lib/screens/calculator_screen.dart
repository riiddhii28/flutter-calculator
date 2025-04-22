import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:math_expressions/math_expressions.dart';
import 'package:calculator/services/auth_service.dart';
import 'package:calculator/services/firestore_service.dart';
import 'package:calculator/widgets/calculator_button.dart';
import 'package:calculator/screens/history_screen.dart'; // Import the history screen

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({super.key});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  String input = '';
  String output = '';

  void onButtonClick(String value) {
    setState(() {
      if (value == 'C') {
        input = '';
        output = '';
      } else if (value == '⌫') {
        input = input.isNotEmpty ? input.substring(0, input.length - 1) : '';
      } else if (value == '=') {
        try {
          Parser p = Parser();
          Expression exp = p.parse(input.replaceAll('×', '*').replaceAll('÷', '/'));
          ContextModel cm = ContextModel();
          double eval = exp.evaluate(EvaluationType.REAL, cm);
          output = eval.toString();

          // Save result to Firestore
          FirestoreService().addCalculation(input, output);
        } catch (e) {
          output = 'Error';
        }
      } else {
        input += value;
      }
    });
  }

  void logout() async {
    await AuthService().signOut();
  }

  void goToHistoryScreen(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const HistoryScreen()), // Navigate to the history screen
    );
  }

  @override
  Widget build(BuildContext context) {
    final buttonLabels = [
      ['7', '8', '9', '÷'],
      ['4', '5', '6', '×'],
      ['1', '2', '3', '-'],
      ['C', '0', '=', '+'],
      ['⌫'],
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Smart Calculator'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: logout,
            icon: const Icon(Icons.logout),
          ),
          IconButton(
            onPressed: () => goToHistoryScreen(context), // Button to go to history screen
            icon: const Icon(Icons.history),
          ),
        ],
      ),
      body: Column(
        children: [
          const SizedBox(height: 24),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              input,
              style: const TextStyle(fontSize: 28, color: Colors.black87),
            ),
          ),
          Container(
            padding: const EdgeInsets.all(20),
            alignment: Alignment.centerRight,
            child: Text(
              output,
              style: const TextStyle(fontSize: 32, color: Colors.deepPurple, fontWeight: FontWeight.bold),
            ),
          ),
          const Spacer(),
          ...buttonLabels.map((row) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: row.map((label) {
                return CalculatorButton(
                  text: label,
                  onTap: () => onButtonClick(label),
                );
              }).toList(),
            );
          }),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}
