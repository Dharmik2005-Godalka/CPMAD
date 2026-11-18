import 'package:flutter/material.dart';

import '../logic/bill_calculator.dart';
import '../models/calc_settings.dart';
import '../services/settings_storage.dart';
import '../widgets/summary_card.dart';

/// Calculator tab: bill amount, GST, tip, people and the result card.
class CalculatorPage extends StatefulWidget {
  const CalculatorPage({super.key, required this.onSave});

  /// Called with the text of a split when "Save Split" is tapped.
  final Future<void> Function(String entry) onSave;

  @override
  State<CalculatorPage> createState() => _CalculatorPageState();
}

class _CalculatorPageState extends State<CalculatorPage> {
  final TextEditingController _amountCtrl = TextEditingController();
  final TextEditingController _tipCtrl = TextEditingController();
  final SettingsStorage _settings = SettingsStorage();

  double billAmount = 0;
  double tip = 10;
  int people = 2;
  bool gst = false;
  bool roundUp = false;
  double total = 0;
  double perHead = 0;

  // ------------------------------------------------------------ lifecycle
  // >>> Q7B2 START
  @override
  void initState() {
    super.initState();
    // TODO (Q7-B): start restoring the saved settings here
  }

  Future<void> _restore() async {
    // TODO (Q7-B)
  }

  Future<void> _persist() async {
    // TODO (Q7-B)
  }

  Future<void> _forget() async {
    // TODO (Q7-B)
  }
  // <<< Q7B2 END

  @override
  void dispose() {
    _amountCtrl.dispose();
    _tipCtrl.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------- logic
  /// Puts every input back to its start value (does not recalculate).
  void _setDefaults() {
    _amountCtrl.clear();
    _tipCtrl.clear();
    tip = 10;
    people = 2;
    gst = false;
    roundUp = false;
  }

  /// Computes total and per-person share from the current inputs.
  void _compute() {
    // >>> Q4a START
    billAmount = double.tryParse(_amountCtrl.text) ?? 0;
    // <<< Q4a END
    total = calcTotal(billAmount, tip, gst);
    // >>> Q4c START
    perHead = perPerson(total, people);
    // <<< Q4c END
    // >>> Q5B4 START
    // TODO (Q5-B): round perHead up to a whole rupee when roundUp is on
    // <<< Q5B4 END
  }

  /// Recalculates after any input change and remembers the new values.
  void _calculate() {
    _compute();
    // >>> Q7B3 START
    // TODO (Q7-B): remember the new values
    // <<< Q7B3 END
  }

  // >>> Q5B3 START
  void _resetAll() {
    // TODO (Q5-B): back to start values, then recalculate
  }
  // <<< Q5B3 END

  void _save() {
    if (billAmount <= 0) return;
    widget.onSave(
      formatSplitEntry(billAmount: billAmount, people: people, perHead: perHead),
    );
  }

  // ----------------------------------------------------------------- view
  Widget _buildAmountField() {
    return TextField(
      key: const Key('amountField'),
      controller: _amountCtrl,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      decoration: const InputDecoration(
        labelText: 'Bill amount (₹)',
        border: OutlineInputBorder(),
      ),
      onChanged: (_) => setState(_calculate),
    );
  }

  Widget _buildGstTile() {
    return CheckboxListTile(
      contentPadding: EdgeInsets.zero,
      title: const Text('Include GST (18%)'),
      value: gst,
      // >>> Q4b START
      onChanged: (value) {
        setState(() {
          gst = value!;
          _calculate();
        });
      },
      // <<< Q4b END
    );
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildAmountField(),
            const SizedBox(height: 8),
            _buildGstTile(),
            // >>> Q5A START
            const Text('Tip', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<double>(
                    value: 10,
                    groupValue: tip,
                    onChanged: (value) {
                      setState(() {
                        tip = value!;
                        _tipCtrl.clear();
                        _calculate();
                      });
                    },
                  ),
                  const Text('10%'),
                  Radio<double>(
                    value: 15,
                    groupValue: tip,
                    onChanged: (value) {
                      setState(() {
                        tip = value!;
                        _tipCtrl.clear();
                        _calculate();
                      });
                    },
                  ),
                  const Text('15%'),
                  Radio<double>(
                    value: 20,
                    groupValue: tip,
                    onChanged: (value) {
                      setState(() {
                        tip = value!;
                        _tipCtrl.clear();
                        _calculate();
                      });
                    },
                  ),
                  const Text('20%'),
                ],
              ),
              Text('People: $people', style: const TextStyle(fontWeight: FontWeight.bold)),
              Slider(
                value: people.toDouble(),
                min: 1,
                max: 10,
                divisions: 9,
                label: people.toString(),
                onChanged: (value) {
                  setState(() {
                    people = value.round();
                    _calculate();
                  });
                },
              ),
            // <<< Q5A END
            // >>> Q5B1 START
            // TODO (Q5-B): 'Round up' switch + custom tip TextField
            // <<< Q5B1 END
            // >>> Q5B2 START
            // TODO (Q5-B): Reset button
            // <<< Q5B2 END
            const SizedBox(height: 12),
            SummaryCard(
              billAmount: billAmount,
              tip: tip,
              includeGst: gst,
              total: total,
              perHead: perHead,
              people: people,
              onSave: _save,
            ),
            TextButton(
              onPressed: _forget,
              child: const Text('Forget my settings'),
            ),
          ],
        ),
      ),
    );
  }
}
