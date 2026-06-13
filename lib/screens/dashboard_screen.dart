import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:multi_screen_app/models/course_model.dart';
import 'package:multi_screen_app/providers/course_provider.dart';
import 'package:multi_screen_app/screens/detail_screen.dart';

class DashboardScreen extends ConsumerStatefulWidget {
  const DashboardScreen({super.key, required this.userName});

  final String userName;

  @override
  ConsumerState<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends ConsumerState<DashboardScreen> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _refresh() => ref.read(courseListProvider.notifier).refresh();

  Future<void> _deleteCourse(Course course) async {
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

    if (confirm != true) return;

    try {
      // Optimistic: the list updates immediately inside the notifier.
      await ref.read(courseListProvider.notifier).deleteCourse(course.id);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Course delete ho gaya!'),
          backgroundColor: Colors.green,
        ),
      );
    } catch (e) {
      // Notifier already rolled the list back; just report it.
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  void _goToAddEdit({Course? course}) {
    // The provider is the source of truth now; no return value handling needed.
    Navigator.pushNamed(context, '/add-edit-course', arguments: course);
  }

  @override
  Widget build(BuildContext context) {
    final coursesAsync = ref.watch(filteredCoursesProvider);
    final isLoading = coursesAsync.isLoading;

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
                onPressed: isLoading ? null : _refresh,
                icon: const Icon(Icons.refresh),
              ),
              IconButton(
                tooltip: 'Add course',
                onPressed: () => _goToAddEdit(),
                icon: const Icon(Icons.add_circle_outline),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _searchController,
          onChanged: (value) =>
              ref.read(searchQueryProvider.notifier).state = value,
          decoration: InputDecoration(
            hintText: 'Search courses by title...',
            prefixIcon: const Icon(Icons.search),
            isDense: true,
            suffixIcon: _searchController.text.isEmpty
                ? null
                : IconButton(
                    icon: const Icon(Icons.clear),
                    onPressed: () {
                      _searchController.clear();
                      ref.read(searchQueryProvider.notifier).state = '';
                    },
                  ),
          ),
        ),
        const SizedBox(height: 8),
        Expanded(child: _buildCourseList(coursesAsync)),
      ],
    );
  }

  Widget _buildCourseList(AsyncValue<List<Course>> coursesAsync) {
    return coursesAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (err, _) => Center(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$err',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red),
              ),
              const SizedBox(height: 12),
              ElevatedButton(onPressed: _refresh, child: const Text('Retry')),
            ],
          ),
        ),
      ),
      data: (courses) {
        if (courses.isEmpty) {
          return _buildEmptyState();
        }
        return RefreshIndicator(
          onRefresh: _refresh,
          child: ListView.builder(
            padding: const EdgeInsets.only(bottom: 8),
            itemCount: courses.length,
            itemBuilder: (context, index) {
              final course = courses[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
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
                        onPressed: () => _goToAddEdit(course: course),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteCourse(course),
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
      },
    );
  }

  Widget _buildEmptyState() {
    final hasQuery = ref.watch(searchQueryProvider).trim().isNotEmpty;
    // Wrap in a scrollable so pull-to-refresh still works on the empty state.
    return RefreshIndicator(
      onRefresh: _refresh,
      child: ListView(
        children: [
          SizedBox(
            height: 320,
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    hasQuery ? Icons.search_off : Icons.menu_book_outlined,
                    size: 64,
                    color: const Color(0xFF7E89B4),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    hasQuery
                        ? 'No courses match your search'
                        : 'No courses found',
                    style: const TextStyle(
                      fontSize: 16,
                      color: Color(0xFFC8D2FF),
                    ),
                  ),
                  if (!hasQuery) ...[
                    const SizedBox(height: 6),
                    const Text(
                      'Pull down to refresh or add a new course.',
                      style: TextStyle(color: Color(0xFF7E89B4)),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
