import 'package:flutter/material.dart';
import '../models/developer.dart';
import '../models/project.dart';

//reusable widget1
class SkillChip extends StatelessWidget {
  final String label;

  const SkillChip({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.deepPurple.shade50,
        border: Border.all(color: Colors.deepPurple),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        label,
        style: const TextStyle(color: Colors.deepPurple, fontSize: 13),
      ),
    );
  }
}

//reusable widget2: contact row
class ContactRow extends StatelessWidget {
  final IconData icon;
  final String text;

  const ContactRow({super.key, required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Icon(icon, color: Colors.deepPurple, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(text, style: const TextStyle(fontSize: 14, color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class ProjectCard extends StatelessWidget {
  final Project project;

  const ProjectCard({super.key, required this.project});

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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            project.title,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 6),
          Text(
            project.description,
            style: const TextStyle(fontSize: 13, color: Colors.black87),
          ),
        ],
      ),
    );
  }
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final Student dev = Student(
      name: 'Dharmik Godalka',
      rollNumber: '92400133005',
      grNumber: 'GR12345',
      qualification: 'B.Tech, Information and Communication Technology',
      college: 'Marwadi University',
      skills: ['Data Structures', 'Web Development', 'DBMS', 'Probability and Statistics', 'Design and Analysis of Algorithms'],
      email: 'dharmikgodalka@gmail.com',
      phone: '+91 1234567890',
      location: 'Gujarat, India',
    );

    final List<Project> projects = [
      Project(
        title: 'Second Rank in Semester 3',
        description: 'I got second rank in my semester 3 with a CGPA around 9.',
      ),
      Project(
        title: '2024 - SIH Hackathon Participant',
        description: 'Built a education based smart car project for small age children.',
      ),
      Project(
        title: '2025 - SIH Hackathon Participant',
        description: 'Built a web based Allumni portal for Marwadi University students and alumni.',
      ),
      Project(
        title: '2025 - SSIP Hackathon participant',
        description: 'Developed Solution for the problem that has been created by the Traffic.',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        title: const Text('Student Profile', style: TextStyle(color: Colors.white)),
        backgroundColor: Colors.deepPurple,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              
              //name
              Container(
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  dev.name,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
                ),
              ),

              const SizedBox(height: 12),

              // photo section...
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                ),
                                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dev.qualification, style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          Text('College: ${dev.college}', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text('Roll No: ${dev.rollNumber}', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text('GR No: ${dev.grNumber}', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text('Phone: ${dev.phone}', style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 4),
                          Text('Email: ${dev.email}', style: Theme.of(context).textTheme.bodyMedium),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Image.asset(
                        'images/profile.jpg',
                        width: 110,
                        height: 130,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 12),

              //skill part section:
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
                    Text('Subjects', style: Theme.of(context).textTheme.titleMedium),
                    const SizedBox(height: 12),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: dev.skills.map((s) => SkillChip(label: s)).toList(),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              //achievements part section...
              Text('Achievements', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              ...projects.map((p) => ProjectCard(project: p)),

            ],
          ),
        ),
      ),
    );
  }
}