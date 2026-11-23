import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/student.dart';
import '../providers/student_provider.dart';
import '../utils/app_routes.dart';
import '../utils/constants.dart';
import '../widgets/state_views.dart';
import '../widgets/student_card.dart';
import '../widgets/skeleton.dart';

class StudentListScreen extends StatelessWidget {
  const StudentListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StudentProvider>();

    return Scaffold(
      appBar: AppBar(title: Text('Students (${provider.students.length})')),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.pushNamed(context, AppRoutes.studentForm),
        icon: const Icon(Icons.person_add),
        label: const Text('Add'),
      ),
      body: buildBody(context, provider),
    );
  }

  Widget buildBody(BuildContext context, StudentProvider provider) {
    // 1. Loading
    if (provider.isLoading) return const SkeletonList();

    // 2. Error
    if (provider.error != null) {
      return ErrorView(message: provider.error!, onRetry: provider.retry);
    }

    // 3. Empty (no students at all)
    if (provider.students.isEmpty) {
      return const EmptyView(
        icon: Icons.school_outlined,
        message: 'No students yet.\nTap Add to create the first one.',
      );
    }

    // 4. Loaded
    final students = provider.filteredStudents;

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 4),
          child: TextField(
            decoration: InputDecoration(
              hintText: 'Search by name, roll number or email',
              prefixIcon: const Icon(Icons.search),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            onChanged: provider.setSearchQuery,
          ),
        ),
        buildDepartmentChips(provider),
        buildYearAndSort(provider),
        buildResultInfo(provider, students.length),
        Expanded(
          child: students.isEmpty
              ? const EmptyView(
                  icon: Icons.search_off,
                  message: 'No students match your search',
                )
              : buildList(students),
        ),
      ],
    );
    
  }

  Widget buildDepartmentChips(StudentProvider provider) {
    final options = ['All', ...kDepartments];

    return SizedBox(
      height: 50,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 8),
        itemCount: options.length,
        itemBuilder: (context, index) {
          final department = options[index];
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 8),
            child: ChoiceChip(
              label: Text(department),
              selected: provider.selectedDepartment == department,
              onSelected: (_) => provider.setDepartment(department),
            ),
          );
        },
      ),
    );
  }

    // Year filter + sort menu
  Widget buildYearAndSort(StudentProvider provider) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 0, 4, 0),
      child: Row(
        children: [
          Expanded(
            child: SegmentedButton<int>(
              showSelectedIcon: false,
              style: const ButtonStyle(visualDensity: VisualDensity.compact),
              segments: const [
                ButtonSegment(value: 0, label: Text('All')),
                ButtonSegment(value: 1, label: Text('1st')),
                ButtonSegment(value: 2, label: Text('2nd')),
                ButtonSegment(value: 3, label: Text('3rd')),
                ButtonSegment(value: 4, label: Text('4th')),
              ],
              selected: {provider.selectedYear},
              onSelectionChanged: (selection) {
                provider.setYear(selection.first);
              },
            ),
          ),
          PopupMenuButton<StudentSort>(
            icon: const Icon(Icons.sort),
            tooltip: 'Sort',
            initialValue: provider.sort,
            onSelected: provider.setSort,
            itemBuilder: (context) {
              return StudentSort.values.map((s) {
                return PopupMenuItem(value: s, child: Text(sortLabel(s)));
              }).toList();
            },
          ),
        ],
      ),
    );
  }

  // "Showing 3 of 12" + reset button
  Widget buildResultInfo(StudentProvider provider, int shown) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 8, 0),
      child: Row(
        children: [
          Expanded(
            child: Text(
              'Showing $shown of ${provider.students.length}  •  ${sortLabel(provider.sort)}',
              style: const TextStyle(color: Colors.grey, fontSize: 12),
            ),
          ),
          if (provider.hasActiveFilters)
            TextButton.icon(
              onPressed: provider.resetFilters,
              icon: const Icon(Icons.filter_alt_off, size: 18),
              label: const Text('Reset'),
            ),
        ],
      ),
    );
  }

  // Responsive: a list on phones, a grid on wide screens
  Widget buildList(List<Student> students) {
    return LayoutBuilder(
      builder: (context, constraints) {
        void open(Student s) {
          Navigator.pushNamed(
            context,
            AppRoutes.studentDetails,
            arguments: s.id,
          );
        }

        if (constraints.maxWidth >= 700) {
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 90),
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
              maxCrossAxisExtent: 450,
              mainAxisExtent: 88,
            ),
            itemCount: students.length,
            itemBuilder: (context, index) {
              final student = students[index];
              return StudentCard(student: student, onTap: () => open(student));
            },
          );
        }

        return ListView.builder(
          padding: const EdgeInsets.only(bottom: 90),
          itemCount: students.length,
          itemBuilder: (context, index) {
            final student = students[index];
            return StudentCard(student: student, onTap: () => open(student));
          },
        );
      },
    );
  }
}
