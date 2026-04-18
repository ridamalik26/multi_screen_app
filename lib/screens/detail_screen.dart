import 'package:flutter/material.dart';

class DetailScreen extends StatelessWidget {
  final String subjectName;

  const DetailScreen({super.key, required this.subjectName});

  @override
  Widget build(BuildContext context) {
    final keyTopics = [
      'Weekly practical labs',
      'Mini projects and presentations',
      'Mid + final assessment',
      'Hands-on classroom activities',
    ];

    return Scaffold(
      appBar: AppBar(title: Text(subjectName)),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            Container(
              padding: const EdgeInsets.all(18),
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
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.menu_book_rounded,
                      color: Colors.white,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      subjectName,
                      style: const TextStyle(
                        fontSize: 20,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'This course covers advanced concepts related to system design, architecture, and process optimization. You will gain both practical and theoretical understanding through projects and assignments.',
              style: TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 20),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: const ListTile(
                leading: Icon(Icons.schedule, color: Color(0xFF9EABFF)),
                title: Text(
                  'Schedule',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                subtitle: Text(
                  'Monday & Wednesday: 10:00 AM - 12:00 PM\nFriday: 9:00 AM - 11:00 AM',
                ),
              ),
            ),
            const SizedBox(height: 14),
            Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
              child: Padding(
                padding: const EdgeInsets.all(14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Key Highlights',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...keyTopics.map(
                      (topic) => Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.check_circle_outline,
                              size: 18,
                              color: Color(0xFF9EABFF),
                            ),
                            const SizedBox(width: 8),
                            Expanded(child: Text(topic)),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
