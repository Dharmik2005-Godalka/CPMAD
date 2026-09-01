import 'package:flutter/material.dart';
import '../models/student.dart';

class MarksInputScreen extends StatefulWidget {
  const MarksInputScreen({super.key});

  @override
  State<MarksInputScreen> createState() => _MarksInputScreenState();
}

class _MarksInputScreenState extends State<MarksInputScreen> {
  final TextEditingController nameController = TextEditingController();

  // one controller per subject
  final TextEditingController daaController = TextEditingController();
  final TextEditingController dsipController = TextEditingController();
  final TextEditingController mathsController = TextEditingController();
  final TextEditingController cpmadController = TextEditingController();
  final TextEditingController dsaController = TextEditingController();

  Student? resultStudent;

  void calculateResult() {
    double daaMarks = double.tryParse(daaController.text) ?? 0;
    double dsipMarks = double.tryParse(dsipController.text) ?? 0;
    double mathsMarks = double.tryParse(mathsController.text) ?? 0;
    double cpmadMarks = double.tryParse(cpmadController.text) ?? 0;
    double dsaMarks = double.tryParse(dsaController.text) ?? 0;

    Student student = Student(
      name: nameController.text.isEmpty ? 'Student' : nameController.text,
      rollNumber: 0,
      subjectMarks: {
        'DAA': daaMarks,
        'DSIP': dsipMarks,
        'Maths': mathsMarks,
        'CPMAD': cpmadMarks,
        'DSA': dsaMarks,
      },
    );

    setState(() {
      resultStudent = student;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Enter Marks', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: 'Student Name'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: daaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'DAA Marks'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: dsipController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'DSIP Marks'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: mathsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Maths Marks'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: cpmadController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'CPMAD Marks'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: dsaController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'DSA Marks'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculateResult,
              child: const Text('Calculate Result'),
            ),

            const SizedBox(height: 24),

            if (resultStudent != null) buildResultSection(resultStudent!),
          ],
        ),
      ),
    );
  }

  Widget buildResultSection(Student s) {
    double total = s.calculateTotal();
    double percentage = s.calculatePercentage();
    String grade = s.calculateGrade();
    bool passed = s.isPass();

    List<Widget> subjectRows = [];
    s.subjectMarks.forEach((subject, marks) {
      subjectRows.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(subject, style: const TextStyle(fontSize: 16)),
              Text(marks.toString(), style: const TextStyle(fontSize: 16)),
            ],
          ),
        ),
      );
    });

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Name: ${s.name}',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const Divider(),
          ...subjectRows,
          const Divider(),
          Text('Total Marks: ${total.toStringAsFixed(0)}',
              style: const TextStyle(fontSize: 16)),
          Text('Percentage: ${percentage.toStringAsFixed(2)}%',
              style: const TextStyle(fontSize: 16)),
          Text('Grade: $grade',
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
            decoration: BoxDecoration(
              color: passed ? Colors.green : Colors.red,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              passed ? 'RESULT: PASS' : 'RESULT: FAIL',
              style: const TextStyle(color: Colors.white, fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}