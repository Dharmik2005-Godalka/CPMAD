import 'package:flutter/material.dart';
import '../models/student.dart';

class MarksInputScreen extends StatefulWidget {
  const MarksInputScreen({super.key});

  @override
  State<MarksInputScreen> createState() => _MarksInputScreenState();
}

class _MarksInputScreenState extends State<MarksInputScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController daaController = TextEditingController();
  final TextEditingController dsipController = TextEditingController();
  final TextEditingController mathsController = TextEditingController();
  final TextEditingController cpmadController = TextEditingController();
  final TextEditingController dsaController = TextEditingController();

  // holds ALL students entered so far
  List<Student> students = [];

  void addStudent() {
    double daaMarks = double.tryParse(daaController.text) ?? 0;
    double dsipMarks = double.tryParse(dsipController.text) ?? 0;
    double mathsMarks = double.tryParse(mathsController.text) ?? 0;
    double cpmadMarks = double.tryParse(cpmadController.text) ?? 0;
    double dsaMarks = double.tryParse(dsaController.text) ?? 0;

    Student student = Student(
      name: nameController.text.isEmpty ? 'Student' : nameController.text,
      rollNumber: students.length + 1,
      subjectMarks: {
        'DAA': daaMarks,
        'DSIP': dsipMarks,
        'Maths': mathsMarks,
        'CPMAD': cpmadMarks,
        'DSA': dsaMarks,
      },
    );

    setState(() {
      students.add(student);

      // clear fields for the next student
      nameController.clear();
      daaController.clear();
      dsipController.clear();
      mathsController.clear();
      cpmadController.clear();
      dsaController.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Result Calculator',
            style: TextStyle(color: Colors.white)),
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
              onPressed: addStudent,
              child: const Text('Add Student'),
            ),

            const SizedBox(height: 24),

            if (students.isNotEmpty) buildStatsSection(),
            const SizedBox(height: 16),
            if (students.isNotEmpty) buildStudentList(),
          ],
        ),
      ),
    );
  }

  Widget buildStatsSection() {
    double highest = getHighestPercentage(students);
    double lowest = getLowestPercentage(students);
    double average = getAveragePercentage(students);
    String topper = getTopperName(students);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('Class Statistics (${students.length} student(s))',
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text('Highest Percentage: ${highest.toStringAsFixed(2)}% ($topper)'),
          Text('Lowest Percentage: ${lowest.toStringAsFixed(2)}%'),
          Text('Average Percentage: ${average.toStringAsFixed(2)}%'),
        ],
      ),
    );
  }

  Widget buildStudentList() {
    // loop through the list to build a card per student
    List<Widget> studentCards = [];
    for (var s in students) {
      studentCards.add(
        Container(
          margin: const EdgeInsets.only(bottom: 12),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            border: Border.all(color: Colors.deepPurple),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('${s.name} (Roll No: ${s.rollNumber})',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              Text('Total: ${s.calculateTotal().toStringAsFixed(0)}  |  '
                  'Percentage: ${s.calculatePercentage().toStringAsFixed(2)}%  |  '
                  'Grade: ${s.calculateGrade()}'),
              Text(
                s.isPass() ? 'PASS' : 'FAIL',
                style: TextStyle(
                  color: s.isPass() ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('All Students',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        ...studentCards,
      ],
    );
  }
}