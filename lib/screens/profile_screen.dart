import 'package:flutter/material.dart';
import 'package:multi_screen_app/screens/login_screen.dart';
import 'package:multi_screen_app/services/auth_service.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key, required this.userName});

  final String userName;

  @override
  Widget build(BuildContext context) {
    final previousCourses = [
      {'name': 'Data Structures', 'grade': 'A'},
      {'name': 'Database Systems', 'grade': 'A-'},
      {'name': 'Operating Systems', 'grade': 'B+'},
      {'name': 'Computer Networks', 'grade': 'A'},
      {'name': 'Human Computer Interaction', 'grade': 'A-'},
      {'name': 'Cloud Computing', 'grade': 'B+'},
      {'name': 'Cyber Security Basics', 'grade': 'A'},
      {'name': 'Machine Learning Intro', 'grade': 'B'},
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            gradient: const LinearGradient(
              colors: [Color(0xFF17244F), Color(0xFF312269)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Row(
            children: [
              const CircleAvatar(
                radius: 36,
                backgroundImage: AssetImage('assests/animated me🖤.webp'),
              ),
              const SizedBox(width: 16),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    userName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'BSc Computer Science',
                    style: TextStyle(color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  const Text(
                    'CGPA: 3.67',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 24),
        const Text(
          'Previous Courses',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Expanded(
          child: ListView.separated(
            itemCount: previousCourses.length,
            separatorBuilder: (_, __) => const Divider(),
            itemBuilder: (context, index) {
              final course = previousCourses[index];
              return ListTile(
                leading: CircleAvatar(
                  backgroundColor: const Color(0xFF1B274E),
                  child: const Icon(Icons.book_rounded, color: Color(0xFF9EABFF)),
                ),
                title: Text(course['name']!),
                trailing: Chip(
                  label: Text(course['grade']!),
                  avatar: const Icon(Icons.star, size: 16, color: Colors.amber),
                  backgroundColor: const Color(0xFF1B274E),
                ),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          width: double.infinity,
          child: OutlinedButton.icon(
            onPressed: () async {
              await AuthService.logout();
              if (!context.mounted) return;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (context) => const LoginScreen()),
                (route) => false,
              );
            },
            icon: const Icon(Icons.logout),
            label: const Text('Log out'),
          ),
        ),
      ],
    );
  }
}
