import 'package:flutter/material.dart';
import 'package:expensemanager/models/expense.dart';

class ExpenseScreen extends StatefulWidget {
  const ExpenseScreen({super.key});

  @override
  State<ExpenseScreen> createState() => _ExpenseScreenState();
}

class _ExpenseScreenState extends State<ExpenseScreen> {
  TextEditingController txtTitle = TextEditingController();
  TextEditingController txtAmount = TextEditingController();
  TextEditingController txtDescription = TextEditingController();
  TextEditingController txtDate = TextEditingController();

  List<Expense> expenses = [];
  DateTime? selDate;
  int selInd = -1;

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
    txtTitle.text = "";
    txtAmount.text = "";
    txtDescription.text = "";
    txtDate.text = "";
    selDate = null;
    selInd = -1;
  }

  void saveExpense() {
    double? amount = double.tryParse(txtAmount.text);
    if (amount == null || txtTitle.text.isEmpty) {
      return;
    }
    DateTime date = selDate ?? DateTime.now();

    setState(() {
      if (selInd == -1) {
        expenses.add(Expense(txtTitle.text, amount, txtDescription.text, date));
      } else {
        expenses[selInd].title = txtTitle.text;
        expenses[selInd].amount = amount;
        expenses[selInd].description = txtDescription.text;
        expenses[selInd].date = date;
      }
      clearForm();
    });
  }

  void editExpense(Expense expense) {
    setState(() {
      txtTitle.text = expense.title;
      txtAmount.text = expense.amount.toString();
      txtDescription.text = expense.description;
      selDate = expense.date;
      txtDate.text = formatDate(expense.date);
      selInd = expenses.indexOf(expense);
    });
  }

  void deleteExpense(Expense expense) {
    setState(() {
      expenses.remove(expense);
      clearForm();
    });
  }

  double get totalExpense {
    double total = 0;
    for (Expense e in expenses) {
      total += e.amount;
    }
    return total;
  }

  // Sorted newest -> oldest, with a date heading (String) before each new day
  List<Object> get rows {
    List<Expense> sorted = List.from(expenses);
    sorted.sort((a, b) => b.date.compareTo(a.date));

    List<Object> result = [];
    String lastDate = "";
    for (Expense e in sorted) {
      String d = formatDate(e.date);
      if (d != lastDate) {
        result.add(d);
        lastDate = d;
      }
      result.add(e);
    }
    return result;
  }

  @override
  Widget build(BuildContext context) {
    List<Object> items = rows;

    return Scaffold(
      appBar: AppBar(
        title: Text('Expense Manager', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                TextField(
                  controller: txtTitle,
                  decoration: InputDecoration(
                    hintText: "Enter title",
                    labelText: "Title",
                  ),
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
                  controller: txtDescription,
                  decoration: InputDecoration(
                    hintText: "Enter description",
                    labelText: "Description",
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
                      onPressed: saveExpense,
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
            child: Text(
              'Total: ₹${totalExpense.toStringAsFixed(2)}',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
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

                // Expense row
                Expense expense = item as Expense;
                return ListTile(
                  title: Row(
                    children: [
                      Expanded(child: Text(expense.title)),
                      Text('₹${expense.amount.toStringAsFixed(2)}'),
                    ],
                  ),
                  subtitle: Text(expense.description),
                  trailing: SizedBox(
                    width: 100,
                    child: Row(
                      children: [
                        IconButton(
                          onPressed: () => editExpense(expense),
                          icon: Icon(Icons.edit),
                        ),
                        IconButton(
                          onPressed: () => deleteExpense(expense),
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