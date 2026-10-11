import 'package:flutter/material.dart';
import '../l10n/app_strings.dart';

class CalculatorScreen extends StatefulWidget {
  final Future<void> Function(String) onLanguageChanged;

  const CalculatorScreen({super.key, required this.onLanguageChanged});

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final TextEditingController firstController = TextEditingController();
  final TextEditingController secondController = TextEditingController();

  double? result;
  String? messageKey; // key of the error message, so it changes with language

  @override
  void dispose() {
    firstController.dispose();
    secondController.dispose();
    super.dispose();
  }

  void calculate(String operation) {
    final a = double.tryParse(firstController.text.trim());
    final b = double.tryParse(secondController.text.trim());

    if (a == null || b == null) {
      setState(() {
        result = null;
        messageKey = 'invalid_input';
      });
      return;
    }

    if (operation == 'divide' && b == 0) {
      setState(() {
        result = null;
        messageKey = 'divide_zero';
      });
      return;
    }

    double answer = 0;
    if (operation == 'add') {
      answer = a + b;
    } else if (operation == 'subtract') {
      answer = a - b;
    } else if (operation == 'multiply') {
      answer = a * b;
    } else if (operation == 'divide') {
      answer = a / b;
    }

    setState(() {
      result = answer;
      messageKey = null;
    });
  }

  void clearAll() {
    firstController.clear();
    secondController.clear();
    setState(() {
      result = null;
      messageKey = null;
    });
  }

  // show 5 instead of 5.0
  String showNumber(double value) {
    if (value % 1 == 0) {
      return value.toInt().toString();
    }
    return value.toStringAsFixed(2);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'app_title')),
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.language),
            tooltip: AppStrings.t(context, 'language'),
            onSelected: (code) {
              widget.onLanguageChanged(code);
            },
            itemBuilder: (context) {
              return AppStrings.languageNames.entries.map((entry) {
                return PopupMenuItem<String>(
                  value: entry.key,
                  child: Text(entry.value),
                );
              }).toList();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: firstController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: InputDecoration(
                labelText: AppStrings.t(context, 'first_number'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: secondController,
              keyboardType: const TextInputType.numberWithOptions(
                decimal: true,
                signed: true,
              ),
              decoration: InputDecoration(
                labelText: AppStrings.t(context, 'second_number'),
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 16),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                ElevatedButton(
                  onPressed: () => calculate('add'),
                  child: Text(AppStrings.t(context, 'add')),
                ),
                ElevatedButton(
                  onPressed: () => calculate('subtract'),
                  child: Text(AppStrings.t(context, 'subtract')),
                ),
                ElevatedButton(
                  onPressed: () => calculate('multiply'),
                  child: Text(AppStrings.t(context, 'multiply')),
                ),
                ElevatedButton(
                  onPressed: () => calculate('divide'),
                  child: Text(AppStrings.t(context, 'divide')),
                ),
                OutlinedButton(
                  onPressed: clearAll,
                  child: Text(AppStrings.t(context, 'clear')),
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (result != null)
              Card(
                child: ListTile(
                  title: Text(AppStrings.t(context, 'result')),
                  trailing: Text(
                    showNumber(result!),
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            if (messageKey != null)
              Text(
                AppStrings.t(context, messageKey!),
                style: const TextStyle(color: Colors.red, fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}