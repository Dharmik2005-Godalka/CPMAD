import 'package:flutter/material.dart';
import 'confirmation_screen.dart';

class AcademicDetailsScreen extends StatefulWidget {
  final String name;
  final String email;
  final String phone;
  final String password;
  final double age;

  const AcademicDetailsScreen({
    super.key,
    required this.name,
    required this.email,
    required this.phone,
    required this.password,
    required this.age,
  });

  @override
  State<AcademicDetailsScreen> createState() => _AcademicDetailsScreenState();
}

class _AcademicDetailsScreenState extends State<AcademicDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController tenthPercentageController = TextEditingController();
  final TextEditingController tenthSchoolController = TextEditingController();
  final TextEditingController twelfthPercentageController = TextEditingController();
  final TextEditingController twelfthSchoolController = TextEditingController();
  final TextEditingController appliedCourseController = TextEditingController();

  final Map<String, bool> skillOptions = {
    'Flutter': false,
    'PHP': false,
    'Python': false,
    'C++': false,
  };

  void goNext() {
    if (_formKey.currentState!.validate()) {
      List<String> selectedSkills = skillOptions.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      if (selectedSkills.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one skill')),
        );
        return;
      }

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ConfirmationScreen(
            name: widget.name,
            email: widget.email,
            phone: widget.phone,
            password: widget.password,
            age: widget.age,
            tenthPercentage: tenthPercentageController.text,
            tenthSchool: tenthSchoolController.text,
            twelfthPercentage: twelfthPercentageController.text,
            twelfthSchool: twelfthSchoolController.text,
            appliedCourse: appliedCourseController.text,
            skills: selectedSkills,
          ),
        ),
      );
    }
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: Column(
        children: [
          buildStepIndicator(1),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('Academic Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                    const SizedBox(height: 16),

                    TextFormField(
                      controller: tenthPercentageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '10th Percentage'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return '10th percentage is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: tenthSchoolController,
                      decoration: const InputDecoration(labelText: '10th School Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return '10th school name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: twelfthPercentageController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(labelText: '12th Percentage'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return '12th percentage is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: twelfthSchoolController,
                      decoration: const InputDecoration(labelText: '12th School Name'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return '12th school name is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),

                    TextFormField(
                      controller: appliedCourseController,
                      decoration: const InputDecoration(labelText: 'Applied Course'),
                      validator: (value) {
                        if (value == null || value.trim().isEmpty) return 'Applied course is required';
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),

                    const Text('Skills', style: TextStyle(fontWeight: FontWeight.bold)),
                    ...skillOptions.keys.map((skill) {
                      return CheckboxListTile(
                        title: Text(skill),
                        value: skillOptions[skill],
                        contentPadding: EdgeInsets.zero,
                        controlAffinity: ListTileControlAffinity.leading,
                        onChanged: (value) {
                          setState(() {
                            skillOptions[skill] = value!;
                          });
                        },
                      );
                    }),
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
                            onPressed: goNext,
                            child: const Text('Next'),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}