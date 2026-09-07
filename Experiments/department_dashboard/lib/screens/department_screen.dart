import 'package:flutter/material.dart';
import '../models/department.dart';
import '../models/faculty.dart';

class InfoTile extends StatelessWidget {
  final IconData icon;
  final String text;

  const InfoTile({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14)),
          ),
        ],
      ),
    );
  }
}

//reusable widget: faculty card:
class FacultyCard extends StatelessWidget {
  final Faculty faculty;

  const FacultyCard({super.key, required this.faculty});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const CircleAvatar(
            radius: 28,
            backgroundColor: Colors.deepPurple,
            child: Icon(Icons.person, size: 32, color: Colors.white),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  faculty.name,
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 6),
                InfoTile(icon: Icons.email, text: faculty.email),
                InfoTile(icon: Icons.phone, text: faculty.phone),
                InfoTile(icon: Icons.access_time, text: 'Available: ${faculty.availability}'),
                InfoTile(icon: Icons.calendar_today, text: 'Lectures: ${faculty.lectureDays}'),
                InfoTile(icon: Icons.menu_book, text: 'Subjects: ${faculty.subjects}'),
                InfoTile(icon: Icons.school, text: faculty.education),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class DepartmentScreen extends StatelessWidget {
  const DepartmentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Department dept = Department(
      name: 'Information and Communication Technology',
      faculty: [
        Faculty(
          name: 'Prof. CD Parmar',
          email: 'cd.parmar@university.edu',
          phone: '1234567890',
          availability: '12:00 - 1:00, 2:00 - 4:00',
          lectureDays: 'Tuesday, Friday',
          subjects: 'DLD, BEE, ICE, ML, etc.',
          education: 'M.Tech in Electronics',
        ),
        Faculty(
          name: 'Prof. Arjav Bavarava',
          email: 'arjav.bavarava@university.edu',
          phone: '2345678901',
          availability: '12:00 - 1:00, 2:00 - 4:00',
          lectureDays: 'Monday, Tuesday, Thursday',
          subjects: 'SS, BEE, ADC, CN, etc.',
          education: 'M.Tech in ICT',
        ),
        Faculty(
          name: 'Vijay Dubey',
          email: 'vijay.dubey@university.edu',
          phone: '3456789012',
          availability: '12:00 - 1:00, 2:00 - 4:00',
          lectureDays: 'Thursday, Wednesday, Friday',
          subjects: 'C, MCI, OS, COA, etc.',
          education: 'M.Tech in Computer Science',
        ),
        Faculty(
          name: 'Nisith Kotak',
          email: 'nisith.kotak@university.edu',
          phone: '1111111111',
          availability: '12:00 - 1:00, 2:00 - 4:00',
          lectureDays: 'Tuesday, Wednesday, Thursday, Friday',
          subjects: 'ML, C, R, DSA, DAA, etc.',
          education: 'M.Tech in Artificial Intelligence',
        ),
        Faculty(
          name: 'Arjoo Sir',
          email: 'arjoo.sir@university.edu',
          phone: '1234567899',
          availability: '12:00 - 1:00, 2:00 - 4:00',
          lectureDays: 'Monday, Tuesday, Wednesday',
          subjects: 'DSA, OOP, C++, Flutter',
          education: 'M.Tech in Software Engineering',
        ),
        Faculty(
          name: 'Mitesh Solanki',
          email: 'mitesh.solanki@university.edu',
          phone: '1234567891',
          availability: '12:00 - 1:00, 2:00 - 4:00',
          lectureDays: 'Tuesday, Thursday, Friday',
          subjects: 'C, FSSI, Python, etc.',
          education: 'M.Tech in Computer Engineering',
        ),
        Faculty(
          name: 'Dr Sunil Lavdiya',
          email: 'sunil.lavdiya@university.edu',
          phone: '1234567800',
          availability: '12:00 - 1:00, 2:00 - 4:00',
          lectureDays: 'Tuesday, Friday',
          subjects: 'BEE, DLD, ICE, etc.',
          education: 'Ph.D. in Electronics Engineering',
        ),
      ],
      courses: ['B.Tech ICT', 'M.Tech ICT', 'AI/ML'],
      facilities: ['Computer Lab', 'Networking Lab', 'Library', 'Seminar Hall'],
      email: 'ict.dept@university.edu',
      phone: '+91 90000 00000',
      location: 'Block C, Marwadi University',
    );

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        title: const Text('Department Info', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.account_balance, color: Colors.deepPurple, size: 26),
                    const SizedBox(width: 10),
                    Flexible(
                      child: Text(
                        dept.name,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              //faculty
              Text('Faculty', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              ...dept.faculty.map((f) => FacultyCard(faculty: f)),

              const SizedBox(height: 8),

              //courses
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Courses', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...dept.courses.map((c) => InfoTile(icon: Icons.book, text: c)),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Facilities', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    ...dept.facilities.map((f) => InfoTile(icon: Icons.apartment, text: f)),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              //contact info.
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Contact', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 8),
                    InfoTile(icon: Icons.email, text: dept.email),
                    InfoTile(icon: Icons.phone, text: dept.phone),
                    InfoTile(icon: Icons.location_on, text: dept.location),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}