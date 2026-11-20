import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/student_provider.dart';
import '../utils/constants.dart';
import '../widgets/responsive_center.dart';
import '../widgets/state_views.dart';
import '../widgets/stat_bar.dart';
import '../widgets/stat_card.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();

    return Scaffold(
      appBar: AppBar(title: const Text('Dashboard')),
      body: buildBody(provider),
    );
  }

  Widget buildBody(StudentProvider provider) {
    if (provider.isLoading) return const LoadingView();

    if (provider.error != null) {
      return ErrorView(message: provider.error!, onRetry: provider.retry);
    }

    if (provider.students.isEmpty) {
      return const EmptyView(
        icon: Icons.bar_chart,
        message: 'No data yet.\nAdd students to see statistics.',
      );
    }

    // Year counts use readable labels: "1st Year", "2nd Year" ...
    final byYear = {
      for (final entry in provider.countByYear.entries)
        yearLabel(entry.key): entry.value,
    };

    return ResponsiveCenter(
      maxWidth: 700,
      child: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          Row(
            children: [
              Expanded(
                child: StatCard(
                  icon: Icons.groups,
                  value: '${provider.totalStudents}',
                  label: 'Total students',
                ),
              ),
              Expanded(
                child: StatCard(
                  icon: Icons.apartment,
                  value: '${provider.departmentsInUse}',
                  label: 'Departments',
                ),
              ),
              Expanded(
                child: StatCard(
                  icon: Icons.emoji_events,
                  value: provider.topDepartment ?? '-',
                  label: 'Largest department',
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          buildBarCard('Students by department', provider.countByDepartment),
          buildBarCard('Students by year', byYear),
        ],
      ),
    );
  }

  Widget buildBarCard(String title, Map<String, int> data) {
    final maxValue = data.values.fold(0, (a, b) => a > b ? a : b);

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            ...data.entries.map(
              (entry) => StatBar(
                label: entry.key,
                value: entry.value,
                maxValue: maxValue,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
