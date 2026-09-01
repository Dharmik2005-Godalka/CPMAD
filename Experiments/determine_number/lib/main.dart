import 'package:flutter/material.dart';

void main() {
  runApp(const NumberCheckerApp());
}

class NumberCheckerApp extends StatelessWidget {
  const NumberCheckerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Number Checker',
      theme: ThemeData(primarySwatch: Colors.deepPurple),
      home: const NumberCheckerScreen(),
    );
  }
}

class NumberCheckerScreen extends StatefulWidget {
  const NumberCheckerScreen({super.key});

  @override
  State<NumberCheckerScreen> createState() => _NumberCheckerScreenState();
}

class _NumberCheckerScreenState extends State<NumberCheckerScreen> {
  final TextEditingController numberController = TextEditingController();

  bool isCalculated = false;
  int number = 0;
  bool isPrime = false;
  bool isPalindrome = false;
  bool isArmstrong = false;
  bool isEven = false;

  bool checkPrime(int n) {
    if (n < 2) return false;
    for (int i = 2; i * i <= n; i++) {
      if (n % i == 0) return false;
    }
    return true;
  }

  bool checkPalindrome(int n) {
    String original = n.toString();
    String reversed = original.split('').reversed.join('');
    return original == reversed;
  }

  bool checkArmstrong(int n) {
    String digits = n.abs().toString();
    int power = digits.length;
    int sum = 0;
    for (int i = 0; i < digits.length; i++) {
      int digit = int.parse(digits[i]);
      sum = sum + pow(digit, power);
    }
    return sum == n;
  }

  int pow(int base, int exponent) {
    int result = 1;
    for (int i = 0; i < exponent; i++) {
      result = result * base;
    }
    return result;
  }

  void checkNumber() {
    int n = int.tryParse(numberController.text) ?? 0;

    setState(() {
      number = n;
      isPrime = checkPrime(n);
      isPalindrome = checkPalindrome(n);
      isArmstrong = checkArmstrong(n);
      isEven = n % 2 == 0;
      isCalculated = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Number Checker', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: numberController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Enter a number'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: checkNumber,
              child: const Text('Check Number'),
            ),

            const SizedBox(height: 24),

            if (isCalculated) buildResultSection(),
          ],
        ),
      ),
    );
  }

  Widget buildResultSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Number: $number',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          buildResultRow('Prime', isPrime),
          buildResultRow('Palindrome', isPalindrome),
          buildResultRow('Armstrong', isArmstrong),
          buildResultRow(isEven ? 'Even' : 'Odd', true),
        ],
      ),
    );
  }

  Widget buildResultRow(String label, bool value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 16)),
          Icon(
            value ? Icons.check_circle : Icons.cancel,
            color: value ? Colors.green : Colors.red,
          ),
        ],
      ),
    );
  }
}