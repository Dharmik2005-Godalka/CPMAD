import 'package:flutter/material.dart';
import 'academic_details_screen.dart';

class PersonalDetailsScreen extends StatefulWidget {
  const PersonalDetailsScreen({super.key});

  @override
  State<PersonalDetailsScreen> createState() => _PersonalDetailsScreenState();
}

class _PersonalDetailsScreenState extends State<PersonalDetailsScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String gender = 'Male';
  double age = 18;

  void goNext() {
    if (_formKey.currentState!.validate()) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => AcademicDetailsScreen(
            name: nameController.text,
            email: emailController.text,
            phone: phoneController.text,
            password: passwordController.text,
            age: age,
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
          buildStepIndicator(0),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Form(
                key: _formKey,
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
                    const SizedBox(height: 24),

                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: goNext,
                        child: const Text('Next'),
                      ),
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