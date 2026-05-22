import 'package:flutter/material.dart';
import 'package:multi_screen_app/models/course_model.dart';
import 'package:multi_screen_app/screens/detail_screen.dart';
import 'package:multi_screen_app/services/api_service.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key, required this.userName});

  final String userName;

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  final ApiService _apiService = ApiService();
  List<Course> _courses = [];
  bool _isLoading = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadCourses();
  }

  Future<void> _loadCourses() async {
    setState(() {
      _isLoading = true;
      _error = null;
    });
    try {
      final courses = await _apiService.fetchCourses();
      if (!mounted) return;
      setState(() => _courses = courses);
    } catch (e) {
      if (mounted) setState(() => _error = e.toString());
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _deleteCourse(int index) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Delete Course?'),
        content: const Text('Kya aap waqai delete karna chahte hain?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Nahi'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: const Text('Haan', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );

    if (confirm != true || !mounted) return;

    try {
      await _apiService.deleteCourse(_courses[index].id);
      if (!mounted) return;
      setState(() => _courses.removeAt(index));
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course delete ho gaya!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  Future<void> _goToAddEdit({Course? course, int? index}) async {
    final result = await Navigator.pushNamed(
      context,
      '/add-edit-course',
      arguments: course,
    );

    if (!mounted || result == null || result is! Course) return;

    setState(() {
      if (index != null) {
        _courses[index] = result;
      } else {
        _courses.insert(0, result);
      }
    });
  }

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
          widget.userName,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 16),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              const Text(
                'Courses',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const Spacer(),
              IconButton(
                tooltip: 'Refresh',
                onPressed: _isLoading ? null : _loadCourses,
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                tooltip: 'Add course',
                onPressed: _isLoading ? null : () => _goToAddEdit(),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: _buildCourseList()),
      ],
    );
  }

  Widget _buildCourseList() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(_error!, style: const TextStyle(color: Colors.red)),
              const SizedBox(height: 12),
              ElevatedButton(
                onPressed: _loadCourses,
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    if (_courses.isEmpty) {
      return const Center(child: Text('Koi course nahi mila'));
    }

    return RefreshIndicator(
      onRefresh: _loadCourses,
      child: ListView.builder(
        padding: const EdgeInsets.only(bottom: 8),
        itemCount: _courses.length,
        itemBuilder: (context, index) {
          final course = _courses[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 8),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            child: ListTile(
              leading: CircleAvatar(child: Text('${course.id}')),
              title: Text(
                course.title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: Text(
                course.body,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, color: Color(0xFF9EABFF)),
                    onPressed: () => _goToAddEdit(course: course, index: index),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteCourse(index),
                  ),
                ],
              ),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DetailScreen(course: course),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
