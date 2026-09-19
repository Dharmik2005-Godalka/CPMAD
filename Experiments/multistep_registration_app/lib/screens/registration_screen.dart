import 'package:flutter/material.dart';
import '../models/student.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  int currentStep = 0;

  final _personalFormKey = GlobalKey<FormState>();
  final _academicFormKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String gender = 'Male';
  double age = 18;
  bool wantsUpdates = false;

  final Map<String, bool> courseOptions = {
    'Flutter': false,
    'PHP': false,
    'Python': false,
    'C++': false,
  };

  void goToNextStep() {
    if (currentStep == 0) {
      if (_personalFormKey.currentState!.validate()) {
        setState(() {
          currentStep = 1;
        });
      }
    } else if (currentStep == 1) {
      if (_academicFormKey.currentState!.validate()) {
        bool anyCourseSelected = courseOptions.values.any((v) => v);
        if (!anyCourseSelected) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Please select at least one course')),
          );
          return;
        }
        setState(() {
          currentStep = 2;
        });
      }
    }
  }

  void goToPreviousStep() {
    setState(() {
      currentStep = currentStep - 1;
    });
  }

  void submitFinal() {
    List<String> selectedCourses = courseOptions.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    final Student student = Student(
      name: nameController.text,
      email: emailController.text,
      phone: phoneController.text,
      gender: gender,
      courses: selectedCourses,
      age: age,
      wantsUpdates: wantsUpdates,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Registration submitted successfully')),
    );

    setState(() {
      nameController.clear();
      emailController.clear();
      phoneController.clear();
      passwordController.clear();
      gender = 'Male';
      age = 18;
      wantsUpdates = false;
      courseOptions.updateAll((key, value) => false);
      currentStep = 0;
    });

    _personalFormKey.currentState?.reset();
    _academicFormKey.currentState?.reset();

    debugPrint('Submitted: ${student.name}, ${student.email}');
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
          buildStepIndicator(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: buildCurrentStep(),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildStepIndicator() {
    List<String> labels = ['Personal', 'Academic', 'Confirm'];
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: List.generate(3, (index) {
          bool isActive = index == currentStep;
          bool isDone = index < currentStep;
          return Row(
            children: [
              CircleAvatar(
                radius: 16,
                backgroundColor: isActive || isDone ? Colors.deepPurple : Colors.grey.shade300,
                child: Text(
                  '${index + 1}',
                  style: TextStyle(color: isActive || isDone ? Colors.white : Colors.black54),
                ),
              ),
              const SizedBox(width: 6),
              Text(labels[index]),
              if (index != 2) const SizedBox(width: 12),
            ],
          );
        }),
      ),
    );
  }

  Widget buildCurrentStep() {
    if (currentStep == 0) return buildPersonalDetailsStep();
    if (currentStep == 1) return buildAcademicDetailsStep();
    return buildConfirmationStep();
  }

  //personal details:
  Widget buildPersonalDetailsStep() {
    return Form(
      key: _personalFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Personal Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          TextFormField(
            controller: nameController,
            decoration: const InputDecoration(labelText: 'Name'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Name is required';
              return null;
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(labelText: 'Email'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Email is required';
              if (!value.contains('@') || !value.contains('.')) return 'Enter a valid email';
              return null;
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: phoneController,
            keyboardType: TextInputType.phone,
            decoration: const InputDecoration(labelText: 'Phone'),
            validator: (value) {
              if (value == null || value.trim().isEmpty) return 'Phone number is required';
              if (value.trim().length != 10) return 'Enter a valid 10-digit phone number';
              return null;
            },
          ),
          const SizedBox(height: 12),

          TextFormField(
            controller: passwordController,
            obscureText: true,
            decoration: const InputDecoration(labelText: 'Password'),
            validator: (value) {
              if (value == null || value.isEmpty) return 'Password is required';
              if (value.length < 6) return 'Password must be at least 6 characters';
              return null;
            },
          ),
          const SizedBox(height: 20),

          const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
          RadioGroup<String>(
            groupValue: gender,
            onChanged: (value) {
              setState(() {
                gender = value!;
              });
            },
            child: Row(
              children: const [
                Radio<String>(value: 'Male'),
                Text('Male'),
                SizedBox(width: 16),
                Radio<String>(value: 'Female'),
                Text('Female'),
              ],
            ),
          ),
          const SizedBox(height: 24),

          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: goToNextStep,
              child: const Text('Next'),
            ),
          ),
        ],
      ),
    );
  }

  //academic Details:
  Widget buildAcademicDetailsStep() {
    return Form(
      key: _academicFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Academic Details', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 16),

          const Text('Courses/Skills', style: TextStyle(fontWeight: FontWeight.bold)),
          ...courseOptions.keys.map((course) {
            return CheckboxListTile(
              title: Text(course),
              value: courseOptions[course],
              contentPadding: EdgeInsets.zero,
              controlAffinity: ListTileControlAffinity.leading,
              onChanged: (value) {
                setState(() {
                  courseOptions[course] = value!;
                });
              },
            );
          }),
          const SizedBox(height: 16),

          Text('Age: ${age.toInt()}', style: const TextStyle(fontWeight: FontWeight.bold)),
          Slider(
            value: age,
            min: 15,
            max: 60,
            divisions: 45,
            label: age.toInt().toString(),
            onChanged: (value) {
              setState(() {
                age = value;
              });
            },
          ),
          const SizedBox(height: 8),

          SwitchListTile(
            title: const Text('Receive updates about new courses'),
            value: wantsUpdates,
            contentPadding: EdgeInsets.zero,
            onChanged: (value) {
              setState(() {
                wantsUpdates = value;
              });
            },
          ),
          const SizedBox(height: 24),

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: goToPreviousStep,
                  child: const Text('Back'),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ElevatedButton(
                  onPressed: goToNextStep,
                  child: const Text('Next'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Confirmation part:
  Widget buildConfirmationStep() {
    List<String> selectedCourses = courseOptions.entries
        .where((entry) => entry.value)
        .map((entry) => entry.key)
        .toList();

    return Column(
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
              Text('Name: ${nameController.text}'),
              Text('Email: ${emailController.text}'),
              Text('Phone: ${phoneController.text}'),
              Text('Gender: $gender'),
              Text('Courses: ${selectedCourses.join(', ')}'),
              Text('Age: ${age.toInt()}'),
              Text('Wants updates: ${wantsUpdates ? 'Yes' : 'No'}'),
            ],
          ),
        ),
        const SizedBox(height: 24),

        Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: goToPreviousStep,
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
    );
  }
}