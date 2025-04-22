import 'package:flutter/material.dart';

class CalculatorButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;

  const CalculatorButton({
    super.key,
    required this.text,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isOperator = ['+', '-', '×', '÷', '='].contains(text);
    final isSpecial = ['C', '⌫'].contains(text);

    return Padding(
      padding: const EdgeInsets.all(6.0),
      child: SizedBox(
        width: MediaQuery.of(context).size.width / 5,
        height: 70,
        child: ElevatedButton(
          onPressed: onTap,
          style: ElevatedButton.styleFrom(
            backgroundColor: isOperator
                ? Colors.deepPurple
                : isSpecial
                    ? Colors.redAccent
                    : Colors.grey.shade200,
            foregroundColor: isOperator || isSpecial
                ? Colors.white
                : Colors.black87,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            textStyle: const TextStyle(fontSize: 24),
          ),
          child: Text(text),
        ),
      ),
    );
  }
}
