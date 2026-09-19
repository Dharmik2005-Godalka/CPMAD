import 'package:flutter/material.dart';
import '../models/student.dart';

class RegistrationScreen extends StatefulWidget {
  const RegistrationScreen({super.key});

  @override
  State<RegistrationScreen> createState() => _RegistrationScreenState();
}

class _RegistrationScreenState extends State<RegistrationScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  String gender = 'Male';
  double age = 22;
  bool wantsUpdates = false;

  final Map<String, bool> courseOptions = {
    'Flutter': false,
    'DBMS': false,
    'Python': false,
    'C++': false,
  };

  Student? submittedStudent;

  void submitForm() {
    if (_formKey.currentState!.validate()) {
      List<String> selectedCourses = courseOptions.entries
          .where((entry) => entry.value)
          .map((entry) => entry.key)
          .toList();

      if (selectedCourses.isEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Please select at least one course')),
        );
        return;
      }

      setState(() {
        submittedStudent = Student(
          name: nameController.text,
          email: emailController.text,
          phone: phoneController.text,
          gender: gender,
          courses: selectedCourses,
          age: age,
          wantsUpdates: wantsUpdates,
        );

        // Reset the form for a fresh entry
        nameController.clear();
        emailController.clear();
        phoneController.clear();
        passwordController.clear();
        gender = 'Male';
        age = 18;
        wantsUpdates = false;
        courseOptions.updateAll((key, value) => false);
      });

      _formKey.currentState!.reset();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Student Registration', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Name is required';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Email is required';
                  }
                  if (!value.contains('@') || !value.contains('.')) {
                    return 'Enter a valid email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Phone'),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Phone number is required';
                  }
                  if (value.trim().length != 10) {
                    return 'Enter a valid 10-digit phone number';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),

              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(labelText: 'Password'),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Password is required';
                  }
                  if (value.length < 6) {
                    return 'Password must be at least 6 characters';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              const Text('Gender', style: TextStyle(fontWeight: FontWeight.bold)),
              Row(
                children: [
                  Radio<String>(
                    value: 'Male',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                  const Text('Male'),
                  const SizedBox(width: 16),
                  Radio<String>(
                    value: 'Female',
                    groupValue: gender,
                    onChanged: (value) {
                      setState(() {
                        gender = value!;
                      });
                    },
                  ),
                  const Text('Female'),
                ],
              ),
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
              const SizedBox(height: 20),

              ElevatedButton(
                onPressed: submitForm,
                child: const Text('Submit'),
              ),

              const SizedBox(height: 24),

              if (submittedStudent != null) buildResultSection(submittedStudent!),
            ],
          ),
        ),
      ),
    );
  }

  void editStudent(Student s) {
    setState(() {
      nameController.text = s.name;
      emailController.text = s.email;
      phoneController.text = s.phone;
      gender = s.gender;
      age = s.age;
      wantsUpdates = s.wantsUpdates;
      courseOptions.updateAll((key, value) => s.courses.contains(key));
      submittedStudent = null;
    });
  }

  void deleteStudent() {
    setState(() {
      submittedStudent = null;
    });
  }

  Widget buildResultSection(Student s) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Registration Successful',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Colors.deepPurple),
                    onPressed: () => editStudent(s),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: deleteStudent,
                  ),
                ],
              ),
            ],
          ),
          const Divider(),
          Text('Name: ${s.name}'),
          Text('Email: ${s.email}'),
          Text('Phone: ${s.phone}'),
          Text('Gender: ${s.gender}'),
          Text('Courses: ${s.courses.join(', ')}'),
          Text('Age: ${s.age.toInt()}'),
          Text('Wants updates: ${s.wantsUpdates ? 'Yes' : 'No'}'),
        ],
      ),
    );
  }
}