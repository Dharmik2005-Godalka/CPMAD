import 'package:flutter/material.dart';
import '../models/student.dart';

class ConfirmationScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String password;
  final double age;
  final String tenthPercentage;
  final String tenthSchool;
  final String twelfthPercentage;
  final String twelfthSchool;
  final String appliedCourse;
  final List<String> skills;

  const ConfirmationScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.age,
    required this.tenthPercentage,
    required this.tenthSchool,
    required this.twelfthPercentage,
    required this.twelfthSchool,
    required this.appliedCourse,
    required this.skills,
  });

  @override
  State<ConfirmationScreen> createState() => _ConfirmationScreenState();
}

class _ConfirmationScreenState extends State<ConfirmationScreen> {
  bool wantsNotifications = false;
  bool confirmedInfo = false;

  void submitFinal() {
    if (!confirmedInfo) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please confirm the information before submitting')),
      );
      return;
    }

    final Student student = Student(
      name: widget.name,
      email: widget.email,
      phone: widget.phone,
      password: widget.password,
      age: widget.age,
      tenthPercentage: widget.tenthPercentage,
      tenthSchool: widget.tenthSchool,
      twelfthPercentage: widget.twelfthPercentage,
      twelfthSchool: widget.twelfthSchool,
      appliedCourse: widget.appliedCourse,
      skills: widget.skills,
      wantsNotifications: wantsNotifications,
      confirmedInfo: confirmedInfo,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration submitted successfully')),
    );

    debugPrint('Submitted: ${student.name}, ${student.email}');

    Navigator.popUntil(context, (route) => route.isFirst);
  }

  Widget buildStepIndicator(int currentStep) {
    List<String> labels = ['Personal', 'Academic', 'Confirm'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          bool isActive = index == currentStep;
          return Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: isActive ? Colors.deepPurple : Colors.grey.shade300,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: isActive ? Colors.white : Colors.black54),
                ),
              ),
              const SizedBox(width: 6),
              Text(labels[index]),
            ],
          );
        }),
      ),
    );
  }

  Widget buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 130,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
          ),
          Expanded(child: Text(value)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          buildStepIndicator(2),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text('Confirmation', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 16),

                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.deepPurple),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        buildDetailRow('Name', widget.name),
                        buildDetailRow('Email', widget.email),
                        buildDetailRow('Phone', widget.phone),
                        buildDetailRow('Age', widget.age.toInt().toString()),
                        buildDetailRow('10th %', widget.tenthPercentage),
                        buildDetailRow('10th School', widget.tenthSchool),
                        buildDetailRow('12th %', widget.twelfthPercentage),
                        buildDetailRow('12th School', widget.twelfthSchool),
                        buildDetailRow('Applied Course', widget.appliedCourse),
                        buildDetailRow('Skills', widget.skills.join(', ')),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),

                  SwitchListTile(
                    title: const Text('Receive notifications'),
                    value: wantsNotifications,
                    contentPadding: EdgeInsets.zero,
                    onChanged: (value) {
                      setState(() {
                        wantsNotifications = value;
                      });
                    },
                  ),

                  CheckboxListTile(
                    title: const Text('I confirm the above information is correct'),
                    value: confirmedInfo,
                    contentPadding: EdgeInsets.zero,
                    controlAffinity: ListTileControlAffinity.leading,
                    onChanged: (value) {
                      setState(() {
                        confirmedInfo = value!;
                      });
                    },
                  ),
                  const SizedBox(height: 24),

                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text('Back'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: submitFinal,
                          child: const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}