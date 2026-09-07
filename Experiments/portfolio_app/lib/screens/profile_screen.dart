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
    final Creator dev = Creator(
      name: 'Dharmik Godalka',
      qualification: 'B.Tech, Information and Communication Technology',
      skills: ['Prompt Engineering','PHP', 'MySQL', 'C++', 'Python'],
      email: 'dharmikgodalka@gmail.com',
      phone: '+91 1234567890',
      location: 'Gujarat, India',
    );

    final List<Project> projects = [
      Project(
        title: 'Internship Management System',
        description: 'A system to manage internship applications and placements. It magages things like this, a student can apply for internship, a company can post internship and a admin can manage all the things.',
      ),
      Project(
        title: 'Python based Quiz App',
        description: 'Using the Python library Flask, I created a web-based quiz application that allows users to take quizzes on various topics. The app features a user-friendly interface, multiple-choice questions, and instant feedback on answers.',
      ),
      Project(
        title: 'E-commerce Website',
        description: 'A web-based e-commerce platform for buying and selling products online.',
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFEFEFEF),
      appBar: AppBar(
        title: const Text('Developer Portfolio', style: TextStyle(color: Colors.white)),
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
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(dev.qualification, style: Theme.of(context).textTheme.bodyMedium),
                          const SizedBox(height: 8),
                          const Text(
                            'Student Developer',
                            style: TextStyle(color: Colors.deepPurple, fontSize: 13),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'Student of Marwadi University, pursuing B.Tech in Information and Communication Technology. I am passionate about coding and have a keen interest in developing innovative solutions. I have worked on several projects and have gained experience in various programming languages and frameworks. I am always eager to learn new technologies and improve my skills.'
                            'projects — currently exploring Flutter, PHP and C++.',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
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
                    Text('Skills', style: Theme.of(context).textTheme.titleMedium),
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

              //project part section...
              Text('Projects', style: Theme.of(context).textTheme.headlineSmall),
              const SizedBox(height: 12),
              ...projects.map((p) => ProjectCard(project: p)),

              const SizedBox(height: 8),

              //contact info section...
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "Let's talk",
                      style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 12),
                    ContactRow(icon: Icons.email, text: dev.email),
                    ContactRow(icon: Icons.phone, text: dev.phone),
                    ContactRow(icon: Icons.location_on, text: dev.location),
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