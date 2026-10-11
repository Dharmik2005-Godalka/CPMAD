import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/student_service.dart';

class StudentFormScreen extends StatefulWidget {
  final Student? student; // null = add, not null = edit

  const StudentFormScreen({super.key, this.student});

  @override
  State<StudentFormScreen> createState() => _StudentFormScreenState();
}

class _StudentFormScreenState extends State<StudentFormScreen> {
  final formKey = GlobalKey<FormState>();
  final studentService = StudentService();
  late final TextEditingController nameController;
  late final TextEditingController rollController;
  late final TextEditingController departmentController;
  late final TextEditingController semesterController;
  bool isSaving = false;

  bool get isEdit => widget.student != null;

  @override
  void initState() {
    super.initState();
    final s = widget.student;
    nameController = TextEditingController(text: s?.name ?? '');
    rollController = TextEditingController(text: s?.rollNumber ?? '');
    departmentController = TextEditingController(text: s?.department ?? '');
    semesterController = TextEditingController(
      text: s != null ? '${s.semester}' : '',
    );
  }

  @override
  void dispose() {
    nameController.dispose();
    rollController.dispose();
    departmentController.dispose();
    semesterController.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!formKey.currentState!.validate()) return;

    setState(() {
      isSaving = true;
    });

    final student = Student(
      id: widget.student?.id,
      name: nameController.text.trim(),
      rollNumber: rollController.text.trim(),
      department: departmentController.text.trim(),
      semester: int.parse(semesterController.text.trim()),
    );

    if (isEdit) {
      await studentService.updateStudent(student);
    } else {
      await studentService.addStudent(student);
    }

    if (mounted) Navigator.pop(context);
  }

  Widget field(
    String label,
    TextEditingController controller, {
    bool number = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        keyboardType: number ? TextInputType.number : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: const OutlineInputBorder(),
        ),
        validator: (value) {
          if (value == null || value.trim().isEmpty) {
            return 'Enter $label';
          }
          if (number && int.tryParse(value.trim()) == null) {
            return 'Enter a valid number';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(isEdit ? 'Edit Student' : 'Add Student')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: formKey,
          child: Column(
            children: [
              field('Name', nameController),
              field('Roll Number', rollController),
              field('Department', departmentController),
              field('Semester', semesterController, number: true),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isSaving ? null : save,
                  child: Text(isEdit ? 'Update' : 'Save'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
