import 'package:flutter/material.dart';
import 'detail_screen.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key, required this.userName});

  final String userName;

  final List<String> subjects = const [
    'Mobile App Development',
    'Software Re-engineering',
    'MIS',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const SizedBox(height: 10),
        const CircleAvatar(
          radius: 40,
          backgroundImage: AssetImage('assests/animated me🖤.webp'),
        ),
        const SizedBox(height: 8),
        Text(
          userName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          'Semester 5 • CS Department',
          style: const TextStyle(fontSize: 12, color: Color(0xFF9AA6D1)),
        ),
        const SizedBox(height: 16),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            color: const Color(0xFF172246),
          ),
          child: Row(
            children: const [
              Icon(Icons.auto_graph, color: Color(0xFF9EABFF)),
              SizedBox(width: 10),
              Expanded(
                child: Text(
                  'Progress this week: 78% complete. Keep going!',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Expanded(
          child: Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: subjects.length,
              itemBuilder: (context, index) {
                final subjectIcons = [
                  Icons.phone_android_rounded,
                  Icons.settings_suggest_rounded,
                  Icons.analytics_outlined,
                ];
                return Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: ListTile(
                    leading: CircleAvatar(
                      backgroundColor: const Color(0xFF1B274E),
                      child: Icon(subjectIcons[index], color: Color(0xFF9EABFF)),
                    ),
                    title: Text(subjects[index]),
                    subtitle: const Text('View course details'),
                    trailing: const Icon(Icons.chevron_right_rounded, size: 24),
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              DetailScreen(subjectName: subjects[index]),
                        ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ),
      ],
    );
  }
}
