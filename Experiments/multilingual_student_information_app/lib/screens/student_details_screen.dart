import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../l10n/app_strings.dart';
import '../models/student.dart';

class StudentDetailsScreen extends StatelessWidget {
  const StudentDetailsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final student = ModalRoute.of(context)!.settings.arguments as Student;
    final code = Localizations.localeOf(context).languageCode;

    // locale based date and number formatting
    final date = DateFormat.yMMMMd(code).format(student.admissionDate);
    final fees = NumberFormat.currency(
      locale: code,
      symbol: '₹',
      decimalDigits: 0,
    ).format(student.fees);
    final percentage = NumberFormat.decimalPatternDigits(
      locale: code,
      decimalDigits: 1,
    ).format(student.percentage);
    final roll = NumberFormat.decimalPattern(code).format(student.rollNumber);

    return Scaffold(
      appBar: AppBar(title: Text(AppStrings.t(context, 'student_details'))),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Card(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.person),
                title: Text(AppStrings.t(context, 'name')),
                subtitle: Text(student.name),
              ),
              ListTile(
                leading: const Icon(Icons.numbers),
                title: Text(AppStrings.t(context, 'roll_no')),
                subtitle: Text(roll),
              ),
              ListTile(
                leading: const Icon(Icons.apartment),
                title: Text(AppStrings.t(context, 'department')),
                subtitle: Text(AppStrings.t(context, student.departmentKey)),
              ),
              ListTile(
                leading: const Icon(Icons.calendar_today),
                title: Text(AppStrings.t(context, 'admission_date')),
                subtitle: Text(date),
              ),
              ListTile(
                leading: const Icon(Icons.currency_rupee),
                title: Text(AppStrings.t(context, 'fees')),
                subtitle: Text(fees),
              ),
              ListTile(
                leading: const Icon(Icons.percent),
                title: Text(AppStrings.t(context, 'percentage')),
                subtitle: Text('$percentage %'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
