import 'package:flutter/material.dart';
import 'package:income_transaction_app/models/transaction.dart';

class TransactionScreen extends StatefulWidget {
  const TransactionScreen({super.key});

  @override
  State<TransactionScreen> createState() => _TransactionScreenState();
}

class _TransactionScreenState extends State<TransactionScreen> {
  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtNote = TextEditingController();
  TextEditingController txtDate = TextEditingController();

  List<Transaction> transactions = [];
  DateTime? selDate;
  int selInd = -1;
  bool isIncome = false;

  String formatDate(DateTime d) {
    String day = d.day.toString().padLeft(2, '0');
    String month = d.month.toString().padLeft(2, '0');
    return '$day/$month/${d.year}';
  }

  Future<void> pickDate() async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: selDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        selDate = picked;
        txtDate.text = formatDate(picked);
      });
    }
  }

  void clearForm() {
    txtAmount.text = "";
    txtNote.text = "";
    txtDate.text = "";
    selDate = null;
    selInd = -1;
    isIncome = false;
  }

  void saveTransaction() {
    double? amount = double.tryParse(txtAmount.text);
    if (amount == null || txtNote.text.isEmpty) {
      return;
    }
    DateTime date = selDate ?? DateTime.now();

    setState(() {
      if (selInd == -1) {
        transactions.add(Transaction(amount, txtNote.text, isIncome, date));
      } else {
        transactions[selInd].amount = amount;
        transactions[selInd].note = txtNote.text;
        transactions[selInd].isIncome = isIncome;
        transactions[selInd].date = date;
      }
      clearForm();
    });
  }

  void editTransaction(Transaction transaction) {
    setState(() {
      txtAmount.text = transaction.amount.toString();
      txtNote.text = transaction.note;
      isIncome = transaction.isIncome;
      selDate = transaction.date;
      txtDate.text = formatDate(transaction.date);
      selInd = transactions.indexOf(transaction);
    });
  }

  void deleteTransaction(Transaction transaction) {
    setState(() {
      transactions.remove(transaction);
      clearForm();
    });
  }

  double get totalIncome {
    double total = 0;
    for (Transaction t in transactions) {
      if (t.isIncome) total += t.amount;
    }
    return total;
  }

  double get totalExpense {
    double total = 0;
    for (Transaction t in transactions) {
      if (!t.isIncome) total += t.amount;
    }
    return total;
  }

  double get balance => totalIncome - totalExpense;

  // Sorted newest -> oldest, with a date heading (String) before each new day
  List<Object> get rows {
    List<Transaction> sorted = List.from(transactions);
    sorted.sort((a, b) => b.date.compareTo(a.date));

    List<Object> result = [];
    String lastDate = "";
    for (Transaction t in sorted) {
      String d = formatDate(t.date);
      if (d != lastDate) {
        result.add(d);
        lastDate = d;
      }
      result.add(t);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<Object> items = rows;

    return Scaffold(
      appBar: AppBar(
        title: Text('Income & Transactions', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text("Money out"),
                        value: false,
                        groupValue: isIncome,
                        onChanged: (value) {
                          setState(() {
                            isIncome = value!;
                          });
                        },
                      ),
                    ),
                    Expanded(
                      child: RadioListTile<bool>(
                        title: Text("Money in"),
                        value: true,
                        groupValue: isIncome,
                        onChanged: (value) {
                          setState(() {
                            isIncome = value!;
                          });
                        },
                      ),
                    ),
                  ],
                ),
                TextField(
                  controller: txtAmount,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter amount",
                    labelText: "Amount",
                  ),
                ),
                TextField(
                  controller: txtNote,
                  decoration: InputDecoration(
                    hintText: "What is this transaction for",
                    labelText: "Note",
                  ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: txtDate,
                        readOnly: true,
                        onTap: pickDate,
                        decoration: InputDecoration(
                          hintText: "Select date",
                          labelText: "Date",
                        ),
                      ),
                    ),
                    IconButton(
                      onPressed: saveTransaction,
                      icon: Icon(selInd == -1 ? Icons.add : Icons.check),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: double.infinity,
            color: Colors.deepPurple.shade50,
            padding: const EdgeInsets.all(12),
            margin: const EdgeInsets.only(top: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('In: ₹${totalIncome.toStringAsFixed(2)}'),
                Text('Out: ₹${totalExpense.toStringAsFixed(2)}'),
                Text(
                  'Balance: ₹${balance.toStringAsFixed(2)}',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemBuilder: (context, index) {
                Object item = items[index];

                // Date heading
                if (item is String) {
                  return Container(
                    width: double.infinity,
                    color: Colors.grey.shade200,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 6,
                    ),
                    child: Text(
                      item,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  );
                }

                // Transaction row
                Transaction transaction = item as Transaction;
                return ListTile(
                  title: Text(transaction.note),
                  trailing: SizedBox(
                    width: 180,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Text(
                          '${transaction.isIncome ? "+" : "-"}₹${transaction.amount.toStringAsFixed(2)}',
                          style: TextStyle(
                            color: transaction.isIncome ? Colors.green : Colors.red,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          onPressed: () => editTransaction(transaction),
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => deleteTransaction(transaction),
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ),
                );
              },
              itemCount: items.length,
            ),
          ),
        ],
      ),
    );
  }
}