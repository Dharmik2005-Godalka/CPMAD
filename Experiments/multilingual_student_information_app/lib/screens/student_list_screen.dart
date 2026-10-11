import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_strings.dart';
import '../models/student.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final code = Localizations.localeOf(context).languageCode;
    final today = DateFormat.yMMMMEEEEd(code).format(DateTime.now());
    final total = NumberFormat.decimalPattern(code).format(students.length);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppStrings.t(context, 'app_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.language),
            tooltip: AppStrings.t(context, 'language'),
            onPressed: () {
              Navigator.pushNamed(context, '/language');
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Card(
            color: Colors.indigo.shade50,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppStrings.t(context, 'welcome'),
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('${AppStrings.t(context, 'today')}: $today'),
                  const SizedBox(height: 4),
                  Text('${AppStrings.t(context, 'total_students')}: $total'),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            AppStrings.t(context, 'student_list'),
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 4),
          ...students.map(
            (student) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(student.name[0]),
                ),
                title: Text(student.name),
                subtitle: Text(AppStrings.t(context, student.departmentKey)),
                trailing: const Icon(Icons.arrow_forward_ios, size: 16),
                onTap: () {
                  Navigator.pushNamed(context, '/details', arguments: student);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}