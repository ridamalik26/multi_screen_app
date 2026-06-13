import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/course_model.dart';
import '../providers/course_provider.dart';

class AddEditCourseScreen extends ConsumerStatefulWidget {
  const AddEditCourseScreen({super.key});

  @override
  ConsumerState<AddEditCourseScreen> createState() =>
      _AddEditCourseScreenState();
}

class _AddEditCourseScreenState extends ConsumerState<AddEditCourseScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _bodyController = TextEditingController();
  bool _isSubmitting = false;
  Course? _existingCourse;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _existingCourse = ModalRoute.of(context)?.settings.arguments as Course?;
    if (_existingCourse != null) {
      _titleController.text = _existingCourse!.title;
      _bodyController.text = _existingCourse!.body;
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _bodyController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _isSubmitting = true);

    final notifier = ref.read(courseListProvider.notifier);
    final title = _titleController.text;
    final body = _bodyController.text;

    try {
      if (_existingCourse != null) {
        await notifier.updateCourse(
          _existingCourse!.copyWith(title: title, body: body),
        );
      } else {
        await notifier.addCourse(title, body);
      }
      if (!mounted) return;
      Navigator.pop(context);
    } catch (e) {
      // Notifier already rolled back the optimistic change.
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e'), backgroundColor: Colors.red),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = _existingCourse != null;
    return Scaffold(
      appBar: AppBar(
        title: Text(isEditing ? 'Course Edit Karo' : 'Naya Course Add Karo'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(
                  labelText: 'Course Title',
                  border: OutlineInputBorder(),
                ),
                validator: (val) => val!.isEmpty ? 'Title likho' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _bodyController,
                decoration: const InputDecoration(
                  labelText: 'Course Description',
                  border: OutlineInputBorder(),
                ),
                maxLines: 4,
                validator: (val) => val!.isEmpty ? 'Description likho' : null,
              ),
              const SizedBox(height: 24),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: _isSubmitting ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                  child: _isSubmitting
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(isEditing ? 'Update Karo' : 'Add Karo'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
