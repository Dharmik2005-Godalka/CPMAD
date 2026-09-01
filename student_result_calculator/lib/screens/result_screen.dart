import 'package:flutter/material.dart';
import '../models/student.dart';

class MarksInputScreen extends StatefulWidget 
{
  const MarksInputScreen({super.key});

  @override
  State<MarksInputScreen> createState() => _MarksInputScreenState();
}

class _MarksInputScreenState extends State<MarksInputScreen> {
  final TextEditingController nameController = TextEditingController();

  final TextEditingController mathController = TextEditingController();
  final TextEditingController physicsController = TextEditingController();
  final TextEditingController chemistryController = TextEditingController();
  final TextEditingController englishController = TextEditingController();
  final TextEditingController csController = TextEditingController();

  Student? resultStudent;

  void calculateResult() 
  {
    double mathMarks = double.tryParse(mathController.text) ?? 0;
    double physicsMarks = double.tryParse(physicsController.text) ?? 0;
    double chemistryMarks = double.tryParse(chemistryController.text) ?? 0;
    double englishMarks = double.tryParse(englishController.text) ?? 0;
    double csMarks = double.tryParse(csController.text) ?? 0;

    Student student = Student(
      name: nameController.text.isEmpty ? 'Student' : nameController.text,
      rollNumber: 0,
      subjectMarks: {
        'Mathematics': mathMarks,
        'Physics': physicsMarks,
        'Chemistry': chemistryMarks,
        'English': englishMarks,
        'Computer Science': csMarks,
      },
    );

    setState(() 
    {
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
              controller: mathController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Mathematics Marks'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: physicsController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Physics Marks'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: chemistryController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Chemistry Marks'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: englishController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'English Marks'),
            ),
            const SizedBox(height: 12),

            TextField(
              controller: csController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(labelText: 'Computer Science Marks'),
            ),
            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: calculateResult,
              child: const Text('Calculate Result'),
            ),

            const SizedBox(height: 24),

            // only show result section after calculation is done
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

    // loop through the map to display each subject's marks
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