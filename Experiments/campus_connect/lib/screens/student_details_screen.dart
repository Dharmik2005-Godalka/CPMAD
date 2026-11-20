import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';
import '../utils/app_routes.dart';
import '../utils/constants.dart';
import '../widgets/responsive_center.dart';
import '../widgets/state_views.dart';
import '../widgets/student_avatar.dart';

class StudentDetailsScreen extends StatelessWidget {
  final String studentId;

  const StudentDetailsScreen({super.key, required this.studentId});

  @override
  Widget build(BuildContext context) {
    // Read from the provider so edits show up here instantly
    final student = context.watch<StudentProvider>().getById(studentId);

    if (student == null) {
      return Scaffold(
        appBar: AppBar(),
        body: const EmptyView(
          icon: Icons.person_off,
          message: 'Student not found',
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('Student details'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'Edit',
            onPressed: () => Navigator.pushNamed(
              context,
              AppRoutes.studentForm,
              arguments: student,
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete),
            tooltip: 'Delete',
            onPressed: () => _confirmDelete(context, student),
          ),
        ],
      ),
      body: ResponsiveCenter(
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            Center(
              child: Hero(
                tag: 'avatar-${student.id}',
                child: StudentAvatar(student: student, radius: 60),
              ),
            ),
            const SizedBox(height: 16),
            Center(
              child: Text(
                student.name,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ),
            const SizedBox(height: 8),
            Center(child: Chip(label: Text(student.department))),
            const SizedBox(height: 20),
            buildInfo(Icons.badge, 'Roll number', student.rollNo),
            buildInfo(Icons.school, 'Year', yearLabel(student.year)),
            buildInfo(Icons.email, 'Email', student.email),
            buildInfo(Icons.phone, 'Phone', student.phone),
          ],
        ),
      ),
    );
  }

  Widget buildInfo(IconData icon, String label, String value) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(value),
        subtitle: Text(label),
      ),
    );
  }

  Future<void> _confirmDelete(BuildContext context, Student student) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete student'),
        content: Text('Delete ${student.name}? This cannot be undone.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (confirmed != true || !context.mounted) return;

    // Grab these before the awaits below
    final provider = context.read<StudentProvider>();
    final messenger = ScaffoldMessenger.of(context);

    Navigator.pop(context); // back to the list first

    try {
      await provider.deleteStudent(student.id);
      messenger.showSnackBar(const SnackBar(content: Text('Student deleted')));
    } catch (_) {
      messenger.showSnackBar(
        const SnackBar(content: Text('Could not delete the student')),
      );
    }
  }
}
