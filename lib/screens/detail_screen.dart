import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String subjectName;

  const DetailScreen({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(subjectName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network('[via.placeholder.com](https://via.placeholder.com/400x200)'),
            const SizedBox(height: 16),
            Text(
              subjectName,
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 10),
            const Text(
              'This course covers advanced concepts related to system design, architecture, and process optimization. You will gain both practical and theoretical understanding through projects and assignments.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            const Text('Schedule:', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
            const SizedBox(height: 5),
            const Text('Monday & Wednesday: 10:00 AM - 12:00 PM\nFriday: 9:00 AM - 11:00 AM'),
          ],
        ),
      ),
    );
  }
}
