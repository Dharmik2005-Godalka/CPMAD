import 'package:flutter/material.dart';

/// Shows the result of the calculation and the "Save Split" button.
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.billAmount,
    required this.tip,
    required this.includeGst,
    required this.total,
    required this.perHead,
    required this.people,
    required this.onSave,
  });

  final double billAmount;
  final double tip;
  final bool includeGst;
  final double total;
  final double perHead;
  final int people;
  final VoidCallback onSave;

  // >>> Q3b START
    Widget _row(String label, double value) 
    {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text('₹${value.toStringAsFixed(2)}'
          ),
        ],
      ),
    );
  }
  // <<< Q3b END

  @override
  Widget build(BuildContext context) {
    // >>> Q3a START
    return Card(
  elevation: 4,
  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
  child: Padding(
    padding: const EdgeInsets.all(16),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: const [
            Icon(Icons.receipt_long, color: Colors.green),
            SizedBox(width: 8),
            Text('Bill Summary',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        const Divider(height: 24),
        _row('Bill amount', billAmount),
        _row('Tip (${tip.toStringAsFixed(0)}%)', billAmount * tip / 100),
        if (includeGst) _row('GST (18%)', billAmount * 18 / 100),
        const Divider(height: 24),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text('Total',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
            Text('₹${total.toStringAsFixed(2)}',
                style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.green)),
          ],
        ),
        _row('Per person ($people)', perHead),
        const SizedBox(height: 12),
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            onPressed: onSave,
            child: const Text('Save Split'),
          ),
        ),
      ],
    ),
  ),
);
    // <<< Q3a END
  }
}
