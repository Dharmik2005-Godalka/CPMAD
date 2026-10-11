import 'package:flutter/material.dart';
import '../models/student.dart';
import '../services/auth_service.dart';
import '../services/student_service.dart';
import 'student_form_screen.dart';

class StudentListScreen extends StatefulWidget {
  const StudentListScreen({super.key});

  @override
  State<StudentListScreen> createState() => _StudentListScreenState();
}

class _StudentListScreenState extends State<StudentListScreen> {
  final authService = AuthService();
  final studentService = StudentService();
  String searchText = '';

  void openForm({Student? student}) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => StudentFormScreen(student: student),
      ),
    );
  }

  Future<void> confirmDelete(Student student) async {
    final yes = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Student'),
        content: Text('Delete ${student.name}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete'),
          ),
        ],
      ),
    );

    if (yes == true) {
      await studentService.deleteStudent(student.id!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = authService.currentUser!;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Students'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: () {
              authService.logout();
            },
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => openForm(),
        child: const Icon(Icons.add),
      ),
      body: Column(
        children: [
          // logged in user information
          StreamBuilder<Map<String, dynamic>?>(
            stream: authService.userStream(user.uid),
            builder: (context, snapshot) {
              final data = snapshot.data;
              final name = data?['name'] ?? user.displayName ?? '';
              final role = data?['role'] == 'teacher' ? 'Teacher' : 'Student';
              return Card(
                margin: const EdgeInsets.all(12),
                color: Colors.blue.shade50,
                child: ListTile(
                  leading: const CircleAvatar(child: Icon(Icons.person)),
                  title: Text(name),
                  subtitle: Text('${user.email}\n$role'),
                  isThreeLine: true,
                ),
              );
            },
          ),

          // search box
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: TextField(
              decoration: const InputDecoration(
                labelText: 'Search by name',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
              onChanged: (value) {
                setState(() {
                  searchText = value;
                });
              },
            ),
          ),

          // student list from Firestore
          Expanded(
            child: StreamBuilder<List<Student>>(
              stream: studentService.getStudents(searchText),
              builder: (context, snapshot) {
                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }
                if (!snapshot.hasData) {
                  return const Center(child: CircularProgressIndicator());
                }

                final students = snapshot.data!;
                if (students.isEmpty) {
                  return const Center(child: Text('No students found'));
                }

                return ListView.builder(
                  itemCount: students.length,
                  itemBuilder: (context, index) {
                    final student = students[index];
                    return Card(
                      margin: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      child: ListTile(
                        leading: CircleAvatar(child: Text(student.name[0])),
                        title: Text(student.name),
                        subtitle: Text(
                          'Roll: ${student.rollNumber}  |  ${student.department}  |  Sem ${student.semester}',
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.edit),
                              onPressed: () => openForm(student: student),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              onPressed: () => confirmDelete(student),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
